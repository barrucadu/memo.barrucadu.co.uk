---
title: Simplifying Execution Traces
tags: concurrency, dejafu, haskell, programming, research
date: 2018-03-08
audience: People interested in the dejafu internals.
---

It's well known that randomly generated test failures are a poor
debugging aid.  That's why every non-toy randomised property testing
library (like [Hedgehog][] or [Hypothesis][] or [QuickCheck][]) puts a
considerable amount of effort into shrinking failures.  It's a
non-trivial problem, but it's absolutely essential.

It's also something that dejafu does not do.

[Hedgehog]: http://hackage.haskell.org/package/hedgehog
[QuickCheck]: http://hackage.haskell.org/package/QuickCheck
[Hypothesis]: https://github.com/HypothesisWorks/hypothesis-python


Running example
---------------

I'm going to use the "stores are transitively visible" litmus test as
a running example.  Here it is:

```haskell
import qualified Control.Monad.Conc.Class as C
import           Test.DejaFu.Internal
import           Test.DejaFu.SCT
import           Test.DejaFu.SCT.Internal.DPOR
import           Test.DejaFu.Types
import           Test.DejaFu.Utils

storesAreTransitivelyVisible :: C.MonadConc m => m (Int, Int, Int)
storesAreTransitivelyVisible = do
  x <- C.newCRef 0
  y <- C.newCRef 0
  j1 <- C.spawn (C.writeCRef x 1)
  j2 <- C.spawn (do r1 <- C.readCRef x; C.writeCRef x 1; pure r1)
  j3 <- C.spawn (do r2 <- C.readCRef y; r3 <- C.readCRef x; pure (r2,r3))
  (\() r1 (r2,r3) -> (r1,r2,r3)) <$> C.readMVar j1 <*> C.readMVar j2 <*> C.readMVar j3
```

I picked this one because it's kind of arbitrarily complex.  It's a
small test, but it's for the relaxed memory implementation, so there's
a lot going on.  It's a fairly dense test.

I'm now going to define a metric of trace complexity which I'll
justify in a moment:

```haskell
complexity :: Trace -> (Int, Int, Int, Int)
complexity = foldr go (0,0,0,0) where
  go (SwitchTo _, _, CommitCRef _ _) (w, x, y, z) = (w+1, x+1, y,   z)
  go (Start    _, _, CommitCRef _ _) (w, x, y, z) = (w+1, x,   y+1, z)
  go (Continue,   _, CommitCRef _ _) (w, x, y, z) = (w+1, x,   y,   z+1)
  go (SwitchTo _, _, _)              (w, x, y, z) = (w,   x+1, y,   z)
  go (Start    _, _, _)              (w, x, y, z) = (w,   x,   y+1, z)
  go (Continue,   _, _)              (w, x, y, z) = (w,   x,   y,   z+1)
```

Using the `183-shrinking` branch, we can now get the first trace for
every distinct result, along with its complexity:

```haskell
results :: Way -> MemType -> IO ()
results way memtype = do
  let settings = set lequality (Just (==))
               $ fromWayAndMemType way memtype
  res <- runSCTWithSettings settings storesAreTransitivelyVisible
  flip mapM_ res $ \(efa, trace) ->
    putStrLn (show efa ++ "\t" ++ showTrace trace ++ "\t" ++ show (complexity trace))
```

Here are the results for systematic testing:

