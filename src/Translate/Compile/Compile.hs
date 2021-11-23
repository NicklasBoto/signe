{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE KindSignatures    #-}
{-# LANGUAGE NamedFieldPuns    #-}
{-# LANGUAGE TupleSections     #-}
{-# LANGUAGE RankNTypes        #-}
{-# LANGUAGE LambdaCase        #-}

module Translate.Compile.Compile where

import Frontend.SAST.Abs
import Translate.FQC
import Translate.Unitary
import Frontend.SAST.Par
import Frontend.SAST.Print
import Translate.Result
import Data.Complex
import Data.Tuple (swap)
import Data.Bifunctor
import qualified Data.Set as Set
import qualified Data.Map as Map
import Data.List
import Data.List.Split
import Control.Monad hiding ( guard )
import Data.Function
import Translate.Matrix hiding (orthogonal)
import Control.Lens hiding ( uses, Context )
import Data.Maybe (catMaybes, mapMaybe, fromJust)
import Debug.Trace
import Type.Check (inferExpr)

type Context = Set.Set Id
type Env = Map.Map Id Int

emptyEnv :: Env
emptyEnv = Map.empty

emptyContext :: Context
emptyContext = Set.empty

test :: Program
test = parse "main : qubit * qubit := (~0, ~0)"

showSer :: Unitary -> IO ()
showSer ~(Ser xs) = putStrLn $ intercalate "\n" $ map show xs 

idFQC :: FQC
idFQC = FQC
    { input   = 1
    , heap    = 0
    , output  = 1
    , garbage = 0
    , unitary = Perm [0]
    }

testCompile :: String -> Unitary
testCompile = testResult . fmap (removeEmpties . unitary) . compile emptyEnv . parseExpr

compileExpr :: String -> IO ()
compileExpr e = print (FQC i h g o φ') >> putStrLn "" >> print (testResult $ matrix φ')
    where FQC i h g o φ = testResult . compile emptyEnv $ parseExpr e
          φ' = removeEmpties φ

showCompile :: String -> IO ()
showCompile = showSer . testCompile

compile :: Env -> Expr -> Result FQC
compile env = \case
    Var x -> do
        size_x <- maybe (throw Urk) return $ Map.lookup x env
        let env' = Map.delete x env
        if Map.null env'
            then return FQC
                { input   = size_x
                , heap    = 0
                , output  = size_x
                , garbage = 0
                , unitary = iN size_x
                }
            else return FQC
                { input   = length env' + size_x
                , heap    = 0
                , output  = size_x
                , garbage = length env'
                , unitary = Perm $ batchPermutation [length env', size_x] [1,0]
                }

    KetZero -> return FQC
        { input   = 0
        , heap    = 1
        , output  = 1
        , garbage = 0
        , unitary = Perm [0]
        }

    KetOne -> return FQC
        { input   = 0
        , heap    = 1
        , output  = 1
        , garbage = 0
        , unitary = Rot (0,1) (1,0)
        }

    Abs xs e -> compile (Map.fromList (zip xs (repeat 1)) `Map.union` env) e

    App f x -> do
        let uf = uses f 
            ux = uses x
            ψ  = Set.toList $ Set.union uf ux
            γδ = on (<>) Set.toList uf ux
            φC = contraction ψ γδ
            is    = map (fromJust . flip Map.lookup env) γδ
            (γ,δ) = splitAt (length uf) (zip γδ is)

        FQC iF hf oF gf φf <- compile (Map.fromList γ) f
        FQC ix hx ox gx φx <- compile (Map.fromList δ) x
        
        
        let perml = batchPermutation [ix,iF-ox,hx,hf] [1,0,2,3]
            permc = batchPermutation [iF-ox,ox,gx,hf] [0,1,3,2]
            permr = batchPermutation [oF,gf,gx]       [0,2,1]

        return FQC 
            { input   = input φC
            , heap    = heap φC + hf + hx
            , output  = oF
            , garbage = gx + gf
            , unitary = Ser 
                [ Par [unitary φC, iN (hx+hf)]
                , Perm perml
                , Par [iN (iF-ox), φx, iN hf]
                , Perm permc
                , Par [φf, iN gx]
                , Perm permr    
                ]
            }

    Mul k q -> return FQC
        { input   = 0
        , heap    = 1
        , output  = 1
        , garbage = 0
        , unitary = Rot (C k, 0) (0, C k)
        }

    Tup [] -> return FQC
        { input   = 0
        , heap    = 0
        , output  = 0
        , garbage = 0
        , unitary = Perm []
        }

    Tup [t,u] -> do
        let ut = uses t
            uu = uses u
            ψ  = Set.toList $ Set.union ut uu
            γδ = on (<>) Set.toList ut uu
            φC = contraction ψ γδ
            is    = map (fromJust . flip Map.lookup env) γδ
            (γ,δ) = splitAt (length ut) (zip γδ is)
        
        FQC it ht ot gt φt <- compile (Map.fromList γ) t
        FQC iu hu ou gu φu <- compile (Map.fromList δ) u

        let perml = batchPermutation [it,iu,ht,hu] [0,2,1,3]
            permr = batchPermutation [ot,gt,ou,gu] [0,2,1,3]

        return FQC
            { input   = input φC
            , heap    = heap φC + ht + hu
            , output  = ot + ou
            , garbage = gt + gu
            , unitary = Ser
                [ Par [unitary φC, iN (ht+hu)]
                , Perm perml
                , Par [φt, φu]
                , Perm permr
                ]
            }

    Tup (x:xs) -> compile env $ Tup [x, Tup xs]

    Let i u -> do
        let (xs,t) = Map.elemAt 0 i
            is = Set.fromList xs
            ut = uses t
            uu = uses u `Set.difference` is
            ψ  = Set.toList $ Set.union ut uu
            γδ = on (<>) Set.toList ut uu
            φC = contraction ψ γδ
            ix    = map (fromJust . flip Map.lookup env) γδ
            (γ,δ) = splitAt (length ut) (zip γδ ix)

        ft' <- compile (Map.fromList γ) t

        let diff = is `Set.intersection` uses u
            w    = weakening is diff

        ft@(FQC it ht ot gt φt) <- w `comp` ft'

        let sized_is = Map.fromSet (const 1) (is `Set.intersection` uses u)
            nis      = length sized_is

        FQC iu hu ou gu φu <- compile (sized_is `Map.union` Map.fromList δ) u

        let perml = batchPermutation [it,iu-nis,ht,hu] [1,0,2,3]
            permc = batchPermutation [iu-nis,ot,gt,hu] [0,1,3,2]
            permr = batchPermutation [ou,gu,gt] [0,2,1]

        return FQC
            { input   = input φC
            , heap    = heap φC + ht + hu
            , output  = ou
            , garbage = gt + gu
            , unitary = Ser
                [ Par [unitary φC, iN (ht+hu)]
                , Perm perml
                , Par [iN (iu-nis), φt, iN hu]
                , Perm permc
                , Par [φu, iN gt]
                , Perm permr
                ]
            }

    If c t u -> do
        let uc    = uses c
            ub    = uses t `Set.union` uses u
            vars  = Set.toList $ Set.union uc ub
            γδ    = on (<>) Set.toList uc ub
            φC    = contraction vars γδ
            ixs   = map (fromJust . flip Map.lookup env) γδ
            (γ,δ) = splitAt (length uc) (zip γδ ixs)

        FQC ic hc oc gc φc <- compile (Map.fromList γ) c
        FQC it ht ot gt φt <- compile (Map.fromList δ) t
        FQC iu hu ou gu φu <- compile (Map.fromList δ) u

        let FQC ib hb ob gb φb = FQC
                { input   = 1 + length ub
                , heap    = max ht hu
                , output  = 1 + ot
                , garbage = 0
                , unitary = Cond φt φu
                }

        let perml = batchPermutation [ic,ib-1,hc,hb] [1,0,2,3]
            permc = batchPermutation [ib-1,1,gc,hb]  [1,0,3,2]
            permr = batchPermutation [1,ob-1,gc]     [1,0,2]
            
        return FQC
            { input   = input φC
            , heap    = heap φC + hc + hb
            , output  = ob - 1
            , garbage = gc + 1
            , unitary = Ser
                [ Par [unitary φC, iN (hc+hb)]
                , Perm perml
                , Par [iN (ib-1), φc, iN hb]
                , Perm permc
                , Par [φb, iN gc]
                , Perm permr
                ]
            }

    Ifq c t u -> do
        (d,l,lc,r,rc,ψ) <- orthogonal env t u

        let uc    = uses c
            ub    = lc `Set.union` rc
            vars  = Set.toList $ Set.union uc ub
            γδ    = on (<>) Set.toList uc ub
            φC    = contraction vars γδ
            ixs   = map (fromJust . flip Map.lookup env) γδ
            (γ,δ) = splitAt (length uc) (zip γδ ixs)

        FQC ic hc oc gc φc <- compile (Map.fromList γ) c

        let FQC ib hb ob gb φb = FQC
                { input   = 1 + length ub
                , heap    = max (heap l) (heap r)
                , output  = 1 + output l
                , garbage = 0
                , unitary = Cond (unitary l) (unitary r)
                }

        let perml = batchPermutation [ic,ib-1,hc,hb] [1,0,2,3]
            permc = batchPermutation [ib-1,1,hb]     [1,0,2]
            permr = batchPermutation [1,ob-1]        [1,0]
            
        return FQC
            { input   = input φC
            , heap    = heap φC + hc + hb
            , output  = output ψ
            , garbage = 0
            , unitary = Ser
                [ Par [unitary φC, iN (hc+hb)]
                , Perm perml
                , Par [iN (ib-1), φc, iN hb]
                , Perm permc
                , φb
                , Perm permr
                , unitary ψ
                ]
            }

    x -> throw Urk

removeEmpties :: Unitary -> Unitary
removeEmpties (Par us) = Par $ filter nonEmpty $ map removeEmpties us
removeEmpties (Ser us) = Ser $ filter nonEmpty $ map removeEmpties us
removeEmpties (Cond t f) = Cond (removeEmpties t) (removeEmpties f)
removeEmpties a        = a

nonEmpty :: Unitary -> Bool
nonEmpty (Perm [])  = False
nonEmpty (Par [])   = False
nonEmpty (Ser [])   = False
nonEmpty (Cond t f) = nonEmpty t || nonEmpty f
nonEmpty _          = True

contextPerm :: Int -> Int -> Int -> Int -> Unitary
contextPerm size a b c = Perm perm
    where band = [0..size-1]
          (γ,(δ,(ηt,ηu))) = second (second (splitAt a) . splitAt b) (splitAt c band)
          perm = γ <> ηt <> δ <> ηu

batchPermutation :: [Int] -> [Int] -> [Int]
batchPermutation c = concatMap (splitPlaces c [0..sum c] !!)

normalize :: C -> C -> (C, C)
normalize a b = (a / norm a b, b / norm a b)
    where norm a b = sqrt $ abs a ^ 2 + abs b ^ 2

nullFQC :: FQC
nullFQC = FQC
    { input   = 0
    , heap    = 0
    , output  = 0
    , garbage = 0
    , unitary = Perm []
    }

orthogonal :: Env -> Expr -> Expr -> Result (Int, FQC, Context, FQC, Context, FQC)
orthogonal env KetOne KetZero = return (0, nullFQC, emptyContext, nullFQC, emptyContext, ψ)
    where ψ = FQC
            { input   = 1
            , heap    = 0
            , output  = 1
            , garbage = 0
            , unitary = Perm [0]
            }

orthogonal env KetZero KetOne = return (0, nullFQC, emptyContext, nullFQC, emptyContext, ψ)
    where ψ = FQC
            { input   = 1
            , heap    = 0
            , output  = 1
            , garbage = 0
            , unitary = Rot (0,1) (1,0)
            }

orthogonal env (Tup [t,v]) (Tup [u,w]) = do
    (c,l,lc,r,rc,ψ) <- orthogonal env t u

    let uv = uses v
        varsl = Set.toList $ Set.union uv lc
        γδl = on (<>) Set.toList uv lc
        φCl = contraction varsl γδl
        ixsl    = map (fromJust . flip Map.lookup env) γδl
        (γl,δl) = splitAt (length lc) (zip γδl ixsl)

    let uw = uses w
        varsr = Set.toList $ Set.union uw rc
        γδr = on (<>) Set.toList uw rc
        φCr = contraction varsr γδr
        ixsr = map (fromJust . flip Map.lookup env) γδr
        (γr,δr) = splitAt (length rc) (zip γδr ixsr)
    
    FQC iv hv ov gv ψv <- compile (Map.fromList δl) v 
    FQC iw hw ow gw ψw <- compile (Map.fromList δr) w

    let c' = c + ov
        ρ  = output ψ + ov
        ψ' = FQC
            { input   = c' + 1
            , heap    = 0
            , output  = ρ 
            , garbage = 0
            , unitary = Ser
                [ Perm $ batchPermutation [c,ov,1] [0,2,1]
                , Par [unitary ψ, iN ov]
                ]
            }

    let perml = batchPermutation [input l,iv,heap l,hv] [0,2,1,3]
        l' = FQC
            { input   = input φCl
            , heap    = heap φCl + heap l + hv
            , output  = output l + ov
            , garbage = 0
            , unitary = Ser
                [ Par [unitary φCl, iN (heap l + hv)]
                , Perm perml
                , Par [unitary l, ψv]
                ]
            }
    let permr = batchPermutation [input l,iv,heap l,hv] [0,2,1,3]
        r' = FQC
            { input   = input φCr
            , heap    = heap φCr + heap r + hw
            , output  = output r + ow
            , garbage = 0
            , unitary = Ser
                [ Par [unitary φCr, iN (heap r + hw)]
                , Perm permr
                , Par [unitary r, ψw]
                ]
            }

    return (c', l', lc `Set.union` uses v, r', rc `Set.union` uses w, ψ')

orthogonal _ t f = throw $ BranchesNotOrthonogal t f

amplitude :: Expr -> Result (C, Expr)
amplitude KetZero   = return (1, KetZero)
amplitude KetOne    = return (1, KetOne)
amplitude (Mul k q) = return (C k, q)
amplitude _ = throw Urk

h :: FQC
h = FQC
    { input   = 1
    , heap    = 1
    , output  = 2
    , garbage = 0
    , unitary = Par [Rot (λ,λ) (λ,-λ), Perm [0]]
    } where λ = 1 / sqrt 2

cx :: FQC
cx = FQC
    { input   = 2
    , heap    = 0
    , output  = 2
    , garbage = 0
    , unitary = Cond (Rot (0,1) (1,0)) (Perm [0])
    }

splitContext :: Context -> Expr -> Expr -> (Context, Context, FQC)
splitContext c e1 e2 = (ue1, ue2, fqc)
    where ue1 = uses e1
          ue2 = uses e2
          both = Set.intersection ue1 ue2
          shareN = Set.size both
          fqc = undefined

contraction :: [Id] -> [Id] -> FQC
contraction i o = FQC
    { input   = input
    , heap    = heap
    , output  = output
    , garbage = 0
    , unitary = unitary
    } where input   = length i
            heap    = output - input
            output  = length o
            unitary = Ser $ iN output : map (shares (length o)) (occurances o)

weakening :: Context -> Context -> FQC
weakening i o = FQC
    { input   = input
    , heap    = 0
    , output  = output
    , garbage = garbage
    , unitary = unitary
    } where input   = length i
            heap    = output - input
            output  = length o
            garbage = length diff
            diff    = Set.toList $ i Set.\\ o
            unitary = swapW diff (Set.toList i)

shares :: Int -> [Int] -> Unitary
shares size ~(i:is) = Ser $ map circ is
    where swaps = swapUp size (i+1)
          mlist [] = Nothing
          mlist xs = Just xs
          padU = Perm <$> mlist [0..i-1]
          padD = Perm <$> mlist [0..size-i-3]
          cx x = Par $ catMaybes [padU, Just cnot, padD]
          circ x = Ser [swaps x, cx x, swaps x]

iN :: Int -> Unitary
iN x = Perm [0..x-1]


pX :: Unitary
pX = Rot (0,1) (1,0)

cnot :: Unitary
cnot = Cond pX (iN 1)

swapUp :: Int -> Int -> Int -> Unitary
swapUp size x y = Perm $ swapIx size x y

swapIx :: Int -> Int -> Int -> [Int]
swapIx size x y = (element x .~ (l !! y)) $ (element y .~ (l !! x)) l
    where l = [0..size-1]

occurances :: [Id] -> [[Int]]
occurances = nub . filter ((>1) . length) . (map =<< flip elemIndices)

swapW :: [Id] -> [Id] -> Unitary
swapW g = Perm
        . map fst
        . uncurry (<>)
        . swap
        . partition (flip elem g . snd)
        . zip [0..]

uses :: Expr -> Context
uses (Var i)        = Set.singleton i
uses KetZero        = Set.empty
uses KetOne         = Set.empty
uses (Tup xs)       = Set.unions $ map uses xs
uses (Mul _ e)      = uses e
uses (App e1 e2)    = on (<>) uses e1 e2
uses (Plus e1 e2)   = on (<>) uses e1 e2
uses (Comp e1 e2)   = on (<>) uses e1 e2
uses (Ifq e1 e2 e3) = uses e1 <> uses e2 <> uses e3
uses (If e1 e2 e3)  = uses e1 <> uses e2 <> uses e3
uses (Abs a e)      = Set.difference (uses e) (Set.fromList a)
uses (Let l e)      = Set.difference (uses e) ids <> exps
    where (ids, exps) = bimap
                            (Set.fromList . concat)
                            (Set.unions . map uses)
                            (unzip (Map.toList l))

comp :: FQC -> FQC -> Result FQC
comp (FQC iα hα oα gα α) (FQC iβ hβ oβ gβ β)
    = guard (oβ == iα) Urk
  >> return FQC
    { input   = iβ
    , heap    = hα + hβ
    , output  = oα
    , garbage = gα + gβ
    , unitary = Ser [β, α]
    }