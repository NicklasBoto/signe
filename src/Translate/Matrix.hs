{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE PatternSynonyms      #-}

{-|
Module      : Matrix
Description : Matrix representations
Stability   : experimental

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
import Data.Functor
import Control.Monad ( join, replicateM, liftM2 )
import Data.List ( transpose, permutations )
import Translate.Result

type Matrix = L.Matrix L.C

instance {-# OVERLAPS #-} Show Matrix where
    show = L.dispcf 3

matrix :: Unitary -> Result Matrix
matrix (Par  xs) = foldl L.kronecker (L.ident 1) <$> mapM matrix xs
matrix (Ser  xs) = foldl (<>)        (L.ident 2) <$> mapM matrix xs
matrix (Perm ps) = checkPattern ps $> permutationMatrix (scalePermutation ps)
matrix (Rot u v) = orthogonal u v  $> (2><2) (crotations u v)
matrix (Cond t c) = do
  at <- arity t
  ac <- arity c
  equal at ac $ ConditionalArityMismatch (t,at) (c,ac)

  mt <- matrix t
  mc <- matrix c

  return $ proj0 ac `L.kronecker` mc + proj1 at `L.kronecker` mt

proj :: L.Vector L.C -> Matrix
proj = liftM2 (<>) L.asColumn L.asRow

proj0 :: Int -> Matrix
proj0 = proj . L.fromList . (element 0 .~ 1) . flip replicate 0 . (2^)

proj1 :: Int -> Matrix
proj1 = ((proj . L.fromList) .) . (.~ 1) . element <*> flip replicate 0 . (2^)

checkPattern :: [Int] -> Result ()
checkPattern xs = guard (xs `elem` permutations [0..length xs-1])
                        $ MalformedPermutationPattern xs

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
