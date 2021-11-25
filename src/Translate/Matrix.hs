{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE PatternSynonyms      #-}

{-|
Module      : Matrix
Description : Matrix representations
Stability   : stable

Exports functions transforming unitary transformations to their matrix representations
-}
module Translate.Matrix where

import Prelude hiding ( (<>) )
import Translate.Unitary ( Unitary(..), arity, complex, pattern (:+), C, inner, crotations )
import Numeric.LinearAlgebra ( (><), (<>) )
import qualified Numeric.LinearAlgebra as L
import Control.Lens ( (.~), element )
import Data.Function ( on )
import Data.Maybe (fromJust)
import Data.Functor ( ($>) )
import Control.Monad ( join, replicateM, liftM2 )
import Data.List ( transpose, permutations, nub )
import Translate.Result
    ( TranslationError(RotationNotOrthogonal, ConditionalArityMismatch,
                       MalformedPermutationPattern, SerialArityMismatch,
                       ParallelArityMismatch),
      guard,
      Result,
      testResult,
      equalM )

type Matrix = L.Matrix L.C

instance {-# OVERLAPS #-} Show Matrix where
    show = L.dispcf 3


(⊗) :: Matrix -> Matrix -> Matrix
(⊗) = L.kronecker

(<⊗>) :: Result Matrix -> Matrix -> Result Matrix
(<⊗>) = flip $ (<$>) . (⊗)

matrix :: Unitary -> Result Matrix
matrix (Par  xs) = foldl (⊗) (L.ident 1) <$> mapM matrix xs
matrix (Ser [])  = return $ (0><0) []
matrix (Ser  xs@(x:_)) = checkSer xs
                       >> foldl (<>)
                        <$> (L.ident . (2^) <$> arity x) 
                        <*> mapM matrix xs
matrix (Perm ps) = checkPattern ps $> permutationMatrix (scalePermutation ps)
matrix (Rot  u v) = orthogonal u v  $> (2><2) (crotations u v)
matrix (Cond t c) = on equalM arity t c (ConditionalArityMismatch t c)
                >>= liftM2 (+) <$> (matrix t <⊗>) . proj1 <*> (matrix c <⊗>) . proj0

proj :: L.Vector L.C -> Matrix
proj = liftM2 (<>) L.asColumn L.asRow

proj0 :: Int -> Matrix
proj0 = proj . L.fromList . (element 0 .~ 1) . flip replicate 0 . (2^)

proj1 :: Int -> Matrix
proj1 = ((proj . L.fromList) .) . (.~ 1) . element <*> flip replicate 0 . (2^)

checkPattern :: [Int] -> Result ()
checkPattern xs = guard (xs `elem` permutations [0..length xs-1])
                        $ MalformedPermutationPattern xs

checkPar :: [Unitary] -> Result ()
checkPar xs = do
  x <- mapM arity xs
  guard (length (nub x) == 1) $ ParallelArityMismatch xs
  
checkSer :: [Unitary] -> Result ()
checkSer xs = do
  x <- mapM arity xs
  guard (length (nub x) == 1) $ SerialArityMismatch xs

eq0 :: [Int] -> Bool
eq0 = (==) 0 . length . nub

orthogonal :: (C, C) -> (C, C) -> Result ()
orthogonal u v = guard (inner u v == 0)
               $ RotationNotOrthogonal $ Rot u v

permutationMatrix :: [Int] -> Matrix
permutationMatrix = join (on (><) length)
                <*> ( (=<<)
                  =<< flip ((.~ 1) . element)
                    . flip replicate 0
                    . length
                    )

scalePermutation :: [Int] -> [Int]
scalePermutation = map (foldl ((+) . (2*)) 0)
                 . transpose
                 . ( map =<< (!!)
                   . transpose
                   . flip replicateM [0,1]
                   . length
                   )
