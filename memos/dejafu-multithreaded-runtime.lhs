---
title: A Multithreaded Runtime for Deja Fu
tags: concurrency, dejafu, haskell, programming, research
date: 2017-10-03
audience: People interested in the dejafu internals.
---

The dejafu situation currently looks something like this:

1. We have a *typeclass* abstracting over concurrency.
    - There's an implementation of this typeclass using `IO`.
    - There's also an implementation of this typeclass using a custom monad transformer called
      `ConcT`.

2. Computations of type `MonadRef r n => ConcT r n a` can be executed with a given scheduler, to
   produce a result and an execution trace.

3. Unlike `IO`, the threads in a `ConcT r n` computation are executed in a single-step fashion based
   on the decisions of the scheduler.

4. To implement this single-step execution, all threads are executed in a single "real" thread.

It's the third point that gives dejafu the ability to systematically explore different executions.
If execution were not single-step, then it wouldn't be possible in general to context switch between
arbitrary concurrency actions.

The fourth point greatly simplifies the implementation, but also causes problems: GHC Haskell has a
notion of "bound threads", which are Haskell threads bound to a particular OS thread.  Bound threads
are absolutely essential to use FFI calls which rely on thread-local state.  **Deja Fu cannot
support bound threads if it executes everything in a single thread!**

How can we address this?


PULSE
-----

[PULSE][] is a concurrency-testing tool for Erlang.  It works by code instrumentation: around every
communication operation is inserted a call to the PULSE scheduler process.  The scheduler process
tells processes when they can run.  Execution is *not* serialised into a single thread, the distinct
Erlang processes still exist, but only one of them may run at a time.

[PULSE]: http://www.cse.chalmers.se/~nicsma/papers/finding-race-conditions.pdf

We can do the same thing in Haskell.


Mini Fu
-------

Let's look at a much simplified version of dejafu to try this idea out.

