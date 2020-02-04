---
title: "Weeknotes: 062"
taxon: weeknotes-2019
date: 2019-11-24
---

## Work

- I added the [FAQPage schema.org metadata][] to the
  [/bank-holidays][] and [/when-do-the-clocks-change][] pages, so now
  if you google for "bank holidays" Google gives a rich result:

  ![Screenshot of Google results page showing rich result for the GOV.UK bank holidays page.](weeknotes-062/bank-holidays.png)

  This whole experience has heightened my Scotland-bank-holiday-envy.
  Not only do they have an extra one, theirs seem to be slightly more
  spread out across the year.

  There isn't a rich result for the clock change page because there's
  only one "question" there.  But adding the metadata is still useful,
  as voice assistants and similar technology can use it.

- We're working on productionising our [Learning to Rank][]
  implementation so we can A/B test it, and as part of that I've been
  looking into how training time and data correlate with quality.  So
  I've run a bunch of experiments with models trained on analytics
  data from a day, a fortnight, and a month, with various training
  durations.  I need to write up my results, but it's looking like a
  fortnight of clicks data is a good amount.

- We had a chat about A/B tests, because the last few we've run
  haven't turned up conclusive results.  We worry that we're not
  trying changes which are impactful enough.  So going forward we're
  going to try looking at some metrics like how much the order of
  results has changed before deploying a test.

[FAQPage schema.org metadata]: https://schema.org/FAQPage
[/bank-holidays]: https://www.gov.uk/bank-holidays
[/when-do-the-clocks-change]: https://www.gov.uk/when-do-the-clocks-change
[Learning to Rank]: https://en.wikipedia.org/wiki/Learning_to_rank

## Miscellaneous

- I read [Winter's Heart][] (by Robert Jordan), the eighth book in the
  Wheel of Time series.  I also read [New Spring][], a Wheel of Time
  prequel.

- I've been sorting out my new flat: paying and signing things,
  arranging a time to pick up the keys, and getting quotes from
  removals companies.  I've also been thinking about furniture, both
  for the office I'm going to turn the second bedroom into, and for
  the much larger living / dining room.  Finally, I will have enough
  shelf space for my books (for a little while, at least).

- [Oculus Link][] entered public beta, so I've been able to hook up my
  Quest to my computer and explore PC VR.  This has been hampered
  somewhat by me not owning any PC VR games...

[Winter's Heart]: https://en.wikipedia.org/wiki/Winter%27s_Heart
[New Spring]: https://en.wikipedia.org/wiki/New_Spring
[Oculus Link]: https://support.oculus.com/444256562873335/

## Link Roundup

- [NaN Gates and Flip FLOPS](http://tom7.org/nand/)
- [Computing Eulerian paths is harder than you think](https://byorgey.wordpress.com/2019/11/20/computing-eulerian-paths-is-harder-than-you-think/)
- [How containers work: overlayfs](https://jvns.ca/blog/2019/11/18/how-containers-work--overlayfs/)
- [This Week in Rust 313](https://this-week-in-rust.org/blog/2019/11/19/this-week-in-rust-313/)
- [Issue 186 :: Haskell Weekly](https://haskellweekly.news/issue/186.html)
- [File systems unfit as distributed storage backends: lessons from ten years of Ceph evolution](https://blog.acolyer.org/2019/11/06/ceph-evolution/)
- [Winter is coming even more quickly](http://www.joachim-breitner.de/blog/758-Winter_is_coming_even_more_quickly)
  - [Faster Winter 1: Vectors](http://www.joachim-breitner.de/blog/759-Faster_Winter_1__Vectors)
  - [Faster Winter 2: SPECIALIZE](http://www.joachim-breitner.de/blog/760-Faster_Winter_2__SPECIALIZE)
  - [Faster Winter 3: Difference Lists](http://www.joachim-breitner.de/blog/761-Faster_Winter_3__Difference_Lists)
  - [Faster Winter 4: Export lists](http://www.joachim-breitner.de/blog/762-Faster_Winter_4__Export_lists)
  - [Faster Winter 5: Eta-Expanding ReaderT](http://www.joachim-breitner.de/blog/763-Faster_Winter_5__Eta-Expanding_ReaderT)
- [PlanAlyzer: assessing threats to the validity of online experiments](https://blog.acolyer.org/2019/11/22/planalyzer/)
- [A dirty dozen: twelve common metric interpretation pitfalls in online controlled experiments](https://blog.acolyer.org/2017/09/25/a-dirty-dozen-twelve-common-metric-interpretation-pitfalls-in-online-controlled-experiments/)
- [When to use a machine learned vs. score-based search ranker](https://towardsdatascience.com/when-to-use-a-machine-learned-vs-score-based-search-ranker-aa8762cd9aa9)
- [Malaysia's last known Sumatran rhino dies](https://www.bbc.co.uk/news/world-asia-50531208)
- [Meow Hash](https://mollyrocket.com/meowhash)
