{-# LANGUAGE GeneralisedNewtypeDeriving #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE NamedFieldPuns             #-}
{-# LANGUAGE CPP, MagicHash             #-}
{-# LANGUAGE BlockArguments             #-}
{-# LANGUAGE TupleSections              #-}
{-# LANGUAGE LambdaCase                 #-}

{-|
Module      : Type.Check
Description : Hindley-Milner typechecker
Stability   : stable

Initial Hindley-Milner typechecking of Signe
-}
module Type.Check where

#define DEBUG

import Frontend.SAST.Abs
    ( Expr(..), Id(Id), Program, Scheme(..), Toplevel(..), Type(..) )
import Type.Error ( TypeError(..), urk )
import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.Functor ( (<&>) )
import Data.Function ( on )
import Data.Bifunctor ( Bifunctor(bimap), second )
import Data.Complex ( magnitude )
import Control.Monad ( foldM, replicateM, unless )
import Control.Monad.Except
    ( foldM,
      replicateM,
      unless,
      runExceptT,
      MonadError(throwError),
      ExceptT(..) )
import Control.Monad.State
    ( gets,
      modify,
      evalState,
      MonadState,
      State,
      StateT(StateT) )

#ifdef DEBUG

import Frontend.SAST.Par ( parseExpr, parse, parseType )
import Debug.Trace ( trace )

checkExpr :: Expr -> Either TypeError Scheme
checkExpr = runCheck . infer emptyContext

inferExpr :: String -> Scheme
inferExpr = either (errorWithoutStackTrace . show) id . checkExpr . parseExpr

inferProgram :: String -> [(Id, Scheme)]
inferProgram = either (errorWithoutStackTrace . show) id . checkProgram . parse

inferFile :: FilePath -> IO ()
inferFile path = putStrLn . concatMap put . inferProgram =<< readFile path
    where put (i,s) = show i ++ " : " ++ show s ++ "\n"

debug :: Monad m => String -> m ()
debug = flip trace (return ())

#endif

newtype Context = Context (Map.Map Id Scheme)
    deriving (Eq, Show)

emptyContext :: Context
emptyContext = Context Map.empty

lookupContext :: Context -> Id -> Check (Subst, Type)
lookupContext (Context c) x =
  case Map.lookup x c of
    Nothing -> throwError $ VariableNotInScope x
    Just s  -> (nullSubst,) <$> instantiate s

extend :: Context -> ([Id], Scheme) -> Context
extend (Context c) = Context . go
    where go :: ([Id], Scheme) -> Map.Map Id Scheme
          go ([x],s) = Map.insert x s c
          go (x:xs, Forall vs (a :* b)) =
              Map.insert x (Forall vs a) $ go (xs, Forall vs b)
          go _ = urk

newtype Check a = Check { getCheck :: ExceptT TypeError (State Int) a }
    deriving (Functor, Applicative, Monad, MonadState Int, MonadError TypeError)

checkProgram :: Program -> Either TypeError [(Id, Scheme)]
checkProgram = mapM <$> checkToplevel . generateContext <*> id

checkToplevel :: Check Context -> Toplevel -> Either TypeError (Id, Scheme)
checkToplevel cc (Topl n as Nothing e) = (n,) <$> runCheck do
    c <- cc
    tvs <- generateFreshArgumentTypes as
    (s,t) <- infer (addArguments c as tvs) e
    (s,) . foldr (:->) t . apply s <$> mapM instantiate tvs
checkToplevel cc (Topl n as (Just es) e) = (n,) <$> runCheck do
    c <- cc
    tvs <- generateFreshArgumentTypes as
    (s,t) <- infer (addArguments c as tvs) e
    at <- foldr (:->) t . apply s <$> mapM instantiate tvs
    et <- instantiate es
    let (≃) = (==) `on` closeOver . (s,)
    us <- unify at et
    if et ≃ apply us at
        then return (s, et)
        else throwError $ TypeMismatch et at

generateFreshArgumentTypes :: [[Id]] -> Check [Scheme]
generateFreshArgumentTypes = mapM $ fmap (Forall []) . foldM (\b _ -> (b<>) <$> fresh) TypeUnit

addArguments :: Context -> [[Id]] -> [Scheme] -> Context
addArguments c = foldl extend c ... zip
    where (...) = (.).(.)

generateContext :: Program -> Check Context
generateContext prog = Context . Map.fromList <$> mapM go prog
    where go :: Toplevel -> Check (Id, Scheme)
          go (Topl n _ Nothing _)  = (n,) . generalize emptyContext <$> fresh
          go (Topl n _ (Just t) _) = return (n, t)

runCheck :: Check (Subst, Type) -> Either TypeError Scheme
runCheck = second closeOver . flip evalState 0 . runExceptT . getCheck

closeOver :: (Subst, Type) -> Scheme
closeOver = normalize . generalize emptyContext . uncurry apply

normalize :: Scheme -> Scheme
normalize (Forall ts body) = Forall (fmap snd ord) (normtype body)
  where
    ord = zip (Set.toList $ ftv body) letters

    normtype (a :-> b)   = normtype a :-> normtype b
    normtype (a :* b)    = normtype a :* normtype b
    normtype TypeQubit   = TypeQubit
    normtype TypeUnit    = TypeUnit
    normtype (TypeVar a) = maybe urk TypeVar (lookup a ord)

type Subst = Map.Map Id Type

nullSubst :: Subst
nullSubst = Map.empty

compose, (∘) :: Subst -> Subst -> Subst
compose s1 s2 = Map.map (apply s1) s2 `Map.union` s1
(∘) = compose

class Substitutable a where
    apply :: Subst -> a -> a
    ftv   :: a -> Set.Set Id

instance Substitutable Type where
    apply _ TypeQubit  = TypeQubit
    apply _ TypeUnit   = TypeUnit
    apply s t@(TypeVar id) = Map.findWithDefault t id s
    apply s (n :-> p)  = apply s n :-> apply s p
    apply s (a :* b)   = apply s a :* apply s b

    ftv TypeQubit   = Set.empty
    ftv TypeUnit    = Set.empty
    ftv (TypeVar a) = Set.singleton a
    ftv (n :-> p)   = ftv n `Set.union` ftv p
    ftv (a :* b)    = ftv a `Set.union` ftv b

instance Substitutable Scheme where
    apply s (Forall vs t) = Forall vs $ apply (foldr Map.delete s vs) t
    ftv (Forall vs t) = ftv t `Set.difference` Set.fromList vs

instance Substitutable a => Substitutable [a] where
    apply = fmap . apply
    ftv = foldr (Set.union . ftv) Set.empty

instance Substitutable Context where
    apply s (Context c) = Context $ Map.map (apply s) c
    ftv (Context c) = ftv $ Map.elems c

letters :: [Id]
letters = [1..] >>= fmap (Id Nothing) . flip replicateM ['a'..'z']

fresh :: Check Type
fresh = modify (+1) >> gets (TypeVar . (letters !!))

occursCheck :: Substitutable a => Id -> a -> Bool
occursCheck a t = a `Set.member` ftv t

unify :: Type -> Type -> Check Subst
unify (l :-> r) (l' :-> r') = do
    s1 <- unify l l'
    s2 <- unify (apply s1 r) (apply s1 r')
    return $ s2 ∘ s1
unify (l :* r) (l' :* r') = compose <$> unify l l' <*> unify r r'
unify (TypeVar v) t = bind v t
unify t (TypeVar v) = bind v t
unify s t
    | s == t    = return nullSubst
    | otherwise = throwError $ TypeMismatch t s

bind :: Id -> Type -> Check Subst
bind v t
    | t == TypeVar v  = return nullSubst
    | occursCheck v t = throwError $ InfiniteType v t
    | otherwise       = return $ Map.singleton v t

instantiate :: Scheme -> Check Type
instantiate (Forall vs t) = do
    vs' <- mapM (const fresh) vs
    let s = Map.fromList $ zip vs vs'
    return $ apply s t

generalize :: Context -> Type -> Scheme
generalize c t = Forall vs t
    where vs = Set.toList $ ftv t `Set.difference` ftv c

infer :: Context -> Expr -> Check (Subst, Type)
infer c = \case
    Var x -> lookupContext c x

    KetZero -> return (nullSubst, TypeQubit)

    KetOne -> return (nullSubst, TypeQubit)

    Tup [] -> return (nullSubst, TypeUnit)

    Tup xs -> foldM
        (\(s,t) e -> infer c e <&> bimap (s∘) (t<>))
        (nullSubst, TypeUnit)
        xs

    m@(Mul k e) -> do
        unless (magnitude k == 1) $ throwError $ ScalarNotNormalized m
        (se, te) <- infer c e
        sr <- unify te TypeQubit
        return (sr ∘ se, apply sr te)

    App a b -> do
        tv <- fresh
        (sa, ta) <- infer c a
        (sb, tb) <- infer (apply sa c) b
        sr       <- unify (apply sb ta) (tb :-> tv)
        return (sr ∘ sb ∘ sa, apply sr tv)

    Plus a b -> do
        (sa, ta) <- infer c a
        (sb, tb) <- infer c b
        sa'      <- unify (apply sb ta) TypeQubit
        sb'      <- unify (apply sa' tb) TypeQubit
        return (sb' ∘ sa' ∘ sb ∘ sa, apply sb' tb)

    Comp f g -> infer c e
        where v = Id Nothing "I am too lazy at the moment"
              e = Abs [v] (App f (App g (Var v)))

    -- FIXME: impose orthogonality constraints when possible
    Ifq b t f -> do
        (s1,t1) <- infer c b
        (s2,t2) <- infer c t
        (s3,t3) <- infer c f
        s4 <- unify t1 TypeQubit
        s5 <- unify t2 t3
        return (s5 ∘ s4 ∘ s3 ∘ s2 ∘ s1, apply s5 t2)

    If b t f -> do
        (s1,t1) <- infer c b
        (s2,t2) <- infer c t
        (s3,t3) <- infer c f
        s4 <- unify t1 TypeQubit
        s5 <- unify t2 t3
        return (s5 ∘ s4 ∘ s3 ∘ s2 ∘ s1, apply s5 t2)

    -- FIXME: Handle not factorizable types better
    --
    -- Also,
    -- 
    -- Initialize all let definitions with general types,
    -- add them to the context, and type check them all at once.
    -- This will allow for them to call on each other.
    --
    -- Best regards,
    --
    -- Nicklas Janse Botö
    --
    Let ps e -> do
        is <- mapM (infer c) ps
        let (ss, ts) = unzip $ Map.elems is
            vs       = Map.keys is
            c'       = apply (foldl1 (∘) ss) c
            ts'      = map (generalize c') ts
            c''      = foldl extend c' $ zip vs ts'

        (se, te) <- infer c'' e
        return (foldl (∘) se ss, te)

    Abs xs e -> do
        tvs <- replicateM (length xs) fresh
        let c' = foldl extend c (bimap pure (Forall []) <$> zip xs tvs)
        (s1, t1) <- infer c' e
        return (s1, apply s1 (foldr (:->) t1 tvs))
