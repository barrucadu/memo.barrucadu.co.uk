---
title: Representation & Evaluation of Typed Expressions
tags: programming, research
project: coco
date: 2017-03-23
audience: Haskell programmers.
epistemic_status: I wrote this memo to work out how to implement CoCo.  So this all works and is, mostly, still implemented like this.
---

Or, "I tried really hard to use the [bound][] library but just couldn't get that square peg in this
round hole."

[bound]: https://hackage.haskell.org/package/bound

This is a simplified version of a problem I've been having in [CoCo][]. The current handling of
variables in CoCo is very poor, the programmer has to specify exactly which variables may be
introduced, binds and lets cause shadowing, and no care is taken to avoid generating alpha
equivalent terms.

Here are two representative problems:

1. If you have the variable `x`, and no others, a term like this will not be generated:
   `f >>= \x1 -> g x1 x`

2. If you have the variables `x` and `y` of the same type, these equivalent terms will be generated:
   `f x` and `f y`

[CoCo]: https://github.com/barrucadu/coco

Let's get started...

> {-# LANGUAGE KindSignatures #-}
> {-# LANGUAGE ScopedTypeVariables #-}
>
> import Data.Dynamic (Dynamic, dynApply, dynTypeRep)
> import Data.Function (on)
> import Data.List (groupBy, nub, sortOn)
> import Data.Maybe (mapMaybe, maybeToList)
> import Data.Ord (Down(..))
> import Data.Proxy (Proxy(..))
> import Data.Typeable (Typeable, TypeRep, funResultTy, splitTyConApp, typeOf, typeRep)
> import Data.Void (Void, absurd)
> import GHC.Exts (Any)
> import Unsafe.Coerce (unsafeCoerce)


Mark 1: A Simple Typed Expression Type
--------------------------------------

Our expressions are representations of Haskell code, which makes this a bit unlike most toy
expression evaluators you see in tutorials. We want everything to be very typed, and not expose the
constructors of the expression data type, using smart constructors to ensure that only well-typed
expressions can be created.

It's this typing that makes it really difficult to use the [bound][] library here, as bound doesn't
play so nicely with typed variables. You can infer types for variables later, but I don't really
want to implement that.

> -- | A type for expressions. This would not be exported by actual library code, to prevent the user
> -- from mucking around with the types.
> data Exp1
>   = Lit1 String Dynamic
>   -- ^ Literal values are just dynamically-wrapped Haskell values.
>   | Hole1 TypeRep
>   -- ^ "Holes" are free variables, identified by their position in the tree.
>   | Named1 TypeRep String
>   -- ^ Variables which are bound by a provided environment. More on this later.
>   | Bound1 TypeRep Int
>   -- ^ Variables which are bound by a let, with de Bruijn indices. All variables bound to the same
>   -- let must have the correct type.
>   | Let1 TypeRep Exp1 Exp1
>   -- ^ The binder is assumed to be of the correct type for all the variables bound to it.
>   | Ap1 TypeRep Exp1 Exp1
>   -- ^ The parameter is assumed to be of the correct type for the function.
>
> instance Show Exp1 where
>   show (Lit1 s _) = s
>   show (Hole1 ty) = "(_ :: " ++ show ty ++ ")"
>   show (Named1 ty s) = "(" ++ s ++ " :: " ++ show ty ++ ")"
>   show (Bound1 ty i) = "(" ++ show i ++ " :: " ++ show ty ++ ")"
>   show (Let1 _ b e) = "let <" ++ show b ++ "> in <" ++ show e ++ ">"
>   show (Ap1  _ f e) = "(" ++ show f ++ ") (" ++ show e ++ ")"
>
> -- | Get the type of an expression.
> typeOf1 :: Exp1 -> TypeRep
> typeOf1 (Lit1 _ dyn)  = dynTypeRep dyn
> typeOf1 (Hole1  ty)   = ty
> typeOf1 (Named1 ty _) = ty
> typeOf1 (Bound1 ty _) = ty
> typeOf1 (Let1 ty _ _) = ty
> typeOf1 (Ap1  ty _ _) = ty
>
> -- | Get all the holes in an expression, identified by position.
> holes1 :: Exp1 -> [(Int, TypeRep)]
> holes1 = fst . go 0 where
>   go i (Hole1 ty) = ([(i, ty)], i + 1)
>   go i (Let1 _ b e) =
>     let (bhs, i')  = go i  b
>         (ehs, i'') = go i' e
>     in (bhs ++ ehs, i'')
>   go i (Ap1 _ f e) =
>     let (fhs, i')  = go i  f
>         (ehs, i'') = go i' e
>     in (fhs ++ ehs, i'')
>   go i _ = ([], i)
>
> -- | Get all the named variables in an expression.
> names1 :: Exp1 -> [(String, TypeRep)]
> names1 = nub . go where
>   go (Named1 ty s) = [(s, ty)]
>   go (Let1 _ b e) = go b ++ go e
>   go (Ap1 _ f e) = go f ++ go e
>   go _ = []

**Smart constructors**: we only want to be able to produce type-correct expressions, for two
reasons: the evaluator in [CoCo][] is more complex and does a lot of unsafe coercion, and being able
to just call `error` when the types don't work out is nicer than needing to actually handle it; and
it makes it easier to generate terms programmatically, as you simply try all possibilities and keep
the ones which succeed.

> -- | Construct a literal value.
> lit1 :: String -> Dynamic -> Exp1
> lit1 = Lit1
>
> -- | Construct a typed hole.
> hole1 :: TypeRep -> Exp1
> hole1 = Hole1
>
> -- | Perform a function application, if type-correct.
> ap1 :: Exp1 -> Exp1 -> Maybe Exp1
> ap1 f e = (\ty -> Ap1 ty f e) <$> typeOf1 f `funResultTy` typeOf1 e
>
> -- | Bind a collection of holes, if type-correct.
> --
> -- The binding is applied "atomically", in that you don't need to worry about holes disappearing and
> -- so changing their position-indices while this operation happens; however the position of unbound
> -- holes may be altered in the result of this function.
> let1 :: [Int] -> Exp1 -> Exp1 -> Maybe Exp1
> let1 is b e0 = Let1 (typeOf1 e0) b . fst <$> go 0 0 e0 where
>   go n i (Hole1 ty)
>     | i `elem` is = if typeOf1 b == ty then Just (Bound1 ty n, i + 1) else Nothing
>     | otherwise   = Just (Hole1 ty, i + 1)
>   go n i (Let1 ty b e) = do
>     (b', i')  <- go n     i  b
>     (e', i'') <- go (n+1) i' e
>     Just (Let1 ty b' e', i'')
>   go n i (Ap1 ty f e) = do
>     (f', i')  <- go n i  f
>     (e', i'') <- go n i' e
>     Just (Ap1 ty f' e', i'')
>   go _ i e = Just (e, i)
>
> -- | Give names to holes, if type-correct.
> --
> -- This has the same indexing behaviour as 'let1'.
> name1 :: [(Int, String)] -> Exp1 -> Maybe Exp1
> name1 is e0 = (\(e,_,_) -> e) <$> go [] 0 e0 where
>   go env i n@(Named1 ty s) = case lookup s env of
>     -- if a name gets re-used it had better be at the same type!
>     Just sty
>       | ty == sty -> Just (n, env, i)
>       | otherwise -> Nothing
>     Nothing -> Just (n, env, i)
>   go env i (Hole1 ty) = case lookup i is of
>     Just s -> case lookup s env of
>       Just sty
>         | ty == sty -> Just (Named1 ty s, env, i + 1)
>         | otherwise -> Nothing
>       Nothing -> Just (Named1 ty s, (s,ty):env, i + 1)
>     Nothing -> Just (Hole1 ty, env, i + 1)
>   go env i (Let1 ty b e) = do
>     (b', env',  i')  <- go env  i  b
>     (e', env'', i'') <- go env' i' e
>     Just (Let1 ty b' e', env'', i'')
>   go env i (Ap1 ty f e) = do
>     (f', env',  i')  <- go env  i  f
>     (e', env'', i'') <- go env' i' e
>     Just (Ap1 ty f' e', env'', i'')
>   go env i e = Just (e, env, i)

**Evaluation**: now we have everything in place to evaluate expressions with no unbound
holes. Everything is type-correct-by-construction, so if there are no holes (and the global
environment has everything we need) we can get out a value.

> -- | Evaluate an expression if it has no holes.
> eval1 :: [(String, Dynamic)] -> Exp1 -> Maybe Dynamic
> eval1 globals = go [] where
>   -- the local environment is a list of values, with each new scope prepending a value; this means
>   -- that the de Bruijn indices correspond with list indices
>   go locals (Let1 _ b e) = (\dyn -> go (dyn:locals) e) =<< go locals b
>   go locals (Bound1 _ n) = Just (locals !! n)
>   -- named variables come from the global environment
>   go _ (Named1 ty s) = case lookup s globals of
>     Just dyn | dynTypeRep dyn == ty -> Just dyn
>     _ -> Nothing
>   -- the other operations don't care about either environment
>   go locals (Ap1 _ f e) = do
>     dynf <- go locals f
>     dyne <- go locals e
>     dynf `dynApply` dyne
>   go _ (Lit1 _ dyn) = Just dyn
>   go _ (Hole1 _)  = Nothing

**Removing Holes**: we still have one more problem, it would be nice for holes to be given names
automatically, and not just individual holes, but groups of holes too.

For example, if we have an expression like so:

```
f (_ :: Int) (_ :: Bool) (_ :: Bool) (_ :: Int)
```

It would be nice to be able to generate these expressions automatically:

```
f (w :: Int) (x :: Bool) (y :: Bool) (z :: Int)
f (w :: Int) (x :: Bool) (y :: Bool) (w :: Int)
f (w :: Int) (x :: Bool) (x :: Bool) (z :: Int)
f (w :: Int) (x :: Bool) (x :: Bool) (w :: Int)
```

It would be particularly nice if they were generated in a list in that order, from most free to most
constrained.

> -- | From an expression that may have holes, generate a list of expressions with named variables
> -- substituted instead, ordered from most free (one hole per variable) to most constrained (multiple
> -- holes per variable).
> --
> -- This takes a function to assign a letter to each type, subsequent variables of the same type have
> -- digits appended.
> terms1 :: (TypeRep -> Char) -> Exp1 -> [Exp1]
> terms1 nf = sortOn (Down . length . names1) . go where
>   go e0 = case hs e0 of
>     [] -> [e0]
>     (chosen:_) -> concatMap go
>       [ e | ps <- partitions chosen
>           , let (((_,tyc):_):_) = ps
>           , let vname i = if i == 0 then [nf tyc] else nf tyc : show i
>           , let naming = concat $ zipWith (\i vs -> [(v, vname i) | (v,_) <- vs]) [0..] ps
>           , e <- maybeToList (name1 naming e0)
>       ]
>
>   -- holes grouped by type
>   hs = groupBy ((==) `on` snd) . sortOn snd . holes1
>
>   -- all partitions of a list
>   partitions (x:xs) =
>     [[x]:p | p <- partitions xs] ++
>     [(x:ys):yss | (ys:yss) <- partitions xs]
>   partitions [] = [[]]

Here's an example from ghci:

```
λ> let intHole  = hole1 $ T.typeOf (5::Int)
λ> let boolHole = hole1 $ T.typeOf True
λ> let ibf      = lit1 "f" (D.toDyn ((\_ _ _ a -> a) :: Int -> Bool -> Bool -> Int -> Int))
λ> let ibfExp   = fromJust $ do { x <- ibf `ap1` intHole; y <- x `ap1` boolHole; z <- y `ap1` boolHole; z `ap1` intHole }
λ> mapM_ print $ terms1 (head.show) ibfExp
((((f) ((I :: Int))) ((B :: Bool))) ((B1 :: Bool))) ((I1 :: Int))
((((f) ((I :: Int))) ((B :: Bool))) ((B1 :: Bool))) ((I :: Int))
((((f) ((I :: Int))) ((B :: Bool))) ((B :: Bool))) ((I1 :: Int))
((((f) ((I :: Int))) ((B :: Bool))) ((B :: Bool))) ((I :: Int))
```

Pretty sweet!


Mark 2: More Type Safety
------------------------

What we have now is pretty good, but it leaves a little to be desired: it would be nice to be able
to statically forbid passing expressions with holes to `eval`. As always in Haskell, the solution
is to add another type parameter.

> data Exp2 h
>   = Lit2 String Dynamic
>   | Var2 TypeRep (Var2 h)
>   -- ^ One constructor for holes, named, and bound variables.
>   | Let2 TypeRep (Exp2 h) (Exp2 h)
>   | Ap2  TypeRep (Exp2 h) (Exp2 h)
>
> instance Show (Exp2 h) where
>   show (Lit2 s _) = s
>   show (Var2 ty v) = "(" ++ show v ++ " :: " ++ show ty ++ ")"
>   show (Let2 _ b e) = "let <" ++ show b ++ "> in <" ++ show e ++ ">"
>   show (Ap2 _ f e)  = "(" ++ show f ++ ") (" ++ show e ++ ")"
>
> data Var2 h
>   = Hole2 h
>   -- ^ Holes get a typed tag.
>   | Named2 String
>   -- ^ Environment variables.
>   | Bound2 Int
>   -- ^ Let-bound variables.
>
> instance Show (Var2 h) where
>   show (Hole2  _) = "_"
>   show (Named2 s) = s
>   show (Bound2 i) = show i

**Schemas and Terms**: what does this hole tag buy us? Well, actually, it lets us very simply forbid
the presence of holes! Constructing an `h` value is required to construct a hole, so if we set it to
`Void`, then no holes can be made at all! If the tag is some inhabited type, then an expression may
contain holes (but may not).

Let's introduce two type synonyms to talk about these:

> -- | A schema is an expression which may contain holes. A single schema may correspond to many
> -- terms.
> type Schema2 = Exp2 ()
>
> -- | A term is an expression with no holes. Many terms may correspond to a single schema.
> type Term2 = Exp2 Void
>
> -- | Convert a Schema into a Term if there are no holes.
> toTerm2 :: Schema2 -> Maybe Term2
> toTerm2 (Lit2 s dyn) = Just (Lit2 s dyn)
> toTerm2 (Var2 ty v) = case v of
>   Hole2  _ -> Nothing
>   Named2 s -> Just (Var2 ty (Named2 s))
>   Bound2 i -> Just (Var2 ty (Bound2 i))
> toTerm2 (Let2 ty b e) = Let2 ty <$> toTerm2 b <*> toTerm2 e
> toTerm2 (Ap2  ty f e) = Ap2  ty <$> toTerm2 f <*> toTerm2 e

**Evaluation & Hole Removal**: now we can evaluate _terms_ after removing holes from
_schemas_. Statically-checked guarantees that we're dealing with all of our holes properly, nice!

> -- | Evaluate a term
> eval2 :: [(String, Dynamic)] -> Term2 -> Maybe Dynamic
> eval2 globals = go [] where
>   go locals (Let2 _ b e) = (\dyn -> go (dyn:locals) e) =<< go locals b
>   go locals v@(Var2 _ _) = env locals v
>   go locals (Ap2 _ f e) = do
>     dynf <- go locals f
>     dyne <- go locals e
>     dynf `dynApply` dyne
>   go _ (Lit2 _ dyn) = Just dyn
>
>   env locals (Var2 _ (Bound2 n))
>     | length locals > n = Just (locals !! n)
>     | otherwise = Nothing
>   env _ (Var2 ty (Named2 s)) = case lookup s globals of
>     Just dyn | dynTypeRep dyn == ty -> Just dyn
>     _ -> Nothing
>   env _ (Var2 _ (Hole2 v)) = absurd v -- this is actually unreachable now
>
> -- | From a schema that may have holes, generate a list of terms with named variables
> -- substituted instead.
> terms2 :: (TypeRep -> Char) -> Schema2 -> [Term2]
> terms2 nf = mapMaybe toTerm2 . sortOn (Down . length . names2) . go where
>   go e0 = case hs e0 of
>     [] -> [e0]
>     (chosen:_) -> concatMap go
>       [ e | ps <- partitions chosen
>           , let (((_,tyc):_):_) = ps
>           , let vname i = if i == 0 then [nf tyc] else nf tyc : show i
>           , let naming = concat $ zipWith (\i vs -> [(v, vname i) | (v,_) <- vs]) [0..] ps
>           , e <- maybeToList (name2 naming e0)
>       ]
>
>   -- holes grouped by type
>   hs = groupBy ((==) `on` snd) . sortOn snd . holes2
>
>   -- all partitions of a list
>   partitions (x:xs) =
>     [[x]:p | p <- partitions xs] ++
>     [(x:ys):yss | (ys:yss) <- partitions xs]
>   partitions [] = [[]]

The rest of the code hasn't changed much, but is included for completeness:

> -- | Get the type of an expression.
> typeOf2 :: Exp2 h -> TypeRep
> typeOf2 (Lit2 _ dyn)  = dynTypeRep dyn
> typeOf2 (Var2 ty _)   = ty
> typeOf2 (Let2 ty _ _) = ty
> typeOf2 (Ap2  ty _ _) = ty
>
> -- | Get all the holes in an expression, identified by position.
> holes2 :: Schema2 -> [(Int, TypeRep)]
> holes2 = fst . go 0 where
>   go i (Var2 ty (Hole2 _)) = ([(i, ty)], i + 1) -- tag is ignored
>   go i (Let2 _ b e) =
>     let (bhs, i')  = go i  b
>         (ehs, i'') = go i' e
>     in (bhs ++ ehs, i'')
>   go i (Ap2 _ f e) =
>     let (fhs, i')  = go i  f
>         (ehs, i'') = go i' e
>     in (fhs ++ ehs, i'')
>   go i _ = ([], i)
>
> -- | Get all the named variables in an expression.
> names2 :: Exp2 h -> [(String, TypeRep)]
> names2 = nub . go where
>   go (Var2 ty (Named2 s)) = [(s, ty)]
>   go (Let2 _ b e) = go b ++ go e
>   go (Ap2 _ f e) = go f ++ go e
>   go _ = []
>
> -- | Construct a literal value.
> lit2 :: String -> Dynamic -> Exp2 h
> lit2 = Lit2
>
> -- | Construct a typed hole.
> hole2 :: TypeRep -> Schema2
> hole2 ty = Var2 ty (Hole2 ()) -- holes get tagged with unit
>
> -- | Perform a function application, if type-correct.
> ap2 :: Exp2 h -> Exp2 h -> Maybe (Exp2 h)
> ap2 f e = (\ty -> Ap2 ty f e) <$> typeOf2 f `funResultTy` typeOf2 e
>
> -- | Bind a collection of holes, if type-correct.
> let2 :: [Int] -> Schema2 -> Schema2 -> Maybe Schema2
> let2 is b e0 = Let2 (typeOf2 e0) b . fst <$> go 0 0 e0 where
>   go n i (Var2 ty (Hole2 h))
>     | i `elem` is = if typeOf2 b == ty then Just (Var2 ty (Bound2 n), i + 1) else Nothing -- tag is ignored
>     | otherwise   = Just (Var2 ty (Hole2 h), i + 1) -- tag is preserved
>   go n i (Let2 ty b e) = do
>     (b', i')  <- go n     i  b
>     (e', i'') <- go (n+1) i' e
>     Just (Let2 ty b' e', i'')
>   go n i (Ap2 ty f e) = do
>     (f', i')  <- go n i  f
>     (e', i'') <- go n i' e
>     Just (Ap2 ty f' e', i'')
>   go _ i e = Just (e, i)
>
> -- | Give names to holes, if type-correct.
> name2 :: [(Int, String)] -> Schema2 -> Maybe Schema2
> name2 is e0 = (\(e,_,_) -> e) <$> go [] 0 e0 where
>   go env i n@(Var2 ty (Named2 s)) = case lookup s env of
>     Just sty
>       | ty == sty -> Just (n, env, i)
>       | otherwise -> Nothing
>     Nothing -> Just (n, env, i)
>   go env i (Var2 ty (Hole2 h)) = case lookup i is of
>     Just s -> case lookup s env of
>       Just sty
>         | ty == sty -> Just (Var2 ty (Named2 s), env, i + 1) -- tag is ignored
>         | otherwise -> Nothing
>       Nothing -> Just (Var2 ty (Named2 s), (s,ty):env, i + 1) -- tag is ignored
>     Nothing -> Just (Var2 ty (Hole2 h), env, i + 1) -- tag is preserved
>   go env i (Let2 ty b e) = do
>     (b', env',  i')  <- go env  i  b
>     (e', env'', i'') <- go env' i' e
>     Just (Let2 ty b' e', env'', i'')
>   go env i (Ap2 ty f e) = do
>     (f', env',  i')  <- go env  i  f
>     (e', env'', i'') <- go env' i' e
>     Just (Ap2 ty f' e', env'', i'')
>   go env i e = Just (e, env, i)


Aside: The Implementation of Data.Dynamic
-----------------------------------------

In the Mark 3 evaluator, we're going to need a function of type `Monad m => m Dynamic -> Dynamic`,
which "pushes" the `m` inside the `Dynamic`, and of type `Monad m => Dynamic -> Maybe (m Dynamic)`.
Unfortunately, Data.Dynamic doesn't provide a way to do this, for good reason: it's impossible in
general! There's no way to know what the type of the dynamic value inside the monad is, so there's
no way to do this safely.

Fortunately, implementing a Data.Dynamic-lite is pretty simple.

> -- | A dynamic value is a pair of its type and 'Any'. Any is a magical type which is guaranteed to
> -- | work with 'unsafeCoerce'.
> data BDynamic = BDynamic { bdynTypeRep :: TypeRep, bdynAny :: Any }
>
> instance Show BDynamic where
>   show = show . bdynTypeRep

(`BDynamic` for "barrucadu's dynamic")

We need to be able to construct and deconstruct dynamic values, these operations do use
`unsafeCoerce`, but are safe:

> -- | Convert an arbitrary value into a dynamic one.
> toBDynamic :: Typeable a => a -> BDynamic
> toBDynamic a = BDynamic (typeOf a) (unsafeCoerce a)
>
> -- | Convert a dynamic value into an ordinary value, if the types match.
> fromBDynamic :: Typeable a => BDynamic -> Maybe a
> fromBDynamic (BDynamic ty v) = case unsafeCoerce v of
>   -- this is a bit mind-bending, but the 'typeOf r' here is the type of the 'a', as 'unsafeCoerce
>   -- v :: a' (regardless of whether it actually is an 'a' value or not). The same result could be
>   -- achieved using ScopedTypeVariables and 'typeRep'.
>   r | ty == typeOf r -> Just r
>     | otherwise      -> Nothing

The final operation needed for the Marks 1 and 2 implementation is function application:

> -- | Dynamically-typed function application.
> bdynApply :: BDynamic -> BDynamic -> Maybe BDynamic
> bdynApply (BDynamic ty1 f) (BDynamic ty2 x) = case funResultTy ty1 ty2 of
>   Just ty3 -> Just (BDynamic ty3 ((unsafeCoerce f) x))
>   Nothing  -> Nothing

Now we can construct our strange monad-shuffling operations:

> -- | "Push" a functor inside a dynamic value, given the type of the resultant value.
> --
> -- This is unsafe because if the type is incorrect and the value is later used as that type, good
> -- luck.
> unsafeWrapFunctor :: Functor f => TypeRep -> f BDynamic -> BDynamic
> unsafeWrapFunctor ty fdyn = BDynamic ty (unsafeCoerce $ fmap bdynAny fdyn)
>
> -- | "Extract" a functor from a dynamic value.
> unwrapFunctor :: forall f. (Functor f, Typeable f) => BDynamic -> Maybe (f BDynamic)
> unwrapFunctor (BDynamic ty v) = case splitTyConApp ty of
>     (tyCon, tyArgs)
>       | tyCon == ftyCon && not (null tyArgs) && init tyArgs == ftyArgs
>         -> Just $ BDynamic (last tyArgs) <$> unsafeCoerce v
>     _ -> Nothing
>   where
>     (ftyCon, ftyArgs) = splitTyConApp (typeRep (Proxy :: Proxy f))

It's almost a shame that Data.Dynamic doesn't expose enough to implement this. It has gone for a
safe but limited API. A common Haskell "design" pattern is to have safe public APIs and unsafe but
publically-exposed "internal" APIs, but base doesn't seem to follow that.


Mark 3: Monadic Expressions
---------------------------

This expression representation is pretty nice, but it's rather cumbersome to express monadic
operations for a couple of reasons:

1. Everything is monomorphic, so there would need to be a separate `lit` for `>>=` at every desired
   type.

2. Due to function application having a `Maybe` result, even at a single type writing
   `ap2 (lit2 ((>>=) :: Type)) e1 >>= \f -> ap2 f e2` is not nice.

3. The original need for this expression representation was for generating Haskell terms, and
   generating lambda terms is tricky; it would be nice to be able to bind holes directly.

This calls for a third representation of expressions. For reasons that will become apparent when
looking at the evaluator, we'll specalise this to only working in one monad, and track the monad
type as another parameter of `Exp`:

> data Exp3 (m :: * -> *) (h :: *)
>   = Lit3 String BDynamic
>   | Var3 TypeRep (Var3 h)
>   | Bind3 TypeRep (Exp3 m h) (Exp3 m h)
>   | Let3  TypeRep (Exp3 m h) (Exp3 m h)
>   | Ap3   TypeRep (Exp3 m h) (Exp3 m h)
>
> instance Show (Exp3 m h) where
>   show (Lit3 s _) = s
>   show (Var3 ty v) = "(" ++ show v ++ " :: " ++ show ty ++ ")"
>   show (Bind3 _ b e) = "bind <" ++ show b ++ "> in <" ++ show e ++ ">"
>   show (Let3  _ b e) = "let <" ++ show b ++ "> in <" ++ show e ++ ">"
>   show (Ap3   _ f e) = "(" ++ show f ++ ") (" ++ show e ++ ")"

**Construction**: bind is going to be treated just as a let with special evaluation rules. This
means that de Bruijn indices will be able to refer to a bind or a let. Rather than have two separate
counters for those, we'll just put everything in the same namespace (index-space?).

> -- | Bind a collection of holes, if type-correct.
> let3 :: [Int] -> Schema3 m -> Schema3 m -> Maybe (Schema3 m)
> let3 is b e0 = Let3 (typeOf3 e0) b <$> letOrBind3 is (typeOf3 b) e0
>
> -- | Monadically bind a collection of holes, if type-correct.
> --
> -- This has the same indexing behaviour as 'let3'.
> bind3 :: forall m. Typeable m => [Int] -> Schema3 m -> Schema3 m -> Maybe (Schema3 m)
> bind3 is b e0 = case (splitTyConApp (typeOf3 b), splitTyConApp (typeOf3 e0)) of
>     ((btyCon, btyArgs), (etyCon, etyArgs))
>       | btyCon == mtyCon && btyCon == etyCon && not (null btyArgs) && not (null etyArgs) && mtyArgs == init btyArgs && init btyArgs == init etyArgs
>         -> Bind3 (typeOf3 e0) b <$> letOrBind3 is (last btyArgs) e0
>     _ -> Nothing
>   where
>     (mtyCon, mtyArgs) = splitTyConApp (typeRep (Proxy :: Proxy m))
>
> -- | A helper for 'bind3' and 'let3': bind holes to the top of the expression.
> letOrBind3 :: [Int] -> TypeRep -> Exp3 m h -> Maybe (Exp3 m h)
> letOrBind3 is boundTy e0 = fst <$> go 0 0 e0 where
>   go n i (Var3 ty (Hole3 h))
>     | i `elem` is = if boundTy == ty then Just (Var3 ty (Bound3 n), i + 1) else Nothing
>     | otherwise   = Just (Var3 ty (Hole3 h), i + 1)
>   go n i (Bind3 ty b e) = do -- a new case for Bind3, the same as the case for Let3
>     (b', i')  <- go n     i  b
>     (e', i'') <- go (n+1) i' e
>     Just (Bind3 ty b' e', i'')
>   go n i (Let3 ty b e) = do
>     (b', i')  <- go n     i  b
>     (e', i'') <- go (n+1) i' e
>     Just (Let3 ty b' e', i'')
>   go n i (Ap3 ty f e) = do
>     (f', i')  <- go n i  f
>     (e', i'') <- go n i' e
>     Just (Ap3 ty f' e', i'')
>   go _ i e = Just (e, i)

We could make `letOrBind3` also work for `name3` by carrying around a third state token and letting
the `Var3` case apply an arbitrary function.

**Evaluation**: the new bind case, unfortunately, complicates things somewhat here. It's *much* more
awkward to deal with errors during evaluation, but fortunately the only errors that can actually
arise are unbound named variables: the smart constructors ensure expressions are well-typed and have
valid de Bruijn indices. This means we can just check the named variables for validity up front and
then use `error` once we're sure there actually are no errors.

> -- | Evaluate a term
> eval3 :: forall m. (Monad m, Typeable m) => [(String, BDynamic)] -> Term3 m -> Maybe BDynamic
> eval3 globals e0
>     | all check (names3 e0) = Just (go [] e0)
>     | otherwise = Nothing
>   where
>     go locals (Bind3 ty b e) = case (unwrapFunctor :: BDynamic -> Maybe (m BDynamic)) (go locals b) of
>       Just mdyn -> unsafeWrapFunctor ty $ mdyn >>= \dyn -> case unwrapFunctor (go (dyn:locals) e) of
>         Just dyn -> dyn
>         Nothing -> error "type error I can't deal with here!" -- this is unreachable
>       Nothing -> error "type error I can't deal with here!" -- this is unreachable
>     go locals (Let3 _ b e) = go (go locals b : locals) e
>     go locals v@(Var3 _ _) = case env locals v of
>       Just dyn -> dyn
>       Nothing -> error "environment error I can't deal with here!" -- this is unreachable
>     go locals (Ap3 _ f e) = case go locals f `bdynApply` go locals e of
>       Just dyn -> dyn
>       Nothing -> error "type error I can't deal with here!" -- this is unreachable
>     go _ (Lit3 _ dyn) = dyn
>
>     env locals (Var3 _ (Bound3 n))
>       | length locals > n = Just (locals !! n)
>       | otherwise = Nothing
>     env _ (Var3 ty (Named3 s)) = case lookup s globals of
>       Just dyn | bdynTypeRep dyn == ty -> Just dyn
>       _ -> Nothing
>     env _ (Var3 _ (Hole3 v)) = absurd v
>
>     check (s, ty) = case lookup s globals of
>       Just dyn -> bdynTypeRep dyn == ty
>       Nothing  -> False

Now it becomes apparent why the monad type parameter is needed in the expression type, the evaluator
uses `>>=`, and so it needs to know which monad to bind it as. An alternative would be to use a type
like this, but this still restricts you to using a single monad and so doesn't gain anything:

```
eval3alt :: (Monad m, Typeable m) => proxy m -> [(String, BDynamic)] -> Term3 -> Maybe BDynamic
```

Here's a little example showing that side-effects do work (when I first did this, they didn't, so
it's not quite trivial to get right):

```
λ> r <- newIORef (5::Int)
λ> let intHole = hole3 $ T.typeOf (5::Int)
λ> let plusLit = lit3 "+" . toBDynamic $ ((+) :: Int -> Int -> Int)
λ> let plusTwo = fromJust $ (fromJust $ plusLit `ap3` intHole) `ap3` intHole
λ> let pureInt = lit3 "pure" . toBDynamic $ (pure :: Int -> IO Int)
λ> let plusTwoIO = fromJust $ pureInt `ap3` plusTwo
λ> let intAndTimes = (lit3 "*2" . toBDynamic $ (modifyIORef r (*7) >> pure (7::Int))) :: Exp3 IO h
λ> let eval = fromJust $ (fromBDynamic :: BDynamic -> Maybe (IO Int)) =<< eval3 [] =<< toTerm3 =<< bind3 [0,1] intAndTimes plusTwoIO
λ> eval
14
λ> readIORef r
7
λ> eval
14
λ> readIORef r
49
```

Again, the rest of the code hasn't changed much, but is included for
completeness.

> data Var3 h
>   = Hole3  h
>   | Named3 String
>   | Bound3 Int
>
> instance Show (Var3 h) where
>   show (Hole3  _) = "_"
>   show (Named3 s) = s
>   show (Bound3 i) = show i
>
> -- | A schema is an expression which may contain holes.
> type Schema3 m = Exp3 m ()
>
> -- | A term is an expression with no holes.
> type Term3 m = Exp3 m Void
>
> -- | Convert a Schema into a Term if there are no holes.
> toTerm3 :: Schema3 m -> Maybe (Term3 m)
> toTerm3 (Lit3 s dyn) = Just (Lit3 s dyn)
> toTerm3 (Var3 ty v) = case v of
>   Hole3  _ -> Nothing
>   Named3 s -> Just (Var3 ty (Named3 s))
>   Bound3 i -> Just (Var3 ty (Bound3 i))
> toTerm3 (Bind3 ty b e) = Bind3 ty <$> toTerm3 b <*> toTerm3 e
> toTerm3 (Let3  ty b e) = Let3  ty <$> toTerm3 b <*> toTerm3 e
> toTerm3 (Ap3   ty f e) = Ap3   ty <$> toTerm3 f <*> toTerm3 e
>
> -- | Get the type of an expression.
> typeOf3 :: Exp3 m h -> TypeRep
> typeOf3 (Lit3  _ dyn)  = bdynTypeRep dyn
> typeOf3 (Var3  ty _)   = ty
> typeOf3 (Bind3 ty _ _) = ty
> typeOf3 (Let3  ty _ _) = ty
> typeOf3 (Ap3   ty _ _) = ty
>
> -- | Get all the holes in an expression, identified by position.
> holes3 :: Schema3 m -> [(Int, TypeRep)]
> holes3 = fst . go 0 where
>   go i (Var3 ty (Hole3 _)) = ([(i, ty)], i + 1) -- tag is ignored
>   go i (Let3 _ b e) =
>     let (bhs, i')  = go i  b
>         (ehs, i'') = go i' e
>     in (bhs ++ ehs, i'')
>   go i (Ap3 _ f e) =
>     let (fhs, i')  = go i  f
>         (ehs, i'') = go i' e
>     in (fhs ++ ehs, i'')
>   go i _ = ([], i)
>
> -- | Get all the named variables in an expression.
> names3 :: Exp3 m h -> [(String, TypeRep)]
> names3 = nub . go where
>   go (Var3 ty (Named3 s)) = [(s, ty)]
>   go (Let3 _ b e) = go b ++ go e
>   go (Ap3 _ f e) = go f ++ go e
>   go _ = []
>
> -- | Construct a literal value.
> lit3 :: String -> BDynamic -> Exp3 m h
> lit3 = Lit3
>
> -- | Construct a typed hole.
> hole3 :: TypeRep -> Schema3 m
> hole3 ty = Var3 ty (Hole3 ())
>
> -- | Perform a function application, if type-correct.
> ap3 :: Exp3 m h -> Exp3 m h -> Maybe (Exp3 m h)
> ap3 f e = (\ty -> Ap3 ty f e) <$> typeOf3 f `funResultTy` typeOf3 e
>
> -- | Give names to holes, if type-correct.
> name3 :: [(Int, String)] -> Schema3 m -> Maybe (Schema3 m)
> name3 is e0 = (\(e,_,_) -> e) <$> go [] 0 e0 where
>   go env i n@(Var3 ty (Named3 s)) = case lookup s env of
>     Just sty
>       | ty == sty -> Just (n, env, i)
>       | otherwise -> Nothing
>     Nothing -> Just (n, env, i)
>   go env i (Var3 ty (Hole3 h)) = case lookup i is of
>     Just s -> case lookup s env of
>       Just sty
>         | ty == sty -> Just (Var3 ty (Named3 s), env, i + 1)
>         | otherwise -> Nothing
>       Nothing -> Just (Var3 ty (Named3 s), (s,ty):env, i + 1)
>     Nothing -> Just (Var3 ty (Hole3 h), env, i + 1)
>   go env i (Bind3 ty b e) = do -- a new case for Bind3, the same as the case for Let3
>     (b', env',  i')  <- go env  i  b
>     (e', env'', i'') <- go env' i' e
>     Just (Bind3 ty b' e', env'', i'')
>   go env i (Let3 ty b e) = do
>     (b', env',  i')  <- go env  i  b
>     (e', env'', i'') <- go env' i' e
>     Just (Let3 ty b' e', env'', i'')
>   go env i (Ap3 ty f e) = do
>     (f', env',  i')  <- go env  i  f
>     (e', env'', i'') <- go env' i' e
>     Just (Ap3 ty f' e', env'', i'')
>   go env i e = Just (e, env, i)
>
> -- | From a schema that may have holes, generate a list of terms with named variables
> -- substituted instead.
> terms3 :: (TypeRep -> Char) -> Schema3 m -> [Term3 m]
> terms3 nf = mapMaybe toTerm3 . sortOn (Down . length . names3) . go where
>   go e0 = case hs e0 of
>     [] -> [e0]
>     (chosen:_) -> concatMap go
>       [ e | ps <- partitions chosen
>           , let (((_,tyc):_):_) = ps
>           , let vname i = if i == 0 then [nf tyc] else nf tyc : show i
>           , let naming = concat $ zipWith (\i vs -> [(v, vname i) | (v,_) <- vs]) [0..] ps
>           , e <- maybeToList (name3 naming e0)
>       ]
>
>   -- holes grouped by type
>   hs = groupBy ((==) `on` snd) . sortOn snd . holes3
>
>   -- all partitions of a list
>   partitions (x:xs) =
>     [[x]:p | p <- partitions xs] ++
>     [(x:ys):yss | (ys:yss) <- partitions xs]
>   partitions [] = [[]]


Aside: Limited Polymorphism
---------------------------

The representation so far is good, and lets us express everything we want, but it's still not very
friendly to use in one common case: polymorphic monadic functions.

There are many monadic operations of the type `Monad m => m a -> m ()`: the actual type of the first
argument is ignored. At the moment, dealing with such terms requires either specialising that `a` to
each concrete type used, or using something like `void` and specialising *that*.

Implementing full-blown Haskell polymorphism would be a pain, but this is a small and irritating
enough case that it's worth dealing with.

Presenting (trumpets please), the "ignore" type:

> -- | A special type for enabling basic polymorphism.
> --
> -- A function parameter of type @m Ignore@ unifies with values of any type @m a@, where @fmap
> -- (const Ignore)@ is applied to the parameter automatically. This avoids the need to clutter
> -- expressions with calls to 'void', or some other such function.
> data Ignore = Ignore deriving (Bounded, Enum, Eq, Ord, Read, Show)

`Ignore` is going to give us our limited polymorphism, by changing the typing rules for `ap3` and
evaluation rules for `Ap3` slightly.

**Application**: function application is as normal, with the exception that if the formal parameter
has type `m Ignore` and the actual parameter has type `m a`, for any `a`, then the application also
succeeds:

> -- | Perform a function application, if type-correct.
> --
> -- There is a special case, see the comment of the 'Ignore' type.
> ap3ig :: forall m h. (Applicative m, Typeable m) => Exp3 m h -> Exp3 m h -> Maybe (Exp3 m h)
> ap3ig f e = case (splitTyConApp (typeOf3 f), splitTyConApp (typeOf3 e)) of
>     ((_, [fargTy,fresTy]), (etyCon, etyArgs))
>       -- check if the formal parameter is of type @m Ignore@ and the actual parameter is of type @m a@
>       | fargTy == ignoreTy && etyCon == mtyCon && not (null etyArgs) && mtyArgs == init etyArgs -> Just (Ap3 fresTy f e)
>       -- otherwise try normal function application
>       | otherwise -> (\ty -> Ap3 ty f e) <$> typeOf3 f `funResultTy` typeOf3 e
>     _ -> Nothing
>   where
>     ignoreTy = typeOf (pure Ignore :: m Ignore)
>     (mtyCon, mtyArgs) = splitTyConApp (typeRep (Proxy :: Proxy m))

**Evaluation**: evaluation of applications has an analogous case. When applying a function, the type
of the formal parametr is checked and, if it's `m Ignore`, the argument gets `fmap (const Ignore)`
applied:

> -- | Evaluate a term
> eval3ig :: forall m. (Monad m, Typeable m) => [(String, BDynamic)] -> Term3 m -> Maybe BDynamic
> eval3ig globals e0
>     | all check (names3 e0) = Just (go [] e0)
>     | otherwise = Nothing
>   where
>     go locals (Bind3 ty b e) = case (unwrapFunctor :: BDynamic -> Maybe (m BDynamic)) (go locals b) of
>       Just mdyn -> unsafeWrapFunctor ty $ mdyn >>= \dyn -> case unwrapFunctor (go (dyn:locals) e) of
>         Just dyn -> dyn
>         Nothing -> error "type error I can't deal with here!"
>       Nothing -> error "type error I can't deal with here!"
>     go locals (Let3 _ b e) = go (go locals b : locals) e
>     go locals v@(Var3 _ _) = case env locals v of
>       Just dyn -> dyn
>       Nothing -> error "environment error I can't deal with here!"
>     go locals (Ap3 _ f e) =
>       let f' = go locals f
>           e' = go locals e
>       in case f' `bdynApply` (if hasIgnoreArg f' then ignore e' else e') of
>         Just dyn -> dyn
>         Nothing -> error "type error I can't deal with here!"
>     go _ (Lit3 _ dyn) = dyn
>
>     env locals (Var3 _ (Bound3 n))
>       | length locals > n = Just (locals !! n)
>       | otherwise = Nothing
>     env _ (Var3 ty (Named3 s)) = case lookup s globals of
>       Just dyn | bdynTypeRep dyn == ty -> Just dyn
>       _ -> Nothing
>     env _ (Var3 _ (Hole3 v)) = absurd v
>
>     hasIgnoreArg fdyn =
>       let (_, [fargTy,_]) = splitTyConApp (bdynTypeRep fdyn)
>       in fargTy == ignoreTy
>
>     ignore dyn = case (unwrapFunctor :: BDynamic -> Maybe (m BDynamic)) dyn of
>       Just ma -> unsafeToBDynamic ignoreTy (const Ignore <$> ma)
>       Nothing -> error "non-monadic value I can't deal with here!" -- this is unreachable
>
>     ignoreTy = typeOf (pure Ignore :: m Ignore)
>
>     check (s, ty) = case lookup s globals of
>       Just dyn -> bdynTypeRep dyn == ty
>       Nothing  -> False

The final piece of the puzzle is this:

> -- | Convert an arbitrary value into a dynamic value, given its type.
> --
> -- This is unsafe because if the type is incorrect and the value is later used as that type, good
> -- luck.
> unsafeToBDynamic :: TypeRep -> a -> BDynamic
> unsafeToBDynamic ty = BDynamic ty . unsafeCoerce

And a demo:

```
λ> r <- newIORef (5::Int)
λ> let double = lit3 $ toBDynamic ((\x -> x >> x >> pure ()) :: IO Ignore -> IO ()) :: Exp3 IO h
λ> let addOne = lit3 $ toBDynamic (modifyIORef r (+1)) :: Exp3 IO h
λ> let addTwo = fromJust $ double `ap3ig` addOne
λ> let eval = fromJust $ (fromBDynamic :: BDynamic -> Maybe (IO ())) =<< eval3ig [] =<< toTerm3 addTwo
λ> eval
λ> readIORef r
7
λ> eval
λ> readIORef r
9
```
