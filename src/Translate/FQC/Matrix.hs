{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE LambdaCase           #-}

module Translate.FQC.Matrix where

import Prelude hiding ( (<>) )
import Translate.FQC.Unitary
import Numeric.LinearAlgebra ( (><), (<>) )
import qualified Numeric.LinearAlgebra as L
import Control.Lens ( (.~), element )
import Control.Monad ( guard )
import Data.Function ( on )

type Matrix = L.Matrix L.C

instance {-# OVERLAPS #-} Show Matrix where
    show = L.dispcf 3

matrix :: Unitary -> Maybe Matrix
matrix (Par  xs) = foldl L.kronecker (L.ident 1) <$> mapM matrix xs
matrix (Ser  xs) = foldl (<>) (L.ident 2) <$> mapM matrix xs
matrix (Perm ps) = return $ (dim><dim) $ concatMap (($ replicate dim 0) . (.~ 1) . element) ps
    where dim = length ps
matrix (Cond t c) = (guard =<< ((==) <$> arity t <*> arity c)) >> (<>) <$> matrix t <*> matrix c
matrix (Rot (i,j) (k,l)) = return $ (2><2) $ map complex [i,j,k,l]
