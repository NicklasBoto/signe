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
    ( myLexer, pExpr, pProgram, pToplevel, pType, pMono )
import Frontend.Signe.Lex ( Token )
import Frontend.Signe.Layout ( resolveLayout )
import Frontend.SAST.Abs ( Expr, Program, Scheme, Toplevel, Id(..), Type)
import Frontend.SAST.Convert
    ( convert, convertExpr, convertToplevel, convertType, convertMono )
import Data.String ( IsString(..) )

instance IsString Id where
    fromString = Id Nothing

ofParser :: (t -> p) -> ([Token] -> Either String t) -> String -> p
ofParser conv par s = case par (resolveLayout False (myLexer s)) of
    Right e -> conv e
    Left  s -> error s

parseExpr :: String -> Expr
parseExpr = convertExpr `ofParser` pExpr

instance IsString Expr where
    fromString = parseExpr

parseMono :: String -> Type 
parseMono = convertMono `ofParser` pMono

instance IsString Type where
    fromString = parseMono

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
