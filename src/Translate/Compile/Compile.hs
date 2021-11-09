{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE RankNTypes     #-}

module Translate.Compile.Compile where

import Frontend.SAST.Abs
import Translate.FQC.Data
import Data.Map

data Comp = Comp { usedContext :: [String]
                 , types :: Type
                 , fqc   :: FQC }

data FSig = FSig Con Type
data FDef = FDef FSig Expr
type Env a = Map String a
type Prog = Env FDef
type Con = Env Type

compile :: *
compile = undefined