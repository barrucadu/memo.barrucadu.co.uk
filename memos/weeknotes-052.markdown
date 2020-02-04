---
title: "Weeknotes: 052"
taxon: weeknotes-2019
date: 2019-09-15
---

## Work

- Tired of Elasticsearch 5 not supporting [the rank_eval API][], I
  wrote [a script][] which would query our search and compute the
  metrics, enabling me to directly compare ES5 and 6.  This let me do
  some experimentation to figure out which bits of the query
  contribute most significantly to the search result quality and,
  surprisingly, I found that it was phrase matching.  In retrospect
  this makes sense because, while there are many searches which don't
  benefit from phrase matching, there are enough searches for common
  phrases like "income tax" or "vehicle tax" which do.

- We stopped the current search A/B test, which showed a difference of
  1.86 percentage points between ES5 and 6, and started a new one with
  another tweaked query, which takes phrase matching into account.  If
  this is even better, great; if not, the old query we had was
  probably good enough for us to go ahead with the switch to ES6.

- I started work on a change [to make quoted query fragments
  required][], giving our search a more Google-like behaviour.  Barely
  any people use quotes in searches on GOV.UK, so it may not get a lot
  of use, but it's not too tricky to implement and I think it will
  benefit the people who do.  And maybe more people will start to use
  quoted searches once they start to behave differently.

- My team are trying a remote sprint, we're working from home until
  Wednesday next week.  I've rapidly turned into even more of a hermit
  than usual.

[the rank_eval API]: https://www.elastic.co/guide/en/elasticsearch/reference/current/search-rank-eval.html
[a script]: https://gist.github.com/barrucadu/48b616aa03173039da8e594619bcfef5
[to make quoted query fragments required]: https://github.com/alphagov/search-api/pull/1686

## Miscellaneous

- I started reading [Metro 2033][] (by Dmitry Glukhovsky), which is
  the basis for the game of the same name.  It's set after a nuclear
  war rendered the surface uninhabitable, and survivors live in
  communities in the Moscow metro system, living off mushrooms, and
  defending themselves from mutated surface creatures which
  occasionally find their way inside.

- I've been reading the [Ars Magica][] source books, I'm considering
  starting up a game of that once my Call of Cthulhu campaign
  ends---though that won't be for a while, I estimate it's got 10 or
  so sessions (20 weeks if everything is done on time) remaining.  I
  really like the look of the magic system in Ars Magica, it feels
  more like actual magic is supposed to be than in most games.

[Metro 2033]: https://en.wikipedia.org/wiki/Metro_2033
[Ars Magica]: https://en.wikipedia.org/wiki/Ars_Magica

## Link Roundup

- [Tarrare](https://en.wikipedia.org/wiki/Tarrare)
- [Extended Validation not so... extended? How I revoked $1,000,000 worth of EV certificates!](https://scotthelme.co.uk/extended-validation-not-so-extended/)
- [Issue 176 :: haskell Weekly](https://haskellweekly.news/issues/176.html)
- [This Week in Rust 303](https://this-week-in-rust.org/blog/2019/09/10/this-week-in-rust-303/)
