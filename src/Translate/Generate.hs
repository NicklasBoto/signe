module Translate.Generate where

import Translate.Unitary.Data
import Numeric.LinearAlgebra hiding ( C, (===) )
import Math.MFSolve

-- Ser [ Par [Perm [0,1]]
--     , Perm [0,1]
--     , Par [Perm [0],Perm [0]]
--     , Perm [0,1]
--     , Par [Cond (Rot (0.0,1.0) (1.0,0.0)) (Perm [0])]
--     , Perm [1,0]
--     ]

gate :: Unitary -> (C, C, C)
gate ~(Rot (i,j) (k,l)) = (θ, φ, λ)
    where θ = undefined 
          φ = undefined
          λ = undefined

solve i j k l = showVars $ flip execSolver noDeps $ ignore $ do
     let [θ,φ,λ] = map (makeVariable . SimpleVar) ["θ","φ","λ"]
     cos (θ/2) === i
     exp (i*φ) * sin (θ/2) === j
     -exp (i*λ) * sin (θ/2) === k
     exp (i * (φ + λ)) * cos (θ/2) === l