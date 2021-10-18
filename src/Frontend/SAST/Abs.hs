module Frontend.SAST.Abs where

import Data.Complex ( Complex )
import qualified Data.Map as Map

type Program = [Toplevel]

data Id 
    = Id
    { pos  :: (Int, Int)
    , name :: String
    } deriving (Eq, Show, Read, Ord)

data Toplevel = Topl Id [[Id]] (Maybe Type) Expr
  deriving (Eq, Show, Read)

type Let = Map.Map [Id] Expr

data Expr
    = Var Id
    | KetZero
    | KetOne
    | Tup [Expr]
    | Mul (Complex Double) Expr
    | App Expr Expr
    | Plus Expr Expr
    | Comp Expr Expr
    | Ifq Expr Expr Expr
    | If Expr Expr Expr
    | Let Let Expr
    | Abs [Id] Expr
  deriving (Eq, Show, Read)

data Type = Forall [Id] Type | TypeVar Id | TypeQubit | TypeUnit | Type :* Type | Type :-> Type
  deriving (Eq, Ord, Show, Read)