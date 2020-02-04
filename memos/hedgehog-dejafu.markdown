---
title: Using Hedgehog to Test Déjà Fu
tags: concurrency, dejafu, haskell, hedgehog, programming, property-based testing
date: 2018-02-11
---

Déjà Fu is a concurrency testing library, and one thing you definitely
*don't* want to do when testing concurrent programs is to try every
possible interleaving of threads.

Trying every possible interleaving will give you, in general, an
exponential blow-up of the executions you need to perform as your test
case grows in size.  The core testing algorithm we use, a variant of
dynamic partial-order reduction (DPOR)[^dpor], attempts to reduce this
blow-up.  DPOR identifies actions which are *dependent*, and only
tries interleavings which permute dependent actions.

[^dpor]: For all the gory details, see:

    - **Dynamic partial order reduction for relaxed memory models**,
        N. Zhang, M. Kusano, and C. Wang (2015)

    - **Bounded partial-order reduction**,
        K. Coons, M. Musuvathi, and K. McKinley (2013)

    - **Refining dependencies improves partial-order verification methods** (extended abstract),
      P. Godefroid and D. Pirottin (1993)

Here are some examples:

- It doesn't matter which order two threads execute `readMVar`, for
  the same `MVar`.  These actions are *independent*.

- It does matter which order two threads execute `putMVar`, for the
  same `MVar`.  These actions are *dependent*.

- It doesn't matter which order two threads execute `putMVar` for
  different `MVar`s.  These actions are *independent*.

Two actions are dependent if the order in which they are performed
matters.

So the intuition behind DPOR is that most actions in a concurrent
program are *independent*.  DPOR won't help you much if you have a
single piece of shared state which every thread is hitting, but most
concurrent programs aren't like that.  The worst case is still a
terrible exponential blow-up, but the average case is much better.

The dependency relation is *core* part of Déjà Fu today.  It has
impacts on both performance and correctness.  If it says two actions
are dependent when they are not, then we may see unnecessary
interleavings tried.  If it says two actions are not dependent when
they really are, then we may miss necessary interleavings.

Being such an important component, it must be well-tested, right?
Well, sort of.  The Déjà Fu testsuite mostly consists of small
concurrent programs together with a list of expected outputs, testing
that Déjà Fu finds all the nondeterminism in the program.  This does
exercise the dependency relation, but only very indirectly.


The Idea
--------

There things would have remained had I not experienced one of those
coincidence-driven flashes of insight:

- [aherrmann][] opened an [issue on GitHub][issue] asking how to take
  an execution trace and replay it.

- [agnishom][] posted a [thread on /r/algorithms][ralgo] asking how to
  check the equivalence of traces where only some elements commute.

I had my idea.  I can *directly* test the dependency relation like so:

1. Execute a concurrent program.
2. Normalise its execution trace in some way.
3. "Replay" the normalised trace.
4. Assert that the result is the same.

[aherrmann]: https://github.com/aherrmann
[agnishom]: https://www.reddit.com/user/agnishom
[issue]: https://github.com/barrucadu/dejafu/issues/181
[ralgo]: https://www.reddit.com/r/algorithms/comments/7vo0el/checking_equivalence_of_trace_elements/


Normalising Traces
------------------

So, what is a good normal form for a trace?  I tried out a few
approaches here, but there was one I kept coming back to: we should
shuffle around independent actions to keep the program on the main
thread for as long as possible.

There are two reasons I think this works well.  (1) The traces we get
will be easier for a human to read, as the program will stay on its
main thread and only execute another thread where necessary.  (2) A
Haskell program terminates when the main thread terminates, so by
executing the main thread as much as possible, we may find that some
actions don't need to be executed at all.

So firstly we need to know when two actions commute.  Let's just use
the dependency relation for that:

```haskell
-- | Check if two actions commute.
independent
  :: DepState
  -> (ThreadId, ThreadAction)
  -> (ThreadId, ThreadAction)
  -> Bool
independent ds (tid1, ta1) (tid2, ta2) = not (dependent ds tid1 ta1 tid2 ta2)
```

The `DepState` parameter tracks information about the history of the
execution, allowing us to make better decisions.  For example: while
in general it matters in which order two `putMVar`s to the same `MVar`
happen; it *doesn't* matter if the `MVar` is already full, as both
actions will block without achieving anything.

The approach works well in practice, but has been the source of *so
many* off-by-one errors.  Even while writing this memo!

So now onto trace normalisation.  The easiest way to do it is bubble
sort, but with an additional constraint on when we can swap things:

