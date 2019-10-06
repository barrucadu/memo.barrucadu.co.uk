---
title: "Weeknotes: 055"
tags: weeknotes
date: 2019-10-06
audience: General
---

## Open Source

- I fixed up some of my Haskell packages and got them back into Stackage:
  - [concurrency][] and [dejafu][]: MonadFail issues
  - [hunit-dejafu][] and [tasty-dejafu][]: removed because dejafu was
  - [irc-conduit][] and [irc-client][]: version bound issues

[concurrency]: https://www.stackage.org/nightly-2019-10-06/package/concurrency-1.8.0.0
[dejafu]: https://www.stackage.org/nightly-2019-10-06/package/dejafu-2.1.0.1
[hunit-dejafu]: https://www.stackage.org/nightly-2019-10-06/package/hunit-dejafu-2.0.0.1
[tasty-dejafu]: https://www.stackage.org/nightly-2019-10-06/package/tasty-dejafu-2.0.0.1
[irc-conduit]: https://www.stackage.org/nightly-2019-10-06/package/irc-conduit-0.3.0.4
[irc-client]: https://www.stackage.org/nightly-2019-10-06/package/irc-client-1.1.1.1

## Work

- Elasticsearch 5 is now dead and gone, at long last.  I wrote up [an
  ADR on the upgrade][].

- We've started looking into different ways of incorporating
  popularity into our search ranking.  At the moment it has a large
  impact, so some really popular pages show up at the top for a lot of
  queries, even if the page is only tangentially related to the user's
  keywords.

[an ADR on the upgrade]: https://github.com/alphagov/search-api/blob/master/doc/arch/adr-009-elasticsearch6-upgrade.md

## Miscellaneous

- I read [The Great Hunt][] (by Robert Jordan), the second book in the
  Wheel of Time series.

- I went to talk to mortgage advisors at Nationwide and HSBC about
  buying the flat I'm currently renting, but they both wanted a
  deposit of at least 40k, which I can't do.  So I guess I will need
  to move and rent somewhere different.

[The Great Hunt]: https://en.wikipedia.org/wiki/The_Great_Hunt

## Link Roundup

- [What is Good About Haskell?](https://doisinkidney.com/posts/2019-10-02-what-is-good-about-haskell.html)
- [AWS faces Elasticsearch lawsuit for trademark infringement](https://searchaws.techtarget.com/news/252471650/AWS-faces-Elasticsearch-lawsuit-for-trademark-infringement)
- [MicroPython - Python for microcontrollers](https://micropython.org/)
- [This Week in Rust 306](https://this-week-in-rust.org/blog/2019/10/01/this-week-in-rust-306/)
- [The pain of tracking down changes in U.S. law](https://blog.plover.com/law/citations.html)
- [Issue 179 :: Haskell Weekly](https://haskellweekly.news/issues/179.html)
- [D&D Group Overthrows Dungeon Master in Favor of Dungeon Democracy](https://thehardtimes.net/harddrive/dd-group-overthrows-dungeon-master-favor-dungeon-democracy/)
- [Lab-made primordial soup yields RNA bases](https://www.nature.com/articles/d41586-019-02622-4)
- [False Hydra](http://goblinpunch.blogspot.com/2014/09/false-hydra.html)
- [Antimemetics Division Hub](http://www.scp-wiki.net/antimemetics-division-hub)
- [The Strange Case of the Woman Who Can’t Remember Her Past—Or Imagine Her Future | WIRED](https://www.wired.com/2016/04/susie-mckinnon-autobiographical-memory-sdam/)
