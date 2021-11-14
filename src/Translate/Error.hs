{-# LANGUAGE PatternSynonyms #-}

{-|
Module      : Translate.Error
Description : Translations errors
Stability   : experimental

Exports the datatype for errors during translation and compilation
-}
module Translate.Error
    ( TranslationError(..)
    , pattern Urk
    ) where

import Translate.Unitary.Data ( Unitary )

-- | The set of errors that can occur during circuit translation and compilation
data TranslationError
    -- | General failure for MonadFail instance, should not occur
    = Fail String
    -- | Non-equal arites of unitary conditionals
    | ConditionalArityMismatch (Unitary, Int) (Unitary, Int)
    -- | Non-equal arities of serial unitary transformations
    | SerialArityMismatch [Unitary]
    -- | Non-equal arities of parallel unitary transformations
    | ParallelArityMismatch [Unitary]
    -- | Pattern is not a permutation of [0..n-1]
    | MalformedPermutationPattern [Int]
    -- | A rotation operation is not unitary
    | RotationNotOrthogonal Unitary
    


-- | Placeholder error, or impossible error
pattern Urk :: TranslationError
pattern Urk = Fail "The designer of this compiler has not covered his tracks, and this error should never occur."

instance Show TranslationError where
    show (Fail s) = s
