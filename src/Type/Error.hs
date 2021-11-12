{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE NamedFieldPuns  #-}

{-|
Module      : Type.Error
Description : Typechecking errors
Stability   : stable

Errors that occur during initial typechecking
-}
module Type.Error where

import Frontend.SAST.Abs ( Type, Expr, Id(..) )
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

    show (VariableNotInScope Id{pos=Nothing, name}) =
        "Variable not in scope: " ++ show name

    show (VariableNotInScope Id{..}) =
        "Variable not in scope: " ++ show name ++ " at " ++ show pos

    show (InfiniteType v t) =
        "Occurs check, cannot construct the infinite type: " ++
        show v ++ " ~ " ++ show t
    
    show (ScalarNotNormalized e) =
        "Scalar is not normalized: " ++ show e

urk :: a
urk = error "urk"
