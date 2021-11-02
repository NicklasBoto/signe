{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE Rank2Types     #-}
{-# LANGUAGE DataKinds      #-}

module Translate.Realize where

import Data.Functor.Contravariant

newtype T a = T { implement :: a -> * }

instance Contravariant T where
    contramap f (T g) = T $ g . f

data Implementation = Quantum | Classical

class Realizable (c :: Implementation -> *) where
    realize :: forall (i :: Implementation) . c i -> Bool