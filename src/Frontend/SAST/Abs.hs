module Frontend.SAST.Abs where

import Data.Complex ( Complex )
import qualified Data.Map as Map

type Program = [Toplevel]

data Id 
    = Id
    { pos  :: Maybe (Int, Int)
    , name :: String
    } deriving Read

instance Eq Id where
  Id _ a == Id _ b = a == b

instance Ord Id where
  compare (Id _ a) (Id _ b) = compare a b

data Toplevel = Topl Id [[Id]] (Maybe Scheme) Expr
  deriving (Eq, Read)

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
  deriving (Eq, Read)

data Scheme = Forall [Id] Type
  deriving (Eq, Read)

data Type = TypeVar Id | TypeQubit | TypeUnit | Type :* Type | Type :-> Type
  deriving (Eq, Read)