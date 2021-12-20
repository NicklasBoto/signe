{-# LANGUAGE DataKinds #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE GeneralisedNewtypeDeriving #-}
{-# LANGUAGE DerivingVia #-}

module Translate.Generate where

import Translate.Unitary.Data
import Translate.FQC
import GHC.TypeLits
import Control.Monad.Writer
import Control.Monad.State
import Data.Bifunctor
import Data.List

-- Ser [ Par [Perm [0,1]]
--     , Perm [0,1]
--     , Par [Perm [0],Perm [0]]
--     , Perm [0,1]
--     , Par [Cond (Rot (0.0,1.0) (1.0,0.0)) (Perm [0])]
--     , Perm [1,0]
--     ]

newtype Gen a = Gen { getGen :: StateT (Int,Int) (Writer QASM) a }
    deriving (Functor, Applicative, Monad, MonadState (Int,Int), MonadWriter QASM)

data QASM
    = QASM
    { row :: Int
    , col :: Int
    , discard :: Int
    , circuit :: [[Gate]]
    }

data Gate
    = Unitary C C C
    | Control Gate
    | Swap Int Int
    deriving Show

instance Eq Gate where
    Swap a b == Swap c d = (a,b) == (c,d) || (a,b) == (d,c)
    _ == _ = undefined

instance Semigroup QASM where
    (<>) = undefined

instance Monoid QASM where
    mappend = (<>)
    mempty = QASM 0 0 0 []

wire :: Gate -> Gen ()
wire g = modify (first succ)

genCircuit :: Unitary -> Gen ()
genCircuit (Rot (i,j) (k,l)) = undefined -- qasmGate i j k l
genCircuit (Cond φ ψ) = undefined
genCircuit (Perm ps) = tell $ permutationSwaps ps
genCircuit _ = undefined

permutationSwaps :: [Int] -> [Gate]
permutationSwaps = filter (\(Swap m n) -> m /= n) . nub . zipWith Swap [0..]

qasmGate :: C -> C -> C -> C-> Gate
qasmGate i j k l = Unitary θ φ λ
    where imag = 0 :+ 1
          θ = 2 * acos i
          φ = if j == 0 then 0 else log (j / sin (θ/2)) / imag
          λ = if k == 0 then 0 else log (-(k / sin (θ/2))) / imag

-- gate h q {
--    U(π/2, 0, π) q;
-- }

qasmString :: [[String]] -> String
qasmString = unlines . map unwords

putGate :: Gate -> String -> String
putGate ~(Unitary θ φ λ) name = unlines $ map unwords
    [[ "gate", name, "unary_qubit", "{" ]
    ,[ "    U(", show θ, ",", show φ, ",", show λ, ") unary_qubit ;" ]
    ,[ "}" ]
    ]