```
λ> results (systematically defaultBounds) SequentialConsistency
Right (1,0,1)   S0------------S1---S0--S2-----S0--S3-----S0--   (0,0,7,24)
Right (0,0,1)   S0------------S2-----S1---S0---S3-----S0--      (0,0,6,24)
Right (0,0,0)   S0------------S2-P3-----S1---S0--S2----S0---    (0,1,6,23)
Right (1,0,0)   S0------------S3-----S1---S0--S2-----S0---      (0,0,6,24)

λ> results (systematically defaultBounds) TotalStoreOrder
Right (1,0,1)   S0------------S1---S0--S2-----S0--S3-----S0--   (0,0,7,24)
Right (0,0,1)   S0------------S1-P2-----S1--S0---S3-----S0--    (0,1,6,23)
Right (0,0,0)   S0------------S1-P2---P3-----S1--S0--S2--S0---  (0,2,6,22)
Right (1,0,0)   S0------------S1-P3-----S1--S0--S2-----S0---    (0,1,6,23)

λ> results (systematically defaultBounds) PartialStoreOrder
Right (1,0,1)   S0------------S1---S0--S2-----S0--S3-----S0--   (0,0,7,24)
Right (0,0,1)   S0------------S1-P2-----S1--S0---S3-----S0--    (0,1,6,23)
Right (0,0,0)   S0------------S1-P2---P3-----S1--S0--S2--S0---  (0,2,6,22)
Right (1,0,0)   S0------------S1-P3-----S1--S0--S2-----S0---    (0,1,6,23)
```

Pretty messy, right?  Here's the results for *random* testing:

```
λ> results (randomly (mkStdGen 0) 100) SequentialConsistency
Right (1,0,1)   S0-----P1-P0----P2-P1-P0-P3-P1-S2-P3--P0-P3-P0-P3-S2-P0-S2-P0--P2-S0-   (0,15,5,9)
Right (0,0,1)   S0-------P2-P1-P2-P0--P2-P0-P1-P0---S2-P3-P0-P2-S3---P1-S3-S0--         (0,12,5,12)
Right (1,0,0)   S0------------S3-----S1-P2-P1-P0--S2---P1-S0---                         (0,4,5,20)
Right (0,0,0)   S0---------P2-P0--P3-P0-S3--P2-P3-P2--P3-S2-S1--P0----                  (0,9,4,15)

λ> results (randomly (mkStdGen 0) 100) TotalStoreOrder
Right (1,0,1)   S0-----P1--P0-P1-S0-P2--C-S0---P2-P3-P2--S3-P0-P3-P0---S3-P0-P3-S0-     (1,13,6,11)
Right (0,0,1)   S0----P1-P0-----P2--P0--P2-P0-S2--S3-P1-P0---S1-S3----S0--              (0,8,6,16)
Right (0,0,0)   S0--------P2-P0--P3-P2-P0-P3-P2-C-S0-S3---S2--S1-C-S1-P0----            (2,10,6,14)

λ> results (randomly (mkStdGen 0) 100) PartialStoreOrder
Right (1,0,1)   S0-----P1--P0-P1-S0-P2--C-S0---P2-P3-P2--S3-P0-P3-P0---S3-P0-P3-S0-     (1,13,6,11)
Right (0,0,1)   S0----P1-P0-----P2--P0--P2-P0-S2--S3-P1-P0---S1-S3----S0--              (0,8,6,16)
Right (0,0,0)   S0--------P2-P0--P3-P2-P0-P3-P2-C-S0-S3---S2--S1-C-S1-P0----            (2,10,6,14)
```

Yikes!

The complexity metric I defined counts four things:

1. The number of relaxed-memory commit actions
2. The number of pre-emptive context switches
3. The number of non-pre-emptive context switches
4. The number of continues

I would much rather read a long trace where the only context switches
are when threads block, than a short one which is rapidly jumping
between threads.  So, given two equivalent traces, I will always
prefer the one with a lexicographically smaller complexity-tuple.


Trace simplification
--------------------

The key idea underpinning trace simplification is that dejafu can tell
when two scheduling decisions can be swapped without changing the
behaviour of the program.  I talked about this idea in the [Using
Hedgehog to Test Déjà Fu](/hedgehog-dejafu.html) memo.  So we can
implement transformations which are guaranteed to preserve semantics
*without needing to verify this by re-running the test case*.