1. For every adjacent pair of items `x` and `y` in the trace:
    1. If `x` and `y` commute and `thread_id y < thread_id x`:
        1. Swap `x` and `y`.
    2. Update the `DepState` and continue to the next pair.
2. Repeat until there are no more changes.

And here's the code:

```haskell
-- | Rewrite a trace into a canonical form.
normalise
  :: [(ThreadId, ThreadAction)]
  -> [(ThreadId, ThreadAction)]
normalise trc0 = if changed then normalise trc' else trc'
 where
  (changed, trc') = bubble initialDepState False trc0

  bubble ds flag ((x@(tid1, _)):(y@(tid2, _)):trc)
    | independent ds x y && tid2 < tid1 = go ds True y (x : trc)
    | otherwise = go ds flag x (y : trc)
  bubble _ flag trc = (flag, trc)

  go ds flag t@(tid, ta) trc =
    second (t :) (bubble (updateDepState ds tid ta) flag trc)
```

Testing Normalised Traces
-------------------------

Now we need a scheduler which can play a given list of scheduling
decisions.  This isn't built in, but we can make one.  Schedulers look
like this:

```haskell
-- from Test.DejaFu.Schedule
newtype Scheduler state = Scheduler
  { scheduleThread
    :: Maybe (ThreadId, ThreadAction)
    -> NonEmpty (ThreadId, Lookahead)
    -> state
    -> (Maybe ThreadId, state)
  }
```

A scheduler is a stateful function, which takes the previously
scheduled action and the list of runnable threads, and gives back a
thread to execute.  We don't care about those parameters.  We just
want to play a fixed list of scheduling decisions.  And here is how we
do that:

```haskell
-- | Execute a concurrent program by playing a list of scheduling decisions.
play
  :: MemType
  -> [ThreadId]
  -> ConcIO a
  -> IO (Either Failure a, [ThreadId], Trace)
play = runConcurrent (Scheduler sched)
 where
  sched _ _ (t:ts) = (Just t, ts)
  sched _ _ [] = (Nothing, [])
```

Now all the background is in place, so we can test what we want to
test: that an execution, and the play-back of its normalised trace,
give the same result.  For reasons which will become apparent in the
next section, I'm going to parameterise over the normalisation
function:

```haskell
-- | Execute a concurrent program with a random scheduler, normalise its trace,
-- execute the normalised trace, and return both results.
runNorm
  :: ([(ThreadId, ThreadAction)] -> [(ThreadId, ThreadAction)])
  -> Int
  -> MemType
  -> ConcIO a
  -> IO (Either Failure a, [ThreadId], Either Failure a, [ThreadId])
runNorm norm seed memtype conc = do
  let g = mkStdGen seed                                       -- 1
  (efa1, _, trc) <- runConcurrent randomSched memtype g conc
  let                                                         -- 2
    trc' = tail
      ( scanl
        (\(t, _) (d, _, a) -> (tidOf t d, a))
        (initialThread, undefined)
        trc
      )
  let tids1 = map fst trc'
  let tids2 = map fst (norm trc')                             -- 3
  (efa2, s, _) <- play memtype tids2 conc
  let truncated = take (length tids2 - length s) tids2        -- 4
  pure (efa1, tids1, efa2, truncated)
```

There's a lot going on here, so let's break it down:

1. We execute the program with the built-in random scheduler, using
   the provided seed.

2. The trace that `runConcurrent` gives us is in the form `[(Decision,
   [(ThreadId, Lookahead)], ThreadAction)]`, whereas we want a
   `[(ThreadId, ThreadAction)]`.  So this scan just changes the
   format.  It's a scan rather than a map because to convert a
   `Decision` into a `ThreadId` potentially requires knowing what the
   previous thread was.

3. We normalise the trace, and run it again.

4. If the entire normalised trace wasn't used up, then it has some
   unnecessary suffix (because the main thread is now terminating
   sooner).  So we make the normalised trace easier to read by
   chopping off any such suffix.

Finally, we can write a little function to test using the `normalise`
function:

```haskell
-- | Execute a concurrent program with a random scheduler, normalise its trace,
-- execute the normalised trace, and check that both give the same result.
testNormalise
  :: (Eq a, Show a)
  => Int
  -> MemType
  -> ConcIO a
  -> IO Bool
testNormalise seed memtype conc = do
  (efa1, tids1, efa2, tids2) <- runNorm normalise seed memtype conc
  unless (efa1 == efa2) $ do
    putStrLn   "Mismatched result!"
    putStrLn $ "      expected: " ++ show efa1
    putStrLn $ "       but got: " ++ show efa2
    putStrLn   ""
    putStrLn $ "rewritten from: " ++ show tids1
    putStrLn $ "            to: " ++ show tids2
  pure (efa1 == efa2)
```

