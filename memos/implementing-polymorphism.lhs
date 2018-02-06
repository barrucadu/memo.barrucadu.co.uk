---
title: Implementing Polymorphism
tags: coco, programming, research
date: 2017-05-09
audience: Haskell programmers.
epistemic_status: I wrote this memo to work out how to implement CoCo.  So this all works and is, mostly, still implemented like this.
---

Polymorphism is great, it means that we don't need to repeat the same conceptually-polymorphic
definition at multiple monomorphic types (I'm looking at you, Go).  It unfortunately means that we
need something a little smarter than equality for determining if a function application is
well-typed.


As with the other CoCo memos, this is a Literate Haskell file.  In the rendered output, highlighted
source is literate source, non-highlighted source is just commentary.

We're going to re-use the `Typeable` machinery as much as possible, as implementing it all ourself
is nasty.

> {-# LANGUAGE DataKinds #-}
> {-# LANGUAGE PolyKinds #-}
>
> import Data.Function (on)
> import Data.List (nub)
> import Data.Maybe (fromMaybe, isJust)
> import Data.Proxy (Proxy(..))
> import Data.Typeable


Type Variables
--------------

Firstly, we need a representation of type variables.  We can't use actual type variables, because
`Typeable` only works with monomorphic types.  So we'll need to introduce some specific types that
we shall treat as variables during type-checking.  We can get an arbitrary number of these by using
a polymorphic type:

> data TyVar t = TyVar deriving (Bounded, Enum, Eq, Ord, Read, Show)

For convenience, we shall also have four named type variables:

> type A = TyVar 0
> type B = TyVar 1
> type C = TyVar 2
> type D = TyVar 3

If any type needs more than four distinct type variables, it can always introduce its own.

Finally, we can check if a type is a type variable:

> isTypeVar :: TypeRep -> Bool
> isTypeVar = ((==) `on` (fst . splitTyConApp)) (typeRep (Proxy :: Proxy A))


Typing Function Applications
----------------------------

The [Data.Typeable][] module has a handy little function for checking that a function application is
well-typed:

[Data.Typeable]: https://hackage.haskell.org/package/base-4.9.1.0/docs/Data-Typeable.html

```
funResultTy :: TypeRep -> TypeRep -> Maybe TypeRep
```

which takes the function type, the argument type, and returns the result type if the application is
well-typed.  We want something similar, but supporting our type variables.  We don't just want
equality, want *unification*.  We want a function like so:

> -- | Applies a type to a function type.  If type-correct, returns an environment binding type
> -- variables to types, and the result type (with bindings applied).
> polyFunResultTy :: TypeRep -> TypeRep -> Maybe (TypeEnv, TypeRep)
> polyFunResultTy fty aty = do
>   -- get the function and argument types
>   let funTyCon = typeRepTyCon (typeRep (Proxy :: Proxy (() -> ())))
>   (argTy, resultTy) <- case splitTyConApp fty of
>     (con, [argTy, resultTy]) | con == funTyCon -> Just (argTy, resultTy)
>     _ -> Nothing
>   -- produce a (possibly empty) type environment
>   env <- unify aty argTy
>   -- apply the type environment to the result
>   pure (env, applyBindings env resultTy)

**Type Environments:** Firstly, let's define what a type environment actually is.  We'll keep it
very simple: just a map from types to types:

> -- | An environment of type bindings.
> type TypeEnv = [(TypeRep, TypeRep)]

The first in every tuple will be a `TyVar`, but there isn't really a good way to statically enforce
that.

Now that we have type environments, let's apply them to a type.  This need not make a type fully
monomorphic, the bindings may not cover every type variable used, or may define some type variables
in terms of others (as long as a variable isn't defined in terms of itself).  This is fine.

> -- | Apply type environment bindings to a type.
> applyBindings :: TypeEnv -> TypeRep -> TypeRep
> applyBindings env = go where
>   go ty
>     -- look up type variables in the environment, but fall-back to the naked variable if not found
>     | isTypeVar ty = fromMaybe ty (lookup ty env)
>     -- otherwise continue recursively through type constructors
>     | otherwise = let (con, args) = splitTyConApp ty in mkTyConApp con (map go args)

**Unification:** For reasons that will become apparent later, we're going to define a few variants
of this.

Firstly, our standard unification function.  It'll take two types (the order doesn't matter) and
attempt to unify them.  Two types unify if:

1. They're structurally equal; OR
2. At least one is a type variable; OR
3. They have the same constructor with the same number of arguments, and all the arguments unify,
   with compatible environments.

Hey, that sounds like a recursive function!

> -- | Attempt to unify two types.
> unify :: TypeRep -> TypeRep -> Maybe [(TypeRep, TypeRep)]
> unify = unify' True

This next function is the actual workhorse.  It implements the recursive decision procedure
described above and constructs the environment.  It takes a flag to determine if unifying with a
naked type variable is allowed here.  It always is in the recursive case.  This will turn out to be
useful in the next section, when we're talking about polymorphic uses of the state type.

> -- | Attempt to unify two types.
> unify'
>   :: Bool
>   -- ^ Whether to allow either type to be a naked type variable at this level (always true in
>   -- lower levels).
>   -> TypeRep -> TypeRep -> Maybe TypeEnv
> unify' b tyA tyB
>     -- check equality
>     | tyA == tyB = Just []
>     -- check if one is a naked type variable
>     | isTypeVar tyA = if not b || occurs tyA tyB then Nothing else Just [(tyA, tyB)]
>     | isTypeVar tyB = if not b || occurs tyB tyA then Nothing else Just [(tyB, tyA)]
>     -- deconstruct each and attempt to unify subcomponents
>     | otherwise =
>       let (conA, argsA) = splitTyConApp tyA
>           (conB, argsB) = splitTyConApp tyB
>       in if conA == conB && length argsA == length argsB
>          then unifyAccum True id argsA argsB
>          else Nothing
>   where
>     -- check if a type occurs in another
>     occurs needle haystack = needle == haystack || any (occurs needle) (snd (splitTyConApp haystack))

The recursive listy case is handled by this `unifyAccum` function, which is mutually recursive with
`unify'`:

> -- | An accumulating unify: attempts to unify two lists of types pairwise and checks that the
> -- resulting assignments do not conflict with the current type environment.
> unifyAccum :: Bool -> (Maybe TypeEnv -> Maybe TypeEnv) -> [TypeRep] -> [TypeRep] -> Maybe TypeEnv
> unifyAccum b f as bs = foldr go (Just []) (zip as bs) where
>   go (tyA, tyB) (Just env) =
>     unifyTypeEnvs b env =<< f (unify' b tyA tyB)
>   go _ Nothing = Nothing

The final piece of the unification puzzle is how to combine type environments.  This is necessary to
be able to unify types like `T A A` and `T Int B`.  One option is to enforce equality of bindings,
but that is too restrictive (it won't work in the `T` example, as `Int` is not `B`, yet both *do*
unify).  The correct solution is to unify the bindings.  This is yet another mutually recursive
function:

> -- | Unify two type environments, if possible.
> unifyTypeEnvs :: Bool -> TypeEnv -> TypeEnv -> Maybe TypeEnv
> unifyTypeEnvs b env1 env2 = foldr go (Just []) (nub $ map fst env1 ++ map fst env2) where
>   go tyvar acc@(Just env) = case (lookup tyvar env, lookup tyvar env1, lookup tyvar env2) of
>     (_, Just ty1, Just ty2) -> unifyTypeEnvs b env . ((tyvar, ty1):) =<< unify' b ty1 ty2
>     (x, Just ty1, _)
>       | isJust x  -> unifyTypeEnvs b env [(tyvar, ty1)]
>       | otherwise -> Just ((tyvar, ty1):env)
>     (x, _, Just ty2)
>       | isJust x  -> unifyTypeEnvs b env [(tyvar, ty2)]
>       | otherwise -> Just ((tyvar, ty2):env)
>     _ -> acc
>   go _ Nothing = Nothing

And now, an example:

```
λ> data T a b = T
λ> unify (typeOf (undefined :: T A A)) (typeOf (undefined :: T Int B))
Just [(TyVar Nat 0,TyVar Nat 1),(TyVar Nat 1,Int)]

λ> let funTy = typeOf (undefined :: A -> B -> Bool -> Either A B)
λ> polyFunResultTy funTy (typeOf (undefined::Int))
Just ([(TyVar Nat 0,Int)],TyVar Nat 1 -> Bool -> Either Int (TyVar Nat 1))
```


Monomorphising the State Type
-----------------------------

In a CoCo signature, the state type is monomorphic, but it can be nice to treat it as polymorphic
for two reasons:

1. Needing to change the types inside the signature because the type *of the signature* changed is a
   pain.
2. It helps avoid repetition.

Here are a couple of function types that may appear in a signature:

```
MVar Concurrency Int ->        Concurrency Int
MVar Concurrency Int -> Int -> Concurrency ()
```

If the state type is `MVar Concurrency Int`, then (1) is saying that if we change it to `MVar
Concurrency Bool` we now need to change those two types above, and (2) is saying that we're
needlessly repeating the `Int`.  It would be much nicer to have these types in the signature:

```
MVar Concurrency A ->      Concurrency A
MVar Concurrency A -> A -> Concurrency ()
```

Now that we have implemented type unification, we can do this!  For a function type in the
signature:

1. Try to unify every argument, *excluding naked type variables*, against the state type.
2. Check that the environments are compatible.
3. Apply the combined environment to the function type.

This effect of this is to monomorphise polymorphic uses of the state type.  This is good because the
state type often determines other argument types, and once we know the concrete types of function
arguments we can infer what hole types we need.  If functions have totally polymorphic types, hole
inference doesn't work so well.

> -- | Monomorphise polymorphic uses of the state type in a function type.
> monomorphise :: Typeable s
>   => Proxy s -- ^ The state type.
>   -> TypeRep -- ^ The function type.
>   -> TypeRep
> monomorphise s ty0 = fromMaybe ty0 $ do
>   let stateTy = typeRep s
>   argTys <- funArgTys ty0
>   env    <- unifyAccum False (maybe (Just []) Just) (repeat stateTy) argTys
>   pure (applyBindings env ty0)

Now we see the purpose of the boolean argument to `unify'`.  If we have the type `A -> MVar
Concurrency A -> Concurrency ()`, we don't want to unify `MVar Concurrency Int` with `A`, we want to
skip that over!  More generally, we want to avoid unifying a fully-polymorphic type with our state
type but, as all our type variables have kind `*`, just preventing the top-level unification
suffices.

Oh, we'll also need this helper function to get all the argument types of a function:

> -- | Get all of a function's argument types.  Returns @Nothing@ if not a function type.
> funArgTys :: TypeRep -> Maybe [TypeRep]
> funArgTys ty = case splitTyConApp ty of
>     (con, [argTy, resultTy]) | con == funTyCon -> Just $
>       argTy : fromMaybe [] (funArgTys resultTy)
>     _ -> Nothing
>   where
>     funTyCon = typeRepTyCon (typeRep (Proxy :: Proxy (() -> ())))

And we're done!

```
λ> let s = Proxy :: Proxy (Either Int Bool)
λ> let f = typeOf (undefined :: A -> Either A B -> B)
λ> monomorphise s f
Int -> Either Int Bool -> Bool
```