Although we don't need to re-run the test case at all, the
`183-shrinking` branch currently does, but only once at the end after
the minimum has been found.  This is because it's easier to generate a
simpler sequence of scheduling decisions and use dejafu to produce the
corresponding trace than it is to produce a simpler trace directly.
This is still strictly better than a typical shrinking algorithm,
which would re-run the test case after *each* shrinking step, rather
than only at the end.

Rather than drag this out, here's what those random traces simplify
to:

```haskell
resultsS :: Way -> MemType -> IO ()
resultsS way memtype = do
  let settings = set lsimplify True
               . set lequality (Just (==))
               $ fromWayAndMemType way memtype
  res <- runSCTWithSettings settings storesAreTransitivelyVisible
  flip mapM_ res $ \(efa, trace) ->
    putStrLn (show efa ++ "\t" ++ showTrace trace ++ "\t" ++ show (complexity trace))
```

```
λ> resultsS (randomly (mkStdGen 0) 100) SequentialConsistency
Right (1,0,1)   S0----------P1---S2--P3-----S0---S2---S0---     (0,2,5,22)
Right (0,0,1)   S0----------P2-P1-P2-P1--S0---S2---S3-----S0--- (0,4,5,20)
Right (1,0,0)   S0------------S3-----S1---S0--S2----P0---       (0,1,5,23)
Right (0,0,0)   S0------------S3--P2-----S3---S1--P0----        (0,2,4,22)

λ> resultsS (randomly (mkStdGen 0) 100) TotalStoreOrder
Right (1,0,1)   S0----------P1---S2-----S0----S3-----S0--       (0,1,5,23)
Right (0,0,1)   S0----------P1-P2-----S0--S1--S0---S3-----S0--  (0,2,6,22)
Right (0,0,0)   S0----------P2--P3-----S0--S2---S1--P0----      (0,3,4,21)

λ> resultsS (randomly (mkStdGen 0) 100) PartialStoreOrder
Right (1,0,1)   S0----------P1---S2-----S0----S3-----S0--       (0,1,5,23)
Right (0,0,1)   S0----------P1-P2-----S0--S1--S0---S3-----S0--  (0,2,6,22)
Right (0,0,0)   S0----------P2--P3-----S0--S2---S1--P0----      (0,3,4,21)
```

This is much better.

There are two simplification phases: a preparation phase, which puts
the trace into a normal form and prunes unnecessary commits; and an
iteration phase, which repeats a step function until a fixed point is
reached (or the iteration limit is).

### Preparation

The preparation phase has two steps: first we put the trace into
*lexicographic normal form*, then we prune unnecessary commits.

We put a trace in lexicographic normal form by sorting by thread ID,
where only independent actions can be swapped:

```haskell
lexicoNormalForm :: MemType -> [(ThreadId, ThreadAction)] -> [(ThreadId, ThreadAction)]
lexicoNormalForm memtype = go where
  go trc =
    let trc' = bubble initialDepState trc
    in if trc == trc' then trc else go trc'

  bubble ds (t1@(tid1, ta1):t2@(tid2, ta2):trc)
    | independent ds tid1 ta1 tid2 ta2 && tid2 < tid1 = bgo ds t2 (t1 : trc)
    | otherwise = bgo ds t1 (t2 : trc)
  bubble _ trc = trc

  bgo ds t@(tid, ta) trc = t : bubble (updateDepState memtype ds tid ta) trc
```

If simplification only put traces into lexicographic normal form, we
would get these results:

