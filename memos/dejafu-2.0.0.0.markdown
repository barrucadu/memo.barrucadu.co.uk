---
title: dejafu-2.0.0.0
tags: dejafu, haskell, programming, release notes
date: 2019-02-12
audience: General
---

(this message has also been sent to [/r/haskell][] and [haskell-cafe][])

[/r/haskell]: https://www.reddit.com/r/haskell/comments/aq09u5/ann_dejafu2000_a_library_for_unittesting/
[haskell-cafe]: https://mail.haskell.org/pipermail/haskell-cafe/2019-February/130694.html

---

I'm pleased to announce a new super-major release of [dejafu][1], a
library for testing concurrent Haskell programs.

While there are breaking changes, common use-cases shouldn't be
affected too significantly (or not at all).  There is a brief guide to
the changes, and how to migrate if necessary, [on the website][2].


What's dejafu?
--------------

dejafu is a unit-testing library for concurrent Haskell programs.
Tests are deterministic, and work by systematically exploring the
possible schedules of your concurrency-using test case, allowing you
to confidently check your threaded code.

[HUnit][3] and [Tasty][4] bindings are available.

dejafu requires your test case to be written against the `MonadConc`
typeclass from the [concurrency][5] package.  This is a necessity,
dejafu cannot peek inside your `IO` or `STM` actions, so it needs to
be able to plug in an alternative implementation of the concurrency
primitives for testing.  There is some guidance for how to switch from
`IO` code to `MonadConc` code [on the website][6].

If you really need `IO`, you can use `MonadIO` - but make sure it's
deterministic enough to not invalidate your tests!

Here's a small example reproducing a deadlock found in an earlier
version of the [auto-update][7] library:

```
> :{
autocheck $ do
  auto <- mkAutoUpdate defaultUpdateSettings
  auto
:}
[fail] Successful
    [deadlock] S0--------S1-----------S0-
[fail] Deterministic
    [deadlock] S0--------S1-----------S0-

    () S0--------S1--------p0--
```

dejafu finds the deadlock, and gives a simplified execution trace for
each distinct result.  More in-depth traces showing exactly what each
thread did are also available.  This is using a version of auto-update
modified to use the `MonadConc` typeclass.  The source is in the
[dejafu testsuite][8].


What's new?
-----------

The highlights for this release are setup actions, teardown actions,
and invariants:

- **Setup actions** are for things which are not really a part of your
  test case, but which are needed for it (for example, setting up a
  test distributed system).  As dejafu can run a single test case many
  times, repeating this work can be a significant overhead.  By
  defining this as a setup action, dejafu can "snapshot" the state at
  the end of the action, and efficiently reload it in subsequent
  executions of the same test.

- **Teardown actions** are for things you want to run after your test
  case completes, in all cases, even if the test deadlocks (for
  example).  As dejafu controls the concurrent execution of the test
  case, inspecting shared state is possible even if the test case
  fails to complete.

- **Invariants** are effect-free atomically-checked conditions over
  shared state which must always hold.  If an invariant throws an
  exception, the test case is aborted, and any teardown action run.

Here is an example of a setup action with an invariant:

```
> :{
autocheck $
  let setup = do
        var <- newEmptyMVar
        registerInvariant $ do
          value <- inspectMVar var
          when (value == Just 1) $
            throwM Overflow
        pure var
  in withSetup setup $ \var -> do
       fork $ putMVar var 0
       fork $ putMVar var 1
       tryReadMVar var
:}
[fail] Successful
    [invariant failure] S0--P2-
[fail] Deterministic
    [invariant failure] S0--P2-

    Nothing S0----

    Just 0 S0--P1--S0--
```

In the `[invariant failure]` case, thread 2 is scheduled, writing the
forbidden value "1" to the MVar, which terminates the test.

Here is an example of a setup action with a teardown action:

```
> :{
autocheck $
  let setup = newMVar ()
      teardown var (Right _) = show <$> tryReadMVar var
      teardown _   (Left  e) = pure (show e)
  in withSetupAndTeardown setup teardown $ \var -> do
       fork $ takeMVar var
       takeMVar var
:}
[pass] Successful
[fail] Deterministic
    "Nothing" S0---

    "Deadlock" S0-P1--S0-
```

The teardown action can perform arbitrary concurrency effects,
including inspecting any mutable state returned by the setup action.

Setup and teardown actions were previously available in a slightly
different form as the `dontCheck` and `subconcurrency` functions,
which have been removed (see the migration guide if you used these).

[1]: http://hackage.haskell.org/package/dejafu
[2]: https://dejafu.readthedocs.io/en/latest/migration_1x_2x.html
[3]: http://hackage.haskell.org/package/hunit-dejafu
[4]: http://hackage.haskell.org/package/tasty-dejafu
[5]: http://hackage.haskell.org/package/concurrency
[6]: https://dejafu.readthedocs.io/en/latest/typeclass.html
[7]: http://hackage.haskell.org/package/auto-update
[8]: https://github.com/barrucadu/dejafu/blob/master/dejafu-tests/lib/Examples/AutoUpdate.hs