And does it work?  Let's copy two example programs from the
Test.DejaFu docs:

```haskell
-- from Test.DejaFu
example1
  :: MonadConc m
  => m String
example1 = do
  var <- newEmptyMVar
  fork (putMVar var "hello")
  fork (putMVar var "world")
  readMVar var

example2
  :: MonadConc m
  => m (Bool, Bool)
example2 = do
  r1 <- newCRef False
  r2 <- newCRef False
  x <- spawn $ writeCRef r1 True >> readCRef r2
  y <- spawn $ writeCRef r2 True >> readCRef r1
  (,) <$> readMVar x <*> readMVar y
```

And then test them:

```
> testNormalise 0 TotalStoreOrder example1
True
> testNormalise 0 TotalStoreOrder example2
True
```

According to my very unscientific method, everything works perfectly!


Enter Hedgehog
--------------

You can probably see where this is going: just supplying *one* random
seed and *one* memory model is a poor way to test things.  Ah, if only
we had some sort of tool to generate arbitrary values for us!

But that's not all: if the dependency relation is correct, then *any*
permutation of independent actions should give the same result, not
just the one which `normalise` implements.  So before we introduce
[Hedgehog][] and arbitrary values, let's make something a little more
chaotic:

```haskell
-- | Shuffle independent actions in a trace according to the given list.
shuffle
  :: [Bool]
  -> [(ThreadId, ThreadAction)]
  -> [(ThreadId, ThreadAction)]
shuffle = go initialDepState
 where
  go ds (f:fs) (t1:t2:trc)
    | independent ds t1 t2 && f = go' ds fs t2 (t1 : trc)
    | otherwise = go' ds fs t1 (t2 : trc)
  go _ _ trc = trc

  go' ds fs t@(tid, ta) trc =
    t : go (updateDepState ds tid ta) fs trc
```

In `normalise`, two independent actions will *always* be re-ordered if
it gets us closer to the canonical form.  However, in `shuffle`, two
independent actions will either be re-ordered or not, depending on the
supplied list of `Bool`.

This is much better for testing our dependency relation, as we can now
get far more re-orderings which *all* should satisfy the same
property: that no matter how the independent actions in a trace are
shuffled, we get the same result.

I think it's about time to bring out Hedgehog:

```haskell
-- | Execute a concurrent program with a random scheduler, arbitrarily permute
-- the independent actions in the trace, and check that we get the same result
-- out.
hog :: (Eq a, Show a) => ConcIO a -> IO Bool
hog conc = Hedgehog.check . property $ do
  mem <- forAll Gen.enumBounded                               -- 1
  seed <- forAll $ Gen.int (Range.linear 0 100)
  fs <- forAll $ Gen.list (Range.linear 0 100) Gen.bool

  (efa1, tids1, efa2, tids2) <- liftIO                        -- 2
    $ runNorm (shuffle fs) seed mem conc
  footnote ("            to: " ++ show tids2)                 -- 3
  footnote ("rewritten from: " ++ show tids1)
  efa1 === efa2
```

Let's break that down:

1. We're telling Hedgehog that this property should hold for all
   memory models, all seeds, and all `Bool`-lists.  Unlike most
   Haskell property-testing libraries, Hedgehog takes generator
   functions rather than using a typeclass.  I think this is nicer.

2. We run our program, normalise it, and get all the results just as
   before.

3. We add some footnotes: messages which Hedgehog will display along
   with a failure.  For some reason these get displayed in reverse
   order.

Alright, let's see if Hedgehog finds any bugs for us:

```
> hog example1
  ? <interactive> failed after 3 tests and 1 shrink.

       ??? extra.hs ???
    82 ? hog :: (Eq a, Show a) => ConcIO a -> IO Bool
    83 ? hog conc = Hedgehog.check . property $ do
    84 ?   mem <- forAll Gen.enumBounded
       ?   ? SequentialConsistency
    85 ?   seed <- forAll $ Gen.int (Range.linear 0 100)
       ?   ? 0
    86 ?   fs <- forAll $ Gen.list (Range.linear 0 100) Gen.bool
       ?   ? [ False , True ]
    87 ?
    88 ?   (efa1, tids1, efa2, tids2) <- liftIO
    89 ?     $ runNorm (shuffle fs) seed mem conc
    90 ?   footnote ("            to: " ++ show tids2)
    91 ?   footnote ("rewritten from: " ++ show tids1)
    92 ?   efa1 === efa2
       ?   ^^^^^^^^^^^^^
       ?   ? Failed (- lhs =/= + rhs)
       ?   ? - Right "hello"
       ?   ? + Left InternalError

    rewritten from: [main,main,1,main,1,2,main,2,main]
                to: [main,1]

    This failure can be reproduced by running:
    > recheck (Size 2) (Seed 1824012233418733250 (-4876494268681827407)) <property>

False
```

