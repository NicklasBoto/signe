module Translate.Reality.Error where

data RealityError
    = NoMainFunction
    | Uninstantiated
    | Unrealizable
    | Urk

instance Show RealityError where
    show NoMainFunction =
        "No main function defined"

    show Uninstantiated =
        "Program output not instantiated. Main function must be monomorphic"

    show Unrealizable =
        "Program output not realizable"
    
    show Urk =
        "urk"