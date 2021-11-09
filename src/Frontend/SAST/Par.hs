{-|
Module      : SAST.Par
Description : Internal parsers
Stability   : stable

Exports parser for use internally in the compiler
-}
module Frontend.SAST.Par 
    ( parseExpr
    , parseType
    , parse
    ) where

import Frontend.Signe.Par
    ( myLexer, pExpr, pProgram, pToplevel, pType )
import Frontend.Signe.Lex ( Token )
import Frontend.Signe.Layout ( resolveLayout )
import Frontend.SAST.Abs ( Expr, Program, Scheme, Toplevel )
import Frontend.SAST.Convert
    ( convert, convertExpr, convertToplevel, convertType )
import Data.String ( IsString(..) )

ofParser :: (t -> p) -> ([Token] -> Either String t) -> String -> p
ofParser conv par s = case par (resolveLayout False (myLexer s)) of
    Right e -> conv e
    Left  s -> error s

parseExpr :: String -> Expr
parseExpr = convertExpr `ofParser` pExpr

instance IsString Expr where
    fromString = parseExpr

parseType :: String -> Scheme
parseType = convertType `ofParser` pType

instance IsString Scheme where
    fromString = parseType

parseToplevel :: String -> Toplevel
parseToplevel = convertToplevel `ofParser` pToplevel

instance IsString Toplevel where
    fromString = parseToplevel

parse :: String -> Program
parse s = case pProgram (resolveLayout True (myLexer s)) of
    Right e -> convert e
    Left  s -> error s
