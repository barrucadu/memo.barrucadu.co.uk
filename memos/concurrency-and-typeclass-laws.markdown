---
title: Concurrency and Typeclass Laws
taxon: research-dejafucoco
date: 2015-11-29
---

*Note: This is using (at the time of writing) the latest developmental
  version of Deja Fu, which is not yet on hackage. It will be soon!
  But until then, if you want to replicate this, clone
  [from git][dejafu-git].*

I recently implemented [async-dejafu][async-dejafu], a version of the
[async][] library using Deja Fu so programs written with it can be
tested, and I was curious about checking the relevant typeclass laws
automatically.

Checking typeclass laws has been [done][tc1] [with][tc2]
[QuickCheck][tc3] [before][tc4], but the difference here is that async
uses *concurrency*! If only we had some way to test concurrent Haskell
code! Oh, wait…

[dejafu-git]: https://github.com/barrucadu/dejafu
[async-dejafu]: https://github.com/barrucadu/dejafu/tree/4572eba19e91f7fbc3a228fa7376b0f0db51b55f/async-dejafu
[async]: https://hackage.haskell.org/package/async
[tc1]: http://paginas.fe.up.pt/~niadr/PUBLICATIONS/LIACC_publications_2011_12/pdf/OC26_Amaral_Haskell2012.pdf
[tc2]: http://austinrochford.com/posts/2014-05-27-quickcheck-laws.html
[tc3]: https://mail.haskell.org/pipermail/beginners/2010-July/004614.html
[tc4]: https://hackage.haskell.org/package/quickcheck-properties

## The set-up

Specifically, I want to test the laws for the `Concurrently`
type. `Concurrently` is a monad for expressing `IO` actions which
should be run concurrently.

Firstly, we need some language extensions and imports:

```haskell
{-# LANGUAGE RankNTypes          #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE ViewPatterns        #-}

module Concurrently where

import Control.Applicative
import Control.Exception (SomeException)
import Control.Monad ((>=>), ap, liftM, forever)
import Control.Monad.Catch (onException)
import Control.Monad.Conc.Class
import Data.Maybe (isJust)
import Data.Set (Set, fromList)
import Test.DejaFu (Failure(..), defaultMemType)
import Test.DejaFu.Deterministic (ConcST, Trace)
import Test.DejaFu.SCT (sctBound, defaultBounds)
import Test.QuickCheck (Arbitrary(..))
import Test.QuickCheck.Function (Fun, apply)
import Unsafe.Coerce (unsafeCoerce)
```

I have sadly not managed to eliminate that `unsafeCoerce`, it shows up
because of the use of higher-ranked types, and makes me very sad. If
anyone knows how I can get rid of it, I would be very happy!

Now we need our `Concurrently` type. The original just uses `IO`, so
we have to parameterise ours over the underlying monad:

```haskell
newtype Concurrently m a = Concurrently { runConcurrently :: m a }
```

We'll also be using a `ConcST` variant for testing a lot, so here's a
type synonym for that:

```haskell
type CST t = Concurrently (ConcST t)
```

We also need some instances for `Concurrently` in order to make
QuickCheck happy, but these aren't terribly important:

```haskell
instance Show (Concurrently m a) where
  show _ = "<concurrently>"

instance (Arbitrary a, Applicative m) => Arbitrary (Concurrently m a) where
  arbitrary = Concurrently . pure <$> arbitrary
```

Ok, let's get started!

## Functor

`Functor` lets you apply a pure function to a value in a context.

```haskell
class Functor f where
  fmap :: (a -> b) -> f a -> f b
```

A `Functor` should satisfy the identity law:

```haskell
fmap id = id
```

And the composition law:

```haskell
fmap f . fmap g = fmap (f . g)
```

The `Functor` instance for `Concurrently` just delegates the work to
the instance for the underlying monad:

```haskell
instance MonadConc m => Functor (Concurrently m) where
  fmap f (Concurrently a) = Concurrently $ f <$> a
```

The composition law is a little awkward to express in a way that
QuickCheck can deal with, as it involves arbitrary
functions. QuickCheck has a `Fun` type, representing functions which
can be serialised to a string. Bearing that in mind, here is how we
can express those two laws as tests:

```haskell
prop_functor_id :: Ord a => CST t a -> Bool
prop_functor_id ca = ca `eq` (id <$> ca)

prop_functor_comp :: Ord c => CST t a -> Fun a b -> Fun b c -> Bool
prop_functor_comp ca (apply -> f) (apply -> g) = (g . f <$> ca) `eq` (g <$> (f <$> ca))
```

