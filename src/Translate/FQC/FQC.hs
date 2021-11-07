{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE KindSignatures  #-}
{-# LANGUAGE Rank2Types      #-}
{-# LANGUAGE DataKinds       #-}

module Translate.FQC.FQC where

import Translate.FQC.Unitary
import Translate.FQC.Matrix

-- H input heap
-- h initialisation constant
-- A input 
-- B output
-- G garbage

data FQC = FQC
    { input, heap, output, garbage :: Int
    , unitary :: Unitary
    }

instance Show FQC where
    show FQC{..} = mconcat
        [ "A: " , show input   , "\n"
        , "H: " , show heap    , "\n"
        , "B: " , show output  , "\n"
        , "G: " , show garbage , "\n"
        , "φ: " , show unitary
        ]

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
