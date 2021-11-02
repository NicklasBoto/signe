module Type.Error where

import Frontend.SAST.Abs
import Frontend.SAST.Print ()

data TypeError
    = TypeMismatch Type Type
    | InfiniteType Id Type
    | VariableNotInScope Id
    | ScalarNotNormalized Expr

instance Show TypeError where
    show (TypeMismatch e a) =
        "Couldn't match expected type '" ++ show e ++
        "' with actual type '" ++ show a ++ "'"

    show (VariableNotInScope v) =
        "Variable not in scope: " ++ show v

    show (InfiniteType v t) =
        "Occurs check, cannot construct the infinite type: " ++
        show v ++ " ~ " ++ show t
    
    show (ScalarNotNormalized e) =
        "Scalar is not normalized: " ++ show e


urk :: a
urk = error "urk"