{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE PatternSynonyms    #-}
{-# LANGUAGE DerivingVia        #-}

module Translate.FQC.Unitary
    ( C(..)
    , Unitary(..)
    ) where

import Prelude hiding ( (<>) )
import Data.Data ( Data )
import Text.PrettyPrint
    ( ($$),
      (<+>),
      (<>),
      braces,
      double,
      int,
      nest,
      punctuate,
      render,
      sep,
      text,
      Doc )
import qualified Data.Complex as Cx ( Complex(..) )

newtype C = C (Cx.Complex Double)
    deriving (Num, Fractional, Floating, Eq)
        via (Cx.Complex Double)
    deriving Data

instance Show C where
    show = render . showC

showC :: C -> Doc
showC (C (r Cx.:+ 0)) = double r 
showC (C (0 Cx.:+ i)) = double i <> "i"
showC (C (r Cx.:+ i)) = double r <+> "+" <+> double i <> "i"

pattern (:+) :: Double -> Double -> C
pattern (:+) r i = C (r Cx.:+ i)

data Unitary 
    = Par [Unitary]
    | Ser [Unitary]
    | Perm [Int]
    | Cond Unitary Unitary
    | Rot (C,C) (C,C)
    deriving Eq

instance Show Unitary where
    show = render . showU

showU :: Unitary -> Doc
showU (Par   us) = sep $ punctuate "⊗" $ map showU us
showU (Ser   us) = sep $ punctuate "⊙" $ map showU us
showU (Perm  is) = braces $ sep $ map int is
showU (Cond t c) = showU t <+> "if" <+> showU c
showU (Rot (i,j) (k,l)) = "⎡" <> a <+> b <> "⎤"
                $$ nest 3 "⎣" <> c <+> d <> "⎦"
    where [a,b,c,d] = map (text . show) [i,j,k,l]
