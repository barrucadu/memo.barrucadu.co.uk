---
title: Improving Performance by Discarding Traces
tags: dejafu, haskell, programming, release notes
date: 2017-08-16
audience: General
---

**tl;dr** if you don't want all the execution traces, you might now be
able to run your dejafu tests with several thousand times less memory.

---

dejafu leans more towards correctness than performance, by
default. Your test cases will be executed using the
`Test.DejaFu.SCT.sctBounded` function, which is complete but can be
slow; every result you get will have an associated trace, which can be
useful for debugging, but takes up memory.

dejafu-0.7.1.0 gives you an extra knob to tweak, and 0.7.1.1 makes it
even better.

## Discarding results and traces (dejafu-0.7.1.0)

![Random testing before (with traces)](/throwing-away-traces/randomly-before.png)

![Random testing after (without traces)](/throwing-away-traces/randomly-after.png)

**Full-size images:**
[before](/throwing-away-traces/randomly-before-full.pdf),
[after](/throwing-away-traces/randomly-after-full.pdf).

Test cases with long traces have been a particularly bad case, as all
the traces stuck around in memory until you did something with them at
the end (like print the bad ones).  This is such a case:

```haskell
contendedMVar :: MonadConc m => m ()
contendedMVar = do
  threadId <- myThreadId
  mvar     <- newEmptyMVar

  let maxval = 150
  let go = takeMVar mvar >>= \x -> if x == maxval then killThread threadId else go

  for_ [1..20] . const $ fork go
  fork $ for_ [1..maxval] (putMVar mvar)

  takeMVar =<< newEmptyMVar
```

I ran that 100 times with random scheduling, and the traces varied
from about 2500 to 3000 elements long.  That's a lot of stuff to keep
around in memory!

Sometimes you don't want *all* the results or traces of your test
case, you only want some of them.  Now you can tell dejafu to throw
things away as it's running, allowing garbage collection to kick in
sooner, and reduce the resident memory usage.

There's a new type and some new functions:

```haskell
module Test.DejaFu.SCT where

-- ...

-- | An @Either Failure a -> Maybe Discard@ value can be used to
-- selectively discard results.
--
-- @since 0.7.1.0
data Discard
  = DiscardTrace
  -- ^ Discard the trace but keep the result.  The result will appear
  -- to have an empty trace.
  | DiscardResultAndTrace
  -- ^ Discard the result and the trace.  It will simply not be
  -- reported as a possible behaviour of the program.
  deriving (Eq, Show, Read, Ord, Enum, Bounded)

-- | A variant of 'runSCT' which can selectively discard results.
--
-- @since 0.7.1.0
runSCTDiscard :: MonadRef r n
  => (Either Failure a -> Maybe Discard)
  -- ^ Selectively discard results.
  -> Way
  -- ^ How to run the concurrent program.
  -> MemType
  -- ^ The memory model to use for non-synchronised @CRef@ operations.
  -> ConcT r n a
  -- ^ The computation to run many times.
  -> n [(Either Failure a, Trace)]

-- and: runSCTDiscard', resultsSetDiscard, resultsSetDiscard', sctBoundDiscard,
--      sctUniformRandomDiscard, sctWeightedRandomDiscard
-- and: dejafuDiscard, dejafuDiscardIO         (Test.DejaFu)
-- and: testDejafuDiscard, testDejafuDiscardIO (Test.{HUnit,Tasty}.DejaFu)
```

Every iteration of the SCT loop, an `Either Failure a` value is
produced.  The `*Discard` function variants will throw it (or its
trace) away if you so tell it.

For example, you can now check that a test case doesn't deadlock in a
far more memory-efficient way like so:

```haskell
dejafuDiscard
  -- "efa" == "either failure a", discard everything but deadlocks
  (\efa -> if efa == Left Deadlock then Nothing else Just DiscardResultAndTrace)
  -- try 1000 executions with random scheduling
  (randomly (mkStdGen 42) 1000)
  -- use the default memory model
  defaultMemType
  -- your test case
  testCase
  -- the predicate to check (which is a bit redundant in this case)
  ("Never Deadlocks", deadlocksNever)
```

## A much improved DPOR implementation (dejafu-0.7.1.1)

![Systematic testing before (with traces)](/throwing-away-traces/systematically-before.png)

![Systematic testing after (without traces)](/throwing-away-traces/systematically-after.png)

**Full-size images:**
[before](/throwing-away-traces/systematically-before-full.pdf),
[after](/throwing-away-traces/systematically-after-full.pdf).

Unfortunately, 0.7.1.0 was only a win for random testing, as
systematic testing explicitly constructed the tree of executions in
memory.  This has been a long-standing issue with dejafu, but I'd
never gotten around to solving it before, because it wasn't really any
worse than what was happening elsewhere in the codebase.  But now it
was the worst!

The solution, in principle, was simple: you can avoid constructing the
complete tree by instead exploring schedules in a depth-first fashion,
which means you only need a stack and some bookkeeping information.

The implementation was fairly simple too!  I like simple things.

So now we can check every possible execution of our test case for
deadlocks, still in a memory-efficient fashion:

```haskell
dejafuDiscard
  (\efa -> if efa == Left Deadlock then Nothing else Just DiscardResultAndTrace)
  -- the default way is systematic testing
  defaultWay
  defaultMemType
  testCase
  ("Never Deadlocks", deadlocksNever)
```

It's not as memory-efficient as random scheduling, as it needs to keep
around *some* information about prior executions, but the amount it is
keeping around is greatly reduced from before.

---

What's next?  I don't really know.  There are still a lot of memory
inefficiencies in dejafu, but they all pale in comparison to these
two, so they can probably sit for a while longer.  I'd like to build a
suite of benchmarks, because I don't really have any other than the
test suite (which makes a poor benchmark).  If you have any test cases
which dejafu just can't handle, let me know!

I think it's fair to say that the frontiers of what dejafu is capable
of have been pushed back a *long* way by these changes.
