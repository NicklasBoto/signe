{-# OPTIONS_GHC -w #-}
{-# OPTIONS -XMagicHash -XBangPatterns -XTypeSynonymInstances -XFlexibleInstances -cpp #-}
#if __GLASGOW_HASKELL__ >= 710
{-# OPTIONS_GHC -XPartialTypeSignatures #-}
#endif
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module Frontend.Signe.Par
  ( happyError
  , myLexer
  , pProgram
  , pListToplevel
  , pToplevel
  , pListPattern
  , pExpr3
  , pExpr2
  , pExpr1
  , pExpr
  , pListExpr
  , pLet
  , pListLet
  , pComplex
  , pPattern
  , pMono2
  , pMono1
  , pMono
  , pType
  , pListId
  ) where
import qualified Frontend.Signe.Abs
import Frontend.Signe.Lex
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import qualified GHC.Exts as Happy_GHC_Exts
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.0

newtype HappyAbsSyn  = HappyAbsSyn HappyAny
#if __GLASGOW_HASKELL__ >= 607
type HappyAny = Happy_GHC_Exts.Any
#else
type HappyAny = forall a . a
#endif
newtype HappyWrap21 = HappyWrap21 (Frontend.Signe.Abs.Id)
happyIn21 :: (Frontend.Signe.Abs.Id) -> (HappyAbsSyn )
happyIn21 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap21 x)
{-# INLINE happyIn21 #-}
happyOut21 :: (HappyAbsSyn ) -> HappyWrap21
happyOut21 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut21 #-}
newtype HappyWrap22 = HappyWrap22 (Frontend.Signe.Abs.Scalar)
happyIn22 :: (Frontend.Signe.Abs.Scalar) -> (HappyAbsSyn )
happyIn22 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap22 x)
{-# INLINE happyIn22 #-}
happyOut22 :: (HappyAbsSyn ) -> HappyWrap22
happyOut22 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut22 #-}
newtype HappyWrap23 = HappyWrap23 (Frontend.Signe.Abs.Program)
happyIn23 :: (Frontend.Signe.Abs.Program) -> (HappyAbsSyn )
happyIn23 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap23 x)
{-# INLINE happyIn23 #-}
happyOut23 :: (HappyAbsSyn ) -> HappyWrap23
happyOut23 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut23 #-}
newtype HappyWrap24 = HappyWrap24 ([Frontend.Signe.Abs.Toplevel])
happyIn24 :: ([Frontend.Signe.Abs.Toplevel]) -> (HappyAbsSyn )
happyIn24 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap24 x)
{-# INLINE happyIn24 #-}
happyOut24 :: (HappyAbsSyn ) -> HappyWrap24
happyOut24 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut24 #-}
newtype HappyWrap25 = HappyWrap25 (Frontend.Signe.Abs.Toplevel)
happyIn25 :: (Frontend.Signe.Abs.Toplevel) -> (HappyAbsSyn )
happyIn25 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap25 x)
{-# INLINE happyIn25 #-}
happyOut25 :: (HappyAbsSyn ) -> HappyWrap25
happyOut25 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut25 #-}
newtype HappyWrap26 = HappyWrap26 ([Frontend.Signe.Abs.Pattern])
happyIn26 :: ([Frontend.Signe.Abs.Pattern]) -> (HappyAbsSyn )
happyIn26 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap26 x)
{-# INLINE happyIn26 #-}
happyOut26 :: (HappyAbsSyn ) -> HappyWrap26
happyOut26 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut26 #-}
newtype HappyWrap27 = HappyWrap27 (Frontend.Signe.Abs.Expr)
happyIn27 :: (Frontend.Signe.Abs.Expr) -> (HappyAbsSyn )
happyIn27 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap27 x)
{-# INLINE happyIn27 #-}
happyOut27 :: (HappyAbsSyn ) -> HappyWrap27
happyOut27 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut27 #-}
newtype HappyWrap28 = HappyWrap28 (Frontend.Signe.Abs.Expr)
happyIn28 :: (Frontend.Signe.Abs.Expr) -> (HappyAbsSyn )
happyIn28 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap28 x)
{-# INLINE happyIn28 #-}
happyOut28 :: (HappyAbsSyn ) -> HappyWrap28
happyOut28 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut28 #-}
newtype HappyWrap29 = HappyWrap29 (Frontend.Signe.Abs.Expr)
happyIn29 :: (Frontend.Signe.Abs.Expr) -> (HappyAbsSyn )
happyIn29 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap29 x)
{-# INLINE happyIn29 #-}
happyOut29 :: (HappyAbsSyn ) -> HappyWrap29
happyOut29 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut29 #-}
newtype HappyWrap30 = HappyWrap30 (Frontend.Signe.Abs.Expr)
happyIn30 :: (Frontend.Signe.Abs.Expr) -> (HappyAbsSyn )
happyIn30 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap30 x)
{-# INLINE happyIn30 #-}
happyOut30 :: (HappyAbsSyn ) -> HappyWrap30
happyOut30 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut30 #-}
newtype HappyWrap31 = HappyWrap31 ([Frontend.Signe.Abs.Expr])
happyIn31 :: ([Frontend.Signe.Abs.Expr]) -> (HappyAbsSyn )
happyIn31 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap31 x)
{-# INLINE happyIn31 #-}
happyOut31 :: (HappyAbsSyn ) -> HappyWrap31
happyOut31 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut31 #-}
newtype HappyWrap32 = HappyWrap32 (Frontend.Signe.Abs.Let)
happyIn32 :: (Frontend.Signe.Abs.Let) -> (HappyAbsSyn )
happyIn32 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap32 x)
{-# INLINE happyIn32 #-}
happyOut32 :: (HappyAbsSyn ) -> HappyWrap32
happyOut32 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut32 #-}
newtype HappyWrap33 = HappyWrap33 ([Frontend.Signe.Abs.Let])
happyIn33 :: ([Frontend.Signe.Abs.Let]) -> (HappyAbsSyn )
happyIn33 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap33 x)
{-# INLINE happyIn33 #-}
happyOut33 :: (HappyAbsSyn ) -> HappyWrap33
happyOut33 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut33 #-}
newtype HappyWrap34 = HappyWrap34 (Frontend.Signe.Abs.Complex)
happyIn34 :: (Frontend.Signe.Abs.Complex) -> (HappyAbsSyn )
happyIn34 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap34 x)
{-# INLINE happyIn34 #-}
happyOut34 :: (HappyAbsSyn ) -> HappyWrap34
happyOut34 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut34 #-}
newtype HappyWrap35 = HappyWrap35 (Frontend.Signe.Abs.Pattern)
happyIn35 :: (Frontend.Signe.Abs.Pattern) -> (HappyAbsSyn )
happyIn35 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap35 x)
{-# INLINE happyIn35 #-}
happyOut35 :: (HappyAbsSyn ) -> HappyWrap35
happyOut35 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut35 #-}
newtype HappyWrap36 = HappyWrap36 (Frontend.Signe.Abs.Mono)
happyIn36 :: (Frontend.Signe.Abs.Mono) -> (HappyAbsSyn )
happyIn36 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap36 x)
{-# INLINE happyIn36 #-}
happyOut36 :: (HappyAbsSyn ) -> HappyWrap36
happyOut36 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut36 #-}
newtype HappyWrap37 = HappyWrap37 (Frontend.Signe.Abs.Mono)
happyIn37 :: (Frontend.Signe.Abs.Mono) -> (HappyAbsSyn )
happyIn37 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap37 x)
{-# INLINE happyIn37 #-}
happyOut37 :: (HappyAbsSyn ) -> HappyWrap37
happyOut37 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut37 #-}
newtype HappyWrap38 = HappyWrap38 (Frontend.Signe.Abs.Mono)
happyIn38 :: (Frontend.Signe.Abs.Mono) -> (HappyAbsSyn )
happyIn38 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap38 x)
{-# INLINE happyIn38 #-}
happyOut38 :: (HappyAbsSyn ) -> HappyWrap38
happyOut38 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut38 #-}
newtype HappyWrap39 = HappyWrap39 (Frontend.Signe.Abs.Type)
happyIn39 :: (Frontend.Signe.Abs.Type) -> (HappyAbsSyn )
happyIn39 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap39 x)
{-# INLINE happyIn39 #-}
happyOut39 :: (HappyAbsSyn ) -> HappyWrap39
happyOut39 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut39 #-}
newtype HappyWrap40 = HappyWrap40 ([Frontend.Signe.Abs.Id])
happyIn40 :: ([Frontend.Signe.Abs.Id]) -> (HappyAbsSyn )
happyIn40 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap40 x)
{-# INLINE happyIn40 #-}
happyOut40 :: (HappyAbsSyn ) -> HappyWrap40
happyOut40 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut40 #-}
happyInTok :: (Token) -> (HappyAbsSyn )
happyInTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyInTok #-}
happyOutTok :: (HappyAbsSyn ) -> (Token)
happyOutTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOutTok #-}


happyExpList :: HappyAddr
happyExpList = HappyA# "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x80\x00\x00\x00\x00\x02\x00\x00\x00\x00\x10\x08\x00\xc1\xcf\x00\x00\x00\x00\x00\x02\x01\x20\xf8\x19\x00\x00\x00\x00\x40\x20\xc8\x0d\x7f\x03\x00\x00\x00\x00\x08\x04\xb9\xe1\x6f\x00\x00\x00\x00\x00\x81\x20\x37\xfc\x0d\x00\x00\x00\x00\x20\x00\x00\x00\x80\x00\x00\x00\x00\x00\x04\x00\x00\x00\x10\x00\x00\x00\x00\x00\x40\x00\x08\x00\x04\x00\x00\x00\x00\x10\x00\x00\x00\x40\x00\x00\x00\x00\x00\x02\x00\x80\x00\x08\x00\x00\x00\x00\x40\x00\x00\x10\x00\x01\x00\x00\x00\x00\x08\x00\x00\x02\x20\x00\x00\x00\x00\x00\x01\x80\x40\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x20\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x10\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa9\x00\x10\xfc\x0c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x41\x6e\xf8\x1b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x08\x04\xb9\xe1\x6f\x00\x00\x00\x00\x00\x81\x20\x37\xfc\x0d\x00\x00\x00\x00\x20\x10\xe4\x86\xbf\x01\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x08\x00\xc1\xcf\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x20\x00\x00\x00\x00\x00\x01\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x30\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x02\x40\xf0\x33\x00\x00\x00\x00\x80\x40\x90\x1b\xfe\x06\x00\x00\x00\x00\x10\x08\x72\xc3\xdf\x00\x00\x00\x00\x00\x02\x41\x6e\xf8\x1b\x00\x00\x00\x00\x40\x20\xc8\x0d\x7f\x03\x00\x00\x00\x00\x08\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x10\x00\x01\x00\x00\x00\x00\x08\x00\x00\x02\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x04\x40\x00\x00\x00\x00\x00\x02\x00\x80\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x81\x20\x37\xfc\x0d\x00\x00\x00\x00\x20\x10\xe4\x86\xbf\x01\x00\x00\x00\x00\x04\x82\xdc\xf0\x37\x00\x00\x00\x00\x80\x40\x90\x1b\xfe\x06\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x02\x41\x6e\xf8\x1b\x00\x00\x00\x00\x40\x00\x20\x10\x80\x01\x00\x00\x00\x00\x08\x04\xb9\xe1\x6f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x20\xc8\x0d\x7f\x03\x00\x00\x00\x00\x08\x04\xb9\xe1\x6f\x00\x00\x00\x00\x00\x81\x20\x37\xfc\x0d\x00\x00\x00\x00\x20\x10\xe4\x86\xbf\x01\x00\x00\x00\x00\x04\x82\xdc\xf0\x37\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_pProgram","%start_pListToplevel","%start_pToplevel","%start_pListPattern","%start_pExpr3","%start_pExpr2","%start_pExpr1","%start_pExpr","%start_pListExpr","%start_pLet","%start_pListLet","%start_pComplex","%start_pPattern","%start_pMono2","%start_pMono1","%start_pMono","%start_pType","%start_pListId","Id","Scalar","Program","ListToplevel","Toplevel","ListPattern","Expr3","Expr2","Expr1","Expr","ListExpr","Let","ListLet","Complex","Pattern","Mono2","Mono1","Mono","Type","ListId","'('","')'","'*'","'+'","','","'-'","'->'","'-j'","'.'","':'","':='","';'","'='","'\\\\'","'else'","'forall'","'if'","'if*'","'if\176'","'in'","'j'","'let'","'qubit'","'then'","'{'","'}'","'~+'","'~-'","'~0'","'~1'","'~i'","'~j'","'\955'","'\8704'","L_Id","L_Scalar","%eof"]
        bit_start = st Prelude.* 77
        bit_end = (st Prelude.+ 1) Prelude.* 77
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..76]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

happyActOffsets :: HappyAddr
happyActOffsets = HappyA# "\xde\xff\xde\xff\xde\xff\x06\x00\x47\x00\x47\x00\x1a\x00\x1a\x00\x1a\x00\x06\x00\x06\x00\x3c\x00\x06\x00\x10\x00\x10\x00\x10\x00\x30\x00\xde\xff\xde\xff\x00\x00\xde\xff\xe1\xff\x00\x00\x85\x00\x00\x00\x00\x00\xe1\xff\x10\x00\xe5\xff\x00\x00\xe5\xff\xea\xff\xea\xff\xea\xff\x00\x00\xea\xff\xed\xff\x15\x00\xfe\xff\x00\x00\x00\x00\x00\x00\x22\x00\x0f\x00\x5c\x00\x4f\x00\x00\x00\x00\x00\x3b\x00\x00\x00\x69\x00\x6a\x00\x8d\x00\x1a\x00\x82\x00\x1a\x00\x1a\x00\x1a\x00\x74\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x84\x00\x83\x00\x83\x00\x01\x00\x83\x00\x83\x00\x06\x00\x06\x00\x83\x00\x83\x00\xa3\x00\x8c\x00\x00\x00\x92\x00\x88\x00\x00\x00\x00\x00\xad\x00\x06\x00\x7c\x00\xaf\x00\xb9\x00\xb1\x00\x71\x00\xc4\x00\x47\x00\x1a\x00\x1a\x00\x1a\x00\x1a\x00\x06\x00\x97\x00\x00\x00\xcb\x00\xc9\x00\xd2\x00\xda\x00\x10\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x10\x00\xba\x00\xcf\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x1a\x00\x1a\x00\x1a\x00\x1a\x00\xcc\x00\x1a\x00\x30\x00\x1a\x00\x00\x00\x00\x00\xdc\x00\x00\x00\xdd\x00\xdf\x00\xe1\x00\xe9\x00\x00\x00\x00\x00\xf8\x00\x00\x00\x00\x00\x00\x00\x1a\x00\x1a\x00\x1a\x00\x1a\x00\x1a\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyGotoOffsets :: HappyAddr
happyGotoOffsets = HappyA# "\x0a\x00\x49\x00\x8a\x00\x46\x00\x8e\x01\x8a\x01\x72\x01\xd8\x00\xb7\x00\xa2\x00\x91\x00\xb8\x00\xa4\x00\x0b\x00\x87\x00\x6c\x00\x03\x00\x04\x00\x00\x00\x00\x00\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6f\x00\x32\x00\x00\x00\x42\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfb\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x92\x01\x00\x00\x00\x00\x00\x00\x00\x00\xc2\x00\x4a\x00\xe2\x00\xec\x00\xf6\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4e\x00\x00\x00\x00\x00\x92\x01\x00\x00\x00\x00\xa6\x00\xae\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6d\x00\x00\x00\x00\x00\x00\x00\x00\x00\x95\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x9c\x01\xcd\x00\x7c\x01\x80\x01\x00\x01\x9e\x00\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x89\x00\x8b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x72\x00\x75\x00\x04\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0a\x01\x14\x01\x1e\x01\x28\x01\x00\x00\x32\x01\x68\x00\x3c\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x46\x01\x50\x01\x5a\x01\x64\x01\x6e\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyAdjustOffset :: Happy_GHC_Exts.Int# -> Happy_GHC_Exts.Int#
happyAdjustOffset off = off

happyDefActions :: HappyAddr
happyDefActions = HappyA# "\xea\xff\xea\xff\x00\x00\xe6\xff\x00\x00\x00\x00\x00\x00\x00\x00\xce\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xed\xff\xb7\xff\x00\x00\xc1\xff\xbc\xff\xbb\xff\xba\xff\x00\x00\x00\x00\x00\x00\xc0\xff\x00\x00\x00\x00\x00\x00\x00\x00\xc3\xff\x00\x00\x00\x00\xc7\xff\x00\x00\xc5\xff\xc4\xff\xec\xff\xca\xff\x00\x00\x00\x00\x00\x00\xe4\xff\xd9\xff\xd0\xff\xcf\xff\xcd\xff\x00\x00\x00\x00\xce\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe1\xff\xe0\xff\xe2\xff\xe3\xff\xdf\xff\xde\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe6\xff\xe6\xff\x00\x00\x00\x00\x00\x00\x00\x00\xeb\xff\xea\xff\x00\x00\xe5\xff\xda\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xce\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc6\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb6\xff\xbd\xff\xbe\xff\xbf\xff\x00\x00\x00\x00\x00\x00\x00\x00\xc9\xff\xcb\xff\xd7\xff\xd8\xff\xcc\xff\xdc\xff\xdd\xff\xdb\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe9\xff\xe8\xff\x00\x00\xd2\xff\x00\x00\x00\x00\x00\x00\x00\x00\xd1\xff\xc8\xff\x00\x00\xb9\xff\xb8\xff\xc2\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe7\xff\xd3\xff\xd6\xff\xd5\xff\xd4\xff"#

happyCheck :: HappyAddr
happyCheck = HappyA# "\xff\xff\x23\x00\x01\x00\x00\x00\x00\x00\x00\x00\x25\x00\x01\x00\x23\x00\x08\x00\x00\x00\x00\x00\x02\x00\x03\x00\x04\x00\x25\x00\x23\x00\x01\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x15\x00\x13\x00\x13\x00\x04\x00\x0f\x00\x01\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x08\x00\x25\x00\x23\x00\x24\x00\x25\x00\x17\x00\x0e\x00\x23\x00\x15\x00\x11\x00\x12\x00\x13\x00\x0c\x00\x15\x00\x16\x00\x01\x00\x00\x00\x23\x00\x25\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x01\x00\x23\x00\x24\x00\x04\x00\x10\x00\x06\x00\x00\x00\x08\x00\x08\x00\x13\x00\x00\x00\x17\x00\x01\x00\x00\x00\x00\x00\x05\x00\x03\x00\x04\x00\x00\x00\x08\x00\x15\x00\x15\x00\x22\x00\x23\x00\x0e\x00\x13\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x15\x00\x13\x00\x23\x00\x24\x00\x24\x00\x13\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x00\x00\x0d\x00\x23\x00\x24\x00\x00\x00\x00\x00\x05\x00\x00\x00\x03\x00\x04\x00\x00\x00\x02\x00\x25\x00\x00\x00\x05\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x0f\x00\x10\x00\x11\x00\x0f\x00\x10\x00\x11\x00\x0f\x00\x10\x00\x11\x00\x0f\x00\x10\x00\x11\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x07\x00\x19\x00\x04\x00\x25\x00\x03\x00\x00\x00\x0a\x00\x0b\x00\x18\x00\x00\x00\x0f\x00\x10\x00\x0f\x00\x10\x00\x0f\x00\x10\x00\x0b\x00\x0c\x00\x00\x00\x0e\x00\x0b\x00\x0c\x00\x00\x00\x0e\x00\x00\x00\x23\x00\x00\x00\x23\x00\x25\x00\x0b\x00\x0c\x00\x05\x00\x0e\x00\x0b\x00\x00\x00\x0c\x00\x0e\x00\x25\x00\x0e\x00\x05\x00\x0e\x00\x23\x00\x09\x00\x00\x00\x01\x00\x01\x00\x09\x00\x24\x00\x0e\x00\x06\x00\x07\x00\x08\x00\x09\x00\x0a\x00\x00\x00\x01\x00\x0d\x00\x0d\x00\x02\x00\x18\x00\x06\x00\x07\x00\x08\x00\x09\x00\x0a\x00\x00\x00\x01\x00\x0d\x00\x05\x00\x18\x00\x09\x00\x06\x00\x07\x00\x08\x00\x09\x00\x0a\x00\x00\x00\x01\x00\x0d\x00\x09\x00\x02\x00\x23\x00\x06\x00\x07\x00\x08\x00\x09\x00\x00\x00\x01\x00\x15\x00\x0d\x00\x1a\x00\x0b\x00\x06\x00\x07\x00\x08\x00\x09\x00\x00\x00\x01\x00\x0f\x00\x0d\x00\x0f\x00\x14\x00\x06\x00\x07\x00\x08\x00\x09\x00\x00\x00\x01\x00\x0f\x00\x0d\x00\x02\x00\x00\x00\x06\x00\x07\x00\x08\x00\x09\x00\x00\x00\x01\x00\x01\x00\x0d\x00\x00\x00\xff\xff\x06\x00\x07\x00\x08\x00\x09\x00\x00\x00\x01\x00\xff\xff\x0d\x00\xff\xff\xff\xff\x06\x00\x07\x00\x08\x00\x09\x00\x00\x00\x01\x00\xff\xff\x0d\x00\xff\xff\xff\xff\x06\x00\x07\x00\x08\x00\x09\x00\x00\x00\x01\x00\xff\xff\x0d\x00\xff\xff\xff\xff\x06\x00\x07\x00\x08\x00\x09\x00\x00\x00\x01\x00\xff\xff\x0d\x00\xff\xff\xff\xff\x06\x00\x07\x00\x08\x00\x09\x00\x00\x00\x01\x00\xff\xff\x0d\x00\xff\xff\xff\xff\x06\x00\x07\x00\x08\x00\x09\x00\x00\x00\x01\x00\xff\xff\x0d\x00\xff\xff\xff\xff\x06\x00\x07\x00\x08\x00\x09\x00\x00\x00\x01\x00\xff\xff\x0d\x00\xff\xff\xff\xff\x06\x00\x07\x00\x08\x00\x09\x00\x00\x00\x01\x00\xff\xff\x0d\x00\xff\xff\xff\xff\x06\x00\x07\x00\x08\x00\x09\x00\x00\x00\x01\x00\xff\xff\x0d\x00\xff\xff\xff\xff\x06\x00\x07\x00\x08\x00\x09\x00\x00\x00\x01\x00\xff\xff\x0d\x00\xff\xff\xff\xff\x06\x00\x07\x00\x08\x00\x09\x00\x00\x00\x01\x00\xff\xff\x0d\x00\x00\x00\x01\x00\x06\x00\x07\x00\x08\x00\x09\x00\x06\x00\x07\x00\x08\x00\x0d\x00\x00\x00\x01\x00\xff\xff\x0d\x00\x00\x00\x01\x00\x06\x00\x07\x00\x08\x00\xff\xff\x06\x00\x07\x00\x08\x00\x0d\x00\x00\x00\x01\x00\xff\xff\x0d\x00\x00\x00\x01\x00\x06\x00\x07\x00\x00\x00\x01\x00\x06\x00\xff\xff\xff\xff\x0d\x00\x06\x00\xff\xff\xff\xff\x0d\x00\x00\x00\x01\x00\xff\xff\x0d\x00\xff\xff\xff\xff\x06\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff"#

happyTable :: HappyAddr
happyTable = HappyA# "\x00\x00\x14\x00\x36\x00\x16\x00\x14\x00\x14\x00\xff\xff\x25\x00\x14\x00\x28\x00\x48\x00\x16\x00\x4c\x00\x4d\x00\x4b\x00\xff\xff\x14\x00\x1c\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x29\x00\x15\x00\x68\x00\x61\x00\x21\x00\x36\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x28\x00\xff\xff\x14\x00\x2a\x00\xff\xff\x1e\x00\x37\x00\x14\x00\x62\x00\x38\x00\x39\x00\x3a\x00\x60\x00\x29\x00\x3b\x00\x1c\x00\x14\x00\x14\x00\xff\xff\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x36\x00\x14\x00\x2a\x00\x5d\x00\x1d\x00\x5e\x00\x14\x00\x28\x00\x28\x00\x64\x00\x22\x00\x1e\x00\x36\x00\x48\x00\x14\x00\x46\x00\x4a\x00\x4b\x00\x14\x00\x28\x00\x29\x00\x29\x00\x1f\x00\x14\x00\x47\x00\x63\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x29\x00\x57\x00\x14\x00\x2a\x00\x2a\x00\x52\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x16\x00\x5f\x00\x14\x00\x2a\x00\x16\x00\x48\x00\x5c\x00\x16\x00\x80\x00\x4b\x00\x16\x00\x78\x00\xff\xff\x16\x00\x5c\x00\x17\x00\x18\x00\x19\x00\x82\x00\x17\x00\x18\x00\x1f\x00\x17\x00\x18\x00\x65\x00\x17\x00\x18\x00\x8c\x00\x17\x00\x18\x00\x8b\x00\x16\x00\x67\x00\x16\x00\x48\x00\x16\x00\x68\x00\x54\x00\x49\x00\xff\xff\x5b\x00\x22\x00\x7f\x00\x80\x00\x7c\x00\x22\x00\x17\x00\x20\x00\x17\x00\x6a\x00\x17\x00\x69\x00\x2a\x00\x2b\x00\x22\x00\x2c\x00\x2a\x00\x7c\x00\x22\x00\x2c\x00\x22\x00\x14\x00\x22\x00\x14\x00\xff\xff\x2a\x00\x70\x00\x50\x00\x2c\x00\x2d\x00\x22\x00\x4f\x00\x2c\x00\xff\xff\x23\x00\x4f\x00\x47\x00\x14\x00\x7e\x00\x2e\x00\x25\x00\x25\x00\x79\x00\x2a\x00\x47\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x2e\x00\x25\x00\x34\x00\x26\x00\x77\x00\x7b\x00\x2f\x00\x30\x00\x31\x00\x58\x00\x59\x00\x2e\x00\x25\x00\x34\x00\x6f\x00\x7a\x00\x6e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x74\x00\x2e\x00\x25\x00\x34\x00\x6d\x00\x6c\x00\x14\x00\x2f\x00\x30\x00\x31\x00\x42\x00\x2e\x00\x25\x00\x8a\x00\x34\x00\x85\x00\x93\x00\x2f\x00\x30\x00\x31\x00\x56\x00\x2e\x00\x25\x00\x91\x00\x34\x00\x90\x00\x92\x00\x2f\x00\x30\x00\x31\x00\x55\x00\x2e\x00\x25\x00\x8f\x00\x34\x00\x8e\x00\x62\x00\x2f\x00\x30\x00\x31\x00\x54\x00\x2e\x00\x25\x00\x6f\x00\x34\x00\x8a\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x71\x00\x2e\x00\x25\x00\x00\x00\x34\x00\x00\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x88\x00\x2e\x00\x25\x00\x00\x00\x34\x00\x00\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x87\x00\x2e\x00\x25\x00\x00\x00\x34\x00\x00\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x86\x00\x2e\x00\x25\x00\x00\x00\x34\x00\x00\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x85\x00\x2e\x00\x25\x00\x00\x00\x34\x00\x00\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x83\x00\x2e\x00\x25\x00\x00\x00\x34\x00\x00\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x81\x00\x2e\x00\x25\x00\x00\x00\x34\x00\x00\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x97\x00\x2e\x00\x25\x00\x00\x00\x34\x00\x00\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x96\x00\x2e\x00\x25\x00\x00\x00\x34\x00\x00\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x95\x00\x2e\x00\x25\x00\x00\x00\x34\x00\x00\x00\x00\x00\x2f\x00\x30\x00\x31\x00\x94\x00\x2e\x00\x25\x00\x00\x00\x34\x00\x2e\x00\x25\x00\x2f\x00\x30\x00\x31\x00\x93\x00\x2f\x00\x30\x00\x43\x00\x34\x00\x2e\x00\x25\x00\x00\x00\x34\x00\x2e\x00\x25\x00\x2f\x00\x30\x00\x73\x00\x00\x00\x2f\x00\x30\x00\x72\x00\x34\x00\x2e\x00\x25\x00\x00\x00\x34\x00\x2e\x00\x25\x00\x2f\x00\x44\x00\x2e\x00\x25\x00\x45\x00\x00\x00\x00\x00\x34\x00\x51\x00\x00\x00\x00\x00\x34\x00\x2e\x00\x25\x00\x00\x00\x34\x00\x00\x00\x00\x00\x75\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x34\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyReduceArr = Happy_Data_Array.array (18, 73) [
	(18 , happyReduce_18),
	(19 , happyReduce_19),
	(20 , happyReduce_20),
	(21 , happyReduce_21),
	(22 , happyReduce_22),
	(23 , happyReduce_23),
	(24 , happyReduce_24),
	(25 , happyReduce_25),
	(26 , happyReduce_26),
	(27 , happyReduce_27),
	(28 , happyReduce_28),
	(29 , happyReduce_29),
	(30 , happyReduce_30),
	(31 , happyReduce_31),
	(32 , happyReduce_32),
	(33 , happyReduce_33),
	(34 , happyReduce_34),
	(35 , happyReduce_35),
	(36 , happyReduce_36),
	(37 , happyReduce_37),
	(38 , happyReduce_38),
	(39 , happyReduce_39),
	(40 , happyReduce_40),
	(41 , happyReduce_41),
	(42 , happyReduce_42),
	(43 , happyReduce_43),
	(44 , happyReduce_44),
	(45 , happyReduce_45),
	(46 , happyReduce_46),
	(47 , happyReduce_47),
	(48 , happyReduce_48),
	(49 , happyReduce_49),
	(50 , happyReduce_50),
	(51 , happyReduce_51),
	(52 , happyReduce_52),
	(53 , happyReduce_53),
	(54 , happyReduce_54),
	(55 , happyReduce_55),
	(56 , happyReduce_56),
	(57 , happyReduce_57),
	(58 , happyReduce_58),
	(59 , happyReduce_59),
	(60 , happyReduce_60),
	(61 , happyReduce_61),
	(62 , happyReduce_62),
	(63 , happyReduce_63),
	(64 , happyReduce_64),
	(65 , happyReduce_65),
	(66 , happyReduce_66),
	(67 , happyReduce_67),
	(68 , happyReduce_68),
	(69 , happyReduce_69),
	(70 , happyReduce_70),
	(71 , happyReduce_71),
	(72 , happyReduce_72),
	(73 , happyReduce_73)
	]

happy_n_terms = 38 :: Prelude.Int
happy_n_nonterms = 20 :: Prelude.Int

happyReduce_18 = happySpecReduce_1  0# happyReduction_18
happyReduction_18 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn21
		 (Frontend.Signe.Abs.Id (mkPosToken happy_var_1)
	)}

