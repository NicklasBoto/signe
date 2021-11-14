{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE TupleSections  #-}
{-# LANGUAGE RankNTypes     #-}
{-# LANGUAGE LambdaCase     #-}

module Translate.Compile.Compile where

import Frontend.SAST.Abs
import Translate.FQC
import Translate.Unitary
import Data.Map
import Frontend.SAST.Par
import Frontend.SAST.Print
import Translate.Result
import Data.Complex

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

idFQC :: FQC
idFQC = FQC
    { input   = 1
    , heap    = 0
    , output  = 1
    , garbage = 0
    , unitary = Perm [0]
    }

compile :: Expr -> Result FQC
compile = \case
    KetZero -> return FQC
        { input   = 0
        , heap    = 1
        , output  = 1
        , garbage = 0
        , unitary = Perm [0]
        }

    KetOne -> return FQC
        { input   = 0
        , heap    = 1
        , output  = 1
        , garbage = 0
        , unitary = Rot (0,1) (1,0)
        }

    Mul k q -> return FQC
        { input   = 0
        , heap    = 1
        , output  = 1
        , garbage = 0
        , unitary = Rot (C k,0) (0, C k)
        }

    Plus p q -> do
        (ap, cp) <- amplitude p
        (aq, cq) <- amplitude q
        guard (orthogonal cp cq) Urk

        let (k,v) = normalize ap aq

        return FQC
            { input   = 0
            , heap    = 1
            , output  = 1
            , garbage = 0
            , unitary = Rot (k, v) (v, -k) 
            }

    _ -> throw Urk

normalize :: C -> C -> (C, C)
normalize a b = (a / norm a b, b / norm a b)
    where norm a b = sqrt $ abs a ^ 2 + abs b ^ 2

orthogonal :: Expr -> Expr -> Bool
orthogonal KetOne KetZero = True
orthogonal KetZero KetOne = True
orthogonal _       _      = False

amplitude :: Expr -> Result (C, Expr)
amplitude KetZero   = return (1, KetZero)
amplitude KetOne    = return (1, KetOne)
amplitude (Mul k q) = return (C k, q)
amplitude _ = throw Urk
