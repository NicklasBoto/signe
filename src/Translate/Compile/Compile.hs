{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE RankNTypes     #-}

module Translate.Compile.Compile where

import Frontend.SAST.Abs
import Translate.FQC
import Translate.Unitary
import Data.Map
import Frontend.SAST.Par
import Frontend.SAST.Print
import Type.Check

data Comp = Comp { usedContext :: [String]
                 , types :: Type
                 , fqc   :: FQC }

data FSig = FSig Con Type
data FDef = FDef FSig Expr
type Env a = Map String a
type Prog = Env FDef
type Con = Env Type

test :: Program
test = parse "main : qubit * qubit := (~0, ~0)"

test_fqc :: FQC
test_fqc = FQC 
    { input   = 0
    , heap    = 2
    , output  = 2
    , garbage = 0
    , unitary = Perm [0,1]
    }

compile :: *
compile = undefined