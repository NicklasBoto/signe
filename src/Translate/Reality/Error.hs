module Translate.Reality.Error where

data RealityError
    = NoMainFunction
    | Urk

instance Show RealityError where
    show NoMainFunction =
        "No main function defined"
    
    show Urk =
        "urk"