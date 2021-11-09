{-# LANGUAGE RecordWildCards #-}

module Translate.FQC.Data where

import Translate.Unitary.Data

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
