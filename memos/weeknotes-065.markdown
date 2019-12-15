---
title: "Weeknotes: 065"
tags: weeknotes
date: 2019-12-15
audience: General
---

## Work

- The highlight of the week has been tracking down the cause of a
  Javascript error to the side-effect of a dependency upgrade in July.
  If you click the "Request an accessible format." links on a recent
  statistical publication (like [Quota use statistics][]), nothing
  happens.  However, the same links on recent guidance (like [Plant
  imports: authorised border control posts in the UK][]) *do* work,
  revealing a hidden paragraph which tells you how to ask for an
  accessible version of the file.

  With a bit of digging, and asking frontenders for help, I learned
  that the problem is that the broken links are missing a
  `data-module="toggle"` attribute in the enclosing `div` tag, and the
  working links have that.  So an attribute is missing somewhere.  The
  strange thing is that both types of page use [the same erb
  template][], and it *does* have the attribute.

  Anyway, after two hours of investigation, me and the other developer
  on support this shift tracked down the likely culprit: [an update to
  govspeak][], GOV.UK's markdown variant.  Govspeak seemed to be the
  culprit, because the difference between the guidance pages and the
  statistical data set pages is that the attachment HTML for guidance
  pages is rendered as-is, but for statistical data sets it gets
  reinterpreted as govspeak.

  We confirmed this hypothesis by looking up things published around
  the 19th of July, and became pretty confident that that's when
  things broke.  So, time to dig into Govspeak...

  Here's an interesting excerpt from the Govspeak changelog:

  > BREAKING CHANGE: Input is sanitized by default, to use unsafe HTML
  > initialize with a sanitize option of false

  We disabled HTML sanitisation in Govspeak, and confirmed that the
  `data-module` attribute *didn't* get stripped.  So in the end, [the
  fix was very straightforward][].  But not straightforward to find.

[Quota use statistics]: https://www.gov.uk/government/statistical-data-sets/quota-use-statistics
[Plant imports: authorised border control posts in the UK]: https://www.gov.uk/government/publications/plant-imports-authorised-points-of-entry-to-the-uk
[the same erb template]: https://github.com/alphagov/whitehall/blob/56006c6f6ba033fbe450ef91d46204499e62e337/app/views/documents/_attachment.html.erb#L75-L87
[an update to govspeak]: https://github.com/alphagov/whitehall/pull/4913
[the fix was very straightforward]: https://github.com/alphagov/govspeak/pull/173

## Miscellaneous

- I've been commuting from my new flat for a week now.  It's not so
  bad, getting a seat in the mornings seems a bit hit-or-miss (but it
  was like that with the bus too); but the station outside the office
  is the end of the line, so getting a seat in the evening is pretty
  easy.  I've been reading during the trip.

- I've read three books this week I've not read for several years:
  - [I Am Legend][], by Richard Matheson.
  - [Behold the Man][], by Michael Moorcock.
  - [The King in Yellow][], by Robert W. Chambers.

- The last 5 Wheel of Time books arrived, so I've started on those.

[I Am Legend]: https://en.wikipedia.org/wiki/I_Am_Legend_(novel)
[Behold the Man]: https://en.wikipedia.org/wiki/Behold_the_Man_(novel)
[The King in Yellow]: https://en.wikipedia.org/wiki/The_King_in_Yellow

## Link Roundup

- [O(n^2), again, now in WMI](https://randomascii.wordpress.com/2019/12/08/on2-again-now-in-wmi/)
- [Issue 189 :: Haskell Weekly](https://haskellweekly.news/issue/189.html)
- [This Week in Rust 316](https://this-week-in-rust.org/blog/2019/12/10/this-week-in-rust-316/)
- [430 Million-Year-Old Fossil Of Sea Creature Named After Lovecraft's Cthulhu Mythos](https://www.forbes.com/sites/davidbressan/2019/04/10/430-million-year-old-fossil-of-sea-creature-named-after-lovecrafts-cthulhu-mythos/)
