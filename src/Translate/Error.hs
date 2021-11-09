{-# LANGUAGE PatternSynonyms #-}

module Translate.Error
    ( TranslationError(..)
    , pattern Urk
    ) where

-- | The set of errors that can occur during circuit translation and compilation
data TranslationError
    -- | General failure for MonadFail instance, should not occur
    = Fail String
    -- |
    | ConditionalArityMismatch Unitary Unitary

pattern Urk :: TranslationError
pattern Urk = Fail "The designer of this compiler has not covered his tracks, and this error should never occur."

instance Show TranslationError where
    show (Fail s) = s
