{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances    #-}

module Translate.FQC.Matrix where

import Prelude hiding ( (<>) )
import Translate.FQC.Unitary ( Unitary(..), arity, complex )
import Numeric.LinearAlgebra ( (><), (<>) )
import qualified Numeric.LinearAlgebra as L
import Control.Lens ( (.~), element )
import Data.Function ( on )
import Control.Monad ( guard, join, replicateM )
import Data.List ( transpose )

type Matrix = L.Matrix L.C

instance {-# OVERLAPS #-} Show Matrix where
    show = L.dispcf 3

-- add more checks
matrix :: Unitary -> Maybe Matrix
matrix (Par  xs) = foldl L.kronecker (L.ident 1) <$> mapM matrix xs
matrix (Ser  xs) = foldl (<>) (L.ident 2) <$> mapM matrix xs
matrix (Perm ps) = return $ permutationMatrix $ scalePermutation ps
matrix (Cond t c) = (guard =<< ((==) <$> arity t <*> arity c)) >> (<>) <$> matrix t <*> matrix c
matrix (Rot (i,j) (k,l)) = return $ (2><2) $ map complex [i,j,k,l]

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
