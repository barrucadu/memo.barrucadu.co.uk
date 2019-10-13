---
title: "Weeknotes: 056"
tags: weeknotes
date: 2019-10-13
audience: General
---

## Work

- On Wednesday the team had a day-long hackathon into improving search
  relevancy.  We split into sub-teams and just tried stuff out for the
  day, before gathering and presenting our findings.  My team looked
  into using bigrams in relevancy scoring.  For example, if you search
  for "David Cameron speech", then a page containing "David Cameron"
  or "Cameron speech" would score higher than a page which contained
  those three words scattered across the entire document.  We had some
  good results, so I think a fuller investigation is probably on the
  cards.

  Interestingly, some work on bigrams had been done before, [but was
  removed][] because it didn't work properly.  Though fixing it didn't
  take much effort, so I'm not sure why it wasn't just fixed back
  then.

- I took Thursday and Friday off.

[but was removed]: https://github.com/alphagov/search-api/commit/806a68cb11f926c328bf360171c754ed6fca06ac

## Miscellaneous

- I read [The Dragon Reborn][] (by Robert Jordan), the third book in
  the Wheel of Time series.

- On Tuesday I went to Cambridge for the ["How To" book tour][].  The
  book is pretty good, though I've only read a bit of it so far.

- On Thursday I went to York to give a talk about GOV.UK to
  [HackSoc][].

[The Dragon Reborn]: https://en.wikipedia.org/wiki/The_Dragon_Reborn
["How To" book tour]: https://xkcd.com/how-to/
[HackSoc]: https://www.hacksoc.org/

## Link Roundup

- [Murder Suspect's Ankle Bracelet Removed Over Missed Payments](https://www.iheart.com/content/2019-10-04-murder-suspects-ankle-bracelet-removed-over-missed-payments/)
- [LAFABLE - Large Agile Framework Appropriate for Big, Lumbering Enterprises](http://lafable.com/)
- [Ken Thompson's Unix password](https://leahneukirchen.org/blog/archive/2019/10/ken-thompson-s-unix-password.html)
- [NixOS Weekly #13 - NixOS 19.09 release, cache.nixos.org improvements, github actions for Nix, a number of talks](https://weekly.nixos.org/2019/13-nixos-19-09-release-cache-nixos-org-improvements-github-actions-for-nix-a-number-of-talks.html)
- [Issue 180 :: Haskell Weekly](https://haskellweekly.news/issues/180.html)
- [This Week in Rust 307](https://this-week-in-rust.org/blog/2019/10/08/this-week-in-rust-307/)
- [Applying deep learning to Airbnb search](https://blog.acolyer.org/2019/10/09/applying-deep-learning-to-airbnb-search/)
