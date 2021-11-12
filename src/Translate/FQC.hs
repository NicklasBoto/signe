{-|
Module      : FQC
Description : Finite quantum computations
Stability   : experimental

Exports the datatype for finite quantum computations as well as their predefined morphisms
-}
module Translate.FQC
    ( FQC(..)
    ) where

import Translate.Unitary.Data
import Translate.FQC.Data
import Control.Monad
import Translate.Matrix
import Translate.Result

test :: Unitary
test = Par [ notU, unitary had ]

φC :: Unitary
φC = undefined

idU :: Int -> Unitary
idU x = Perm [0..x-1]

notU :: Unitary
notU = Rot (0,1) (1,0)

δ :: FQC
δ = FQC
    { input   = 1
    , heap    = 1
    , output  = 2
    , garbage = 0
    , unitary = Cond notU (idU 1)
    }

del :: FQC
del = δ

cnot :: Unitary
cnot = Cond (Rot (0,1) (1,0)) (Perm [0])

qnot :: FQC
qnot = FQC
    { input   = 1
    , heap    = 0
    , output  = 1
    , garbage = 0
    , unitary = notU
    }

had :: FQC
had = FQC
    { input   = 1
    , heap    = 0
    , output  = 1
    , garbage = 0
    , unitary = Rot (λ,λ) (λ,-λ) 
    } where λ = 1 / sqrt 2

mat1, mat2, mat3, mat4, mat5 :: Unitary
mat1 = Rot (0.8366533864541833 :+ (-0.5477327002605806), 0) (0, -0.49019607843137253 :+ 0.871612187093838)
mat2 = Rot (-0.8346613545816733 :+ 0.550763491135611, 0) (0, 1)
mat3 = Rot (0.035856573705179286 :+ 0.8235294117647058, 0.566139) (-0.566139, 0.035856573705179286 :+ (-0.8235294117647058))
mat4 = Rot (-0.21115537848605578 :+ (-0.4230769230769231), -0.881147) (-0.881147, 0.21115537848605578 :+ (-0.4230769230769231))
mat5 = Rot (-0.7211155378486056 :+ (-0.5616438356164384), -0.008 :+ 0.4055669895188358) (-0.405646, -0.5473130239812032 :+ (-0.7320518224778756))

combs = Par . map Ser . flip replicateM [mat1, mat2, mat3, mat4, mat5]