```
λ> resultsS (randomly (mkStdGen 0) 100) SequentialConsistency
Right (1,0,1)   S0-----------P1---S2--P0--S2--P0-P3----P0--             (0,5,3,19)
Right (0,0,1)   S0-----------P2-P1-P2-P1-P0--S2--P0-P1-S2-S3----P0--    (0,8,4,16)
Right (1,0,0)   S0------------S3----P1--P0--S1-S2----P0---              (0,3,4,21)
Right (0,0,0)   S0------------S2-P3--P2----S3--P1--P0----               (0,4,3,20)

λ> resultsS (randomly (mkStdGen 0) 100) TotalStoreOrder
Right (1,0,1)   S0-------P1---S2--C-S0-----P2--P0--S2-S3----P0--        (1,5,5,19)
Right (0,0,1)   S0-----------P1-P2--P0-S1-P0-P2--P0--S1-S2-S3----P0--   (0,7,5,17)
Right (0,0,0)   S0-----------P2---P3--C-S0-S2--S3--P1-C-S1-P0----       (2,6,5,18)

λ> resultsS (randomly (mkStdGen 0) 100) PartialStoreOrder
Right (1,0,1)   S0-------P1---S2--C-S0-----P2--P0--S2-S3----P0--        (1,5,5,19)
Right (0,0,1)   S0-----------P1-P2--P0-S1-P0-P2--P0--S1-S2-S3----P0--   (0,7,5,17)
Right (0,0,0)   S0-----------P2---P3--C-S0-S2--S3--P1-C-S1-P0----       (2,6,5,18)
```

These are better than they were, but we can do better still.

After putting the trace into lexicographic normal form, we delete any
commit actions which are followed by any number of independent actions
and then a memory barrier:

```haskell
dropCommits :: MemType -> [(ThreadId, ThreadAction)] -> [(ThreadId, ThreadAction)]
dropCommits SequentialConsistency = id
dropCommits memtype = go initialDepState where
  go ds (t1@(tid1, ta1@(CommitCRef _ _)):t2@(tid2, ta2):trc)
    | isBarrier (simplifyAction ta2) = go ds (t2:trc)
    | independent ds tid1 ta1 tid2 ta2 = t2 : go (updateDepState memtype ds tid2 ta2) (t1:trc)
  go ds (t@(tid,ta):trc) = t : go (updateDepState memtype ds tid ta) trc
  go _ [] = []
```

Such commits don't affect the behaviour of the program at all, as all
buffered writes gets flushed when the memory barrier happens.

If simplification only did the preparation phase, we would get these
results:

```
λ> resultsS (randomly (mkStdGen 0) 100) SequentialConsistency
Right (1,0,1)   S0-----------P1---S2--P0--S2--P0-P3----P0--             (0,5,3,19)
Right (0,0,1)   S0-----------P2-P1-P2-P1-P0--S2--P0-P1-S2-S3----P0--    (0,8,4,16)
Right (1,0,0)   S0------------S3----P1--P0--S1-S2----P0---              (0,3,4,21)
Right (0,0,0)   S0------------S2-P3--P2----S3--P1--P0----               (0,4,3,20)

λ> resultsS (randomly (mkStdGen 0) 100) TotalStoreOrder
Right (1,0,1)   S0-------P1---S2--P0-----P2--P0--S2-S3----P0--          (0,5,4,19)
     ^-- better than just lexicoNormalForm
Right (0,0,1)   S0-----------P1-P2--P0-S1-P0-P2--P0--S1-S2-S3----P0--   (0,7,5,17)
Right (0,0,0)   S0-----------P2---P3--P0-S2--S3--P1--P0----             (0,5,3,19)
     ^-- better than just lexicoNormalForm

λ> resultsS (randomly (mkStdGen 0) 100) PartialStoreOrder
Right (1,0,1)   S0-------P1---S2--P0-----P2--P0--S2-S3----P0--          (0,5,4,19)
     ^-- better than just lexicoNormalForm
Right (0,0,1)   S0-----------P1-P2--P0-S1-P0-P2--P0--S1-S2-S3----P0--   (0,7,5,17)
Right (0,0,0)   S0-----------P2---P3--P0-S2--S3--P1--P0----             (0,5,3,19)
     ^-- better than just lexicoNormalForm
```

### Iteration

The iteration phase attempts to reduce context switching by pushing
actions forwards, or pulling them backwards, through the trace.

