---
title: "Weeknotes: 020"
tags: weeknotes
date: 2019-02-03
audience: General
---

## Ph.D

- I passed.

  ![Section of Ph.D report showing that the examiners recommend the degree be awarded with no corrections.](/weeknotes-020/thesis.png)

  There's one optional correction, writing about some closely related
  work I haven't mentioned, but I'm undecided whether I want to do
  that yet.

## Work

- Continued with setting up the [new search service][], and the
  machinery for it to be kept in sync with the [old search service][]
  while we're running both in parallel temporarily.  Had a meeting
  with the AWS Migration Team about how our strands of work are going
  to interact.  Wrote some Terraform to create a new AWS managed
  ElasticSearch cluster (or a "domain", as AWS calls it).

[new search service]: https://github.com/alphagov/search-api
[old search service]: https://github.com/alphagov/rummager

## Miscellaneous

- I implemented [concurrency invariants][] in the dejafu 2.0.0.0
  branch.  These let you check properties of shared state, and abort
  the computation by throwing an exception if you don't like it.
  Here's a very contrived example:

  ```haskell
  let setup = do
        var <- newEmptyMVar
        registerInvariant $ do
          value <- inspectMVar var
          when (value == Just False) $
            throwM (AssertionFailed "MVar contains False")
        pure var
  in withSetup setup $ \var -> do
       fork $ putMVar var True
       fork $ putMVar var False
       readMVar var
  ```

  Here we create an `MVar` called `var`, and create an invariant
  (`registerInvariant`) which reads it (`inspectMVar`) and checks that
  it doesn't contain the value `False`.  The main computation forks
  two threads, one writes `True` to the `MVar`, the other writes
  `False`, and then reads it.  In executions where the `False` thread
  wins, the computation will be terminated *immediately after the
  `putMVar`* with an `InvariantFailure` condition, which contains the
  exception which was raised.

  There's a few things to note here:

  - The invariant checker isn't totally naive, it only tests an
    invariant if one of the shared variables (which can be `IORef`s,
    `MVar`s, or `TVar`s) have been written to since the last time the
    invariant passed.

  - Invariants are atomic, and have no visible side-effects.  They
    don't change the values of any shared variables, and they don't
    enforce a memory barrier.  This is achieved by using a new
    `Invariant` monad to limit what you can do, rather than allowing
    arbitrary concurrency effects.

  - Invariants (and so the shared variables they check) have to be
    created in the setup phase, and get checked in the main phase.
    Creating an invariant in the main phase won't achieve anything.

  The only things remaining in my dejafu 2.0.0.0 checklist are
  documentation things, and having a go at optimising it.  Though,
  unsurprisingly, I optimised all the low-hanging fruit in dejafu a
  while ago.

- I found that [Adjoint][] are using dejafu in the [testsuite of their
  Raft library for Haskell][], which is pretty neat.  I think all the
  actual uses of dejafu I've come across in the wild are for
  distributed systems---which I didn't design it to support---and not
  regular concurrent programs---which I did.

- I finally had a use for what I'm calling the "'~' instance pattern",
  and [wrote a memo][].

- I was pleasantly surprised by how easy switching bank accounts is.
  I used the Current Account Switch Service to change from Santander
  (who finally bumped me off a graduate account, onto one with no
  interest) to Nationwide (and an account which does give interest),
  and everything just worked.  The only things I changed manually were
  a couple of services which were using my debit card details (rather
  than a direct debit) to do billing.

- I fermented some carrot sticks, with some cloves of garlic and
  radishes, and they turned out pretty well after five days.  I
  probably should have thought about what to use them for beforehand.
  Apparently they can be [used in borscht][], though I used regular
  carrots, rather than the black carrots the recipe calls for.

- I got the urge to play some [Runescape][] on Saturday evening, and
  made a new account.  In some ways it's very different to when I last
  played, but in others very similar.  The graphics are still pretty
  bad (which is funny as it told me to upgrade my graphics drivers),
  but it's fun.

[concurrency invariants]: https://github.com/barrucadu/dejafu/commit/129c21912e36e4015c610460c3c4077c997a3096
[Adjoint]: https://www.adjoint.io/
[testsuite of their Raft library for Haskell]: https://github.com/adjoint-io/raft/blob/master/test/TestDejaFu.hs
[wrote a memo]: /tilde-instance-pattern.html
[used in borscht]: https://bellyovermind.com/2018/02/07/fermented-black-carrot-borscht-soup/
[Runescape]: https://www.runescape.com/

## Link Roundup

- [Programming paradigms for dummies: what every programmer should know](https://blog.acolyer.org/2019/01/25/programming-paradigms-for-dummies-what-every-programmer-should-know/)
- [I Cut Google Out Of My Life. It Screwed Up Everything](https://gizmodo.com/i-cut-google-out-of-my-life-it-screwed-up-everything-1830565500)
- [This Week in Rust 271](https://this-week-in-rust.org/blog/2019/01/29/this-week-in-rust-271/)
- [Mention your favorite Haskell-related conference talk ?](https://www.reddit.com/r/haskell/comments/akx68e/mention_your_favorite_haskellrelated_conference/)
- [Issue 144 :: Haskell Weekly](https://haskellweekly.news/issues/144.html)
- [Comparing nub implementations](https://andreaspk.github.io/posts/2019-02-01-nub-benchmarks.html)
- [Pirate-Powered CDNs Operate Innovative Illicit Streaming Model](https://torrentfreak.com/pirate-powered-cdns-operate-innovative-illicit-streaming-model-190203/)
- [Haskell Weekly in 2018](https://taylor.fausak.me/2019/02/03/haskell-weekly-in-2018/)
- [The ReaderT Design Pattern](https://www.fpcomplete.com/blog/2017/06/readert-design-pattern)
- [An epic treatise on scheduling, bug tracking, and triage](https://apenwarr.ca/log/20171213)