happyReduce_19 = happySpecReduce_1  1# happyReduction_19
happyReduction_19 happy_x_1
	 =  case happyOutTok happy_x_1 of { (PT _ (T_Scalar happy_var_1)) -> 
	happyIn22
		 (Frontend.Signe.Abs.Scalar happy_var_1
	)}

happyReduce_20 = happySpecReduce_1  2# happyReduction_20
happyReduction_20 happy_x_1
	 =  case happyOut24 happy_x_1 of { (HappyWrap24 happy_var_1) -> 
	happyIn23
		 (Frontend.Signe.Abs.Progr happy_var_1
	)}

happyReduce_21 = happySpecReduce_0  3# happyReduction_21
happyReduction_21  =  happyIn24
		 ([]
	)

happyReduce_22 = happySpecReduce_3  3# happyReduction_22
happyReduction_22 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut25 happy_x_1 of { (HappyWrap25 happy_var_1) -> 
	case happyOut24 happy_x_3 of { (HappyWrap24 happy_var_3) -> 
	happyIn24
		 ((:) happy_var_1 happy_var_3
	)}}

happyReduce_23 = happyReduce 4# 4# happyReduction_23
happyReduction_23 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut21 happy_x_1 of { (HappyWrap21 happy_var_1) -> 
	case happyOut26 happy_x_2 of { (HappyWrap26 happy_var_2) -> 
	case happyOut30 happy_x_4 of { (HappyWrap30 happy_var_4) -> 
	happyIn25
		 (Frontend.Signe.Abs.ToplF happy_var_1 happy_var_2 happy_var_4
	) `HappyStk` happyRest}}}

