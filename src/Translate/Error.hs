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
import Frontend.SAST.Abs ( Expr )
import Frontend.SAST.Print ()

-- | The set of errors that can occur during circuit translation and compilation
data TranslationError
    -- | General failure for MonadFail instance, should not occur
    = Fail String
    -- | Non-equal arites of unitary conditionals
    | ConditionalArityMismatch Unitary Unitary
    -- | Non-equal arities of serial unitary transformations
    | SerialArityMismatch [Unitary]
    -- | Non-equal arities of parallel unitary transformations
    | ParallelArityMismatch [Unitary]
    -- | Pattern is not a permutation of [0..n-1]
    | MalformedPermutationPattern [Int]
    -- | A rotation operation is not unitary
    | RotationNotOrthogonal Unitary
    -- | Branches of a strict conditional are not orthogonal
    | BranchesNotOrthonogal Expr Expr
    


-- | Placeholder error, or impossible error
pattern Urk :: TranslationError
pattern Urk = Fail "The designer of this compiler has not covered his tracks, and this error should never occur."

instance Show TranslationError where
    show (Fail s) = s
    show (ConditionalArityMismatch u v)   = "ConditionalArityMismatch: Arities not matching\n" ++ show u ++ "\n" ++ show v
    show (SerialArityMismatch xs)         = "SerialArityMismatch: Arities do not match" ++ concatMap ((++) "\n" . show) xs
    show (ParallelArityMismatch xs)       = "ParallelArityMismatch: Arities do not match" ++ concatMap ((++) "\n" . show) xs
    show (MalformedPermutationPattern ns) = "MalformedPermutationPattern: Pattern is not a permutation of [0..n-1]\n" ++ show ns
    show (RotationNotOrthogonal u)        = "RotationNotOrthogonal: Rotation is not orthogonal" ++ show u
    show (BranchesNotOrthonogal t f)      = "BranchesNotOrthogonal: Branches of strict conditional are not orthogonal\n" ++ show (t,f)