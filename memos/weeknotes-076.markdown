---
title: "Weeknotes: 076"
taxon: weeknotes-2020
date: 2020-03-01T19:00:00
audience: General
---

## Open Source

I made a few small dejafu changes:

- ([PR #308][]) Pulling in some changes from the stm package
- ([PR #310][]) Fixing an error message

I tried doing a little refactoring to rule out some error conditions,
but the resultant code was less clear.  I suspect I'm at (or very
close to) a local optimum with the current dejafu code.  Any
significant gains are likely to need a big rethink of the core
approach.

[PR #308]: https://github.com/barrucadu/dejafu/pull/308
[PR #310]: https://github.com/barrucadu/dejafu/pull/310

## Work

No work this week.  I'm back on Wednesday.

## Miscellaneous

This has been a good week for lazing around and doing nothing of
importance.

### Books

I finished reading [The Unicorn Project][].  Like The Phoenix Project,
which I read [a few weeks ago][], I wasn't terribly impressed.  It did
fix some of the flaws of The Phoenix Project: TPP is about ops, and
portrays them as pretty much infallible, merely misguided at times;
whereas TUP is about devs and they are fallible.  Well, except for the
main character.  To make everything right, you just need her to come
in and, with a little functional programming and CI/CD, she'll fix all
your bugs while also making your code way shorter.  The primary
antagonist of the book is an exec who, it seems, hates success.  Even
when they manage the biggest promotion event of the company's history,
she's all "we just don't have the DNA to do IT, we need to outsource
this before they run us into the ground."

I'd say it was less bad than The Phoenix Project, but not by much.

I also finished reading The Return of the King.  And I started reading
[The Vorrh][].

[The Unicorn Project]: https://www.goodreads.com/book/show/44333183-the-unicorn-project
[a few weeks ago]: weeknotes-074.html
[The Vorrh]: https://en.wikipedia.org/wiki/The_Vorrh

### Games

My [Apocalypse World][] game started this weekend.  I've started a
memo to write up the [session notes][].

I got and played [Taur][].  It's fun, but there are some aspects of
the game which feel a bit unpolished:

- Construction and research is done using gems which you get for
  completing missions.  The distribution of these gems is incredibly
  uneven, I've got dozens of some and none of others.  This means
  there's often just nothing I can do to improve my base, despite the
  enemies getting tougher and tougher.

- The game tells you that when some part of your base gets destroyed,
  you're refunded the full resources.  Sometimes that doesn't happen,
  so things will be destroyed and (because the distribution of gems is
  really uneven) it often takes a while to build back up.  So now
  you're facing tougher enemies with a weaker base than one which lost
  before.

- You can only construct or destroy parts of your base during
  missions, not between missions.  This is a pain because, while
  you're doing construction, time is still passing and the enemies are
  still attacking you!  Albeit slowly.

I also got [Middle-earth: Shadow of War][].  I've only played a few
hours of this so far, but it's been fun.  It's pretty similar to
[Shadow of Mordor][], which I enjoyed at the time.  For some reason
Shelob, the terrifying spider-demon spawn of Ungoliant, appears as a
human woman in this.  I guess they felt a talking spider might be a
bit much.

[Apocalypse World]: http://apocalypse-world.com/
[session notes]: apotheosis-session-notes.html
[Taur]: https://store.steampowered.com/app/1227780/Taur/
[Middle-earth: Shadow of War]: https://store.steampowered.com/app/356190/Middleearth_Shadow_of_War/
[Shadow of Mordor]: https://store.steampowered.com/app/241930/Middleearth_Shadow_of_Mordor/

### TV

I watched all of [Avatar: The Last Airbender][], which was massively
popular when it was on TV.  I see why, it's done really well.  There's
good character development, very little feels like filler material
(sadly, most of what *did* feel like filler was in the final season),
and the world is interesting.

I then started on [The Legend of Korra][], which some say is even
better.  I'm only a couple of episodes into that, but it's good so
far.

[Avatar: The Last Airbender]: https://en.wikipedia.org/wiki/Avatar:_The_Last_Airbender
[The Legend of Korra]: https://en.wikipedia.org/wiki/The_Legend_of_Korra

### Sleep

I've been plagued, basically as long as I can remember, with great
difficulty getting to sleep at night.  Various theories have been put
forth, none of which have really panned out:

- Don't have any caffeine after noon
- Don't use the computer for an hour before bed
- Only use the bedroom for sleeping (eg, not for reading)

I've even tried taking disgusting-tasting (non-prescription) sleeping
pills!

Since I started recording my sleep with an app about two years ago,
I've racked up a 700-hour deficit, which means I'm under-sleeping by
an average of one hour a night.  Though in practice my sleep duration
is usually between 8 and 5 hours a night, and the quarter-year average
as of when I started my time off was about 6.7 hours a night.

While I've been off I decided to do an experiment: set no alarms, go
to sleep when I'm tired, and see what the pattern looks like.  My
hypothesis was that I had somehow picked up a longer-than-24-hour
cycle.  Here's the data:

Night       From    To   Duration (hours)
---------  -----  ----  -----------------
Wednesday   0400  1200               8.00
Thursday    0300  1130               8.50
Friday      0300  1130               8.50
Saturday    0345  1215               8.50
Sunday      0315  1300               9.75
Monday      0345  1245               9.00
Tuesday     0445  1245               8.00
Wednesday   0445  1300               9.25
Thursday    0500  1315               8.25
Friday      0530  1230               7.00
Saturday    0530  1230               7.00

I'm not too sure what to make of this.  You could make the case that
the time I go to bed is gradually drifting later and later[^time], but
the time I wake up isn't experiencing a similar shift: they both vary
independently.

One thing is clear though, I get much more sleep when I'm able to
sleep when I naturally feel like it.

[^time]: Sadly I don't have a month or two to test this hypothesis,
  and as I'm back at work on Wednesday I need to try to abruptly shift
  back to waking up at 7AM.

## Link Roundup

- [Testing higher-order properties with QuickCheck](https://blog.poisson.chat/posts/2020-02-24-quickcheck-higherorder.html)
- [GHC 8.8.3 released](https://www.haskell.org/ghc/blog/20200224-ghc-8.8.3-released.html)
- [Early Riser or Night Owl? New Study May Help to Explain the Difference](https://directorsblog.nih.gov/2020/02/25/early-riser-or-night-owl-new-study-may-help-to-explain-the-difference/)
- [Monad of no return/>> Proposal (MRP)](https://gitlab.haskell.org/ghc/ghc/wikis/proposal/monad-of-no-return)
- [What makes a code base good for junior engineers to work on?](https://lobste.rs/s/5q6yae/what_makes_code_base_good_for_junior)
- [Rusty's API Design Manifesto](http://sweng.the-davies.net/Home/rustys-api-design-manifesto)
- [Meaningful availability](https://blog.acolyer.org/2020/02/26/meaningful-availability/)
- [This Week in Rust 327](https://this-week-in-rust.org/blog/2020/02/25/this-week-in-rust-327/)
- [Issue 200 :: Haskell Weekly](https://haskellweekly.news/issue/200.html)
- [My Ordinary Life: Improvements Since the 1990s](https://www.gwern.net/Improvements)