We're using view patterns here to extract the actual function from the
`Fun` value. let's see if the laws hold!

```bash
λ> quickCheck (prop_functor_id :: CST t Int -> Bool)
+++ OK, passed 100 tests.
λ> quickCheck (prop_functor_comp :: CST t Int -> Fun Int Integer -> Fun Integer String -> Bool)
+++ OK, passed 100 tests.
```

Cool! Wait, what's that `eq` function?

### Equality and concurrency?

I've decided to treat two concurrent computations as equal if the sets
of values that they can produce are equal:

```haskell
eq :: Ord a => CST t a -> CST t a -> Bool
eq left right = runConcurrently left `eq'` runConcurrently right

eq' :: forall t a. Ord a => ConcST t a -> ConcST t a -> Bool
eq' left right = results left == results right where
  results cst = fromList . map fst $ sctBound' cst

  sctBound' :: ConcST t a -> [(Either Failure a, Trace)]
  sctBound' = unsafeCoerce $ sctBound defaultMemType defaultBounds
```

This is where the unfortunate `unsafeCoerce` comes in. The definition
of `sctBound'` there doesn't type-check without it, which is a
shame. If anyone could offer a solution, I would be very grateful.

## Applicative

`Applicative` extends `Functor` with the ability to inject a value
into a context without introducing any effects, and to apply a
function in a context to a value in a context.

```haskell
class Functor f => Applicative f where
  pure  :: a -> f a
  (<*>) :: f (a -> b) -> f a -> f b
```

An `Applicative` should satisfy the identity law:

```haskell
pure id <*> a = a
```

The homomorphism law, which says that applying a pure function to a
pure value in a context is the same as just applying the function to
the value and injecting the entire result into a context:

```haskell
pure (f a) = pure f <*> pure a
```

The interchange law, which says that when applying a function in a
context to a pure value, the order in which each is evaluated doesn't
matter:

```haskell
u <*> pure y = pure ($ y) <*> u
```

And the composition law, which is a sort of associativity property:

```haskell
u <*> (v <*> w) = pure (.) <*> u <*> v <*> w
```

Finally, there is a law relating `Applicative` to `Functor`, that says
we can decompose `fmap` into two steps, injecting a function into a
context, and then application within that context:

```haskell
f <$> x = pure f <*> x
```

This is where `Concurrently` gets its concurrency. `(<*>)` runs its
two arguments concurrently, killing the other if one throws an
exception.

```haskell
instance MonadConc m => Applicative (Concurrently m) where
  pure = Concurrently . pure

  Concurrently fs <*> Concurrently as = Concurrently $
    (\(f, a) -> f a) <$> concurrently fs as

concurrently :: MonadConc m => m a -> m b -> m (a, b)
concurrently = ...
```

Armed with the knowledge of how to generate arbitrary functions, these
are all fairly straight-forward to test

```haskell
prop_applicative_id :: Ord a => CST t a -> Bool
prop_applicative_id ca = ca `eq` (pure id <*> ca)

prop_applicative_homo :: Ord b => a -> Fun a b -> Bool
prop_applicative_homo a (apply -> f) = (pure $ f a) `eq` (pure f <*> pure a)

prop_applicative_inter :: Ord b => CST t (Fun a b) -> a -> Bool
prop_applicative_inter u y = (u' <*> pure y) `eq` (pure ($ y) <*> u') where
  u' = apply <$> u

prop_applicative_comp :: Ord c => CST t (Fun b c) -> CST t (Fun a b) -> CST t a -> Bool
prop_applicative_comp u v w = (u' <*> (v' <*> w)) `eq` (pure (.) <*> u' <*> v' <*> w) where
  u' = apply <$> u
  v' = apply <$> v
 
prop_applicative_fmap :: Ord b => Fun a b -> CST t a -> Bool
prop_applicative_fmap (apply -> f) a = (f <$> a) `eq` (pure f <*> a)
```

And indeed we see that the laws hold:

```bash
λ> quickCheck (prop_applicative_id :: CST t Int -> Bool)
+++ OK, passed 100 tests.
λ> quickCheck (prop_applicative_homo :: String -> Fun String Int -> Bool)
+++ OK, passed 100 tests.
λ> quickCheck (prop_applicative_inter :: CST t (Fun Int String) -> Int -> Bool)
+++ OK, passed 100 tests.
λ> quickCheck (prop_applicative_comp :: CST t (Fun Int String) -> CST t (Fun Char Int) -> CST t Char -> Bool)
+++ OK, passed 100 tests.
λ> quickCheck (prop_applicative_fmap :: Fun Int String -> CST t Int -> Bool)
+++ OK, passed 100 tests.
```