happyReduce_24 = happyReduce 6# 4# happyReduction_24
happyReduction_24 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut21 happy_x_1 of { (HappyWrap21 happy_var_1) -> 
	case happyOut26 happy_x_2 of { (HappyWrap26 happy_var_2) -> 
	case happyOut39 happy_x_4 of { (HappyWrap39 happy_var_4) -> 
	case happyOut30 happy_x_6 of { (HappyWrap30 happy_var_6) -> 
	happyIn25
		 (Frontend.Signe.Abs.ToplFT happy_var_1 happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest}}}}

happyReduce_25 = happySpecReduce_0  5# happyReduction_25
happyReduction_25  =  happyIn26
		 ([]
	)

happyReduce_26 = happySpecReduce_2  5# happyReduction_26
happyReduction_26 happy_x_2
	happy_x_1
	 =  case happyOut35 happy_x_1 of { (HappyWrap35 happy_var_1) -> 
	case happyOut26 happy_x_2 of { (HappyWrap26 happy_var_2) -> 
	happyIn26
		 ((:) happy_var_1 happy_var_2
	)}}

happyReduce_27 = happySpecReduce_1  6# happyReduction_27
happyReduction_27 happy_x_1
	 =  case happyOut21 happy_x_1 of { (HappyWrap21 happy_var_1) -> 
	happyIn27
		 (Frontend.Signe.Abs.EVar happy_var_1
	)}

happyReduce_28 = happySpecReduce_1  6# happyReduction_28
happyReduction_28 happy_x_1
	 =  happyIn27
		 (Frontend.Signe.Abs.ETrue
	)

happyReduce_29 = happySpecReduce_1  6# happyReduction_29
happyReduction_29 happy_x_1
	 =  happyIn27
		 (Frontend.Signe.Abs.EFalse
	)

happyReduce_30 = happySpecReduce_1  6# happyReduction_30
happyReduction_30 happy_x_1
	 =  happyIn27
		 (Frontend.Signe.Abs.qplus
	)

happyReduce_31 = happySpecReduce_1  6# happyReduction_31
happyReduction_31 happy_x_1
	 =  happyIn27
		 (Frontend.Signe.Abs.qminus
	)

happyReduce_32 = happySpecReduce_1  6# happyReduction_32
happyReduction_32 happy_x_1
	 =  happyIn27
		 (Frontend.Signe.Abs.qimagi
	)

happyReduce_33 = happySpecReduce_1  6# happyReduction_33
happyReduction_33 happy_x_1
	 =  happyIn27
		 (Frontend.Signe.Abs.qimagj
	)

happyReduce_34 = happySpecReduce_3  6# happyReduction_34
happyReduction_34 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut31 happy_x_2 of { (HappyWrap31 happy_var_2) -> 
	happyIn27
		 (Frontend.Signe.Abs.ETup happy_var_2
	)}

happyReduce_35 = happySpecReduce_3  6# happyReduction_35
happyReduction_35 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut34 happy_x_1 of { (HappyWrap34 happy_var_1) -> 
	case happyOut27 happy_x_3 of { (HappyWrap27 happy_var_3) -> 
	happyIn27
		 (Frontend.Signe.Abs.EMul happy_var_1 happy_var_3
	)}}

happyReduce_36 = happySpecReduce_3  6# happyReduction_36
happyReduction_36 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut30 happy_x_2 of { (HappyWrap30 happy_var_2) -> 
	happyIn27
		 (happy_var_2
	)}

happyReduce_37 = happySpecReduce_2  7# happyReduction_37
happyReduction_37 happy_x_2
	happy_x_1
	 =  case happyOut28 happy_x_1 of { (HappyWrap28 happy_var_1) -> 
	case happyOut27 happy_x_2 of { (HappyWrap27 happy_var_2) -> 
	happyIn28
		 (Frontend.Signe.Abs.EApp happy_var_1 happy_var_2
	)}}

happyReduce_38 = happySpecReduce_1  7# happyReduction_38
happyReduction_38 happy_x_1
	 =  case happyOut27 happy_x_1 of { (HappyWrap27 happy_var_1) -> 
	happyIn28
		 (happy_var_1
	)}

happyReduce_39 = happySpecReduce_3  8# happyReduction_39
happyReduction_39 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut28 happy_x_1 of { (HappyWrap28 happy_var_1) -> 
	case happyOut29 happy_x_3 of { (HappyWrap29 happy_var_3) -> 
	happyIn29
		 (Frontend.Signe.Abs.EPlus happy_var_1 happy_var_3
	)}}

happyReduce_40 = happySpecReduce_3  8# happyReduction_40
happyReduction_40 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut28 happy_x_1 of { (HappyWrap28 happy_var_1) -> 
	case happyOut29 happy_x_3 of { (HappyWrap29 happy_var_3) -> 
	happyIn29
		 (Frontend.Signe.Abs.emin happy_var_1 happy_var_3
	)}}

happyReduce_41 = happyReduce 6# 8# happyReduction_41
happyReduction_41 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut30 happy_x_2 of { (HappyWrap30 happy_var_2) -> 
	case happyOut30 happy_x_4 of { (HappyWrap30 happy_var_4) -> 
	case happyOut30 happy_x_6 of { (HappyWrap30 happy_var_6) -> 
	happyIn29
		 (Frontend.Signe.Abs.EIfq happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest}}}

happyReduce_42 = happyReduce 6# 8# happyReduction_42
happyReduction_42 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut30 happy_x_2 of { (HappyWrap30 happy_var_2) -> 
	case happyOut30 happy_x_4 of { (HappyWrap30 happy_var_4) -> 
	case happyOut30 happy_x_6 of { (HappyWrap30 happy_var_6) -> 
	happyIn29
		 (Frontend.Signe.Abs.eifqs happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest}}}

happyReduce_43 = happyReduce 6# 8# happyReduction_43
happyReduction_43 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut30 happy_x_2 of { (HappyWrap30 happy_var_2) -> 
	case happyOut30 happy_x_4 of { (HappyWrap30 happy_var_4) -> 
	case happyOut30 happy_x_6 of { (HappyWrap30 happy_var_6) -> 
	happyIn29
		 (Frontend.Signe.Abs.EIf happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest}}}

happyReduce_44 = happyReduce 6# 8# happyReduction_44
happyReduction_44 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut33 happy_x_3 of { (HappyWrap33 happy_var_3) -> 
	case happyOut30 happy_x_6 of { (HappyWrap30 happy_var_6) -> 
	happyIn29
		 (Frontend.Signe.Abs.ELet happy_var_3 happy_var_6
	) `HappyStk` happyRest}}

happyReduce_45 = happyReduce 4# 8# happyReduction_45
happyReduction_45 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut40 happy_x_2 of { (HappyWrap40 happy_var_2) -> 
	case happyOut30 happy_x_4 of { (HappyWrap30 happy_var_4) -> 
	happyIn29
		 (Frontend.Signe.Abs.EAbs happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_46 = happyReduce 4# 8# happyReduction_46
happyReduction_46 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut40 happy_x_2 of { (HappyWrap40 happy_var_2) -> 
	case happyOut30 happy_x_4 of { (HappyWrap30 happy_var_4) -> 
	happyIn29
		 (Frontend.Signe.Abs.eabss happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_47 = happySpecReduce_1  8# happyReduction_47
happyReduction_47 happy_x_1
	 =  case happyOut28 happy_x_1 of { (HappyWrap28 happy_var_1) -> 
	happyIn29
		 (happy_var_1
	)}

happyReduce_48 = happySpecReduce_1  9# happyReduction_48
happyReduction_48 happy_x_1
	 =  case happyOut29 happy_x_1 of { (HappyWrap29 happy_var_1) -> 
	happyIn30
		 (happy_var_1
	)}

happyReduce_49 = happySpecReduce_0  10# happyReduction_49
happyReduction_49  =  happyIn31
		 ([]
	)

happyReduce_50 = happySpecReduce_1  10# happyReduction_50
happyReduction_50 happy_x_1
	 =  case happyOut30 happy_x_1 of { (HappyWrap30 happy_var_1) -> 
	happyIn31
		 ((:[]) happy_var_1
	)}

happyReduce_51 = happySpecReduce_3  10# happyReduction_51
happyReduction_51 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut30 happy_x_1 of { (HappyWrap30 happy_var_1) -> 
	case happyOut31 happy_x_3 of { (HappyWrap31 happy_var_3) -> 
	happyIn31
		 ((:) happy_var_1 happy_var_3
	)}}

happyReduce_52 = happySpecReduce_3  11# happyReduction_52
happyReduction_52 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut35 happy_x_1 of { (HappyWrap35 happy_var_1) -> 
	case happyOut30 happy_x_3 of { (HappyWrap30 happy_var_3) -> 
	happyIn32
		 (Frontend.Signe.Abs.LLet happy_var_1 happy_var_3
	)}}

happyReduce_53 = happySpecReduce_1  12# happyReduction_53
happyReduction_53 happy_x_1
	 =  case happyOut32 happy_x_1 of { (HappyWrap32 happy_var_1) -> 
	happyIn33
		 ((:[]) happy_var_1
	)}

happyReduce_54 = happySpecReduce_3  12# happyReduction_54
happyReduction_54 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_1 of { (HappyWrap32 happy_var_1) -> 
	case happyOut33 happy_x_3 of { (HappyWrap33 happy_var_3) -> 
	happyIn33
		 ((:) happy_var_1 happy_var_3
	)}}

happyReduce_55 = happyReduce 4# 13# happyReduction_55
happyReduction_55 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut22 happy_x_1 of { (HappyWrap22 happy_var_1) -> 
	case happyOut22 happy_x_3 of { (HappyWrap22 happy_var_3) -> 
	happyIn34
		 (Frontend.Signe.Abs.CComp happy_var_1 happy_var_3
	) `HappyStk` happyRest}}

happyReduce_56 = happySpecReduce_1  13# happyReduction_56
happyReduction_56 happy_x_1
	 =  case happyOut22 happy_x_1 of { (HappyWrap22 happy_var_1) -> 
	happyIn34
		 (Frontend.Signe.Abs.creal happy_var_1
	)}

happyReduce_57 = happySpecReduce_2  13# happyReduction_57
happyReduction_57 happy_x_2
	happy_x_1
	 =  case happyOut22 happy_x_1 of { (HappyWrap22 happy_var_1) -> 
	happyIn34
		 (Frontend.Signe.Abs.cimag happy_var_1
	)}

happyReduce_58 = happySpecReduce_1  13# happyReduction_58
happyReduction_58 happy_x_1
	 =  happyIn34
		 (Frontend.Signe.Abs.cnmag
	)

happyReduce_59 = happySpecReduce_1  13# happyReduction_59
happyReduction_59 happy_x_1
	 =  happyIn34
		 (Frontend.Signe.Abs.cjmag
	)

happyReduce_60 = happySpecReduce_1  14# happyReduction_60
happyReduction_60 happy_x_1
	 =  case happyOut21 happy_x_1 of { (HappyWrap21 happy_var_1) -> 
	happyIn35
		 (Frontend.Signe.Abs.PVar happy_var_1
	)}

happyReduce_61 = happyReduce 5# 14# happyReduction_61
happyReduction_61 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut21 happy_x_2 of { (HappyWrap21 happy_var_2) -> 
	case happyOut21 happy_x_4 of { (HappyWrap21 happy_var_4) -> 
	happyIn35
		 (Frontend.Signe.Abs.PTup happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_62 = happySpecReduce_1  15# happyReduction_62
happyReduction_62 happy_x_1
	 =  case happyOut21 happy_x_1 of { (HappyWrap21 happy_var_1) -> 
	happyIn36
		 (Frontend.Signe.Abs.MVar happy_var_1
	)}

happyReduce_63 = happySpecReduce_1  15# happyReduction_63
happyReduction_63 happy_x_1
	 =  happyIn36
		 (Frontend.Signe.Abs.MQubit
	)

happyReduce_64 = happySpecReduce_3  15# happyReduction_64
happyReduction_64 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut38 happy_x_2 of { (HappyWrap38 happy_var_2) -> 
	happyIn36
		 (happy_var_2
	)}

happyReduce_65 = happySpecReduce_3  16# happyReduction_65
happyReduction_65 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut36 happy_x_1 of { (HappyWrap36 happy_var_1) -> 
	case happyOut37 happy_x_3 of { (HappyWrap37 happy_var_3) -> 
	happyIn37
		 (Frontend.Signe.Abs.MTens happy_var_1 happy_var_3
	)}}

happyReduce_66 = happySpecReduce_3  16# happyReduction_66
happyReduction_66 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut36 happy_x_1 of { (HappyWrap36 happy_var_1) -> 
	case happyOut37 happy_x_3 of { (HappyWrap37 happy_var_3) -> 
	happyIn37
		 (Frontend.Signe.Abs.MArrow happy_var_1 happy_var_3
	)}}

happyReduce_67 = happySpecReduce_1  16# happyReduction_67
happyReduction_67 happy_x_1
	 =  case happyOut36 happy_x_1 of { (HappyWrap36 happy_var_1) -> 
	happyIn37
		 (happy_var_1
	)}

happyReduce_68 = happySpecReduce_1  17# happyReduction_68
happyReduction_68 happy_x_1
	 =  case happyOut37 happy_x_1 of { (HappyWrap37 happy_var_1) -> 
	happyIn38
		 (happy_var_1
	)}

happyReduce_69 = happySpecReduce_1  18# happyReduction_69
happyReduction_69 happy_x_1
	 =  case happyOut38 happy_x_1 of { (HappyWrap38 happy_var_1) -> 
	happyIn39
		 (Frontend.Signe.Abs.TMono happy_var_1
	)}

happyReduce_70 = happyReduce 4# 18# happyReduction_70
happyReduction_70 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut40 happy_x_2 of { (HappyWrap40 happy_var_2) -> 
	case happyOut38 happy_x_4 of { (HappyWrap38 happy_var_4) -> 
	happyIn39
		 (Frontend.Signe.Abs.TPoly happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_71 = happyReduce 4# 18# happyReduction_71
happyReduction_71 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut40 happy_x_2 of { (HappyWrap40 happy_var_2) -> 
	case happyOut38 happy_x_4 of { (HappyWrap38 happy_var_4) -> 
	happyIn39
		 (Frontend.Signe.Abs.tpolys happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_72 = happySpecReduce_1  19# happyReduction_72
happyReduction_72 happy_x_1
	 =  case happyOut21 happy_x_1 of { (HappyWrap21 happy_var_1) -> 
	happyIn40
		 ((:[]) happy_var_1
	)}

happyReduce_73 = happySpecReduce_2  19# happyReduction_73
happyReduction_73 happy_x_2
	happy_x_1
	 =  case happyOut21 happy_x_1 of { (HappyWrap21 happy_var_1) -> 
	case happyOut40 happy_x_2 of { (HappyWrap40 happy_var_2) -> 
	happyIn40
		 ((:) happy_var_1 happy_var_2
	)}}

happyNewToken action sts stk [] =
	happyDoAction 37# notHappyAtAll action sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = happyDoAction i tk action sts stk tks in
	case tk of {
	PT _ (TS _ 1) -> cont 1#;
	PT _ (TS _ 2) -> cont 2#;
	PT _ (TS _ 3) -> cont 3#;
	PT _ (TS _ 4) -> cont 4#;
	PT _ (TS _ 5) -> cont 5#;
	PT _ (TS _ 6) -> cont 6#;
	PT _ (TS _ 7) -> cont 7#;
	PT _ (TS _ 8) -> cont 8#;
	PT _ (TS _ 9) -> cont 9#;
	PT _ (TS _ 10) -> cont 10#;
	PT _ (TS _ 11) -> cont 11#;
	PT _ (TS _ 12) -> cont 12#;
	PT _ (TS _ 13) -> cont 13#;
	PT _ (TS _ 14) -> cont 14#;
	PT _ (TS _ 15) -> cont 15#;
	PT _ (TS _ 16) -> cont 16#;
	PT _ (TS _ 17) -> cont 17#;
	PT _ (TS _ 18) -> cont 18#;
	PT _ (TS _ 19) -> cont 19#;
	PT _ (TS _ 20) -> cont 20#;
	PT _ (TS _ 21) -> cont 21#;
	PT _ (TS _ 22) -> cont 22#;
	PT _ (TS _ 23) -> cont 23#;
	PT _ (TS _ 24) -> cont 24#;
	PT _ (TS _ 25) -> cont 25#;
	PT _ (TS _ 26) -> cont 26#;
	PT _ (TS _ 27) -> cont 27#;
	PT _ (TS _ 28) -> cont 28#;
	PT _ (TS _ 29) -> cont 29#;
	PT _ (TS _ 30) -> cont 30#;
	PT _ (TS _ 31) -> cont 31#;
	PT _ (TS _ 32) -> cont 32#;
	PT _ (TS _ 33) -> cont 33#;
	PT _ (TS _ 34) -> cont 34#;
	PT _ (T_Id _) -> cont 35#;
	PT _ (T_Scalar happy_dollar_dollar) -> cont 36#;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 37# tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

happyThen :: () => Either String a -> (a -> Either String b) -> Either String b
happyThen = ((>>=))
happyReturn :: () => a -> Either String a
happyReturn = (return)
happyThen1 m k tks = ((>>=)) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> Either String a
happyReturn1 = \a tks -> (return) a
happyError' :: () => ([(Token)], [Prelude.String]) -> Either String a
happyError' = (\(tokens, _) -> happyError tokens)
pProgram tks = happySomeParser where
 happySomeParser = happyThen (happyParse 0# tks) (\x -> happyReturn (let {(HappyWrap23 x') = happyOut23 x} in x'))

pListToplevel tks = happySomeParser where
 happySomeParser = happyThen (happyParse 1# tks) (\x -> happyReturn (let {(HappyWrap24 x') = happyOut24 x} in x'))

pToplevel tks = happySomeParser where
 happySomeParser = happyThen (happyParse 2# tks) (\x -> happyReturn (let {(HappyWrap25 x') = happyOut25 x} in x'))

pListPattern tks = happySomeParser where
 happySomeParser = happyThen (happyParse 3# tks) (\x -> happyReturn (let {(HappyWrap26 x') = happyOut26 x} in x'))

pExpr3 tks = happySomeParser where
 happySomeParser = happyThen (happyParse 4# tks) (\x -> happyReturn (let {(HappyWrap27 x') = happyOut27 x} in x'))

pExpr2 tks = happySomeParser where
 happySomeParser = happyThen (happyParse 5# tks) (\x -> happyReturn (let {(HappyWrap28 x') = happyOut28 x} in x'))

pExpr1 tks = happySomeParser where
 happySomeParser = happyThen (happyParse 6# tks) (\x -> happyReturn (let {(HappyWrap29 x') = happyOut29 x} in x'))

pExpr tks = happySomeParser where
 happySomeParser = happyThen (happyParse 7# tks) (\x -> happyReturn (let {(HappyWrap30 x') = happyOut30 x} in x'))

pListExpr tks = happySomeParser where
 happySomeParser = happyThen (happyParse 8# tks) (\x -> happyReturn (let {(HappyWrap31 x') = happyOut31 x} in x'))

pLet tks = happySomeParser where
 happySomeParser = happyThen (happyParse 9# tks) (\x -> happyReturn (let {(HappyWrap32 x') = happyOut32 x} in x'))

pListLet tks = happySomeParser where
 happySomeParser = happyThen (happyParse 10# tks) (\x -> happyReturn (let {(HappyWrap33 x') = happyOut33 x} in x'))

pComplex tks = happySomeParser where
 happySomeParser = happyThen (happyParse 11# tks) (\x -> happyReturn (let {(HappyWrap34 x') = happyOut34 x} in x'))

pPattern tks = happySomeParser where
 happySomeParser = happyThen (happyParse 12# tks) (\x -> happyReturn (let {(HappyWrap35 x') = happyOut35 x} in x'))

pMono2 tks = happySomeParser where
 happySomeParser = happyThen (happyParse 13# tks) (\x -> happyReturn (let {(HappyWrap36 x') = happyOut36 x} in x'))

pMono1 tks = happySomeParser where
 happySomeParser = happyThen (happyParse 14# tks) (\x -> happyReturn (let {(HappyWrap37 x') = happyOut37 x} in x'))

pMono tks = happySomeParser where
 happySomeParser = happyThen (happyParse 15# tks) (\x -> happyReturn (let {(HappyWrap38 x') = happyOut38 x} in x'))

pType tks = happySomeParser where
 happySomeParser = happyThen (happyParse 16# tks) (\x -> happyReturn (let {(HappyWrap39 x') = happyOut39 x} in x'))

pListId tks = happySomeParser where
 happySomeParser = happyThen (happyParse 17# tks) (\x -> happyReturn (let {(HappyWrap40 x') = happyOut40 x} in x'))

happySeq = happyDontSeq


happyError :: [Token] -> Either String a
happyError ts = Left $
  "syntax error at " ++ tokenPos ts ++
  case ts of
    []      -> []
    [Err _] -> " due to lexer error"
    t:_     -> " before `" ++ (prToken t) ++ "'"

myLexer = tokens
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- $Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp $













-- Do not remove this comment. Required to fix CPP parsing when using GCC and a clang-compiled alex.
#if __GLASGOW_HASKELL__ > 706
#define LT(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.<# m)) :: Prelude.Bool)
#define GTE(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.>=# m)) :: Prelude.Bool)
#define EQ(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.==# m)) :: Prelude.Bool)
#else
#define LT(n,m) (n Happy_GHC_Exts.<# m)
#define GTE(n,m) (n Happy_GHC_Exts.>=# m)
#define EQ(n,m) (n Happy_GHC_Exts.==# m)
#endif



















data Happy_IntList = HappyCons Happy_GHC_Exts.Int# Happy_IntList








































infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is ERROR_TOK, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept 0# tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
        (happyTcHack j (happyTcHack st)) (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action



happyDoAction i tk st
        = {- nothing -}
          case action of
                0#           -> {- nothing -}
                                     happyFail (happyExpListPerState ((Happy_GHC_Exts.I# (st)) :: Prelude.Int)) i tk st
                -1#          -> {- nothing -}
                                     happyAccept i tk st
                n | LT(n,(0# :: Happy_GHC_Exts.Int#)) -> {- nothing -}
                                                   (happyReduceArr Happy_Data_Array.! rule) i tk st
                                                   where rule = (Happy_GHC_Exts.I# ((Happy_GHC_Exts.negateInt# ((n Happy_GHC_Exts.+# (1# :: Happy_GHC_Exts.Int#))))))
                n                 -> {- nothing -}
                                     happyShift new_state i tk st
                                     where new_state = (n Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#))
   where off    = happyAdjustOffset (indexShortOffAddr happyActOffsets st)
         off_i  = (off Happy_GHC_Exts.+# i)
         check  = if GTE(off_i,(0# :: Happy_GHC_Exts.Int#))
                  then EQ(indexShortOffAddr happyCheck off_i, i)
                  else Prelude.False
         action
          | check     = indexShortOffAddr happyTable off_i
          | Prelude.otherwise = indexShortOffAddr happyDefActions st




indexShortOffAddr (HappyA# arr) off =
        Happy_GHC_Exts.narrow16Int# i
  where
        i = Happy_GHC_Exts.word2Int# (Happy_GHC_Exts.or# (Happy_GHC_Exts.uncheckedShiftL# high 8#) low)
        high = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr (off' Happy_GHC_Exts.+# 1#)))
        low  = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr off'))
        off' = off Happy_GHC_Exts.*# 2#




{-# INLINE happyLt #-}
happyLt x y = LT(x,y)


readArrayBit arr bit =
    Bits.testBit (Happy_GHC_Exts.I# (indexShortOffAddr arr ((unbox_int bit) `Happy_GHC_Exts.iShiftRA#` 4#))) (bit `Prelude.mod` 16)
  where unbox_int (Happy_GHC_Exts.I# x) = x






data HappyAddr = HappyA# Happy_GHC_Exts.Addr#


-----------------------------------------------------------------------------
-- HappyState data type (not arrays)













-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state 0# tk st sts stk@(x `HappyStk` _) =
     let i = (case Happy_GHC_Exts.unsafeCoerce# x of { (Happy_GHC_Exts.I# (i)) -> i }) in
--     trace "shifting the error token" $
     happyDoAction i tk new_state (HappyCons (st) (sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state (HappyCons (st) (sts)) ((happyInTok (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happySpecReduce_0 nt fn j tk st@((action)) sts stk
     = happyGoto nt j tk st (HappyCons (st) (sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@((HappyCons (st@(action)) (_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happySpecReduce_2 nt fn j tk _ (HappyCons (_) (sts@((HappyCons (st@(action)) (_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happySpecReduce_3 nt fn j tk _ (HappyCons (_) ((HappyCons (_) (sts@((HappyCons (st@(action)) (_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) sts of
         sts1@((HappyCons (st1@(action)) (_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (happyGoto nt j tk st1 sts1 r)

happyMonadReduce k nt fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k (HappyCons (st) (sts)) of
        sts1@((HappyCons (st1@(action)) (_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> happyGoto nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k (HappyCons (st) (sts)) of
        sts1@((HappyCons (st1@(action)) (_))) ->
         let drop_stk = happyDropStk k stk

             off = happyAdjustOffset (indexShortOffAddr happyGotoOffsets st1)
             off_i = (off Happy_GHC_Exts.+# nt)
             new_state = indexShortOffAddr happyTable off_i




          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop 0# l = l
happyDrop n (HappyCons (_) (t)) = happyDrop (n Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) t

happyDropStk 0# l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Happy_GHC_Exts.-# (1#::Happy_GHC_Exts.Int#)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction


happyGoto nt j tk st = 
   {- nothing -}
   happyDoAction j tk new_state
   where off = happyAdjustOffset (indexShortOffAddr happyGotoOffsets st)
         off_i = (off Happy_GHC_Exts.+# nt)
         new_state = indexShortOffAddr happyTable off_i




-----------------------------------------------------------------------------
-- Error recovery (ERROR_TOK is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist 0# tk old_st _ stk@(x `HappyStk` _) =
     let i = (case Happy_GHC_Exts.unsafeCoerce# x of { (Happy_GHC_Exts.I# (i)) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  ERROR_TOK tk old_st CONS(HAPPYSTATE(action),sts) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        DO_ACTION(action,ERROR_TOK,tk,sts,(saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (action) sts stk =
--      trace "entering error recovery" $
        happyDoAction 0# tk action sts ((Happy_GHC_Exts.unsafeCoerce# (Happy_GHC_Exts.I# (i))) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = Prelude.error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions


happyTcHack :: Happy_GHC_Exts.Int# -> a -> a
happyTcHack x y = y
{-# INLINE happyTcHack #-}


-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `Prelude.seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.


{-# NOINLINE happyDoAction #-}
{-# NOINLINE happyTable #-}
{-# NOINLINE happyCheck #-}
{-# NOINLINE happyActOffsets #-}
{-# NOINLINE happyGotoOffsets #-}
{-# NOINLINE happyDefActions #-}

{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
