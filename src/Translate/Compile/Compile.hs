{-# LANGUAGE OverloadedStrings #-}
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
import Data.Maybe (catMaybes, mapMaybe)
import Debug.Trace

type Context = Set.Set Id

test :: Program
test = parse "main : qubit * qubit := (~0, ~0)"

idFQC :: FQC
idFQC = FQC
    { input   = 1
    , heap    = 0
    , output  = 1
    , garbage = 0
    , unitary = Perm [0]
    }

testCompile :: String -> Result Unitary
testCompile = fmap (removeEmpties . unitary) . compile . parseExpr

compile :: Expr -> Result FQC
compile = \case
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

    Mul k q -> return FQC
        { input   = 0
        , heap    = 1
        , output  = 1
        , garbage = 0
        , unitary = Rot (C k, 0) (0, C k)
        }

    Plus p q -> do
        (ap, cp) <- amplitude p
        (aq, cq) <- amplitude q
        guard (orthogonal cp cq) Urk

        let (k,v) = normalize ap aq

        return FQC
            { input   = 0
            , heap    = 1
            , output  = 1
            , garbage = 0
            , unitary = Rot (k, v) (v, -k)
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

        FQC it ht ot gt φt <- compile t
        FQC iu hu ou gu φu <- compile u

        let bandW = length γδ + ht + hu
            perml = contextPerm bandW hu iu it
            permr = contextPerm bandW gu ou ot

        return FQC
            { input   = input φC
            , heap    = heap φC + ht + hu
            , output  = ot + ou
            , garbage = gt + gu
            , unitary = Ser
                [ Par [unitary φC, Perm [0..ht+hu-1]]
                , perml
                , Par [φt, φu]
                , permr
                ]
            }

    Tup (x:xs) -> compile $ Tup [x, Tup xs]

    Let i u -> do
        let ([x],t) = Map.elemAt 0 i
            ut = uses t
            uu = Set.delete x $ uses u
            ψ  = Set.toList $ Set.union ut uu
            γδ = on (<>) Set.toList ut uu
            φC = contraction ψ γδ


        FQC it ht ot gt φt <- compile t
        FQC iu hu ou gu φu <- compile u

        let bandW = length γδ + ht + hu
            perml = undefined --contextPerm' bandW hu 0 (output φC)
            permc = undefined --contextPerm' bandW it iu
            permr = undefined
            w = if x `Set.notMember` uses u
                    then weakening
                    else undefined

        return FQC
            { input = input φC
            , heap = heap φC + ht + hu
            , output = ot + ou
            , garbage = gt + gu
            , unitary = Ser
                [ Par [unitary φC, Perm [0..ht+hu-1]]
                , perml
                , Par [Perm [undefined], φt, Perm [undefined]]
                , permc
                , Par [Perm [undefined], φu, Perm [undefined]]
                , permr
                ]
            }



    _ -> throw Urk

removeEmpties :: Unitary -> Unitary
removeEmpties (Par us) = Par $ filter nonEmpty $ map removeEmpties us
removeEmpties (Ser us) = Ser $ filter nonEmpty $ map removeEmpties us
removeEmpties a        = a

nonEmpty :: Unitary -> Bool
nonEmpty (Perm []) = False
nonEmpty (Par [])  = False
nonEmpty (Ser [])  = False
nonEmpty _         = True

contextPerm :: Int -> Int -> Int -> Int -> Unitary
contextPerm size a b c = Perm perm
    where band = [0..size-1]
          (γ,(δ,(ηt,ηu))) = second (second (splitAt a) . splitAt b) (splitAt c band)
          perm = γ <> ηt <> δ <> ηu

f :: [Int] -> [Int] -> [Int]
f p c = concatMap (splitPlaces c [0..length c - 1] !!) $ map (-1) p

normalize :: C -> C -> (C, C)
normalize a b = (a / norm a b, b / norm a b)
    where norm a b = sqrt $ abs a ^ 2 + abs b ^ 2

orthogonal :: Expr -> Expr -> Bool
orthogonal KetOne KetZero = True
orthogonal KetZero KetOne = True
orthogonal _       _      = False

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