> {-# LANGUAGE GeneralizedNewtypeDeriving #-}
> {-# LANGUAGE ExistentialQuantification #-}
> {-# LANGUAGE TypeFamilies #-}
>
> import qualified Control.Concurrent as C
> import qualified Control.Monad.Cont as K
> import Data.List.NonEmpty (NonEmpty(..), nonEmpty)
> import qualified Data.Map as M
> import Data.Maybe (isNothing)
> import qualified System.Random as R
>
> class Monad m => MonadConc m where
>   type ThreadId m :: *
>   type MVar     m :: * -> *
>
>   fork   :: m () -> m (ThreadId m)
>   forkOS :: m () -> m (ThreadId m)
>
>   newEmptyMVar :: m (MVar m a)
>   putMVar  :: MVar m a -> a -> m ()
>   takeMVar :: MVar m a -> m a
>
> newMVar :: MonadConc m => a -> m (MVar m a)
> newMVar a = do
>   v <- newEmptyMVar
>   putMVar v a
>   pure v

There's a straightforward implementation for `IO`:

> instance MonadConc IO where
>   type ThreadId IO = C.ThreadId
>   type MVar     IO = C.MVar
>
>   fork   = C.forkIO
>   forkOS = C.forkOS
>
>   newEmptyMVar = C.newEmptyMVar
>   putMVar  = C.putMVar
>   takeMVar = C.takeMVar

The testing implementation is a little hairier.  Because we want to be able to single-step it, we'll
use continuations:

> newtype ConcT m a = ConcT { runConcT :: K.Cont (Action m) a }
>   deriving (Functor, Applicative, Monad)
>
> newtype CTThreadId = CTThreadId Int
>   deriving (Eq, Ord)
>
> data CTMVar m a = CTMVar { mvarID :: Int, mvarRef :: MVar m (Maybe a) }
>
> data Action m
>   = Fork   (ConcT m ()) (CTThreadId -> Action m)
>   | ForkOS (ConcT m ()) (CTThreadId -> Action m)
>   | forall a. NewEmptyMVar (CTMVar m a -> Action m)
>   | forall a. PutMVar  (CTMVar m a) a (Action m)
>   | forall a. TakeMVar (CTMVar m a)   (a -> Action m)
>   | Stop (m ())
>
> instance MonadConc (ConcT m) where
>   type ThreadId (ConcT m) = CTThreadId
>   type MVar     (ConcT m) = CTMVar m
>
>   fork   ma = ConcT (K.cont (Fork   ma))
>   forkOS ma = ConcT (K.cont (ForkOS ma))
>
>   newEmptyMVar = ConcT (K.cont NewEmptyMVar)
>   putMVar  mvar a = ConcT (K.cont (\k -> PutMVar mvar a (k ())))
>   takeMVar mvar   = ConcT (K.cont (TakeMVar mvar))

Let's talk about the `Action` type a bit before moving on.  The general structure is
`Name [<args> ...] (<result> -> Action m)`, where `m` is some `MonadConc`.  For `MVar`s, we're
just re-using the `MVar` type of the underlying monad (dejafu proper re-uses the `IORef`s of the
underlying monad).  For `ThreadId`s we're using `Int`s.  And we're going to get the final result out
of the computation with the `Stop` action.


Implementing Mini Fu
--------------------

Let's keep things simple and not support most of the fancy scheduling stuff dejafu does.  Our
scheduler is just going to be a stateful function from runnable threads to a single thread:

> type Scheduler s = NonEmpty CTThreadId -> s -> (CTThreadId, s)

So now our execution function is going to look like this:

> minifu :: MonadConc m => Scheduler s -> s -> ConcT m a -> m (Maybe a, s)
> minifu sched s (ConcT ma) = do
>   out <- newMVar Nothing
>   s'  <- run sched s (K.runCont ma (\a -> Stop (takeMVar out >> putMVar out (Just a))))
>   a   <- takeMVar out
>   pure (a, s')

The real meat is the `run` function:

> run :: MonadConc m => Scheduler s -> s -> Action m -> m s
> run sched s0 a0 = go s0 initialIdSource =<< initialThreads a0 where
>   go s ids threads
>     | initialThreadId `M.member` threads = case runnable threads of
>       Just tids ->
>         let (chosen, s') = sched tids s
>         in uncurry (go s') =<< loopStepThread ids chosen threads
>       Nothing -> pure s
>     | otherwise = pure s
>
>   runnable = nonEmpty . M.keys . M.filter (isNothing . blockedOn)

Like in dejafu proper, execution is going to if the main thread terminates, even if there are other
threads.  Threads are going to live in a map keyed by `ThreadId`.

> type Threads m = M.Map CTThreadId (Thread m)
>
> initialThreads :: MonadConc m => Action m -> m (Threads m)
> initialThreads a0 = do
>   t <- forkThread False a0
>   pure (M.singleton initialThreadId t)
>
> initialThreadId :: CTThreadId
> initialThreadId = CTThreadId 0

Each thread in our program-under-test is going to be executed in an actual thread.  So, like PULSE,
we'll introduce communication (in the form of `MVar`s) around concurrency actions to ensure that we
get single-step execution.  So a thread is going to have three components: the `MVar` (if any) it's
currently blocked on, an `MVar` to signal that it should execute one step, and an `MVar` to
communicate what the thread did.

> data Thread m = Thread
>   { blockedOn   :: Maybe Int
>   , signalStep  :: MVar m IdSource
>   , awaitResult :: MVar m (IdSource, ThreadResult m)
>   }
>
> data ThreadResult m
>   = BusinessAsUsual
>   | Killed
>   | Updated Int
>   | Blocked Int
>   | Forked (Thread m)

The `IdSource` is used to generate new unique thread and `MVar` IDs:

> type IdSource = (Int, Int)
>
> initialIdSource :: IdSource
> initialIdSource = (1, 0)
>
> nextThreadId :: IdSource -> (CTThreadId, IdSource)
> nextThreadId (t, m) = (CTThreadId t, (t + 1, m))
>
> nextMVarId :: IdSource -> (Int, IdSource)
> nextMVarId (t, m) = (m, (t, m + 1))

Forking a thread is going to set up these `MVar`s and the small bit of logic to ensure things happen
as we like:

> forkThread :: MonadConc m => Bool -> Action m -> m (Thread m)
> forkThread isOS act = do
>   signal <- newEmptyMVar
>   await  <- newEmptyMVar
>   _ <- (if isOS then forkOS else fork) (runThread signal await act)
>   pure (Thread Nothing signal await)
>
> runThread :: MonadConc m => MVar m IdSource -> MVar m (IdSource, ThreadResult m) -> Action m -> m ()
> runThread signal await = go where
>   go act = do
>     ids <- takeMVar signal
>     (act', ids', res) <- runStepThread ids act
>     putMVar await (ids', res)
>     maybe (pure ()) go act'

The final pieces of the puzzle are the two `*StepThread` functions, which executes one action of our
chosen thread.  These are a little tricker than in normal dejafu.

Firstly, `loopStepThread`, which tells the thread that was chosen by the scheduler to step:

> loopStepThread :: MonadConc m => IdSource -> CTThreadId -> Threads m -> m (IdSource, Threads m)
> loopStepThread ids tid threads = case M.lookup tid threads of
>   Just thread -> do
>     putMVar (signalStep thread) ids
>     (ids', res) <- takeMVar (awaitResult thread)
>     let resf = case res of
>           BusinessAsUsual -> id
>           Killed -> M.delete tid
>           Updated i -> fmap (\t -> if blockedOn t == Just i then t { blockedOn = Nothing } else t)
>           Blocked i -> M.insert tid (thread { blockedOn = Just i })
>           Forked thread' -> M.insert (fst (nextThreadId ids)) thread'
>     pure (ids', resf threads)
>   Nothing -> pure (ids, threads)

Finally `runStepThread`, which executes an action:

> runStepThread :: MonadConc m => IdSource -> Action m -> m (Maybe (Action m), IdSource, ThreadResult m)
> runStepThread ids (Fork (ConcT ma) k) = do
>   t <- primFork False ma
>   let (tid', ids') = nextThreadId ids
>   pure (Just (k tid'), ids', Forked t)
> runStepThread ids (ForkOS (ConcT ma) k) = do
>   t <- primFork True ma
>   let (tid', ids') = nextThreadId ids
>   pure (Just (k tid'), ids', Forked t)
> runStepThread ids (NewEmptyMVar k) = do
>   v <- newEmptyMVar
>   putMVar v Nothing
>   let (mvid, ids') = nextMVarId ids
>   let mvar = CTMVar mvid v
>   pure (Just (k mvar), ids', BusinessAsUsual)
> runStepThread ids k0@(PutMVar (CTMVar mvid v) a k) = do
>   old <- takeMVar v
>   case old of
>     Just _  -> putMVar v old      >> pure (Just k0, ids, Blocked mvid)
>     Nothing -> putMVar v (Just a) >> pure (Just k, ids,  Updated mvid)
> runStepThread ids k0@(TakeMVar (CTMVar mvid v) k) = do
>   old <- takeMVar v
>   case old of
>     Nothing -> putMVar v old     >> pure (Just k0,    ids, Blocked mvid)
>     Just a  -> putMVar v Nothing >> pure (Just (k a), ids, Updated mvid)
> runStepThread ids (Stop ma) = do
>   ma
>   pure (Nothing, ids, Killed)
>
> primFork :: MonadConc m => Bool -> K.Cont (Action m) () -> m (Thread m)
> primFork isOS ma = forkThread isOS (K.runCont ma (\_ -> Stop (pure ())))

This looks pretty horrible, but each case is fairly small, so just look at those.

Now we can run it (with a random scheduler for fun) and see that it works:

> test :: MonadConc m => m Int
> test = do
>   a <- newEmptyMVar
>   b <- newMVar 2
>   c <- newMVar 3
>   forkOS (putMVar a b)
>   forkOS (putMVar a c)
>   forkOS (takeMVar b >> putMVar b 14)
>   forkOS (takeMVar c >> putMVar c 15)
>   takeMVar =<< takeMVar a
>
> randomSched :: Scheduler R.StdGen
> randomSched (t:|ts) g =
>   let (i, g') = R.randomR (0, length ts) g
>   in ((t:ts) !! i, g')
>
> main :: IO ()
> main = do
>   g <- R.newStdGen
>   print . fst =<< minifu randomSched g test

Giving:

```
λ> main
Just 14
λ> main
Just 2
λ> main
Just 14
λ> main
Just 2
λ> main
Just 14
λ> main
Just 14
λ> main
Just 15
λ> main
Just 15
```

That wasn't so bad!


Next Steps to Deja Fu
---------------------

Mini Fu is much smaller than Deja Fu, but it demonstrates the key concepts.  To get a multithreaded
runtime into dejafu, I think the main change to this stuff is to figure out how thread communication
is going to work: in dejafu proper, actions can change the continuation of an arbitrary thread (eg,
throwing an exception to a thread will call its exception handler).

The overhead of this method compared to the single-threaded approach must be measured.  It would be
great to support bound threads, but not at the cost of everything else becoming much worse!  If the
overhead is bad, perhaps a hybrid approach could be used: unbound threads in the program-under-test
are executed as they are currently, whereas bound threads get the fancy multithreaded
implementation.  It would complicate things, but possibly eliminate the overhead in the common case.

Finally, when the main thread terminates, any still-running ones should terminate as well, so the
`Thread` record will need to contain the `ThreadId m` of the underlying monad, so `killThread` can
be used.
