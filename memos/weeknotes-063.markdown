---
title: "Weeknotes: 063"
taxon: weeknotes-2019
date: 2019-12-01
---

## Work

- I did a bunch of small tech debt / platform health related issues
  this week:

  - Updated a bunch of docs about data replication to use [the govuk-docker scripts][].
  - Fixed a few bugs in [replicating postgresql state][].
  - Made some maintenance scripts use Elasticsearch 6 instead of
    Elasticsearch 5 (which no longer exists---I don't think those
    scripts are used much).
  - Removed an unused dashboard.
  - Fixed [some Elasticsearch 6 deprecation warnings][].
  - ...[and some more][].
  - ...[and again][].
  - Tidied up some [reranking code][].
  - And did some preliminary work so we can [track reranking][].
  - [Stopped non-English content getting into search][].

- Another session of [Learn to Code][] lesson 2 ran on Friday, and I
  helped out.

- I'm off next week.

[the govuk-docker scripts]: https://github.com/alphagov/govuk-docker/tree/master/bin
[replicating postgresql state]: https://github.com/alphagov/govuk-docker/pull/268
[some Elasticsearch 6 deprecation warnings]: https://github.com/alphagov/search-api/pull/1815
[and some more]: https://github.com/alphagov/search-api/pull/1812
[and again]: https://github.com/alphagov/search-api/pull/1811
[reranking code]: https://github.com/alphagov/search-api/pull/1807
[track reranking]: https://github.com/alphagov/search-api/pull/1806
[Stopped non-English content getting into search]: https://github.com/alphagov/search-api/pull/1810
[Learn to Code]: https://learn-to-code.london.cloudapps.digital/

## Miscellaneous

- Mostly preparing for the move: packing things, throwing away things
  I don't want to pack, collecting the keys, ferrying a bunch of stuff
  over in suitcases when it became apparent that I didn't have enough
  boxes...


## Link Roundup

- [Internet world despairs as non-profit .org sold for $$$$ to private equity firm, price caps axed](https://www.theregister.co.uk/2019/11/20/org_registry_sale_shambles/)
- [Winter is coming even more quickly](http://www.joachim-breitner.de/blog/758-Winter_is_coming_even_more_quickly)
  - [Faster Winter 7: The Zipper](http://www.joachim-breitner.de/blog/764-Faster_Winter_6__Simpler_Code)
  - [Faster Winter 6: Simpler Code](http://www.joachim-breitner.de/blog/765-Faster_Winter_7__The_Zipper)
  - [Faster Winter: Statistics (the making-of)](http://www.joachim-breitner.de/blog/766-Faster_Winter__Statistics_%28the_making-of%29)
- [Facial Recognition Software Knows It Has Seen Man Before But Can’t Remember His Name](https://www.theonion.com/facial-recognition-software-knows-it-has-seen-man-befor-1840033674)
- [It’s Way Too Easy to Get a .gov Domain Name](https://krebsonsecurity.com/2019/11/its-way-too-easy-to-get-a-gov-domain-name/)
- [Man or boy test](https://en.wikipedia.org/wiki/Man_or_boy_test)
- [The Last Person on Earth Without Windows 95](https://zipcon.net/~kestral/win95.html)
- [Issue 187 :: Haskell Weekly](https://haskellweekly.news/issue/187.html)
- [This Week in Rust 314](https://this-week-in-rust.org/blog/2019/11/26/this-week-in-rust-314/)
- [Inventing an Operation to Solve x^x = y](http://mathforum.org/library/drmath/view/54586.html)
- [An Overview of Distributed Systems and the Consensus Problem](https://probablyexactlywrong.com/distsys/)
- [The Last Question by Isaac Asimov](https://www.multivax.com/last_question.html)
