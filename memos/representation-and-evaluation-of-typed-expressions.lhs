---
title: Representation & Evaluation of Typed Expressions
tags: programming, research
project: spec
date: 2017-03-23
---

Or, "I tried really hard to use the [bound][] library but just couldn't get that square peg in this
round hole."

[bound]: https://hackage.haskell.org/package/bound

This is a simplified version of a problem I've been having in [spec][]. The current handling of
variables in spec is very poor, the programmer has to specify exactly which variables may be
introduced, binds and lets cause shadowing, and no care is taken to avoid generating alpha
equivalent terms.

Here are two representative problems:

1. If you have the variable `x`, and no others, a term like this will not be generated:
   `f >>= \x1 -> g x1 x`

2. If you have the variables `x` and `y` of the same type, these equivalent terms will be generated:
   `f x` and `f y`

[spec]: https://github.com/barrucadu/spec

Let's get started...

> import Data.Dynamic (Dynamic, dynApply, dynTypeRep)
> import Data.Function (on)
> import Data.List (groupBy, nub, sortOn)
> import Data.Maybe (mapMaybe, maybeToList)
> import Data.Ord (Down(..))
> import Data.Typeable (TypeRep, funResultTy)
> import Data.Void (Void, absurd)


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
>   = Lit1 Dynamic
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
>   show (Lit1 _) = "lit"
>   show (Hole1 ty) = "(_ :: " ++ show ty ++ ")"
>   show (Named1 ty s) = "(" ++ s ++ " :: " ++ show ty ++ ")"
>   show (Bound1 ty i) = "(" ++ show i ++ " :: " ++ show ty ++ ")"
>   show (Let1 _ b e) = "let <" ++ show b ++ "> in <" ++ show e ++ ">"
>   show (Ap1 _ f e)  = "(" ++ show f ++ ") (" ++ show e ++ ")"
>
> -- | Get the type of an expression.
> typeOf1 :: Exp1 -> TypeRep
> typeOf1 (Lit1   dyn)  = dynTypeRep dyn
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
reasons: the evaluator in [spec][] is more complex and does a lot of unsafe coercion, and being able
to just call `error` when the types don't work out is nicer than needing to actually handle it; and
it makes it easier to generate terms programmatically, as you simply try all possibilities and keep
the ones which succeed.

> -- | Construct a literal value.
> lit1 :: Dynamic -> Exp1
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
>   go _ (Lit1 dyn) = Just dyn
>   go _ (Hole1 _)  = Nothing

**Removing Holes**: we still have one more problem, it would be nice for holes to be given names
automatically, and not just individual holes, but groups of holes too.

For example, if we have an expression like so:

```haskell
f (_ :: Int) (_ :: Bool) (_ :: Bool) (_ :: Int)
```

It would be nice to be able to generate these expressions automatically:

```haskell
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
λ> let ibf      = lit1 (D.toDyn ((\_ _ _ a -> a) :: Int -> Bool -> Bool -> Int -> Int))
λ> let ibfExp   = fromJust $ do { x <- ibf `ap1` intHole; y <- x `ap1` boolHole; z <- y `ap1` boolHole; z `ap1` intHole }
λ> mapM_ print $ terms1 (head.show) ibfExp
((((lit) ((I :: Int))) ((B :: Bool))) ((B1 :: Bool))) ((I1 :: Int))
((((lit) ((I :: Int))) ((B :: Bool))) ((B1 :: Bool))) ((I :: Int))
((((lit) ((I :: Int))) ((B :: Bool))) ((B :: Bool))) ((I1 :: Int))
((((lit) ((I :: Int))) ((B :: Bool))) ((B :: Bool))) ((I :: Int))
```

Pretty sweet!


Mark 2: More Type Safety
------------------------

What we have now is pretty good, but it leaves a little to be desired: it would be nice to be able
to statically forbid passing expressions with holes to `eval`. As always in Haskell, the solution
is to add another type parameter.

> data Exp2 h
>   = Lit2 Dynamic
>   | Var2 TypeRep (Var2 h)
>   -- ^ One constructor for holes, named, and bound variables.
>   | Let2 TypeRep (Exp2 h) (Exp2 h)
>   | Ap2 TypeRep (Exp2 h) (Exp2 h)
>
> instance Show (Exp2 h) where
>   show (Lit2 _) = "lit"
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
>   show (Hole2 _) = "_"
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
> toTerm :: Schema2 -> Maybe Term2
> toTerm (Lit2 dyn) = Just (Lit2 dyn)
> toTerm (Var2 ty v) = case v of
>   Hole2  _ -> Nothing
>   Named2 s -> Just (Var2 ty (Named2 s))
>   Bound2 i -> Just (Var2 ty (Bound2 i))
> toTerm (Let2 ty b e) = Let2 ty <$> toTerm b <*> toTerm e
> toTerm (Ap2  ty f e) = Ap2  ty <$> toTerm f <*> toTerm e

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
>   go _ (Lit2 dyn) = Just dyn
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
> terms2 nf = mapMaybe toTerm . sortOn (Down . length . names2) . go where
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
> typeOf2 (Lit2 dyn)    = dynTypeRep dyn
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
> lit2 :: Dynamic -> Exp2 h
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
