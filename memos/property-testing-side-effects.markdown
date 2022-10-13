---
title: Property-testing Side Effects
taxon: research-dejafucoco
date: 2017-06-09
---

[dejafu-0.7.0.0][] brings with it [a new module][] for
property-testing the side-effects of stateful expressions.  It's just
a wrapper around the unit-testing stuff dejafu always did, but it's
more convenient than handling things like supplying random arguments
and comparing results yourself.

We can check if two expressions have equivalent behaviours, or if one
has *fewer* behaviours than the other.  Such properties can serve both
as documentation and as regression tests.

Let's dive straight into an example:

> Is `readMVar` equivalent to a `takeMVar` followed by a `putMVar`?

We might phrase this property like so:

```haskell
prop_read_equiv_take_put =
  sig readMVar `equivalentTo` sig (\v -> takeMVar v >>= putMVar v)
```

[dejafu-0.7.0.0]: https://hackage.haskell.org/package/dejafu-0.7.0.0
[a new module]: http://hackage.haskell.org/package/dejafu-0.7.0.0/docs/Test-DejaFu-Refinement.html

## Set-up

The property-testing uses *signatures*, where a signature tells dejafu
how to (1)\ create a *new* state; (2)\ make some *observation* of the
state; (3)\ concurrently *interfere* with the state in some way; and
(4)\ the expression to evaluate.

### State type

Properties are monomorphic, so we can't directly express a property
about *any* `MVar`, we need to pick a concrete type for its contents.
Let's just pick `Int`:

```haskell
type State = MVar ConcIO Int
```

Properties operate in the `ConcIO` monad.  There is no option to use
`ConcST` yet, as I couldn't get a nice interface working which didn't
break type inference in GHCi.

### Initialisation

The state is constructed using a pure *seed value* the
property-checker generates.  We want to consider both *full* and
*empty* `MVar`s, so we'll ask it to supply a `Maybe Int`:

```haskell
type Seed = Maybe Int
```

The initialisation function we will include in the signature then just
calls `newMVar` or `newEmptyMVar` as appropriate:

```haskell
makeMVar :: Seed -> ConcIO State
makeMVar (Just x) = newMVar x
makeMVar Nothing  = newEmptyMVar
```

Seed values are generated using [LeanCheck][], an enumerative
property-based testing library.

[LeanCheck]: https://hackage.haskell.org/package/leancheck

### Observation

We want to know if the `MVar` contains a value when we observe it, and
we want to know what that value is; another `Maybe`:

```haskell
type Observation = Maybe Int
```

It is important that the observation function does not block, so we
use `tryReadMVar` here rather than `readMVar` or `takeMVar`:

```haskell
observeMVar :: State -> Seed -> ConcIO Observation
observeMVar v _ = tryReadMVar v
```

It does not matter if making the observation has side-effects, so
`tryTakeMVar` would have been equally valid.

### Interference

Our interference function will just mess with the value in the `MVar`:

```haskell
interfereMVar :: State -> Seed -> ConcIO ()
interfereMVar mvar mx = do
  tryTakeMVar mvar
  void . tryPutMVar mvar $ case mx of
    Just x  -> (x+1) * 3000
    Nothing -> 7000
```

As LeanCheck is enumerative, large values like 3000 and 7000 will
stand out if the tool reports a failure.

### Signature

Now we package these operations up into a signature:

```haskell
sig :: (State -> ConcIO a) -> Sig State Observation Seed
sig e = Sig
  { initialise = makeMVar
  , observe    = observeMVar
  , interfere  = interfereMVar
  , expression = void . e
  }
```

We could, of course, have defined all this inside `sig` without the
top-level functions and type synonyms.

## Properties

Now we can test the property:

```
> check $ sig readMVar `equivalentTo` sig (\v -> takeMVar v >>= putMVar v)
*** Failure: (seed Just 0)
    left:  [(Nothing,Just 3000)]
    right: [(Nothing,Just 0),(Nothing,Just 3000),(Just Deadlock,Just 3000)]
```

We get a failure!  This is because the left term is atomic, whereas
the right is not: another thread writing to the `MVar` has the
opportunity to swoop in and insert a new value after the `takeMVar`
but before the `putMVar`.  The right has strictly more behaviours than
the left.

We can capture this, by using a different comparison:

```
> check $ sig readMVar `strictlyRefines` sig (\v -> takeMVar v >>= putMVar v)
+++ OK
```

To "strictly refine" something is to have a proper subset of the
behaviour.  There is also a "refines" comparison, which does not
require the subset to be proper.

### Wait a minute...

- Doesn't `readMVar v` return a different thing to `takeMVar v >>= putMVar v`?

    *Yes!*

    If they return at all, the former returns the value in the `MVar`,
    whereas the latter returns unit.  Properties do not care about the
    return value of an expression, only the effects.

    You can see this by looking at the definition of `sig` again: it
    throws away the result of the expression using `void`.

- Both of our properties are of the form ``sig f `cmp` sig g``, can't that redundancy be removed?

    *No!*

    You can use *different* signatures with *different* state types!
    As long as the seed and observation types are the same, `check`
    can compare them.

    You can use this to compare different implementations of a similar
    concurrent data structure.

### Properties with arguments

Properties can also have arguments, using LeanCheck to generate their
values.  This doesn't work in any mysterious way, here's a property
about the [`QSemN`][] functions:

```
> check $ \x y -> sig' (\v -> signalQSemN v (x + y)) `equivalentTo` sig' (\v -> signalQSemN v x >> signalQSemN v y)
*** Failure: -1 1 (seed 0)
    left:  [(Nothing,0)]
    right: [(Nothing,0),(Just Deadlock,0)]
```

You can even use your own types, as long as they have a `Listable`
(the typeclass LeanCheck uses) instance:

```
> :{
newtype Nat n = Nat n deriving Show
instance (Num n, Ord n, Listable n) => Listable (Nat n) where
  list = [Nat n | n <- list, n >= 0]
:}

> check $ \(Nat x) (Nat y) -> sig' (\v -> signalQSemN v (x + y)) `equivalentTo` sig' (\v -> signalQSemN v x >> signalQSemN v y)
+++ OK!
```

Currently it's a bit slow as I need to fiddle with the implementation
and work out what a good number of tests to run is.  `check` uses 10
seed values with 100 variable assignments each (1000 tests total), you
can use `checkFor` to reduce that.

[`QSemN`]: https://hackage.haskell.org/package/concurrency-1.1.2.1/docs/Control-Concurrent-Classy-QSemN.html

## Fin

So there you have it, property-testing for side-effects of stateful
operations.

This has come out of my work on [CoCo][], a tool for automatically
*discovering* these properties ([paper here][]).  In the CoCo
repository are a few more examples.  CoCo is still a work-in-progress,
but one of the goals is to be able to generate dejafu-compatible
output, so that CoCo can discover properties which dejafu can
immediately begin using for regression testing.

[CoCo]: https://github.com/barrucadu/coco
[paper here]: https://www.barrucadu.co.uk/publications/coco-tfp17-prelim.pdf
