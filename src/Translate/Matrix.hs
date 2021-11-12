{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE PatternSynonyms      #-}

module Translate.Matrix where

import Prelude hiding ( (<>) )
import Translate.Unitary ( Unitary(..), arity, complex, pattern (:+), C )
import Translate.Unitary.Data
import Numeric.LinearAlgebra ( (><), (<>) )
import qualified Numeric.LinearAlgebra as L
import Control.Lens ( (.~), element )
import Data.Function ( on )
import Data.Maybe (fromJust)
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
matrix (Rot (i,j) (k,l)) = return $ (2><2) $ map complex [i,j,k,l]
matrix (Cond t c) =
    Nothing

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

eqC :: L.C -> L.C -> Bool
eqC a b = L.magnitude  a - L.magnitude b < 1

par :: (Unitary, Unitary, Unitary) -> Matrix
par (a,b,c) = fromJust $ matrix $ Par [a,b,c]

eqMat :: Matrix -> Matrix -> Bool
eqMat a b = and $ eqMat' a b

eqMat' :: Matrix -> Matrix -> [Bool]
eqMat' a b = zipWith eqC ((L.toList . L.flatten) a) (( L.toList . L.flatten) b)

ser :: (Unitary, Unitary, Unitary) -> Matrix
ser (a,b,c) = fromJust $ matrix $ Ser [a,b,c]

checkPars :: [(Unitary, Unitary, Unitary)] -> [Matrix] -> Bool
checkPars uPairs mats = and $ checkPars' uPairs mats

checkPars' :: [(Unitary, Unitary, Unitary)] -> [Matrix] -> [Bool]
checkPars' uPairs mats = zipWith eqMat mats (map par uPairs)

checkSers :: [(Unitary, Unitary, Unitary)] -> [Matrix] -> Bool
checkSers uPairs mats = and $ checkPars' uPairs mats

checkSers' :: [(Unitary, Unitary, Unitary)] -> [Matrix] -> [Bool]
checkSers' uPairs mats = zipWith eqMat mats (map ser uPairs)

-- Pairs of unitary Rot matrices to test against Par and Ser operations
matPairsTest :: [(Unitary, Unitary, Unitary)]
matPairsTest = [(Rot (0.8366533864541833 :+ (-0.5477327002605806), 0) (0, (-0.49019607843137253) :+ 0.871612187093838),Rot ((-0.8346613545816733) :+ 0.550763491135611, 0) (0, 1),Rot (0.035856573705179286 :+ 0.8235294117647058, 0.5661392179319522) (-0.566139, 0.035856573705179286 :+ (-0.8235294117647058))), (Rot (0.8366533864541833 :+ (-0.5477327002605806), 0) (0, (-0.49019607843137253) :+ 0.871612187093838),Rot ((-0.8346613545816733) :+ 0.550763491135611, 0) (0, 1),Rot ((-0.21115537848605578) :+ (-0.4230769230769231), -0.881147) (-0.881147, 0.21115537848605578 :+ (-0.4230769230769231))), (Rot (0.8366533864541833 :+ (-0.5477327002605806), 0) (0, (-0.49019607843137253) :+ 0.871612187093838),Rot ((-0.8346613545816733) :+ 0.550763491135611, 0) (0, 1),Rot ((-0.7211155378486056) :+ (-0.5616438356164384), (-0.008) :+ 0.4055669895188358) (-0.405646, (-0.5473130239812032) :+ (-0.7320518224778756)))]

-- Results of Par on three-a-piece pair Rot matrices
matPairsParResTest :: [Matrix]
matPairsParResTest = [(8><8) $ map complex [(-0.7701973958809951) :+ (-0.29373858666768865), (-0.22455972919339298) :+ 0.5196985107783093, 0, 0, 0, 0, 0, 0, 0.22455972919339298 :+ (-0.5196985107783093), 0.7417522988942471 :+ 0.35956906569461294, 0, 0, 0, 0, 0, 0, 0, 0, 0.48107351226697215 :+ 0.6693688532599323, 0.4736622938872907 :+ (-0.3100929625612815), 0, 0, 0, 0, 0, 0, (-0.4736622938872907) :+ 0.3100929625612815, (-0.4210744646328076) :+ (-0.7086484891351931), 0, 0, 0, 0, 0, 0, 0, 0, 0.818914290099843 :+ (-0.09415822528949805), (-0.0401417888778836) :+ (-0.5647143090681216), 0, 0, 0, 0, 0, 0, 0.0401417888778836 :+ 0.5647143090681216, (-0.823999071248958) :+ 0.02262557182155081, 0, 0, 0, 0, 0, 0, 0, 0, (-0.7353750235406016) :+ (-0.37243786149109115), (-0.27751922447644717) :+ 0.49345384194126385, 0, 0, 0, 0, 0, 0, 0.27751922447644717 :+ (-0.49345384194126385), 0.7002215199080728 :+ 0.43494391474881655], (8><8) $ map complex [0.47212670136982193 :+ (-0.026020272048484505), 0.3495077441483786 :+ (-0.8088656625648571), 0, 0, 0, 0, 0, 0, 0.3495077441483786 :+ (-0.8088656625648571), 0.3046166857811954 :+ 0.3616481044434032, 0, 0, 0, 0, 0, 0, 0, 0, (-0.4083969279732344) :+ (-0.23831203479021146), (-0.7372142833416104) :+ 0.48263280424489347, 0, 0, 0, 0, 0, 0, (-0.7372142833416104) :+ 0.48263280424489347, (-0.055069203016487656) :+ (-0.46962544605563594), 0, 0, 0, 0, 0, 0, 0, 0, (-0.4070402303451318) :+ 0.24062195989644888, 0.062477213199286126 :+ 0.8789288487283967, 0, 0, 0, 0, 0, 0, 0.062477213199286126 :+ 0.8789288487283967, (-0.4369839415565874) :+ (-0.18062588830368478), 0, 0, 0, 0, 0, 0, 0, 0, 0.4722665407055652 :+ 0.023345047308260897, 0.43193460578605086 :+ (-0.7680181115186169), 0, 0, 0, 0, 0, 0, 0.43193460578605086 :+ (-0.7680181115186169), 0.26525146375845166 :+ 0.39143624982597736], (8><8) $ map complex [0.8016031401461023 :+ (-0.43918540813708395), (-0.36912490076840454) :+ (-0.16821233789495638), 0, 0, 0, 0, 0, 0, 0.16089987570839762 :+ (-0.3723705318421339), 0.8890935135040159 :+ (-0.21204749764548592), 0, 0, 0, 0, 0, 0, 0, 0, (-0.9109544514326671) :+ (-0.07492265630393213), 0.21544907521407305 :+ 0.3437008568170469, 0, 0, 0, 0, 0, 0, (-0.33938500232419194) :+ 0.22218551524521066, (-0.8588800164208392) :+ (-0.31269239582306285), 0, 0, 0, 0, 0, 0, 0, 0, (-0.5090999417925319) :+ 0.7591236172583945, 0.40511345851605995 :+ (-0.020776638720641973), 0, 0, 0, 0, 0, 0, 0.028762097569158634 :+ 0.4046249185737252, (-0.691402402228442) :+ 0.5978412290946217, 0, 0, 0, 0, 0, 0, 0, 0, 0.8430236206787324 :+ (-0.35321748539723996), (-0.3495755621201252) :+ (-0.20578024530010158), 0, 0, 0, 0, 0, 0, 0.19884602143644295 :+ (-0.35356589590381754), 0.9063559880859728 :+ (-0.1181957692700048)]]

-- Results of Ser on three-a-piece pair Rot matrices
matPairsSerResTest :: [Matrix]
matPairsSerResTest = [(2><2) $ map complex [(-0.7701973958809951) :+ (-0.29373858666768865), (-0.22455972919339298) :+ 0.5196985107783093, 0.27751922447644717 :+ (-0.49345384194126385), 0.7002215199080728 :+ 0.43494391474881655], (2><2) $ map complex [0.47212670136982193 :+ (-0.026020272048484505), 0.3495077441483786 :+ (-0.8088656625648571), 0.43193460578605086 :+ (-0.7680181115186169), 0.26525146375845166 :+ 0.39143624982597736], (2><2) $ map complex [0.8016031401461023 :+ (-0.43918540813708395), (-0.36912490076840454) :+ (-0.16821233789495638), 0.19884602143644295 :+ (-0.35356589590381754), 0.9063559880859728 :+ (-0.1181957692700048)]]