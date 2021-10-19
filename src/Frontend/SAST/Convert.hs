module Frontend.SAST.Convert where

import qualified Frontend.SAST.Abs  as SAST
import qualified Frontend.Signe.Abs as Signe
import qualified Data.Map as Map
import Data.Complex ( Complex(..) )
import Data.Bifunctor ( Bifunctor(bimap) )

convert :: Signe.Program -> SAST.Program
convert (Signe.Progr p) = map convertToplevel p

revert :: SAST.Program -> Signe.Program
revert = Signe.Progr . map revertToplevel

convertToplevel :: Signe.Toplevel -> SAST.Toplevel
convertToplevel (Signe.ToplF id ps e)    =  SAST.Topl (convertId id) (map convertPattern ps) Nothing (convertExpr e)
convertToplevel (Signe.ToplFT id ps t e) =  SAST.Topl (convertId id) (map convertPattern ps) (Just (convertType t)) (convertExpr e)

revertToplevel :: SAST.Toplevel -> Signe.Toplevel
revertToplevel (SAST.Topl id ps Nothing e)  = Signe.ToplF (revertId id) (map revertPattern ps) (revertExpr e)
revertToplevel (SAST.Topl id ps (Just t) e) = Signe.ToplF (revertId id) (map revertPattern ps) (revertExpr e)

convertExpr :: Signe.Expr -> SAST.Expr
convertExpr (Signe.EVar id)     = SAST.Var $ convertId id
convertExpr Signe.ETrue         = SAST.KetOne
convertExpr Signe.EFalse        = SAST.KetZero
convertExpr (Signe.ETup es)     = SAST.Tup $ map convertExpr es
convertExpr (Signe.EMul k e)    = SAST.Mul (convertComplex k) (convertExpr e)
convertExpr (Signe.EApp e1 e2)  = SAST.App (convertExpr e1) (convertExpr e2)
convertExpr (Signe.EPlus e1 e2) = SAST.Plus (convertExpr e1) (convertExpr e2)
convertExpr (Signe.EComp e1 e2) = SAST.Comp (convertExpr e1) (convertExpr e2)
convertExpr (Signe.EIfq b t f)  = SAST.Ifq (convertExpr b) (convertExpr t) (convertExpr f)
convertExpr (Signe.EIf b t f)   = SAST.If (convertExpr b) (convertExpr t) (convertExpr f)
convertExpr (Signe.ELet ls e)   = SAST.Let (foldMap convertLet ls) (convertExpr e)
convertExpr (Signe.EAbs ids e)  = SAST.Abs (map convertId ids) (convertExpr e)

revertExpr :: SAST.Expr -> Signe.Expr
revertExpr (SAST.Var id)      = Signe.EVar $ revertId id
revertExpr SAST.KetOne        = Signe.ETrue
revertExpr SAST.KetZero       = Signe.EFalse        
revertExpr (SAST.Tup  es)     = Signe.ETup $ map revertExpr es
revertExpr (SAST.Mul  k e)    = Signe.EMul (revertComplex k) (revertExpr e)
revertExpr (SAST.App  e1 e2)  = Signe.EApp (revertExpr e1) (revertExpr e2)
revertExpr (SAST.Plus  e1 e2) = Signe.EPlus (revertExpr e1) (revertExpr e2)
revertExpr (SAST.Comp  e1 e2) = Signe.EComp (revertExpr e1) (revertExpr e2)
revertExpr (SAST.Ifq  b t f)  = Signe.EIfq (revertExpr b) (revertExpr t) (revertExpr f)
revertExpr (SAST.If  b t f)   = Signe.EIf (revertExpr b) (revertExpr t) (revertExpr f)
revertExpr (SAST.Let  ls e)   = Signe.ELet (revertLet ls) (revertExpr e)
revertExpr (SAST.Abs  ids e)  = Signe.EAbs (map revertId ids) (revertExpr e)

convertComplex :: Signe.Complex -> Complex Double
convertComplex (Signe.CComp re im) = convertScalar re :+ convertScalar im
convertComplex (Signe.CComn re im) = convertScalar re :+ negate (convertScalar im)
convertComplex Signe.CPi           = pi
convertComplex Signe.CE            = exp 1
convertComplex (Signe.CExp a b)    = convertComplex a ** convertComplex b
convertComplex (Signe.CDiv a b)    = convertComplex a / convertComplex b
convertComplex (Signe.CMul a b)    = convertComplex a * convertComplex b

revertComplex :: Complex Double -> Signe.Complex
revertComplex (a :+ b) = Signe.CComp (revertScalar a) (revertScalar b)

convertScalar :: Signe.Scalar -> Double
convertScalar (Signe.Scalar s) = read s

revertScalar :: Double -> Signe.Scalar
revertScalar = Signe.Scalar . show

convertLet :: Signe.Let -> SAST.Let
convertLet (Signe.LLet p e) = Map.singleton (convertPattern p) (convertExpr e)

revertLet :: SAST.Let -> [Signe.Let]
revertLet = map (uncurry Signe.LLet . bimap revertPattern revertExpr) . Map.toList

convertId :: Signe.Id -> SAST.Id
convertId (Signe.Id (pos, name)) = SAST.Id (Just pos) name

revertId :: SAST.Id -> Signe.Id
revertId (SAST.Id (Just pos) name) = Signe.Id (pos, name)
revertId (SAST.Id Nothing name)    = Signe.Id ((-1,-1), name)

convertPattern :: Signe.Pattern -> [SAST.Id]
convertPattern (Signe.PVar id)  = pure $ convertId id
convertPattern (Signe.PTup a b) = [convertId a, convertId b]

revertPattern :: [SAST.Id] -> Signe.Pattern
revertPattern [x]   = Signe.PVar $ revertId x
revertPattern [x,y] = Signe.PTup (revertId x) (revertId y)
revertPattern _ = error "You forgot to implement this is the parser. Akward..."

convertType :: Signe.Type -> SAST.Scheme
convertType (Signe.TMono t)    = SAST.Forall [] $ convertMono t
convertType (Signe.TPoly vs s) = SAST.Forall (map convertId vs) (convertMono s)

revertType :: SAST.Scheme -> Signe.Type
revertType (SAST.Forall [] s) = Signe.TMono $ revertMono s
revertType (SAST.Forall vs s) = Signe.TPoly (map revertId vs) (revertMono s)

convertMono :: Signe.Mono -> SAST.Type
convertMono (Signe.MVar v)     = SAST.TypeVar $ convertId v
convertMono Signe.MQubit       = SAST.TypeQubit
convertMono (Signe.MTens a b)  = convertMono a SAST.:* convertMono b
convertMono (Signe.MArrow n p) = convertMono n SAST.:-> convertMono p

revertMono :: SAST.Type -> Signe.Mono
revertMono (SAST.TypeVar v) = Signe.MVar $ revertId v
revertMono SAST.TypeQubit   = Signe.MQubit
revertMono SAST.TypeUnit    = Signe.MVar $ Signe.Id ((-1,-1), "__UNIT__")
revertMono (a SAST.:* b)    = Signe.MTens (revertMono a) (revertMono b)
revertMono (a SAST.:-> b)   = Signe.MArrow (revertMono a) (revertMono b)
