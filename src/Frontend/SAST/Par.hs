module Frontend.SAST.Par where

import Frontend.Signe.Par
import Frontend.Signe.Lex ( Token )
import Frontend.Signe.Layout
import Frontend.SAST.Abs
import Frontend.SAST.Convert

ofParser :: (t -> p) -> ([Token] -> Either String t) -> String -> p
ofParser conv par s = case par (resolveLayout False (myLexer s)) of
    Right e -> conv e
    Left  s -> error s

parseExpr :: String -> Expr
parseExpr = convertExpr `ofParser` pExpr

parseType :: String -> Scheme
parseType = convertType `ofParser` pType

parseToplevel :: String -> Toplevel
parseToplevel = convertToplevel `ofParser` pToplevel

parse :: String -> Program
parse s = case pProgram (resolveLayout True (myLexer s)) of
    Right e -> convert e
    Left  s -> error s