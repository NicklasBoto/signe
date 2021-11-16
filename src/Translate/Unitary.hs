{-# LANGUAGE PatternSynonyms #-}

{-|
Module      : Unitary
Description : Unitary transformations
Stability   : stable

Exports the datatype for unitary transformations as well as functions defined on them.
-}
module Translate.Unitary
    ( arity
    , inner
    , rotations
    , crotations
    , module Translate.Unitary.Data
    ) where

import Translate.Unitary.Data ( Unitary(..), complex, pattern (:+), C(..) )
import Numeric.LinearAlgebra ( fromList, dot )
import Data.Complex as Cx
import Data.Function ( on )
import Translate.Result
    ( TranslationError(ConditionalArityMismatch, SerialArityMismatch),
      Result,
      guard )

arity :: Unitary -> Result Int
arity (Par [])     = return 0
arity (Par (x:xs)) = (+) <$> arity x <*> arity (Par xs)
arity (Ser [])     = return 0
arity (Ser xs) = do
    as@(a:_) <- mapM arity xs
    guard (all (==a) as) $ SerialArityMismatch xs
    return a
arity (Perm xs)  = return $ length xs
arity (Cond t c) = do
    m <- arity t
    n <- arity c
    guard (m == n) $ ConditionalArityMismatch t c
    return $ m + n
arity (Rot _ _) = return 1

inner :: (C, C) -> (C, C) -> C
inner (i,j) (k,l) = C $ on dot (fromList . map complex) [i,j] [k,l]

rotations :: (C, C) -> (C, C) -> [C]
rotations (i,j) (k,l) = [i,j,k,l]

crotations :: (C, C) -> (C, C) -> [Cx.Complex Double]
crotations = (map complex .) . rotations
