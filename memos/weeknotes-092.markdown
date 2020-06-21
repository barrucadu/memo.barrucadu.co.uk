---
title: "Weeknotes: 092"
taxon: weeknotes-2020
date: 2020-06-21
---

## PLDI

It was <abbr title="ACM SIGPLAN Conference on Programming Language Design and Implementation">PLDI</abbr>
this week, which was virtual and free due to the pandemic.  It was
done pretty well: Slack and a video chat platform for interaction,
talks streamed to Youtube, and questions submitted to speakers via
Slack threads.  William J. Bowman collected [a few comments about the
format from Twitter][].

I managed to catch a few of the sessions live:

- [Armada: Low-Effort Verification of High-Performance Concurrent Programs](https://youtu.be/wFSmOxcUcu8?t=22465)

    About a tool to help verify the correctness of code under x86-TSO.
    The developer writes their program, and their specification, and
    asks Armada to automatically generate a proof of refinement.  If
    it can't, the developer can supply an intermediate level.  This is
    much less tedious than manually coming up with the whole proof of
    refinement yourself, and all the intermediate levels can use the
    full specification language (eg, unbounded integers,
    nondeterminism, sequentially consistent assignments).

- [Efficient Handling of String-Number Conversion](https://youtu.be/RJk45mOdN0k?t=3306)

    I picked this talk entirely based on the title, thinking "surely
    converting between strings and numbers is a solved problem".
    Turns out the talk is about symbolic execution, because existing
    SMT solvers aren't good at strings.  Interesting.  Also turns out
    that the work is motivated by JavaScript's wacky semantics.  Ew.
    Turns out in Javascript `x[1]` and `x["1"]` are exactly the same,
    because a property name is an array index if and only if you can
    round-trip it through a string/int conversion; so `x["01"]` is
    *not* the same because the round-trip loses the leading `"0"`.

- [OOElala: Order-of-Evaluation Based Alias Analysis for Compiler Optimization](https://youtu.be/e0A2Qh3eQn8?t=2194)

    About using the C order-of-evaluation semantics to infer "must not
    alias" relations between pointers.  This is one of those ideas
    where I was surprised compilers weren't doing it already, because
    from the presentation it seems to be sensible (just using a class
    of undefined behaviour to make assumptions about the program,
    which GCC and Clang already do heavily), to not cause problems in
    real-world code, and to be a clear win for performance in every
    benchmark they tried.

- [Promising 2.0: Global Optimizations in Relaxed Memory Concurrency](https://youtu.be/AqL-v29fpNc?t=1733)

    About a new relaxed memory semantics for combining global and
    thread-local optimisations in compilers, without introducing new
    behaviours which were not previously visible.  Program
    optimisation in the presence of nondeterminism (and relaxed memory
    is the ultimate in nondeterminism!) is tricky, so this is very
    cool work.

- [Semantic Code Search via Equational Reasoning](https://youtu.be/_lHLe_R8LhI?t=8969)

    About a tool based on term-rewriting to find patterns in code,
    even across language boundaries.  The talk seems to open with the
    motivation of refactoring, which I thought was really weak, as
    writing the translation from concrete code into abstract terms
    seems like it would be far too much work... then near the end the
    speaker gives a small example of using it for static analysis, and
    it was great!  "This is it," I thought, "this is a great idea for
    bug finding!"  Shame that they didn't present that motivation
    up-front, as I spent almost the whole talk feeling really
    sceptical.

- [Towards an API for the Real Numbers](https://youtu.be/RJk45mOdN0k?t=8133)

    This is about how the Android calculator app represents real
    numbers, in a way which gives arbitrary precision with decidable
    equality.  The representation is a combination of a symbolic one
    with decidable equality and a recursive one with semidecidable
    equality, with some normalisation tricks to keep things in the
    symbolic form for as long as possible.

- [Verifying Concurrent Search Structure Templates](https://youtu.be/wFSmOxcUcu8?t=21284)

    About a method to split apart the concurrency and memory safety
    aspects of a proof of correctness for concurrent search
    structures, meaning you can write simpler, more modular, proofs.

I also saw a few of the "ask me anything" sessions:

- ["Ask Me Anything" with Guy L. Steele Jr.](https://youtu.be/hUQKaTH9TMo?t=13320)
- ["Ask Me Anything" with Simon Peyton Jones](https://youtu.be/jGgQmnPH0dQ?t=104)

These were great, I hope this format or something similar sticks
around for future conferences.

The videos for all the sessions are available on the [ACM SIGPLAN
Youtube channel][].  I don't think the <abbr title="ACM SIGPLAN International Symposium on Memory Management">ISMM</abbr>
videos are yet, I hope they do go up because there are a few I wanted
to check out.

[a few comments about the format from Twitter]: https://www.williamjbowman.com/blog/2020/06/19/a-summary-of-discussions-on-virtual-conferences/
[ACM SIGPLAN Youtube channel]: https://www.youtube.com/channel/UCwG9512Wm7jSS6Iqshz4Dpg/videos


## Open Source

[Mitchell Rosen][] opened [a bug report on dejafu][] for a problem
with masks and exception handlers.  If you have this test case:

```haskell
test = do
  var <- newEmptyMVar
  tId <- uninterruptibleMask $ \restore -> fork $ do
    result <- (Right <$> restore (throw ThreadKilled)) `catch` (pure . Left)
    putMVar var result
  killThread tId
  v <- takeMVar var
  pure (v :: Either AsyncException ())
```

The thread should *always* put into the `MVar`, because the call to
`catch` is outside the `restore`; therefore as soon as `throw` is
called, the masking state reverts to uninterruptible, and the
`killThread` cannot happen.

Previously, dejafu handled these masking state changes by inserting an
`AResetMask` action as the first action of the handler.  But this is
incorrect, because it means the masking state is not restored
atomically, and so the `killThread` has a small window of opportunity
to, well, kill the thread.

I've [implemented a fix][], and am just waiting for Mitchell to
confirm it solves his problem before merging it and making a release.

This will be *yet another* major release of dejafu, because it changes
the `ThreadAction` type.  It's not good that I've ended up in a
situation where more or less every change to dejafu breaks some API;
but I'm not sure how to fix that yet.

[Mitchell Rosen]: https://twitter.com/mitchellsalad
[a bug report on dejafu]: https://github.com/barrucadu/dejafu/issues/324
[implemented a fix]: https://github.com/barrucadu/dejafu/pull/325


## Work

This week was a bit of a learning experience.  Development and user
research had got rather out of sync, with development being a few
weeks ahead, so we found ourselves in the tricky situation of almost
having to make busy-work (like improving the test coverage and
deployment process of our prototype which is almost certainly going to
be thrown away at some point).

I was also a bit unsure of what was actually expected at the end of
our 6-week discovery period: was it an MVP we could put in front of
users?  If so, research being as far behind as it was would be a real
problem.

This culminated in a dev who had recently joined the team scheduling a
couple of meetings to figure this all out.  On the one hand it's good
that he did and that we got some clarity, on the other hand, I should
have realised that if *I* was unsure, everyone else must be *more*
unsure, and done that myself.


## The Plague

[The alert level went down][], so things are re-opening.  I don't
expect things to change much for me though, as GDS is still working
from home for the foreseeable future.  And even if the office were to
re-open, with social distancing still in place capacity would be
greatly reduced, so people would be staying at home a lot more anyway.

[The alert level went down]: https://www.bbc.co.uk/news/uk-53106673


## Books

This week I read:

- **The King in Yellow**, a graphic novel adaptation by
  [I. N. J. Culbard][].

- Volume 11 of **[Overlord][]**, which I read in preparation for
  volume 12 arriving this week... but then on the morning of the
  delivery Amazon changed the item to "out of stock" and the tracking
  information to "order received".  That's kind of annoying, as I
  pre-ordered it.

And I started reading **[Tales of the Dying Earth][]**, by Jack Vance.

[I. N. J. Culbard]: https://en.wikipedia.org/wiki/Ian_Culbard
[Overlord]: https://en.wikipedia.org/wiki/Overlord_(novel_series)
[Tales of the Dying Earth]: https://en.wikipedia.org/wiki/Dying_Earth


## Games

This week my D&D DM was feeling unwell and not up to running a
session, so we played a game of [Microscope][] instead.  Microscope is
a game about collaboratively creative an epic history.  There's no GM,
and no persistent player characters (though sometimes the players will
roleplay a scene, and temporarily have a character), and the history
is created non-linearly; so I'd describe it as a story game rather
than an RPG.  It was very fun, though the steampunk history we were
creating turned really dark really quickly...

I wrote up a memo on [phased real-time combat for Call of Cthulhu][],
an alternative to the standard sequential round structure, which I
think addresses some problems with the system.

[Microscope]: http://www.lamemage.com/microscope/
[phased real-time combat for Call of Cthulhu]: phased-realtime-combat-call-of-cthulhu.html

## Link Roundup

- [Dogs’ Eyes Have Changed Since Humans Befriended Them](https://www.theatlantic.com/science/archive/2019/06/domestication-gave-dogs-two-new-eye-muscles/591868/)
- [Why Do Humans Talk to Animals If They Can’t Understand?](https://www.theatlantic.com/health/archive/2017/08/talking-to-pets/537225/)
- [Lain Thought on End-To-End Encryption with AP Characteristics for a New Era](https://blog.soykaf.com/post/encryption/)
- [Linear types are merged in GHC](https://www.tweag.io/blog/2020-06-19-linear-types-merged/)
- [Issue 216 :: Haskell Weekly](https://haskellweekly.news/issue/216.html)
- [This Week in Rust 343](https://this-week-in-rust.org/blog/2020/06/16/this-week-in-rust-343/)
- [The Rise of Platform Engineering](https://softwareengineeringdaily.com/2020/02/13/setting-the-stage-for-platform-engineering/)
