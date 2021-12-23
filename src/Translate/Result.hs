{-# LANGUAGE GeneralisedNewtypeDeriving #-}
{-# LANGUAGE PatternSynonyms            #-}

{-|
Module      : Result
Description : Translation monad
Stability   : stable

Exports the error handling monad for translation
-}
module Translate.Result
    ( Result
    , module Translate.Error
    , guard
    , equal
    , equalM
    , throw
    , runResult
    , testResult
    ) where

import Translate.Error ( TranslationError(..), pattern Urk, pattern NotImplemented )
import Control.Monad.Except
    ( runExcept, MonadError, Except, ExceptT(ExceptT), throwError )

newtype Result a = Result { getResult :: Except TranslationError a }
    deriving (Functor, Applicative, Monad, MonadError TranslationError)

newtype ResultT m a = ResultT { getResultT :: ExceptT TranslationError m a }
    deriving (Functor, Applicative, Monad, MonadError TranslationError)

instance MonadFail Result where
    fail = throwError . Fail

runResult :: Result a -> Either TranslationError a
runResult = runExcept . getResult

testResult :: Result a -> a
testResult = either (errorWithoutStackTrace . show) id . runResult

guard :: Bool -> TranslationError -> Result ()
guard True  _ = return ()
guard False e = throwError e  

equal :: Eq a => a -> a -> TranslationError -> Result a
equal x y e = guard (x == y) e >> return x

equalM :: Eq a => Result a -> Result a -> TranslationError -> Result a
equalM x y e = do
    x' <- x
    y' <- y
    guard (x' == y') e
    return x'

throw :: TranslationError -> Result notATotalProgram
throw = throwError
