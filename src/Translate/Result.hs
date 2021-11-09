{-# LANGUAGE GeneralisedNewtypeDeriving  #-}
{-# LANGUAGE PatternSynonyms             #-}

module Translate.Result
    ( Result
    , module Translate.Error
    , guard
    ) where

import Translate.Error ( TranslationError(..), pattern Urk )
import Control.Monad.Except
    ( runExcept, MonadError, Except, ExceptT(ExceptT), throwError )

newtype Result a = Result { getResult :: Except TranslationError a }
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
