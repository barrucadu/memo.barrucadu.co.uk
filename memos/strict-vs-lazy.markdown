---
title: Strict-by-default vs Lazy-by-default
tags: haskell, programming
date: 2016-02-12
audience: General
notice: In every discussion of Haskell, the issue of strict vs lazy evaluation comes up.  I think laziness is the better default.
---

In a language with lazy evaluation, a value is computed *only* when it
is needed, and then the computed value is stored. This is in contrast
with strict evaluation (which is by far the most common), where values
are computed as soon as they are defined.

Haskell uses lazy evaluation, and I think it's one of the great
strengths of the language. But the prevalent opinion in the
programming world is that it's maybe a nice idea, but bad in
practice. After all, you can always explicitly introduce laziness in
the form of function calls when you need it. Well, I think it's a
better default. So let's start out with some pros of laziness:

- **The language becomes more uniform.**

I dislike special cases in languages, I like things to be nice and
simple and uniform. I expect most programmers would agree with me. And
yet there are many instances of non-uniformity which everyone seems
happy with!

Consider the simple boolean and operator with short-circuiting,
`&&`. Could you define this in a strict language? No. Boolean
operators tend to have special evaluation rules associated with them
(called a *special form* in the Lisp world), because the right
argument is typically not evaluated if the result can be determined
purely from the left argument.

In Haskell, here is how you can define the short-circuiting boolean
and:

```haskell
(&&) :: Bool -> Bool -> Bool
True  && b = b
False && _ = False
```

Another common special form is the if/then/else statement. This cannot
be defined in a strict language for much the same reason: only one
branch is evaluated depending on the value of the conditional. It's
just a normal function given laziness:

```haskell
ifThenElse :: Bool -> a -> a -> a
ifThenElse True  t _ = t
ifThenElse False _ f = f
```

Laziness lets you define new control structures which the designers of
the language had not foreseen, this makes the language much more
flexible.

- **It does at most as much computation as would be done under strict
  evaluation.**

The "worst case" for lazy evaluation is when all values are
needed. Everything is evaluated, so there is no saving over strict
evaluation. On the other hand, if even *one* value is not needed, less
work has been done than would have been under strict evaluation.

This observation comes from an early paper on lazy evaluation, called
*[CONS Should Not Evaluate Its Arguments][cons]*, done in the context
of Lisp.

[cons]: http://www.cs.indiana.edu/ftp/techreports/TR44.pdf

- **Code can be more modular.**

Here's an example of the Newton-Raphson method of finding square
roots, taken from
*[Why Functional Programming Matters][why]*. Firstly, we define a
function to repeatedly apply a function to a value and gather the
results into a list:

[why]: https://ipaper.googlecode.com/git-history/8070869c59470de474515000e3af74f8958b2161/John-Hughes/The%20Computer%20Journal-1989-Hughes-98-107.pdf

```haskell
repeat :: (a -> a) -> a -> [a]
repeat f a = a : repeat f (f a)
```

Oops, we've already moved out of the realm of what strictness can deal
with. There's no base case for the recursion in `repeat`, so a strict
language would just enter an infinite loop.

Anyway, now we need a function which, given some tolerance and a list
of approximations, finds the first value where two successive
approximations don't differ by more than that tolerance:

```haskell
within :: Double -> [Double] -> Double
within epsilon (a:b:rest) = if abs (a - b) <= epsilon
  then b
  else within epsilon (b:rest)
```

And now the square root function is almost trivial:

```haskell
sqrt a0 epsilon n = within epsilon (repeat next a0) where
  next x = (x + n/x) / 2
```

It may not look like we've gained much, but actually we have: both
`repeat` and `within` can be re-used in other contexts. In order to
make the program modular like this in a strict language, we would need
to explicitly introduce laziness in the form of a generator. That's
more work.

The paper then goes on to re-use these functions to calculate the
square root a slightly different way; to implement numerical
differentiation; and to implement numerical integration. It turns out
that `within` and `repeat` are just the things you need to implement
numerical algorithms.

- **Memoisation (can be) free!**

A common optimisation technique is to store the result of a function
in some sort of lookup table, so if the function is given the same
arguments, the result can be returned without needing to recalculate
it. Well, if you can represent your function as a data structure,
laziness does that for you for free! Caching results is what it is
good for, after all.

We can use this to implement a simple function to get the nth prime in
linear time after it is first calculated:

```haskell
primes :: [Int]
primes = ...

prime :: Int -> Int
prime n = primes !! n
```

The first time `prime n` is computed for some `n`, the `primes` list
will be evaluated up to that point and the value returned. If we ever
call `primes m`, where `m <= n`, then all the function does is
traverse the list to find the value *which has already been computed*!
This is a classic example of trading space for time, the lookup table
uses memory, but we don't need to do a potentially expensive
calculation every time. The nice thing here is that this doesn't
require any special support for explicit memoisation; it's just a
consequence of lazy evaluation.

Naturally, there are disadvantages to lazy evaluation as well:

- **If potentially uses more memory.**

Laziness is implemented by introducing *thunks*. A thunk is a pointer
to some code and an environment. When the value represented by a thunk
is demanded, the code is evaluated and the thunk replaced with its
result. This gives us the evaluation only when we need it and the
caching. When a value is needed immediately, the thunk is just a waste
of space.

Laziness is a bit of a gamble; you're making the judgement that the
space saved by not needing to compute things will offset the space
wasted by allocating these thunks.

- **It's difficult to predict when memory is freed.**