It did!  And look at that output!  Magical!  I must see if I can get
Déjà Fu to give annotated source output like that.

Let's look at `example1` again:

```haskell
do
  var <- newEmptyMVar
  fork (putMVar var "hello")
  fork (putMVar var "world")
  readMVar var
```

Oh dear, our rewritten trace is trying to execute thread `1`
immediately after the first action of the main thread.  The first
action of the main thread is `newEmptyMVar`: thread `1` doesn't exist
at that point!

Let's change our `independent` function to say that an action is
dependent with the fork which creates its thread:

```haskell
independent ds (tid1, ta1) (tid2, ta2)
  | ta1 == Fork tid2 = False
  | ta2 == Fork tid1 = False
  | otherwise = not (dependent ds tid1 ta1 tid2 ta2)
```

How about now?

```
> hog example1
  ? <interactive> failed after 13 tests and 2 shrinks.

       ??? extra.hs ???
    82 ? hog :: (Eq a, Show a) => ConcIO a -> IO Bool
    83 ? hog conc = Hedgehog.check . property $ do
    84 ?   mem <- forAll Gen.enumBounded
       ?   ? SequentialConsistency
    85 ?   seed <- forAll $ Gen.int (Range.linear 0 100)
       ?   ? 0
    86 ?   fs <- forAll $ Gen.list (Range.linear 0 100) Gen.bool
       ?   ? [ True , True ]
    87 ?
    88 ?   (efa1, tids1, efa2, tids2) <- liftIO
    89 ?     $ runNorm (shuffle fs) seed mem conc
    90 ?   footnote ("            to: " ++ show tids2)
    91 ?   footnote ("rewritten from: " ++ show tids1)
    92 ?   efa1 === efa2
       ?   ^^^^^^^^^^^^^
       ?   ? Failed (- lhs =/= + rhs)
       ?   ? - Right "hello"
       ?   ? + Left InternalError

    rewritten from: [main,main,1,main,1,2,main,2,main]
                to: [main,1]

    This failure can be reproduced by running:
    > recheck (Size 12) (Seed 654387260079025817 (-6686572164463137223)) <property>

False
```

Well, that failing trace looks exactly like the previous error.  But
the parameters are different: the first error happened with the list
`[False, True]`, this requires the list `[True, True]`.  So let's
think about what happens to the trace in this case.

1. We start with: `[(main, NewEmptyMVar 0), (main, Fork 1), (1,
   PutMVar 0)]`.

2. The first two actions are independent, and the flag is `True`, so
   we swap them.  We now have: `[(main, Fork 1), (main, NewEmptyMVar
   1), (1, PutMVar 0)]`.

3. The second two actions are independent, and the flag is `True`, so
   we swap them.  We now have: `[(main, Fork 1), (1, PutMVar 0),
   (main, NewEmptyMVar 0)]`.

We can't actually re-order actions of the same thread, so we should
never have swapped the first two.  I suppose there's another problem
here, that no action on an `MVar` commutes with creating that `MVar`,
but we should never be in a situation where that could happen.  So we
need another case in `independent`:

```haskell
independent ds (tid1, ta1) (tid2, ta2)
  | tid1 == tid2 = False
  | ta1 == Fork tid2 = False
  | ta2 == Fork tid1 = False
  | otherwise = not (dependent ds tid1 ta1 tid2 ta2)
```

Our first example program works fine now:

```
> hog example1
  ? <interactive> passed 100 tests.
True
```

The second is a little less happy:

