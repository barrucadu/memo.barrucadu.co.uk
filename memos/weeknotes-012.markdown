---
title: "Weeknotes: 012"
taxon: weeknotes-2018
date: 2018-12-09
---

## Ph.D

- Nothing to report.  I seem to be working at a pace of one or two
  hours a fortnight lately.

## Work

- The main thing to report from this week is that we [carried out some
  load testing][] of our staging environment.  We hit our origin
  servers with a little over 6 times the current (which is also the
  peak) load; about 7500 concurrent nginx connections, vs the 1200 we
  normally see (there is more traffic than this to GOV.UK, but it's
  mostly handled by our CDN).  Our test data consisted of 7993
  distinct paths, taken from our logs, so they represented actual
  usage.

  The good news is that our static content held up pretty well.  The
  bad news is that our dynamic content didn't.  It's particularly
  important that we handle dynamic content well, as our CDN doesn't
  cache that.  The machines themselves didn't seem to be falling over,
  certainly not enough to explain the large number of timeouts I was
  seeing, so I began to wonder how many concurrent connections our
  apps support.  This is distinct to the number of concurrent
  connections our origin servers support, as they reverse-proxy
  requests to various apps (or a cache).

  It turns out that the answer is not that many!  We use a Ruby HTTP
  server called [unicorn][], which uses a thread pool to handle
  concurrent connections.  Our [finder-frontend][] app is only set up
  to have 6 unicorn threads, so requests could easily start to pile
  up, and eventually time out.  Ideally, this number will be
  increased; but that will put additional load on our elasticsearch
  server, which is used by more things than just finder-frontend, so
  care needs to be taken.  As a partial solution, [5-minute caching
  was switched on for finder-frontend][].

  There's some follow-up work planned for the next sprint to look into
  some actual application errors the testing revealed, and also to do
  a survey of how many concurrent connections all of our apps support
  and decide if it's enough.

[carried out some load testing]: https://github.com/alphagov/govuk-load-testing
[unicorn]: https://bogomips.org/unicorn/
[finder-frontend]: https://github.com/alphagov/finder-frontend
[5-minute caching was switched on for finder-frontend]: https://github.com/alphagov/finder-frontend/pull/722

## Miscellaneous

- I started doing [Advent of Code][] in Haskell, putting my [solutions
  on GitHub][].  They're fun little challenges to work through: the
  input and outputs are well specified, there's no need to worry about
  error handling, and there's often a standard algorithmic problem at
  the heart of each one.

- I got a couple of new boardgames, though I've not had a chance to
  play them yet:

  - [Betrayal Legacy][], a prequel of sorts to [Betrayal at House on
    the Hill][] with a campaign mode where aspects of the game can be
    permanently changed (it comes with a lot of rules-altering
    stickers).
  - [Boss Monster][], a game where you have to build the *best*
    dungeon to kill heroes the *fastest*.

- [dejafu][] is [back in Stackage nightly][], after minor tweaks.

- Having become fed up with my non-stick-pan-which-isn't, I decided to
  go all out and get a fancy cast iron pan with a pyrex lid.  It
  arrived on Wednesday, with the lid broken in two and no visible
  damage to the packaging.  I'm replacing it with a pan that has a
  cast iron lid as well.

[Advent of Code]: https://adventofcode.com/
[solutions on GitHub]: https://github.com/barrucadu/aoc
[Betrayal Legacy]: https://boardgamegeek.com/boardgame/240196/betrayal-legacy
[Betrayal at House on the Hill]: https://boardgamegeek.com/boardgame/10547/betrayal-house-hill
[Boss Monster]: https://boardgamegeek.com/boardgame/131835/boss-monster-dungeon-building-card-game
[dejafu]: https://www.stackage.org/nightly-2018-12-09/package/dejafu-1.11.0.4
[back in Stackage nightly]: https://github.com/commercialhaskell/stackage/pull/4197

## Link Roundup

- [Alchemical Groups: Advent of Code with Free Groups and Group Homomorphisms](https://blog.jle.im/entry/alchemical-groups.html)
- [Issue 136 :: Haskell Weekly](https://haskellweekly.news/issues/136.html)
- [This Week in Rust 263](https://this-week-in-rust.org/blog/2018/12/04/this-week-in-rust-263/)