It's just really hard to build up an intuition for this. Profilers are
all but essential if you get a nontrivial space leak. Fortunately,
Haskell has pretty good support for [heap profiling][prof], but it is
certainly much easier to debug space leaks in a strict language.

[prof]: http://book.realworldhaskell.org/read/profiling-and-optimization.html

- **Refactoring can have non-local effects.**

A friend was refactoring some nontrivial code he had part-inherited
part-written, and in doing so he changed the strictness of a function
slightly. This immediately caused the program to crash with a pattern
match failure in a completely separate module.

*What!?*

Cue a long and frustrating debugging session, trying to figure out why
this was happening and how to fix it.

It turns out that the change in strictness was rippling backwards
through the rest of the program, and forced something to be computed
which wasn't being before. Some function that had been written years
ago by someone who had since left had a missing case in a pattern
match. This had been fine, but now the result of applying this
function to a value which matched that case was needed: hence the
error.

That is *awful*. In a strict language, the missing case would have
been found when that code was first written, and would have been
corrected. In a lazy language, you get to discover it months (or even
*years*) after it was introduced and the original author is gone.

## The Killer Feature of Laziness

**You can make a lazy function strict, but you can't make a strict
function lazy without rewriting it.**

And this, to me, is *the* reason why laziness is the better default.

Let's say we have a lazy function we want to make strict. Haskell
provides a function called `seq`, which evaluates its first argument
and returns its second. Given this, we can construct a function to
fully evaluate a data structure. Let's keep it simple and operate on
lists for now:

```haskell
seqList :: [a] -> b -> b
seqList (a:as) b = a `seq` seqList as b
seqList [] b = b
```

Demanding the result of `seqList as b` recurses along the entire list
(because that is the termination condition of the recursion), using
`seq` to evaluate each element[^deepseq].

[^deepseq]: This is actually a slight lie, `seq` only evaluates to
    "weak-head normal form", which corresponds to the outermost
    constructor of a datatype. We actually need to appropriately
    define a `seqList`-like function for every type we want to be able
    to fully evaluate. The [deepseq][] package provides a typeclass to
    handle this.

[deepseq]: https://hackage.haskell.org/package/deepseq

Give this, we can make an arbitrary function operating on lists
completely strict:

```haskell
lazyFunction :: [a] -> [b] -> [c] -> [d]
lazyFunction foo bar baz = ...

strictFunction :: [a] -> [b] -> [c] -> [d]
strictFunction foo bar baz =
  let foo' = seqList foo foo
      bar' = seqList bar bar
      baz' = seqList baz baz
      result = lazyFunction foo' bar' baz'
  in foo' `seq` bar' `seq` baz' `seq` seqList result result
```

When the result of `strictFunction` is demanded, both the arguments
and it will be fully evaluated before being returned. This is because
`seqList` fully evaluates its first argument before returning the
second, and we're giving it the same list for both arguments. A neat
trick! In fact, this pattern is so useful that the [deepseq][]
package, which provides utilities for fully evaluating data
structures, provides a function to this effect called `force`, which
evaluates its argument and returns it.

**Caveat:** The evaluation of `lazyFunction` will still allocate
  thunks, which will then be immediately forced by `seqList`. This
  results in churn in the heap and extra work for the garbage
  collector, which is bad. A *better* function can be achieved if the
  lazy one is rewritten with strictness in mind, as then these excess
  thunks can be avoided. This is typically only an issue in
  performance-critical code: for example the implementations of data
  structures. *Most of the time* you don't need to worry about that
  extra bit of allocation.

We can even go for a middle-ground, where the function is strict in
its result but potentially lazy (depends on how the function is
defined) in its arguments:

```haskell
strictishFunction :: [a] -> [b] -> [c] -> [d]
strictishFunction foo bar baz =
  let result = lazyFunction foo bar baz
  in seqList result result
```

This is more useful. Wanting to be strict in the arguments like that
is quite an uncommon use-case in practice.

Now let's think about how to make a strict function lazy without
poking around in its implementation. So we want something of this form
again:

```haskell
strictFunction :: [a] -> [b] -> [c] -> [d]
strictFunction foo bar baz = ...

lazyFunction :: [a] -> [b] -> [c] -> [d]
lazyFunction foo bar baz =
  let result = strictFunction foo bar baz
  in ??? result
```

Wait, that's not right. Anything we pass in to `strictFunction` will
be fully evaluated, because it's strict! So the function can't be
*that* shape. We can't alter the arguments to `strictFunction` to make
the laziness explicit either, as that would change its type! We can
wrap up the result of `strictFunction` in a thunk, but as soon as we
try to *do* anything with it, any arguments passed in will be fully
evaluated.

We just can't make it lazy.

## Addendum: Strict and Lazy Data Structures

**"If laziness is so great, then why does pretty much every Haskell
  data structure library provide both strict and lazy versions of
  everything?"**

A good question, but not as related as it appears at first
glance. Lazy *evaluation* is about functions, lazy *data* is about the
representation of data structures in memory. Using strict data
structures does not necessarily make your program strict.

Suppose I have a strict string type:

```haskell
silly :: [a] -> StrictString
silly _ = "hello world"
```

Unless the list type is *also* strict, this function will work just
fine on infinite lists, *even though* the result is a totally strict
value which is always fully evaluated.

The reason we have both strict and lazy versions of data structures is
because quite often you *know* that you will be using something in a
strict context, in which case you can write things in a way which will
avoid allocating the useless thunks. But not every use is completely
strict, in which case the lazy version is preferable.