```
> hog example2
  ? <interactive> failed after 48 tests and 9 shrinks.

       ??? extra.hs ???
    82 ? hog :: (Eq a, Show a) => ConcIO a -> IO Bool
    83 ? hog conc = Hedgehog.check . property $ do
    84 ?   mem <- forAll Gen.enumBounded
       ?   ? TotalStoreOrder
    85 ?   seed <- forAll $ Gen.int (Range.linear 0 100)
       ?   ? 0
    86 ?   fs <- forAll $ Gen.list (Range.linear 0 100) Gen.bool
       ?   ? [ False
       ?   ? , False
       ?   ? , False
       ?   ? , False
       ?   ? , False
       ?   ? , False
       ?   ? , False
       ?   ? , False
       ?   ? , False
       ?   ? , False
       ?   ? , False
       ?   ? , False
       ?   ? , False
       ?   ? , False
       ?   ? , True
       ?   ? ]
    87 ?
    88 ?   (efa1, tids1, efa2, tids2) <- liftIO
    89 ?     $ runNorm (shuffle fs) seed mem conc
    90 ?   footnote ("            to: " ++ show tids2)
    91 ?   footnote ("rewritten from: " ++ show tids1)
    92 ?   efa1 === efa2
       ?   ^^^^^^^^^^^^^
       ?   ? Failed (- lhs =/= + rhs)
       ?   ? - Right ( False , True )
       ?   ? + Left InternalError

    rewritten from: [main,main,main,main,main,1,-1,1,1,main,1,main,main,main,main,2,-1,2,2,main,main]
                to: [main,main,main,main,main,1,-1,1,1,main,1,main,main,main,2,main,-1]

    This failure can be reproduced by running:
    > recheck (Size 47) (Seed 2159662051602767058 (-7857629802164753123)) <property>

False
```

This is a little trickier.  Here's my diagnosis:

1. It's an `InternalError` again, which means we're trying to execute
   a thread which isn't runnable.

2. The memory model is `TotalStoreOrder`, and the thread we're trying
   to execute is thread `-1`, a "fake" thread used in the relaxed
   memory implementation.  So this is a relaxed memory bug.

3. The traces only differ in one place: where `main, 2, -1` is changed
   to `2, main, -1`.  So the issue is caused by re-ordering `main` and
   thread `2`.

4. If the `main` action is a memory barrier, then thread `-1` will not
   exist after it.

5. So the `main` action is probably a memory barrier.

Let's push along those lines and add a case for memory barriers to
`independent`:

```haskell
independent ds (tid1, ta1) (tid2, ta2)
  | tid1 == tid2 = False
  | ta1 == Fork tid2 = False
  | ta2 == Fork tid1 = False
  | otherwise = case (simplifyAction ta1, simplifyAction ta2) of
      (UnsynchronisedWrite _, a) | isBarrier a -> False
      (a, UnsynchronisedWrite _) | isBarrier a -> False
      _ -> not (dependent ds tid1 ta1 tid2 ta2)
```

Did we get it?

```
> hog example2
  ? <interactive> passed 100 tests.
True
```

Great!


Bugs?
-----

So, we explored the dependency relation with Hedgehog, and found three
missing cases:

1. Two actions of the same thread are dependent.

2. Any action of a thread is dependent with the `fork` which creates
   that thread.

3. Unsynchronised writes are dependent with memory barriers.

But are these *bugs*?  I'm not so sure:

1. The dependency relation is only ever used to compare different
   threads.

2. This is technically correct, but it's not interesting or useful.

3. This could be a bug.  The relaxed memory implementation is pretty
   hairy and I've had a lot of problems with it in the past.
   Honestly, I just need to rewrite it (or campaign for Haskell to
   become sequentially consistent[^sc] and rip it out).

[^sc]: **SC-Haskell: Sequential Consistency in Languages That Minimize Mutable Shared Heap**,
    M. Vollmer, R. G. Scott, M. Musuvathi, and R. R. Newton (2017)

But even if not bugs, these are definitely *confusing*.  The
dependency relation is currently just an internal thing, not exposed
to users.  However, I'm planning to expose a function to normalise
traces, in which case providing an `independent` function is entirely
reasonable.

So even if these changes don't make it into `dependent`, they will be
handled by `independent`.

**Next steps:** I'm going to get this into the test suite, to get a
large number of extra example programs for free.  My hacky and
cobbled-together testing framework in dejafu-tests is capable of
running every test case with a variety of different schedulers, so I
just need to add another way it runs everything.  I won't need to
touch the actual tests, just the layer of glue which runs them all,
which is nice.

The only problem is that this glue is currently based on [HUnit][] and
[test-framework][], whereas the only integration I can find for
Hedgehog is [tasty-hedgehog][], so I might need to switch to [tasty][]
first.  As usual, the hardest part is getting different libraries to
co-operate!

Hopefully I'll find some bugs!  Well, not exactly *hopefully*, but you
know what I mean.


[hedgehog]: https://hackage.haskell.org/package/hedgehog
[HUnit]: https://hackage.haskell.org/package/HUnit
[test-framework]: https://hackage.haskell.org/package/test-framework
[tasty-hedgehog]: https://hackage.haskell.org/package/tasty-hedgehog
[tasty]: https://hackage.haskell.org/package/tasty
