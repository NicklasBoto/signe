{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances    #-}

module Translate.FQC.Matrix where

import Prelude hiding ( (<>) )
import Translate.FQC.Unitary
import Numeric.LinearAlgebra ( (><), (<>) )
import qualified Numeric.LinearAlgebra as L
import Control.Lens ( (.~), element )
import Control.Monad ( guard )
import Data.Function ( on )
import Debug.Trace

debug :: String -> Maybe ()
debug = flip trace (return ())

type Matrix = L.Matrix L.C

instance {-# OVERLAPS #-} Show Matrix where
    show = L.dispcf 3

matrix :: Unitary -> Maybe Matrix
matrix (Par  xs) = foldl L.kronecker (L.ident 1) <$> mapM matrix xs
matrix (Ser  xs) = foldl (<>) (L.ident 2) <$> mapM matrix xs
matrix (Perm ps) = return $ permutationMatrix ps
matrix (Cond t c) = (guard =<< ((==) <$> arity t <*> arity c)) >> (<>) <$> matrix t <*> matrix c
matrix (Rot (i,j) (k,l)) = return $ (2><2) $ map complex [i,j,k,l]

-- permutationMatrix :: [Int] -> Matrix
permutationMatrix ps = scl . (d><d) $ concatMap (($ replicate d 0) . (.~ 1) . element) ps
    where d     = length ps
          scl x = x

exponentialDimension :: Int -> Matrix
exponentialDimension 0 = (2><1) [1,0]
exponentialDimension 1 = (2><1) [0,1]
exponentialDimension _ = undefined

-- π  = {1 0 2}
-- ψ  = ~010 --> ~100
-- ψ  = [0 0 1 0 0 0 0 0] --> [0 0 0 1 0 0 0 0]
-- π* = {0 1 3 2 4 5 6 7} 



-- replaceAt = (.~ 1) . element
-- zeros = replicate d 0
-- e n = replaceAt n $ zeros