module Translate.FQC.Unitary where

import Data.Complex ( Complex )

type C = Complex Double

data Unitary 
    = Par [Unitary]
    | Ser [Unitary]
    | Perm [Int]
    | Cond Unitary Unitary
    | Rot (C,C) (C,C)
    deriving (Eq, Show)
    