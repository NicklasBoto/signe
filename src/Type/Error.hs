module Type.Error where

import Frontend.SAST.Abs
import Frontend.SAST.Print ()

data TypeError
    = TypeMismatch Type Type
    | InfiniteType Id Type
    | VariableNotInScope Id
    | ScalarNotNormalized Expr
    deriving Show

urk :: a
urk = error "urk"