If we have the trace `[(tid1, act1), (tid2, act2), (tid1, act3)]`,
where `act2` and `act3` are independent, the "pull back"
transformation would re-order that to `[(tid1, act1), (tid1, act3),
(tid2, act2)]`.

In contrast, if `act1` and `act2` were independent, the "push forward"
transformation would re-order that to `[(tid2, act2), (tid1, act1),
(tid1, act3)]`.  The two transformations are almost, but not quite
opposites.

Pull-back walks through the trace and, at every context switch, looks
forward to see if there is a single action of the original thread it
can put before the context switch:

```haskell
pullBack :: MemType -> [(ThreadId, ThreadAction)] -> [(ThreadId, ThreadAction)]
pullBack memtype = go initialDepState where
  go ds (t1@(tid1, ta1):trc@((tid2, _):_)) =
    let ds' = updateDepState memtype ds tid1 ta1
        trc' = if tid1 /= tid2
               then maybe trc (uncurry (:)) (findAction tid1 ds' trc)
               else trc
    in t1 : go ds' trc'
  go _ trc = trc

  findAction tid0 = fgo where
    fgo ds (t@(tid, ta):trc)
      | tid == tid0 = Just (t, trc)
      | otherwise = case fgo (updateDepState memtype ds tid ta) trc of
          Just (ft@(ftid, fa), trc')
            | independent ds tid ta ftid fa -> Just (ft, t:trc')
          _ -> Nothing
    fgo _ _ = Nothing
```

Push-forward walks through the trace and, at every context switch,
looks forward to see if the last action of the original thread can be
put at its next execution:

```haskell
pushForward :: MemType -> [(ThreadId, ThreadAction)] -> [(ThreadId, ThreadAction)]
pushForward memtype = go initialDepState where
  go ds (t1@(tid1, ta1):trc@((tid2, _):_)) =
    let ds' = updateDepState memtype ds tid1 ta1
    in if tid1 /= tid2
       then maybe (t1 : go ds' trc) (go ds) (findAction tid1 ta1 ds trc)
       else t1 : go ds' trc
  go _ trc = trc

  findAction tid0 ta0 = fgo where
    fgo ds (t@(tid, ta):trc)
      | tid == tid0 = Just ((tid0, ta0) : t : trc)
      | independent ds tid0 ta0 tid ta = (t:) <$> fgo (updateDepState memtype ds tid ta) trc
      | otherwise = Nothing
    fgo _ _ = Nothing
```

The iteration process just repeats `pushForward memtype . pullBack memtype`.

If it only used `pullBack`, we would get these results:

```
λ> resultsS (randomly (mkStdGen 0) 100) SequentialConsistency
Right (1,0,1)   S0-----------P1---S2---P0--S2--S0-P3-----S0--           (0,3,5,21)
Right (0,0,1)   S0-----------P2-P1-P2--P1--S0--S2--S0-P3-----S0--       (0,5,5,19)
Right (1,0,0)   S0------------S3-----S1---S0--S2----P0---               (0,1,5,23)
Right (0,0,0)   S0------------S2-P3---P2----S3--S1--P0----              (0,3,4,21)

λ> resultsS (randomly (mkStdGen 0) 100) TotalStoreOrder
Right (1,0,1)   S0-----------P1---S2-----S0---S3-----S0--               (0,1,5,23)
Right (0,0,1)   S0-----------P1-P2-----S0-S1--S0---S3-----S0--          (0,2,6,22)
Right (0,0,0)   S0-----------P2---P3-----S0-S2--S1--P0----              (0,3,4,21)

λ> resultsS (randomly (mkStdGen 0) 100) PartialStoreOrder
Right (1,0,1)   S0-----------P1---S2-----S0---S3-----S0--               (0,1,5,23)
Right (0,0,1)   S0-----------P1-P2-----S0-S1--S0---S3-----S0--          (0,2,6,22)
Right (0,0,0)   S0-----------P2---P3-----S0-S2--S1--P0----              (0,3,4,21)
```

