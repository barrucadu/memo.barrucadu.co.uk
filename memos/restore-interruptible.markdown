---
title: It's not a no-op to unmask an interruptible operation (and dejafu detects this)
taxon: general
tags: concurrency, dejafu, haskell, programming
published: 2021-05-30
---

User effectfully on reddit wrote an article [It's not a no-op to
unmask an interruptible operation][] ([reddit discussion][]) about a
small gotcha with interruptible operations and asynchronous
exceptions.

The gist of it is that this snippet of code:

```haskell
mask $ \restore -> do
  putMVar var x
  ...
```

behaves differently to this snippet of code:

```haskell
mask $ \restore -> do
  restore $ putMVar var x
  ...
```

in the presence of asynchronous exceptions.  The post goes on to
explain what the different behaviours are and why they crop up; but
thinking about concurrency is too much like effort, let's turn to
[dejafu][]!

[It's not a no-op to unmask an interruptible operation]: https://github.com/effectfully-ou/sketches/tree/master/restore-interruptible
[reddit discussion]: https://old.reddit.com/r/haskell/comments/nntfui/its_not_a_noop_to_unmask_an_interruptible/
[dejafu]: http://hackage.haskell.org/package/dejafu


## No restore around the put

In this test case, I want to see

1. if the `putMVar var x` is interrupted by an asynchronous exception; and
2. if the `...` bit of code gets executed

So the actual test case is a bit more complex than just the snippet
above.  We're going to need three threads:

```haskell
thread1 = mask $ \restore -> catch
  (putMVar var "hello world" >> putMVar success True)
  (\(_ :: SomeException) -> putMVar success False)

thread2 = putMVar var "interrupted!"

thread3 = killThread thread1
```

Putting it together into an actual test case, we get:

```haskell
import Control.Concurrent.Classy
import Control.Exception (SomeException)

example1 :: MonadConc m => m (String, Bool)
example1 = do
  var <- newEmptyMVar
  success <- newEmptyMVar
  interruptMe <- newEmptyMVar

  tid <- fork $ mask $ \_ -> do
    putMVar interruptMe ()
    catch
      (putMVar var "hello world" >> putMVar success True)
      (\(_ :: SomeException) -> putMVar success False)

  -- wait for the thread to be inside the `mask`, then fork a thread
  -- to race on the `putMVar` and also throw an async exception.
  takeMVar interruptMe
  _ <- fork $ putMVar var "interrupted!"
  killThread tid

  (,) <$> readMVar var <*> readMVar success
```

There's a little extra ceremony involved in making sure that the race
happens *after* the `mask`---we need a new `interruptMe` `MVar`---but
other than that it's fairly straightforward.

dejafu finds two behaviours for this example, and gives abbreviated
execution traces:

```
> autocheck example1
[pass] Successful
[fail] Deterministic
    ("hello world",True) S0-----S1--------S0------

    ("interrupted!",False) S0-----S1---P0---S2--S1-S0---S1---S0--
False
```


## Do restore around the put

Here's our new test case:

```haskell
import Control.Concurrent.Classy
import Control.Exception (SomeException)

example2 :: MonadConc m => m (String, Bool)
example2 = do
  interruptMe <- newEmptyMVar
  var <- newEmptyMVar
  success <- newEmptyMVar

  tid <- fork $ mask $ \restore -> do
    putMVar interruptMe ()
    catch
      (restore (putMVar var "hello world") >> putMVar success True)
      (\(_ :: SomeException) -> putMVar success False)

  -- wait for the thread to be inside the `mask`, then fork a thread
  -- to race on the `putMVar` and also throw an async exception.
  takeMVar interruptMe
  _ <- fork $ putMVar var "interrupted!"
  killThread tid

  (,) <$> readMVar var <*> readMVar success
```

Lo and behold, dejafu finds a *third* behaviour:

```
> autocheck example2
[pass] Successful
[fail] Deterministic
    ("hello world",True) S0-----S1-----------S0------

    ("hello world",False) S0-----S1-----P0-----S1---S0--

    ("interrupted!",False) S0-----S1----P0----S1---S2--S0---
False
```

So it seems that we can now end up in the situation where the `putMVar
var "hello world"` does happen, but *after* writing to the `MVar` the
asynchronous exception is delivered and so we hit the `putMVar success
False` case.

Weird, right?


## What's the difference?

We can get the actual execution trace for the new case with a
lower-level function in dejafu, `runSCT`.  Digging through it, we can
find the pre-emption of thread 1 (the first thread forked) by thread 0
(the main thread):

```haskell
(SwitchTo main, [(1, WillResetMasking True MaskedInterruptible)], TakeMVar 1 [])
```

This says that we switched to the main thread, and it performed a
`takeMVar` operation.  And furthermore, that thread 1 *will next*
reset the masking state back to `MaskedInterruptible`.

Now the issue becomes clear.  The problematic snippet:

```haskell
mask $ \restore -> do
  restore $ putMVar var x
  ...
```

Actually means to perform these steps:

1. Change the masking state to `MaskedInterruptible`
2. Change the masking state to `Unmasked`
3. Do `putMVar var x`
4. Reset the masking state back to `MaskedInterruptible`
5. Do `...`

The issue is that completing the `putMVar var x` call and resetting
the masking state are *two* operations.  That's not atomic.  So there
is a chance that an exception can be delivered between them.

And that's the issue explained in [It's not a no-op to unmask an
interruptible operation][], replicated with dejafu.
