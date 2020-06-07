---
title: "Weeknotes: 090"
taxon: weeknotes-2020
date: 2020-06-07
---

## Open Source

It was reported that a bunch of recent dejafu git tags hadn't been
pushed to the GitHub repo, so I sorted that out.

I've also had a very weird bug reported:

```haskell
import Test.DejaFu
import Test.DejaFu.Conc.Internal.STM

import Control.Concurrent.Classy hiding (wait)
import Control.Concurrent.Classy.Async

test :: Program (WithSetup (ModelTVar IO Int)) IO Int
test = withSetup setup $ \tvar -> do
    a <- async (act tvar)
    b <- async (act tvar)
    _ <- waitCatch a
    _ <- waitCatch b
    atomically $ readTVar tvar

  where
    setup = atomically $ newTVar 0

    act tvar = do
      atomically $ modifyTVar tvar (+1)
      yield
      atomically $ modifyTVar tvar (subtract 1)
```

dejafu says that this has two possible results: 0 and 1.  But if I
remove the `setup` action and instead initialise the `TVar` directly
in the test, it always returns 0.  Furthermore, the issue only crops
up if the `yield` call is inserted.

Something very strange seems to be going on with STM, setup actions,
and yielding.

## Work

My first full week of tech leading, I've been prototyping stuff,
reaching out to teams in other departments who have worked on similar
projects for advice, and planning work to be done.  There's only three
devs, including myself, on the team, but we've been getting through
tasks at a good rate.  It seems I estimated the amount of work we
could get done in a sprint fairly well: we have our weekly planning on
Tuesdays, and there's only a couple of things remaining for Monday.

I've not really thought at all about the next sprint though, so I'll
probably spend all of Tuesday before planning doing that.

There's definitely a fair bit of organisational work, but I still have
plenty of time to do programming as well.

## The Plague

I managed to buy bread flour.  I then made a terrible loaf of bread;
must be out of practice.

## Books

This week I read [Royal Assassin][], the second in Robin Hobb's
Farseer trilogy.  I've been trying to stick to my 100-pages-a-day
target, but I've found weekends are harder to fit the reading in than
working days.

[Royal Assassin]: https://en.wikipedia.org/wiki/Royal_Assassin

## Games

I decided to end [my Apocalypse World game][], because I realised how
much less fun I was finding running it than [my Call of Cthulhu
game][].  We talked about games to run next, [I wrote up some
ideas][], but ultimately we decided to go for another player's pitch:
[Wolves of God][], a game set in Dark Ages Britain.  It's a fun
looking system, and has some neat things we'll have to get our heads
around, like the Anglo-Saxon gift economy.

So now I'm only running one of the four different fortnightly games
I'm in.

[my Apocalypse World game]: campaign-notes-2020-02-apocalypse-world.html
[my Call of Cthulhu game]: campaign-notes-2020-05-call-of-cthulhu.html
[I wrote up some ideas]: games-i-would-like-to-run.html
[Wolves of God]: https://www.drivethrurpg.com/product/308470/Wolves-of-God-Adventures-in-Dark-Ages-England

## Link Roundup

- ['Dord': A Ghost Word](https://www.merriam-webster.com/words-at-play/dord-a-ghost-word)
- [This Week in Rust 341](https://this-week-in-rust.org/blog/2020/06/02/this-week-in-rust-341/)
- [Issue 214 :: Haskell Weekly](https://haskellweekly.news/issue/214.html)
- [‘Did I miss anything?’: A man emerges from a 75-day silent retreat in Vermont](https://www.boston.com/news/local-news/2020/06/04/did-i-miss-anything-a-man-emerges-from-a-75-day-silent-retreat-in-vermont)
- [World Building Resources: What They Are and Which Ones You Need](https://medium.com/@samhhollon/world-building-resources-what-they-are-and-which-ones-you-need-4bda6cea4a29)
- [The RPG Social Contract (Revisited) - RPG Philosophy](https://www.youtube.com/watch?v=KBymJBOjwEc)
