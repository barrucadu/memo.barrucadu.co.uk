---
title: The '~' Instance Pattern
tags: haskell, programming
date: 2019-02-02
audience: General
---

Typeclass instance selection
----------------------------

Haskell typeclass instances have two parts: some *constraints*, and
the *instance head*:
```haskell
newtype WrappedFunctor f a = WrappedFunctor (n a)

instance Functor f => Functor (WrappedFunctor f) where
--       ^^^^^^^^^                                      constraints
--                    ^^^^^^^^^^^^^^^^^^^^^^^^^^        head

  fmap f (WrappedFunctor fa) = WrappedFunctor (fmap f fa)
```

More specifically, the head is of the form `C (T a1 ... an)`, where
`C` is the class, `T` is a type constructor, and `a1 ... an` are
distinct type variables.[^FlexibleInstances]

[^FlexibleInstances]:
  The `FlexibleInstances` extension relaxes this restriction a little,
  allowing some (or all) of the `a1 ... an` to be arbitrary types, as
  well as type variables.

When the type checker needs to find an instance, it does so purely
based on the head, constraints don't come into it.  The instance above
means "whenever you use `WrappedFunctor f` as a functor, *regardless
of what `f` is and even if we don't know what it is yet*, then you can
use this instance", and a type error will be thrown if whatever
concrete type `f` is instantiated to doesn't in fact have a functor
instance.

You might think that, if we didn't define the instance above and
instead defined this one:

```haskell
instance Functor (WrappedFunctor Maybe) where
  fmap f (WrappedFunctor fa) = WrappedFunctor (fmap f fa)
```

...and then used a `WrappedFunctor f` as a functor, that the type
checker would infer `f` must be `Maybe`.  This is not so!  Typeclass
inference happens under an "open world" approach: just because only
one instance is known *at this time* doesn't mean there won't be a
second instance discovered later.  Prematurely selecting the instance
for `WrappedFunctor Maybe` could be unsound.

Type equality constraints
-------------------------

In GHC Haskell, we can express a constraint that two types have to be
equal.  For example, this is a weird way to check that two values are
equal:

```haskell
-- this requires GADTs or TypeFamilies
funnyEq :: (Eq a, a ~ b) => a -> b -> Bool
funnyEq = (==)
```

We only have a constraint `Eq a`, not `Eq b`, but because of the `a ~
b` constraint, the type checker knows that they're the same type:

```
> funnyEq 'a' 'b'
False
> funnyEq True True
True
> funnyEq True 'b'

<interactive>:22:1: error:
    • Couldn't match type ‘Bool’ with ‘Char’
        arising from a use of ‘funnyEq’
    • In the expression: funnyEq True 'b'
      In an equation for ‘it’: it = funnyEq True 'b'
```

Type equality constraints in typeclass instances
------------------------------------------------

Let's put the two together now.  Let's throw away the two instances we
defined above, and now look at this one:

```haskell
instance (f ~ Maybe) => Functor (WrappedFunctor f) where
  fmap f (WrappedFunctor fa) = WrappedFunctor (fmap f fa)
```

This instance means "whenever you use `WrappedFunctor f` as a functor,
*regardless of what `f` is and even if we don't know what it is yet*,
then you can use this instance", and a type error will be thrown if
`f` cannot be instantiated to `Maybe`.  This is different to the
instance `Functor (WrappedFunctor Maybe)`!

- If we have `instance Functor (WrappedFunctor Maybe)`:

  ```
  > :t fmap (+1) (WrappedFunctor (pure 3))
    :: (Num b, Applicative f, Functor (WrappedFunctor f)) =>
       WrappedFunctor f b
  ```

- If we have `instance (f ~ Maybe) => Functor (WrappedFunctor f)`:

  ```
  > :t fmap (+1) (WrappedFunctor (pure 3))
    :: Num b => WrappedFunctor Maybe b
  ```

With the latter, we get much better type inference.  The downside is
that this instance overlaps any more concrete instances, so we
couldn't (for example) define an instance for `WrappedFunctor
Identity` as well.

But if you only need one instance, it's a neat trick.

Here's a [concrete example from the dejafu-2.0.0.0 branch][example].
I've introduced a `Program` type, to model concurrent programs.
There's one sort of `Program`, a `Program Basic`, which can be used as
a concurrency monad (a `MonadConc`) directly.  The instances are
defined like so:

[example]: https://github.com/barrucadu/dejafu/commit/bb0e953b2b4f830a08f316e675acb9bde3161fa9

```haskell
instance (pty ~ Basic, MonadIO n) => MonadIO (Program pty n) where
  -- ...

instance (pty ~ Basic) => MonadTrans (Program pty) where
  -- ...

instance (pty ~ Basic) =>  MonadCatch (Program pty n) where
  -- ...

instance (pty ~ Basic) => MonadThrow (Program pty n) where
  -- ...

instance (pty ~ Basic) => MonadMask (Program pty n) where
  -- ...

instance (pty ~ Basic, Monad n) => MonadConc (Program pty n) where
  -- ...
```

If instead the instances has been defined for `Program Basic n`, then
the type checker would have complained that the `pty` parameter is (in
many cases) polymorphic, and not use these instances.  This means
every single use of a `Program pty n`, where `pty` was not otherwise
constrained, would need a type annotation.  By instead formulating the
instances this way, the type checker *knows* that if you use a
`Program pty n` as a `MonadConc`, then it must be a `Program Basic n`.

This has turned a potentially huge breaking change, requiring everyone
who uses dejafu to add type annotations to their tests, into something
which just works.
