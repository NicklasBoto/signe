{-# LANGUAGE GeneralisedNewtypeDeriving #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE KindSignatures  #-}

module Translate.Reality.Check where

import Frontend.SAST.Abs
import Translate.Reality.Error
import Frontend.SAST.Par ()
import Frontend.SAST.Print ()
import Data.Function
import Control.Monad.Except
import Control.Applicative (Applicative)

type Result = Maybe RealityError

newtype Check a = Check (Except RealityError a)
    deriving (Functor, Applicative, Monad, MonadError RealityError)

runCheck :: Check a -> Either RealityError a
runCheck (Check c) = runExcept c

ok, urk :: Check ()
ok  = return ()
urk = throwError Urk

test :: Check a -> String
test c = case runCheck c of
    Left  e -> errorWithoutStackTrace $ show e
    Right _ -> "Ok!"

pattern Error :: RealityError -> Result
pattern Error e = Just e

pattern Ok, Bad :: Result
pattern Ok  = Nothing
pattern Bad = Error Urk

realityCheck :: Program -> Result
realityCheck = const Bad

monomorphic :: Scheme -> Check ()
monomorphic (Forall [] t) = go t
    where go TypeUnit  = ok 
          go TypeQubit = ok
          go (s :* t)  = go s >> go t
          go _         = throwError Uninstantiated 
monomorphic _ = throwError Uninstantiated 



-- class Realizable c where
--     check :: c -> Result
--     registerSize :: c -> Int
-- 
-- instance Realizable Type where
--     check = const Bad
-- 
--     registerSize TypeUnit  = 0
--     registerSize TypeQubit = 1
--     registerSize (s :* t)  = ((+) `on` registerSize) s t
--     registerSize _ = Bad
-- 
-- instance Realizable Scheme where
--     check (Forall _ t) = check t

class Register (r :: *) where
    size :: r -> Int

instance Register Type where
    size TypeUnit  = 0
    size TypeQubit = 1
    size (s :* t)  = on (+) size s t
    size _ = undefined 
