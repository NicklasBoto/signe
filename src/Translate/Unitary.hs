module Translate.Unitary
    ( arity
    , module Translate.Unitary.Data
    ) where

import Translate.Unitary.Data
import Translate.Result

arity :: Unitary -> Result Int
arity (Par [])     = return 0
arity (Par (x:xs)) = (+) <$> arity x <*> arity (Par xs)
arity (Ser [])     = return 0
arity (Ser xs) = do
    as@(a:_) <- mapM arity xs
    guard (all (==a) as) Urk
    return a
arity (Perm xs)  = return $ length xs
arity (Cond t c) = do
    m <- arity t
    n <- arity c
    guard (m == n) Urk
    return m 
arity (Rot _ _) = return 1
