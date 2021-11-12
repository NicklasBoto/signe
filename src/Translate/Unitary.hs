{-# LANGUAGE PatternSynonyms #-}

{-|
Module      : Unitary
Description : Unitary transformations
Stability   : stable

Exports the datatype for unitary transformations as well as functions defined on them.
-}
module Translate.Unitary
    ( arity
    , module Translate.Unitary.Data
    ) where

import Translate.Unitary.Data ( Unitary(..), complex, pattern (:+), C )
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
    guard (m == n) $ ConditionalArityMismatch (t,m) (c,n)
    return m 
arity (Rot _ _) = return 1