With no exception, iterating `pullBack` is an improvement over just
doing preparation.

If it only used `pushForward`, we would get these results:

```
λ> resultsS (randomly (mkStdGen 0) 100) SequentialConsistency
Right (1,0,1)   S0-------P1---S2--P0------S2--P3----P0---               (0,4,3,20)
Right (0,0,1)   S0-------P2-P1-P2-P1-P0------S1-S2---S3----P0---        (0,6,4,18)
Right (1,0,0)   S0------------S3----P1--P0--S1-S2----P0---              (0,3,4,21)
     ^-- no improvement over preparation
Right (0,0,0)   S0------------S3--P2-----S3--P1--P0----                 (0,3,3,21)

λ> resultsS (randomly (mkStdGen 0) 100) TotalStoreOrder
Right (1,0,1)   S0----P1---S0---P2----P0-------S2-S3----P0--            (0,4,4,20)
Right (0,0,1)   S0-------P1-P2--P0-----S1-P2--P0---S1-S2-S3----P0--     (0,6,5,18)
Right (0,0,0)   S0----------P2--P3--P0--S2---S3--P1--P0----             (0,5,3,19)
     ^-- no improvement over preparation

λ> resultsS (randomly (mkStdGen 0) 100) PartialStoreOrder
Right (1,0,1)   S0----P1---S0---P2----P0-------S2-S3----P0--            (0,4,4,20)
Right (0,0,1)   S0-------P1-P2--P0-----S1-P2--P0---S1-S2-S3----P0--     (0,6,5,18)
Right (0,0,0)   S0----------P2--P3--P0--S2---S3--P1--P0----             (0,5,3,19)
     ^-- no improvement over preparation
```

With three exceptions, where the traces didn't change, iterating
`pushForward` is an improvement over just doing preparation.

We've already seen the results if we combine them:

```
λ> resultsS (randomly (mkStdGen 0) 100) SequentialConsistency
Right (1,0,1)   S0----------P1---S2--P3-----S0---S2---S0---     (0,2,5,22)
Right (0,0,1)   S0----------P2-P1-P2-P1--S0---S2---S3-----S0--- (0,4,5,20)
Right (1,0,0)   S0------------S3-----S1---S0--S2----P0---       (0,1,5,23)
     ^-- same as pullBack, which is better than pushForward
Right (0,0,0)   S0------------S3--P2-----S3---S1--P0----        (0,2,4,22)

λ> resultsS (randomly (mkStdGen 0) 100) TotalStoreOrder
Right (1,0,1)   S0----------P1---S2-----S0----S3-----S0--       (0,1,5,23)
     ^-- same as pullBack, which is better than pushForward
Right (0,0,1)   S0----------P1-P2-----S0--S1--S0---S3-----S0--  (0,2,6,22)
     ^-- same as pullBack, which is better than pushForward
Right (0,0,0)   S0----------P2--P3-----S0--S2---S1--P0----      (0,3,4,21)

λ> resultsS (randomly (mkStdGen 0) 100) PartialStoreOrder
Right (1,0,1)   S0----------P1---S2-----S0----S3-----S0--       (0,1,5,23)
     ^-- same as pullBack, which is better than pushForward
Right (0,0,1)   S0----------P1-P2-----S0--S1--S0---S3-----S0--  (0,2,6,22)
     ^-- same as pullBack, which is better than pushForward
Right (0,0,0)   S0----------P2--P3-----S0--S2---S1--P0----      (0,3,4,21)
```


Next steps
----------

I think what I have right now is pretty good.  It's definitely a vast
improvement over not doing any simplification.

*But*, no random traces get simplified to the corresponding systematic
traces, which is a little disappointing.  I think that's because the
current passes just try to reduce context switches of any form,
whereas really I want to reduce pre-emptive context switches more than
non-pre-emptive ones.
