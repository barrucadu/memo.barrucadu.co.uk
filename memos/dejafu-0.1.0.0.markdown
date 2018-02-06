---
title: dejafu-0.1.0.0
tags: dejafu, haskell, programming, release notes
date: 2015-08-27
audience: Haskell programmers.
notice: dejafu is a Haskell library for testing concurrent programs.
---

**I will be giving a presentation about Déjà Fu at the Haskell
  Symposium next week.**

Déjà Fu is a library for developing and testing concurrent Haskell
programs, it provides a typeclass-abstraction over GHC's regular
concurrency API, allowing the concrete implementation to be swapped
out.

<div style="text-align:center">
**[Git][] --- [Hackage][] --- [Jenkins][]**
</div>

[Git]:     https://github.com/barrucadu/dejafu
[Hackage]: https://hackage.haskell.org/package/dejafu-0.1.0.0
[Jenkins]: http://ci.barrucadu.co.uk/job/(dejafu)/

Why do we need this? Well, concurrency is really hard to get
right. Empirical studies have found that many real-world concurrency
bugs can be exhibited with small test cases using as few as two
threads: so it's not just big concurrent programs that are hard, small
ones are too. We as programmers just don't seem to have a very good
intuition for traditional threads-and-shared-memory-style
concurrency. The typical approach to testing concurrent programs is to
just run them lots of times, but that doesn't provide any hard
coverage guarantees, and then we need to wonder: how many runs do we
need?

Fortunately, there has been a lot of research into testing concurrency
in the past several years. *Systematic* concurrency testing is an
approach where the source of nondeterminism, the actual scheduler, is
swapped out for one under the control of the testing framework. This
allows possible schedules to be systematically explored, giving real
coverage guarantees for our tests.

This is a library implementing systematic concurrency testing. It
provides two typeclasses, [MonadConc][] to abstract over much of
Control.Concurrent and related modules, and [MonadSTM][], to similarly
abstract over Control.Monad.STM.

[MonadConc]: https://barrucadu.github.io/dejafu/Control-Monad-Conc-Class.html
[MonadSTM]:  https://barrucadu.github.io/dejafu/Control-Monad-STM-Class.html

### How to use it

If you're not making use of any IO in your code other than for
concurrency, the transition to using `MonadConc` and `MonadSTM` will
probably just be a textual substitution:

- `IO` is replaced with `MonadConc m => m`
- `STM` with `MonadSTM m => m`
- `*IORef` with `*CRef`
- `*MVar` with `*CVar`
- `*TVar` with `*CTVar`
- Most other things have the same name, and so can be replaced by just
  swapping imports around.

If you *are* using other IO, you will need a gentle sprinkling of
`MonadIO` and `liftIO` in your code as well.

## Is this really just a drop-in replacement for IO/STM?

That's the idea, yes.

More specifically, the IO instance of `MonadConc` and the STM instance
of `MonadSTM` just use the regular IO and STM functions, and so should
have no noticeable change in behaviour, **except** for `CRef`, the
`IORef` equivalent, where `modifyCRef` behaves like
`atomicModifyIORef`, not `modifyIORef`[^departures].

[^departures]: There are some other differences which can lead to
incorrect results when testing, but which should **not** affect code
when used in an IO or STM context. Specifically:
`Control.Monad.Conc.Class.getNumCapabilities` can lie to encourage
more concurrency when testing; and `Control.Exception.catch` can catch
exceptions from pure code, but `Control.Monad.Conc.Class.catch` can't
(except for the IO instance).

### Related blog posts

- [Haskell Systematic Concurrency Testing][]: My first approach was to
  use a Par-like model based on two typeclasses capturing what can be
  done with shared state. This is alright if all you care about are
  `MVar`s, but starts to feel a bit forced once you start to add in
  things like STM and exceptions.

- [Pre-emption Bounding][]: There are a lot of possible schedules,
  even for very simple cases. Some method of reducing them must be
  used in order to complete testing in a sensible amount of time. One
  simple approach is to just limit the number of pre-emptive context
  switches in a schedule.

- [Reducing Combinatorial Explosion][]: Pre-emption bounding works,
  but still results in a lot of redundant work being done. We can
  characterise the execution of a concurrent program by the ordering
  of *dependent* events, as that is all which can affect the
  result. This lets us massively reduce the number of schedules to
  test, and is core of the technique used in this release.

[Haskell Systematic Concurrency Testing]:
  /posts/2014-12-26-haskell-systematic-concurrency-testing.html

[Pre-emption Bounding]:
  /posts/2015-01-10-pre-emption-bounding.html

[Reducing Combinatorial Explosion]:
  /posts/2015-08-21-reducing-combinatorial-explosion.html

### Related papers

- *[Déjà Fu: A Concurrency Testing Library for Haskell][]*
  (M. Walker and C. Runciman)

- *[Concurrency Testing using Schedule Bounding: an Empirical Study][]*
  (P. Thompson, A. Donaldson, and A. Betts)

- *[Bounded Partial-order Reduction][]*
  (K. Coons, M. Musuvathi, and K. McKinley)

- *[Partial-Order Methods for the Verification of Concurrent Systems][]*
  (P. Godefroid)

[Déjà Fu: A Concurrency Testing Library for Haskell]:
  /publications/dejafu-hs15.pdf

[Concurrency Testing using Schedule Bounding: an Empirical Study]:
  https://dl.acm.org/citation.cfm?id=2555260

[Bounded Partial-order Reduction]:
  https://dl.acm.org/citation.cfm?id=2509136.2509556

[Partial-Order Methods for the Verification of Concurrent Systems]:
  https://dl.acm.org/citation.cfm?id=547238
