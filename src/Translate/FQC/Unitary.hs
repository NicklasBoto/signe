{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE FlexibleInstances  #-}
{-# LANGUAGE FlexibleContexts   #-}
{-# LANGUAGE PatternSynonyms    #-}
{-# LANGUAGE TypeFamilies       #-}
{-# LANGUAGE DerivingVia        #-}

module Translate.FQC.Unitary
    ( C
    , complex
    , Unitary(..)
    , pattern (:+)
    , arity
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
import qualified Data.Complex as Cx ( Complex(..), realPart )
import Control.Monad ( guard )
import Data.Function ( on )
import Foreign.Storable ( Storable )
import Numeric.LinearAlgebra ( RealOf, Element(..), Product(..) )

type instance RealOf C = Double

newtype C = C (Cx.Complex Double)
    deriving (Eq, Num, Ord, Fractional, Floating, Storable)
        via (Cx.Complex Double)
    deriving Data

instance Ord (Cx.Complex Double) where
    (<=) = (<=) `on` Cx.realPart . abs

instance Show C where
    show = render . showC

showC :: C -> Doc
showC (C (r Cx.:+ 0)) = double r 
showC (C (0 Cx.:+ i)) = double i <> "i"
showC (C (r Cx.:+ i)) = double r <+> "+" <+> double i <> "i"

pattern (:+) :: Double -> Double -> C
pattern (:+) r i = C (r Cx.:+ i)

complex :: C -> Cx.Complex Double
complex (C x) = x

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

arity :: Unitary -> Maybe Int
arity (Par [])     = return 0
arity (Par (x:xs)) = (+) <$> arity x <*> arity (Par xs)
arity (Ser [])     = return 0
arity (Ser xs) = do
    as@(a:_) <- mapM arity xs
    guard $ all (==a) as
    return a
arity (Perm xs)  = return $ length xs
arity (Cond t c) = do
    m <- arity t
    n <- arity c
    guard (m == n)
    return m 
arity (Rot _ _) = return 1