## Alternative

`Alternative` is a kind of monoid over `Applicative`.

```haskell
class Applicative f => Alternative f where
  empty :: f a
  (<|>) :: f a -> f a -> f a
  
  -- These both have default definitions
  some :: f a -> f [a]
  many :: f a -> f [a]
```

An `Alternative` should satisfy the monoid laws. Namely, left and
right identity:

```haskell
empty <|> x = x
x <|> empty = x
```

And associativity:

```haskell
(x <|> y) <|> z = x <|> (y <|> z)
```

The `Alternative` instance for `Concurrently` is used to express
races, with `(<|>)` executing both of its arguments concurrently and
returning the first to finish:

```haskell
instance MonadConc m => Alternative (Concurrently m) where
  empty = Concurrently $ forever yield

  Concurrently as <|> Concurrently bs =
    Concurrently $ either id id <$> race as bs

race :: MonadConc m => m a -> m b -> m (Either a b)
race = ...
```

Once again, the translation into QuickCheck properties is quite
simple:

```haskell
prop_alternative_right_id :: Ord a => CST t a -> Bool
prop_alternative_right_id x = x `eq` (x <|> empty)

prop_alternative_left_id :: Ord a => CST t a -> Bool
prop_alternative_left_id x = x `eq` (empty <|> x)

prop_alternative_assoc :: Ord a => CST t a -> CST t a -> CST t a -> Bool
prop_alternative_assoc x y z = (x <|> (y <|> z)) `eq` ((x <|> y) <|> z)
```

And the laws hold!

```bash
λ> quickCheck (prop_alternative_right_id :: CST t Int -> Bool)
+++ OK, passed 100 tests.
λ> quickCheck (prop_alternative_left_id :: CST t Int -> Bool)
+++ OK, passed 100 tests.
λ> quickCheck (prop_alternative_assoc :: CST t Int -> CST t Int -> CST t Int -> Bool)
+++ OK, passed 100 tests.
```

There are also some laws relating `Alternative` to `Applicative`, but
these are expressed in terms of `some` and `many`, which have default
law-satisfying definitions.

## Monad

`Monad` extends `Applicative` with the ability to squash nested
monadic values together, and are commonly used to express sequencing.

```haskell
class Applicative m => Monad m where
  return :: a -> m a
  (>>=)  :: m a -> (a -> m b) -> m b
```

There are a few different formulations of the `Monad` laws, I prefer
the one in terms of `(>=>)` (the fish operator), which is defined as:

```haskell
(>=>) :: Monad m => (a -> m b) -> (b -> m c) -> a -> m c
f >=> g = \x -> f x >>= g
```

Using this function the laws become simply the monoid laws:

```haskell
return >=> f = f
f >=> return = f
(f >=> g) >=> h = f >=> (g >=> h)
```

There are also a few laws relating `Monad` to `Applicative` and `Functor`:

```haskell
f <$> a = f `liftM` a
return = pure
(<*>) = ap
```

As with the `Functor`, the `Monad` instance just delegates the work:

```haskell
instance MonadConc m => Monad (Concurrently m) where
  return = pure

  Concurrently a >>= f = Concurrently $ a >>= runConcurrently . f
```

As these laws are mostly about function equality, a helper function to
express that is used:

```haskell
eqf :: Ord b => (a -> CST t b) -> (a -> CST t b) -> a -> Bool
eqf left right a = left a `eq` right a
```

Given that, the translation is simple:

```haskell
prop_monad_left_id :: Ord b => Fun a (CST t b) -> a -> Bool
prop_monad_left_id (apply -> f) = f `eqf` (return >=> f)

prop_monad_right_id :: Ord b => Fun a (CST t b) -> a -> Bool
prop_monad_right_id (apply -> f) = f `eqf` (f >=> return)

prop_monad_comp :: Ord d => Fun a (CST t b) -> Fun b (CST t c) -> Fun c (CST t d) -> a -> Bool
prop_monad_comp (apply -> f) (apply -> g) (apply -> h) = ((f >=> g) >=> h) `eqf` (f >=> (g >=> h))

prop_monad_fmap :: Ord b => Fun a b -> CST t a -> Bool
prop_monad_fmap (apply -> f) a = (f <$> a) `eq` (f `liftM` a)

prop_monad_pure :: Ord a => a -> Bool
prop_monad_pure = pure `eqf` return

prop_monad_ap :: Ord b => Fun a b -> a -> Bool
prop_monad_ap (apply -> f) a = (pure f <*> pure a) `eq` (return f `ap` return a)
```

