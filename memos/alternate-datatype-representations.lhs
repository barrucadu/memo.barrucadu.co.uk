---
title: Using GADTs for alternative datatype representations
tags: haskell, programming
date: 2019-11-07
---

The generalised algebraic data types (GADTs) GHC extension is really
powerful, and let's you write some neat code.  This memo is a Literate
Haskell file showing how you can use GADTs to write an interface for
sets which works for types which only have an `Eq` instance, but which
enables faster implementations of methods if you have an `Ord`
instance around.  It's not complely transparent---functions which
construct an entirely new set will have `Eq` and `Ord` variants---but
it's better than duplicating every single function.


The `FlexiSet` type
-------------------

I'm going to call my set type `FlexiSet`, because it's a flexible
set[^name].

[^name]: I am good at naming things.

A `FlexiSet` is either a list of values of a type which has an `Eq`
instance, or a set (from our old friend `Data.Set`) of values of a
type which has an `Ord` instance:

> {-# LANGUAGE GADTs #-}
>
> import Prelude hiding (filter, null)
> import qualified Data.List as L
> import qualified Data.Set as S
>
> -- | A flexible set: elements will have at least an 'Eq' instance,
> -- maybe also an 'Ord' instance.
> data FlexiSet a where
>   EqSet  :: Eq  a => [a]     -> FlexiSet a
>   OrdSet :: Ord a => S.Set a -> FlexiSet a
>
> -- | Get the values from a 'FlexiSet'.  The order of the resultant
> -- list is arbitrary.
> toList :: FlexiSet a -> [a]
> toList (EqSet  as) = as
> toList (OrdSet as) = S.toList as

The `Eq` and `Ord` constraints don't leak outside the type, they're
entirely contained.  When an `EqSet` or `OrdSet` value is constructed,
the constraint dictionary is captured as well.  So pattern matching on
a `FlexiSet` will bring the instance into scope, without needing to
include the constraint in the function signature.  Great!  Leaky
constraints are the main reason why [people don't like
type-constrained `data` declarations][].

[people don't like type-constrained `data` declarations]: https://wiki.haskell.org/Data_declaration_with_constraint

We do need `Eq`-aware and `Ord`-aware functions to construct a
`FlexiSet`:

> -- | Construct a 'FlexiSet' for a type @a@ which has an 'Eq'
> -- instance.
> --
> -- If @a@ has an 'Ord' instance, use 'makeOrdSet' instead.
> makeEqSet :: Eq a => [a] -> FlexiSet a
> makeEqSet = EqSet . L.nub
>
> -- | Construct a 'FlexiSet' for a type @a@ which has an 'Ord'
> -- instance.
> makeOrdSet :: Ord a => [a] -> FlexiSet a
> makeOrdSet = OrdSet . S.fromList

Sadly we also need specific functions for mapping, as we need to
constrain the result type of the map function.  This also means we
can't give `FlexiSet` a `Functor` instance (just like `Set` can't have
one):

> -- | Map a function over a 'FlexiSet'.
> --
> -- If the result type has an 'Ord' instance, use 'mapOrd' instead.
> --
> -- This is @O(n)@.
> mapEq :: Eq b => (a -> b) -> FlexiSet a -> FlexiSet b
> mapEq f = EqSet . L.nub . map f . toList
>
> -- | Map a function over a 'FlexiSet'.
> --
> -- This is @O(n)@.
> mapOrd :: Ord b => (a -> b) -> FlexiSet a -> FlexiSet b
> mapOrd f = OrdSet . S.fromList . map f . toList

But we *don't* need to know anything about constraints for
filtering![^filtering] This is because we're not changing the type of
value in the `FlexiSet`, and by pattern matching on it we bring the
instance into scope:

[^filtering]: As an aside, I really like Ruby's `select` / `reject`
  names for `filter` and `\f -> filter (not . f)`.  I often
  misremember whether `filter` keeps things satisfying the predicate,
  or rejects things satisfying the predicate.

> -- | Remove values from a 'FlexiSet' which fail to satisfy the given
> -- predicate.
> --
> -- This is @O(n)@.
> filter :: (a -> Bool) -> FlexiSet a -> FlexiSet a
> filter f (EqSet  as) = EqSet  (L.filter f as)
> filter f (OrdSet as) = OrdSet (S.filter f as)

Here are a few more functions which do something with a single
`FlexiSet`.  Note how the `OrdSet` ones can use the more efficient
`Data.Set` operations, but the `EqSet` ones are stuck with slow
linear-time list functions:

> -- | Insert a value into a 'FlexiSet' if it's not already present.
> --
> -- This is @O(n)@ for 'Eq'-based sets and @O(log n)@ for 'Ord'-based
> -- sets.
> insert :: a -> FlexiSet a -> FlexiSet a
> insert a (EqSet  as) = EqSet  (L.nub (a:as))
> insert a (OrdSet as) = OrdSet (S.insert a as)
>
> -- | Remove a value from a 'FlexiSet' if it's present
> --
> -- This is @O(n)@ for 'Eq'-based sets and @O(log n)@ for 'Ord'-based
> -- sets.
> delete :: a -> FlexiSet a -> FlexiSet a
> delete a (EqSet  as) = EqSet  (L.filter (/=a) as)
> delete a (OrdSet as) = OrdSet (S.delete a as)
>
> -- | Check if a value is present in a 'FlexiSet'.
> --
> -- This is @O(n)@ for 'Eq'-based sets and @O(log n)@ for 'Ord'-based
> -- sets.
> member :: a -> FlexiSet a -> Bool
> member a (EqSet  as) = any (==a) as
> member a (OrdSet as) = S.member a as

Sometimes it doesn't matter whether we have an `EqSet` or an `OrdSet`:

> -- | Check if a 'FlexiSet' is empty.
> --
> -- This is @O(1)@.
> null :: FlexiSet a -> Bool
> null (EqSet  as) = L.null as
> null (OrdSet as) = S.null as

Sometimes it matters a lot:

> -- | Get the number of elements in a 'FlexiSet'.
> --
> -- This is @O(n)@ for 'Eq'-based sets and @O(1)@ for 'Ord'-based
> -- sets.
> size :: FlexiSet a -> Int
> size (EqSet  as) = length as
> size (OrdSet as) = S.size as

We could improve this case by changing our `EqSet` representation to
also track the length.

Functions which combine two `FlexiSet` values of the same type are
interesting, as we get to "upgrade" from an `EqSet` to an `OrdSet` in
some cases:

> -- | Take the union of two 'FlexiSet' values.
> --
> -- This is @O(n)@ if both or either of the sets are 'Eq'-based and
> -- @O(m*log(n/m + 1)), m <= n@ if both are 'Ord'-based.
> --
> -- If one set is 'Eq'-based and one is 'Ord'-based, the result will
> -- be 'Ord'-based.
> union :: FlexiSet a -> FlexiSet a -> FlexiSet a
> union (EqSet  as) (EqSet  bs) = EqSet  (L.nub (as ++ bs))
> union (EqSet  as) (OrdSet bs) = OrdSet (S.union (S.fromList as) bs)
> union (OrdSet as) (EqSet  bs) = OrdSet (S.union as (S.fromList bs))
> union (OrdSet as) (OrdSet bs) = OrdSet (S.union as bs)
>
> -- | Take the intersection of two 'FlexiSet' values.
> --
> -- This is @O(n)@ if both or either of the sets are 'Eq'-based and
> -- @O(m*log(n/m + 1)), m <= n@ if both are 'Ord'-based.
> --
> -- If one set is 'Eq'-based and one is 'Ord'-based, the result will
> -- be 'Ord'-based.
> intersection :: FlexiSet a -> FlexiSet a -> FlexiSet a
> intersection (EqSet  as) (EqSet  bs) = EqSet  (L.filter (`elem` bs) as)
> intersection (EqSet  as) (OrdSet bs) = OrdSet (S.intersection (S.fromList as) bs)
> intersection (OrdSet as) (EqSet  bs) = OrdSet (S.intersection as (S.fromList bs))
> intersection (OrdSet as) (OrdSet bs) = OrdSet (S.intersection as bs)
>
> -- | Take the intersection of two 'FlexiSet' values.
> --
> -- This is @O(n)@ if both or either of the sets are 'Eq'-based and
> -- @O(m*log(n/m + 1)), m <= n@ if both are 'Ord'-based.
> --
> -- If one set is 'Eq'-based and one is 'Ord'-based, the result will
> -- be 'Ord'-based.
> difference :: FlexiSet a -> FlexiSet a -> FlexiSet a
> difference (EqSet  as) (EqSet  bs) = EqSet  (L.filter (`notElem` bs) as)
> difference (EqSet  as) (OrdSet bs) = OrdSet (S.difference (S.fromList as) bs)
> difference (OrdSet as) (EqSet  bs) = OrdSet (S.difference as (S.fromList bs))
> difference (OrdSet as) (OrdSet bs) = OrdSet (S.difference as bs)

But when we combine sets of different types, we have to "downgrade"
from an `OrdSet` to an `EqSet`:

> -- | Take the disjoint union of two 'FlexiSet' values.
> --
> -- This is @O(n)@ if both or either of the sets are 'Eq'-based and
> -- @O(m*log(n/m + 1)), m <= n@ if both are 'Ord'-based.
> --
> -- If one set is 'Eq'-based and one is 'Ord'-based, the result will
> -- be 'Eq'-based.
> disjointUnion :: FlexiSet a -> FlexiSet b -> FlexiSet (Either a b)
> disjointUnion (EqSet  as) (EqSet  bs) = EqSet  (map Left as ++ map Right bs)
> disjointUnion (EqSet  as) (OrdSet bs) = EqSet  (map Left as ++ map Right (S.toList bs))
> disjointUnion (OrdSet as) (EqSet  bs) = EqSet  (map Left (S.toList as) ++ map Right bs)
> disjointUnion (OrdSet as) (OrdSet bs) = OrdSet (S.disjointUnion as bs)

Wrap up
-------

GADTs are a neat generalisation of regular Haskell data types which
allow you to do all sorts of cool things.

For example, in [dejafu][], my concurrency testing library, I'm using
GADTs to:

[dejafu]: https://github.com/barrucadu/dejafu

- ...unify a few different variations on the same type behind a common interface ([source](https://github.com/barrucadu/dejafu/blob/f208e946c0a5dc51e353cd908a81af03ec2b2c4e/dejafu/Test/DejaFu/Conc/Internal/Common.hs#L40-L59)):

   ```haskell
   -- | A representation of a concurrent program for testing.
   --
   -- To construct these, use the 'C.MonadConc' instance, or see
   -- 'Test.DejaFu.Conc.withSetup', 'Test.DejaFu.Conc.withTeardown', and
   -- 'Test.DejaFu.Conc.withSetupAndTeardown'.
   --
   -- @since 2.0.0.0
   data Program pty n a where
     ModelConc ::
       { runModelConc :: (a -> Action n) -> Action n
       } -> Program Basic n a
     WithSetup ::
       { wsSetup   :: ModelConc n x
       , wsProgram :: x -> ModelConc n a
       } -> Program (WithSetup x) n a
     WithSetupAndTeardown ::
       { wstSetup    :: ModelConc n x
       , wstProgram  :: x -> ModelConc n y
       , wstTeardown :: x -> Either Condition y -> ModelConc n a
       } -> Program (WithSetupAndTeardown x y) n a
   ```

- ...hide a type variable which doesn't need to be exposed ([source](https://github.com/barrucadu/dejafu/blob/1a4f99de9ce8c707654aa2f7b8852e33473d8790/dejafu/Test/DejaFu/Conc/Internal/Memory.hs#L52-L56)):

   ```haskell
   -- | A buffered write is a reference to the variable, and the value to
   -- write. Universally quantified over the value type so that the only
   -- thing which can be done with it is to write it to the reference.
   data BufferedWrite n where
     BufferedWrite :: ThreadId -> ModelIORef n a -> a -> BufferedWrite n
   ```

- ...in a few places ([source](https://github.com/barrucadu/dejafu/blob/1a4f99de9ce8c707654aa2f7b8852e33473d8790/dejafu/Test/DejaFu/Internal.hs#L55-L60)):

   ```haskell
   -- | How to explore the possible executions of a concurrent program.
   --
   -- @since 0.7.0.0
   data Way where
     Systematic :: Bounds -> Way
     Randomly   :: RandomGen g => (g -> (Int, g)) -> g -> Int -> Way
   ```

In all these cases GADTs let me be more specific about what type
information leaks out of a constructor, meaning I can have types which
more precisely convey my intent, and not just types which are full of
implementation details.
