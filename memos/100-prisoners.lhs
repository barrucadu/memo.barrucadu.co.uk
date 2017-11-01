---
title: 100 Prisoners
tags: programming
date: 2017-11-01
---

There's a popular logic puzzle which goes something like this:

<blockquote>
There are 100 prisoners in solitary cells. There's a central living
room with one light bulb; this bulb is initially off. No prisoner can
see the light bulb from his or her own cell. Everyday, the warden
picks a prisoner equally at random, and that prisoner visits the
living room. While there, the prisoner can toggle the bulb if he or
she wishes. Also, the prisoner has the option of asserting that all
100 prisoners have been to the living room by now. If this assertion
is false, all 100 prisoners are shot. However, if it is indeed true,
all prisoners are set free and inducted into MENSA, since the world
could always use more smart people. Thus, the assertion should only be
made if the prisoner is 100% certain of its validity. The prisoners
are allowed to get together one night in the courtyard, to discuss a
plan. What plan should they agree on, so that eventually, someone will
make a correct assertion?
</blockquote>

We can express this as a concurrency problem: the warden is the
scheduler, each prisoner is a thread, and when the program terminates
every prisoner should have visited the living room.

Let's set up some imports:

> {-# LANGUAGE RankNTypes #-}
>
> import qualified Control.Concurrent.Classy as C
> import           Control.Monad             (forever, when)
> import           Data.Foldable             (for_)
> import           Data.List                 (genericLength)
> import           Data.Maybe                (mapMaybe)
> import qualified Data.Set                  as S
> import qualified Test.DejaFu               as D
> import qualified Test.DejaFu.Common        as D
> import qualified Test.DejaFu.SCT           as D


Correctness
-----------

Before we try to implement a solution, let's think about how we can
check if an execution corresponds to the prisoners succeeding an
entering MENSA, or failing and being shot.

Prisoners are threads, and the warden is the scheduler.  So if every
thread (prisoner) that is forked is scheduled (taken to the room),
then the prisoners are successful:

> -- | Check if an execution corresponds to a correct guess.
> isCorrect :: D.Trace -> Bool
> isCorrect trc = S.fromList (threads trc) == S.fromList (visits trc)
>
> -- | Get all threads created.
> threads :: D.Trace -> [D.ThreadId]
> threads trc = D.initialThread : mapMaybe go trc where
>   go (_, _, D.Fork tid) = Just tid
>   go _ = Nothing
>
> -- | Get all scheduled threads
> visits :: D.Trace -> [D.ThreadId]
> visits = mapMaybe go where
>   go (D.Start    tid, _, _) = Just tid
>   go (D.SwitchTo tid, _, _) = Just tid
>   go _ = Nothing

So now, given some way of setting up the game and running it to
completion, we can test it and print some statistics:

> -- | Run the prison game and print statistics.
> run :: D.Way -> (forall m. C.MonadConc m => m ()) -> IO ()
> run way game = do
>     traces <- map snd <$> D.runSCT way D.defaultMemType game
>     let successes = filter isCorrect traces
>     let failures  = filter (not . isCorrect) traces
>     putStrLn (show (length traces)    ++ " total attempts")
>     putStrLn (show (length successes) ++ " successes")
>     putStrLn (show (length failures)  ++ " failures")
>     putStrLn (show (avgvisits successes) ++ " average number of room visits per success")
>     putStrLn (show (avgvisits failures)  ++ " average number of room visits per failure")
>     putStrLn "Sample sequences of visits:"
>     for_ (take 5 traces) (print . visits)
>   where
>     avgvisits ts = sum (map (fromIntegral . numvisits) ts) / genericLength ts
>     numvisits = sum . map count where
>       count (_, _, D.STM _ _) = 1
>       count (_, _, D.BlockedSTM _) = 1
>       count (_, _, D.Yield) = 1
>       count _ = 0

I have decided to assume that a prisoner will either yield (doing
nothing) or perform some STM transaction while they're in the room, to
simplify things.


The Perfect Solution
--------------------

A slow but simple strategy is for the prisoners to nominate a leader.
Only the leader can declare to the warden that everyone has visited
the room.  Whenever a prisoner other than the leader visits the room,
if the light is *on*, they do nothing; otherwise, if this is their
first time in the room with the light off, they turn it on, otherwise
they leave it.  Whenever the leader enters the room, they turn the
light off.  When the leader has turned the light off 99 times (or `1 -
num_prisoners` times), they tell the warden that everyone has visited.

Let's set up those algorithms:

> -- | The state of the light bulb.
> data Light = IsOn | IsOff
>
> -- | Count how many prisoners have toggled the light and terminate
> -- when everyone has.
> leader :: C.MonadConc m => Int -> C.TVar (C.STM m) Light -> m ()
> leader prisoners light = go 0 where
>   go counter = do
>     counter' <- C.atomically $ do
>       state <- C.readTVar light
>       case state of
>         IsOn -> do
>           C.writeTVar light IsOff
>           pure (counter + 1)
>         IsOff -> C.retry
>     when (counter' < prisoners - 1)
>       (go counter')
>
> -- | Turn the light on once then do nothing.
> notLeader :: C.MonadConc m => C.TVar (C.STM m) Light -> m ()
> notLeader light = do
>   C.atomically $ do
>     state <- C.readTVar light
>     case state of
>       IsOn  -> C.retry
>       IsOff -> C.writeTVar light IsOn
>   forever C.yield

So now we just need to create a program where the leader is the main
thread and everyone else is a separate thread:

> -- | Most popular English male and female names, according to
> -- Wikipedia.
> name :: Int -> String
> name i = ns !! (i `mod` length ns) where
>   ns = ["Oliver", "Olivia", "George", "Amelia", "Harry", "Emily"]
>
> -- | Set up the prison game.  The number of prisoners should be at
> -- least 1.
> prison :: C.MonadConc m => Int -> m ()
> prison prisoners = do
>   light <- C.atomically (C.newTVar IsOff)
>   for_ [1..prisoners-1] (\i -> C.forkN (name i) (notLeader light))
>   leader prisoners light

Because these are people, not just threads, I've given them names.
The leader is just called "main" though, how unfortunate for them.

<h3>Testing</h3>

Now we can try out our system and see if it works:

```
λ> let runS = run $ D.systematically (D.defaultBounds { D.boundPreemp = Nothing })
λ> runS 1
1 total attempts
1 successes
0 failures
2.0 average number of room visits per success
NaN average number of room visits per failure
Sample sequences of visits:
[main]

λ> runS 2
5 total attempts
5 successes
0 failures
7.0 average number of room visits per success
NaN average number of room visits per failure
Sample sequences of visits:
[main,Olivia,main,Olivia,main]
[main,Olivia,main,Olivia,main]
[main,Olivia,main,Olivia,main]
[main,Olivia,main,Olivia,main]
[main,Olivia,main]

λ> runS 3
2035 total attempts
2035 successes
0 failures
133.39066339066338 average number of room visits per success
NaN average number of room visits per failure
Sample sequences of visits:
(big lists omitted)
```

This doesn't scale well.  It's actually a really bad case for
concurrency testing: every thread is messing with the same shared
state, so dejafu has to try all the orderings.  Not good.

Taking another look at our prisoners, we can see two things which a
human would use to decide whether some schedules are redundant or not:

1. If we adopt any schedule other than alternating leader /
   non-leader, threads will block without doing anything.  So we
   should alternate.

2. When a non-leader has completed their task, they will always yield.
   So we should never schedule a prisoner who will yield.

Unfortunately dejafu can't really make use of (1).  It could be
inferred *if* dejafu was able to compare values inside `TVar`s, rather
than just seeing that there had been a write.  But Haskell doesn't let
us do that without slapping an `Eq` constraint on `writeTVar`, which I
definitely don't want to do (although maybe having a separate
`eqwriteTVar`, `eqputMVar`, and so on would be a nice addition).

Fortunately, dejafu *can* do something with (2).  It already bounds
the maximum number of times a thread can yield, so that we can test
constructs like spinlocks.  This is called *fair bounding*.  The
default bound is 5, but if we set it to 0 dejafu will just never
schedule a thread which is going to yield.  Here we go:

```
λ> let runS = run $ D.systematically (D.defaultBounds { D.boundPreemp = Nothing, D.boundFair = Just 0 })
λ> runS 1
1 total attempts
1 successes
0 failures
2.0 average number of room visits per success
NaN average number of room visits per failure
Sample sequences of visits:
[main]

λ> runS 2
1 total attempts
1 successes
0 failures
4.0 average number of room visits per success
NaN average number of room visits per failure
Sample sequences of visits:
[main,Olivia,main]

λ> runS 3
4 total attempts
4 successes
0 failures
7.5 average number of room visits per success
NaN average number of room visits per failure
Sample sequences of visits:
[main,Olivia,main,George,main]
[main,Olivia,George,main,George,main]
[main,George,main,Olivia,main]
[main,George,Olivia,main,Olivia,main]
```

Much better!  Although it still doesn't scale as nicely as we'd like

```
λ> runS 4
48 total attempts
48 successes
0 failures
11.5 average number of room visits per success
NaN average number of room visits per failure
Sample sequences of visits:
[main,Olivia,main,George,main,Amelia,main]
[main,Olivia,main,George,Amelia,main,Amelia,main]
[main,Olivia,main,Amelia,main,George,main]
[main,Olivia,main,Amelia,George,main,George,main]
[main,Olivia,George,main,George,main,Amelia,main]

λ> runS 5
1536 total attempts
1536 successes
0 failures
16.0 average number of room visits per success
NaN average number of room visits per failure
Sample sequences of visits:
[main,Olivia,main,George,main,Amelia,main,Harry,main]
[main,Olivia,main,George,main,Amelia,Harry,main,Harry,main]
[main,Olivia,main,George,main,Harry,main,Amelia,main]
[main,Olivia,main,George,main,Harry,Amelia,main,Amelia,main]
[main,Olivia,main,George,Amelia,main,Amelia,main,Harry,main]

λ> runS 6
122880 total attempts
122880 successes
0 failures
21.0 average number of room visits per success
NaN average number of room visits per failure
Sample sequences of visits:
[main,Olivia,main,George,main,Amelia,main,Harry,main,Emily,main]
[main,Olivia,main,George,main,Amelia,main,Harry,Emily,main,Emily,main]
[main,Olivia,main,George,main,Amelia,main,Emily,main,Harry,main]
[main,Olivia,main,George,main,Amelia,main,Emily,Harry,main,Harry,main]
[main,Olivia,main,George,main,Amelia,Harry,main,Harry,main,Emily,main]
```

The prisoners are stepping on each other's toes and causing needless
work.  This is probably as good as we can do without adding some extra
primitives to dejafu to optimise the case where we have an `Eq`
instance available, unfortunately.

<h3>A Silver Lining</h3>

In concurrency testing terms, six threads is actually quite a lot.

[Empirical studies][empirical] have found that many concurrency bugs
can be exhibited with only two or three threads!  Furthermore, most
real-world concurrent programs don't have every single thread
operating on the same bit of shared state.

[empirical]: http://www.doc.ic.ac.uk/~afd/homepages/papers/pdfs/2014/PPoPP.pdf


The "Good-Enough" Solution
--------------------------

There's another school of thought which says to just wait for three
years, because by then it's very unlikely that any single prisoner had
never visited the room.  In fact, we would expect each prisoner to
have been to the room ten times by then, assuming the warden is fair.

By keeping track of how many days have passed, we can try this out as
well:

> leader :: C.MonadConc m => Int -> C.TVar (C.STM m) Int -> m ()
> leader prisoners days = C.atomically $ do
>   numDays <- C.readTVar days
>   C.check (numDays >= (prisoners - 1) * 10)
>
> notLeader :: C.MonadConc m => C.TVar (C.STM m) Int -> m ()
> notLeader days = forever . C.atomically $ C.modifyTVar days (+1)
>
> prison :: C.MonadConc m => Int -> m ()
> prison prisoners = do
>   days <- C.atomically (C.newTVar 0)
>   for_ [1..prisoners-1] (\i -> C.forkN (name i) (notLeader days))
>   leader prisoners days

Now let's see how these brave prisoners do (sample visit sequences
omitted because they're pretty long):

```
λ> let runR = run $ D.uniformly (R.mkStdGen 0) 100
λ> runR 1
100 total attempts
100 successes
0 failures
2.0 average number of room visits per success
NaN average number of room visits per failure

λ> runR 2
100 total attempts
100 successes
0 failures
18.35 average number of room visits per success
NaN average number of room visits per failure

λ> runR 3
100 total attempts
100 successes
0 failures
31.92 average number of room visits per success
NaN average number of room visits per failure

λ> runR 4
100 total attempts
100 successes
0 failures
43.52 average number of room visits per success
NaN average number of room visits per failure

λ> runR 5
100 total attempts
100 successes
0 failures
55.88 average number of room visits per success
NaN average number of room visits per failure

λ> runR 6
100 total attempts
100 successes
0 failures
67.37 average number of room visits per success
NaN average number of room visits per failure

λ> runR 7
100 total attempts
100 successes
0 failures
77.05 average number of room visits per success
NaN average number of room visits per failure

λ> runR 8
100 total attempts
99 successes
1 failures
90.4040404040404 average number of room visits per success
81.0 average number of room visits per failure

λ> runR 9
100 total attempts
100 successes
0 failures
101.64 average number of room visits per success
NaN average number of room visits per failure

λ> runR 10
100 total attempts
100 successes
0 failures
114.89 average number of room visits per success
NaN average number of room visits per failure
```

Not bad at all!  Although my puny VPS still can't manage all 100.
