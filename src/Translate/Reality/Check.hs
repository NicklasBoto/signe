{-# LANGUAGE PatternSynonyms #-}

module Translate.Reality.Check where

import Frontend.SAST.Abs
import Translate.Reality.Error

type Result = Maybe RealityError

pattern Error :: RealityError -> Result
pattern Error e = Just e

pattern Ok :: Result
pattern Ok = Nothing

pattern Bad :: Result
pattern Bad = Error Urk

realityCheck :: Program -> Result
realityCheck = const Bad

class Realizable c where
    check :: c -> Result

instance Realizable Type where
    check TypeUnit = Ok
    check _        = Error NoMainFunction 

instance Realizable Scheme where
    check (Forall _ t) = check t
