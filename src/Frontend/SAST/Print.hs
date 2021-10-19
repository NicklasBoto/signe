{-# LANGUAGE NamedFieldPuns #-}

module Frontend.SAST.Print where

import Frontend.SAST.Abs
    ( Type, Expr, Toplevel, Id(Id, name), Scheme )
import Frontend.SAST.Convert
    ( revertToplevel, revertType, revertExpr, revertMono )
import Frontend.Signe.Print ( printTree )

instance Show Id where
    show Id{name} = name

instance Show Toplevel where
    show = printTree . revertToplevel

instance Show Expr where
    show = printTree . revertExpr

instance Show Scheme where
    show = printTree . revertType

instance Show Type where
    show = printTree . revertMono