Are there any counterexamples? No there aren't!

```bash
λ> quickCheck (prop_monad_left_id :: Fun Int (CST t String) -> Int -> Bool)
+++ OK, passed 100 tests.
λ> quickCheck (prop_monad_right_id :: Fun Int (CST t String) -> Int -> Bool)
+++ OK, passed 100 tests.
λ> quickCheck (prop_monad_comp :: Fun Int (CST t String) -> Fun String (CST t Bool) -> Fun Bool (CST t Int) -> Int -> Bool)
+++ OK, passed 100 tests.
λ> quickCheck (prop_monad_fmap :: Fun Int String -> CST t Int -> Bool)
+++ OK, passed 100 tests.
λ> quickCheck (prop_monad_pure :: Int -> Bool)
+++ OK, passed 100 tests.
λ> quickCheck (prop_monad_ap :: Fun Int String -> Int -> Bool)
+++ OK, passed 100 tests.
```

So, it certainly *looks* like all the laws hold! Yay!

## What about effects?

Consider the `eq'` function. This sort of "value-level" equality is
good enough for most types, where any type of effect is a value, but
it doesn't work so well when concurrency (or any sort of `IO`) is
involved, as there effects do not directly correspond to values.

There's one type of effect we particularly care about for the case of
`Concurrently`: namely, the amount of concurrency going on! To test
this, we need to write our tests such that different amounts of
concurrency can produce different results, which means our current
`Arbitrary` instance for `Concurrently` isn't good enough. We need
interaction between different concurrent inputs.

So let's try writing a test case for the `(<*>) = ap` law, but
explicitly testing the amount of concurrency:

```haskell
prop_monad_ap2 :: forall a b. Ord b => Fun a b -> Fun a b -> a -> Bool
prop_monad_ap2 (apply -> f) (apply -> g) a = go (<*>) `eq'` go ap where
  go :: (CST t (a -> b) -> CST t a -> CST t b) -> ConcST t b
  go combine = do
    var <- newEmptyCVar
    let cf = do { res <- tryTakeCVar var; pure $ if isJust res then f else g }
    let ca = do { putCVar var (); pure a }
    runConcurrently $ Concurrently cf `combine` Concurrently ca
```

Here we have two functions, `f` and `g`, and are using whether a
`CVar` is full or empty to choose between them. If the combining
function executes its arguments concurrently, then we will see both
cases; otherwise we'll only see the `g` case. *If* the law holds, and
`(<*>) = ap`, then we will see both cases for both of them!

```bash
λ> quickCheck (prop_monad_ap2 :: Fun Int String -> Fun Int String -> Int -> Bool)
*** Failed! Falsifiable (after 3 tests and 8 shrinks):    
{_->""}
{_->"a"}
0
```

Oops! We found a counterexample! Let's see what's happening:

```bash
λ> results $ go (<*>) (\_ -> "") (\_ -> "a") 0
fromList [Right "",Right "a"]
λ> results $ go ap (\_ -> "") (\_ -> "a") 0
fromList [Right "a"]
```

If we look at the definition of `ap`, the problem becomes clear:

```haskell
ap :: Monad m => m (a -> b) -> m a -> m b
ap mf ma =
  mf >>= \f ->
  ma >>= \a ->
  return (f a)
```

The issue is that our definiton of `(>>=)` is *sequential*, whereas
`(<*>)` is *concurrent*. The `Monad` instance is not consistent with
that `Applicative` *when there is interaction between actions*, as
this shows!

So what's the problem? It's *close enough*, right? Well, close enough
isn't good enough, when it comes to laws. This very issue caused
[breakage][], and is the reason that the `Monad` instance for
`Concurrently` got removed!

[breakage]: https://github.com/simonmar/async/pull/26

## So what?

So what's the point of this? Big deal, laws are important.

Well, that *is* the point. Laws *are* important, but often we don't
bother to test them. That's possibly fine if the instances are simple,
and you can check the laws by just juggling definitions in your head,
but when `IO` is involved, the situation becomes a bit more murky.

Code involving `IO` and concurrency is easy to get wrong, so when
building up a monad or whatever based on it, why not *actually test*
the laws, rather than just assume they're right? Because if, as a
library author, your assumption is wrong, your users will suffer for
it.
