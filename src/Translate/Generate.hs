{-# LANGUAGE DataKinds #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE GeneralisedNewtypeDeriving #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE IncoherentInstances #-}

module Translate.Generate where

import Translate.Unitary
import Translate.Result
import Translate.FQC
import GHC.TypeLits
import Control.Monad.Writer
import Control.Monad.State
import Control.Monad
import Data.Bifunctor
import qualified Numeric.LinearAlgebra as L
import Data.List
import Translate.Result
import qualified Data.Complex as C
import Translate.Compile
import Frontend.SAST.Par

genFile :: FilePath -> IO ()
genFile = putStrLn . putQASM . testResult . compileProgram . parse <=< readFile

-- Ser 
--     [ Par [Perm [0]]
--     , Perm [0]
--     , Par [Rot (0.7071067811865475,0.7071067811865475) (0.7071067811865475,-0.7071067811865475)]
--     , Perm [0]
--     , Perm [0]
--     , Rot (0.0,1.0) (1.0,0.0)
--     ]

test :: Unitary
test = Ser [ Par [Perm [0,1]]
    , Perm [0,1]
    , Par [Perm [0],Perm [0]]
    , Perm [0,1]
    , Par [Cond (Rot (0.0,1.0) (1.0,0.0)) (Perm [0])]
    , Perm [1,0]
    ]

tf :: FQC
tf = FQC
    { input = 1
    , heap = 1
    , output = 2
    , garbage = 0
    , unitary = test
    }

type Circ = [Gate]

newtype Gen a = Gen { getGen :: StateT (Int,Int) (Writer Circ) a }
    deriving (Functor, Applicative, Monad, MonadState (Int,Int), MonadWriter Circ)

runGen :: Gen a -> ((a, (Int, Int)), Circ)
runGen = runWriter . flip runStateT (0,0) . getGen

evalGen :: Gen a -> Circ
evalGen = snd . runGen

generate :: FQC -> QASM
generate (FQC i h o g φ) = QASM
    { qubits  = i+h
    , discard = g
    , circuit = evalGen (genCircuit φ)
    }

putQASM :: FQC -> String
putQASM = putCircuit . generate

data QASM
    = QASM
    { qubits :: Int
    , discard :: Int
    , circuit :: Circ
    } deriving Show

data Gate
    = Unitary Int Double Double Double
    | CX Int Int
    | Swap Int Int
    deriving Show

x, h :: Int -> Gate
x q = Unitary q pi 0 (-pi)
h q = Unitary q (pi/2) 0 (-pi)

instance Eq Gate where
    Swap a b == Swap c d = (a,b) == (c,d) || (a,b) == (d,c)
    _ == _ = undefined

instance Semigroup QASM where
    (<>) = undefined

instance Monoid QASM where
    mappend = (<>)
    mempty = QASM 0 0 []

wire :: Gate -> Gen ()
wire = tell . pure

wires :: [Gate] -> Gen ()
wires = tell

addRow, addCol :: Int -> Gen ()
addRow = modify . first . (+)
addCol = modify . second . (+)

incRow, incCol, decRow, decCol :: Gen ()
incRow = addRow 1
incCol = addCol 1
decRow = addRow (-1)
decCol = addCol (-1)

modSwap :: Int -> Gate -> Gate
modSwap i ~(Swap x y) = Swap (x+i) (y+i)

genCircuit :: Unitary -> Gen ()
genCircuit (Rot (i,j) (k,l)) = do
    (r,_c) <- get
    let (θ,φ,λ) = qasmGate i j k l
        gate    = Unitary r θ φ λ
    wire gate
genCircuit (Cond (Rot (i,j) (k,l)) (Rot (a,b) (c,d))) = do
    incRow
    (r,_c) <- get
    let ((θ,φ,λ), (θ',φ',λ')) = controlledGate i j k l
        ((t,f,lam), (t',f',lam')) = controlledGate a b c d
        gates = [ Unitary r θ φ λ, CX (r-1) r, Unitary r θ' φ' λ', CX (r-1) r
                , x (r-1), Unitary r t f lam, CX (r-1) r, Unitary r t' f' lam', CX (r-1) r, x (r-1)
                ]
    tell gates
    decRow
genCircuit (Cond (Rot (i,j) (k,l)) (Perm [0])) = do
    incRow
    (r,_c) <- get
    let ((θ,φ,λ), (θ',φ',λ')) = controlledGate i j k l
        gates = [ Unitary r θ φ λ, CX (r-1) r, Unitary r θ' φ' λ', CX (r-1) r ]
    tell gates
    decRow
genCircuit (Perm ps) = do
    (r,_c) <- get
    let swaps = map (modSwap r) $ permutationSwaps ps
    tell swaps
genCircuit (Par ps) = mapM_ (liftM2 (>>) genCircuit (addRow . testResult . arity)) ps
genCircuit (Ser ss) = mapM_ (liftM2 (>>) genCircuit (addCol . testResult . arity)) ss
genCircuit x = error $ show x

permutationSwaps :: [Int] -> [Gate]
permutationSwaps = filter (\(Swap m n) -> m /= n) . nub . zipWith Swap [0..]

controlledGate :: C -> C -> C -> C -> ((Double,Double,Double), (Double,Double,Double))
controlledGate i j k l = ((θ,φ,λ), (θ',φ',λ'))
    where φ1 = i
          conj = C . C.conjugate . complex
          m  = L.matFunc sqrt ((2 L.>< 2) (crotations (i,j) (k,l)))
          md = L.tr m
          [[mi,mj],[mk,ml]] = L.toLists m
          [[mdi,mdj],[mdk,mdl]] = L.toLists md
          (θ,φ,λ) = qasmGate (C mi) (C mj) (C mk) (C ml)
          (θ',φ',λ') = qasmGate (C mdi) (C mdj) (C mdk) (C mdl)

qasmGate :: C -> C -> C -> C -> (Double,Double,Double)
qasmGate i j k l
  | abs i^2 + abs k^2 == 1
 && j == - (conjugate k)
 && l == conjugate i = (θ, φ, λ)
  | otherwise = error "not good"
    where conjugate = C . C.conjugate . complex
          x :+ y = i
          p :+ q = k
          φ = if x == 0 || p == 0 then 0 else atan (-y/x) + atan (-q/p)
          λ = if x == 0 || p == 0 then 0 else atan (-y/x) - atan (-q/p)
          θ = 2 * atan (sqrt ((p^2 + q^2) / (x^2 + y^2)))

qasmString :: [[String]] -> String
qasmString = unlines . map concat

putCircuit :: QASM -> String
putCircuit (QASM q d circ) = qasmString
    [ [ "// GENERATED BY THE SIGNE COMPILER" ]
    , [ "// Nicklas Botö, Fabian Forslund 2021" ]
    , [ "OPENQASM 2.0;" ]
    , [ "include \"qelib1.inc\";" ]
    , [ "" ]
    , [ "// initialise qubit registers" ]
    , [ "qreg heap[", show q, "];" ]
    , [ "creg output[", show (q-d), "];" ]
    , [ "" ]
    , [ "// main program" ]
    , map ((++"\n") . putGate) circ
    , [ "" ]
    , [ "// prepare output" ]
    , map (\i -> "reset heap[" ++ show i ++ "];\n") [q-d..q-1]
    , map (\i -> "measure heap[" ++ show i ++ "] -> output[" ++ show i ++ "];\n") [0..q-d-1]
    ]

putGate :: Gate -> String
putGate (Unitary q θ φ λ) = concat ["U(", show θ, ",", show φ, ",", show λ, ") heap[", show q, "];"]
putGate (CX p q) = concat ["CX heap[", show p, "], heap[", show q, "];"]
putGate (Swap m n) = concat ["swap heap[", show m, "], heap[", show n, "];"]
