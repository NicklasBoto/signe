-- Haskell module generated by the BNF converter

module Frontend.Signe.Skel where

import qualified Frontend.Signe.Abs

type Err = Either String
type Result = Err String

failure :: Show a => a -> Result
failure x = Left $ "Undefined case: " ++ show x

transId :: Frontend.Signe.Abs.Id -> Result
transId x = case x of
  Frontend.Signe.Abs.Id string -> failure x
transScalar :: Frontend.Signe.Abs.Scalar -> Result
transScalar x = case x of
  Frontend.Signe.Abs.Scalar string -> failure x
transProgram :: Frontend.Signe.Abs.Program -> Result
transProgram x = case x of
  Frontend.Signe.Abs.Progr toplevels -> failure x
transToplevel :: Frontend.Signe.Abs.Toplevel -> Result
transToplevel x = case x of
  Frontend.Signe.Abs.ToplF id patterns expr -> failure x
  Frontend.Signe.Abs.ToplFT id patterns type_ expr -> failure x
transExpr :: Frontend.Signe.Abs.Expr -> Result
transExpr x = case x of
  Frontend.Signe.Abs.EVar id -> failure x
  Frontend.Signe.Abs.ETrue -> failure x
  Frontend.Signe.Abs.EFalse -> failure x
  Frontend.Signe.Abs.ETup exprs -> failure x
  Frontend.Signe.Abs.EMul complex expr -> failure x
  Frontend.Signe.Abs.EApp expr1 expr2 -> failure x
  Frontend.Signe.Abs.EPlus expr1 expr2 -> failure x
  Frontend.Signe.Abs.EComp expr1 expr2 -> failure x
  Frontend.Signe.Abs.EIfq expr1 expr2 expr3 -> failure x
  Frontend.Signe.Abs.EIf expr1 expr2 expr3 -> failure x
  Frontend.Signe.Abs.ELet lets expr -> failure x
  Frontend.Signe.Abs.EAbs ids expr -> failure x
transLet :: Frontend.Signe.Abs.Let -> Result
transLet x = case x of
  Frontend.Signe.Abs.LLet pattern_ expr -> failure x
transComplex :: Frontend.Signe.Abs.Complex -> Result
transComplex x = case x of
  Frontend.Signe.Abs.CComp scalar1 scalar2 -> failure x
  Frontend.Signe.Abs.CComn scalar1 scalar2 -> failure x
  Frontend.Signe.Abs.CPi -> failure x
  Frontend.Signe.Abs.CE -> failure x
  Frontend.Signe.Abs.CExp complex1 complex2 -> failure x
  Frontend.Signe.Abs.CDiv complex1 complex2 -> failure x
  Frontend.Signe.Abs.CMul complex1 complex2 -> failure x
transPattern :: Frontend.Signe.Abs.Pattern -> Result
transPattern x = case x of
  Frontend.Signe.Abs.PVar id -> failure x
  Frontend.Signe.Abs.PTup id1 id2 -> failure x
transMono :: Frontend.Signe.Abs.Mono -> Result
transMono x = case x of
  Frontend.Signe.Abs.MVar id -> failure x
  Frontend.Signe.Abs.MQubit -> failure x
  Frontend.Signe.Abs.MTens mono1 mono2 -> failure x
  Frontend.Signe.Abs.MArrow mono1 mono2 -> failure x
transType :: Frontend.Signe.Abs.Type -> Result
transType x = case x of
  Frontend.Signe.Abs.TMono mono -> failure x
  Frontend.Signe.Abs.TPoly ids mono -> failure x

