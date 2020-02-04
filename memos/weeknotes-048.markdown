---
title: "Weeknotes: 048"
taxon: weeknotes-2019
date: 2019-08-18
---

## Work

- I spent a couple of days thinking about how we can treat tuning our
  search query as an optimisation problem.  A search query has two
  parts: there's the structure ("match against these fields", "combine
  field scores by multiplying", etc), and the parameters ("weight this
  field by X", "boost this document type by Y", etc).  I've done some
  experimenting, and [particle swarm optimisation][] does an alright
  job of tuning the parameters.  So maybe we just need to come up with
  a good query structure, and can then automatically find good
  parameters for it.

- I wrote a blog post about upgrading from Elasticsearh 2 all the way
  to Elasticsearch 6.  That's currently with the blog editors, and
  will go out some time after we finally switch ES5 off (which I hope
  will be soon).

- Some small business-as-usual user-facing improvements: [making the
  "Corporate reports" link on organisation about pages go to the right
  place][] and [changing the default sort order for statistics
  announcements to "soonest first"][].

[particle swarm optimisation]: https://en.wikipedia.org/wiki/Particle_swarm_optimization
[making the "Corporate reports" link on organisation about pages go to the right place]: https://github.com/alphagov/whitehall/pull/4984
[changing the default sort order for statistics announcements to "soonest first"]: https://github.com/alphagov/finder-frontend/pull/1310

## Miscellaneous

- I'm moving out of my current flat mid next month, so I've been
  looking at new flats online, and am hoping to have a few viewings
  next week.  Flat hunting is really tedious.

- I read [Raft][] (by Stephen Baxter)[^raft], about a small human
  civilisation living in a universe where gravity is a billion times
  stronger than in our home universe.  They live in a nebula which,
  thanks to the strong gravity, has an atmosphere dense enough to be
  breathable (fortunately it's also oxygen rich).  The story is about
  one man's quest to figure out why the nebula is dying, and what to
  do about it.  It's considered the first novel in the [Xeelee
  Sequence][], though the Xeelee themselves are never mentioned, so I
  don't know why.

[^raft]: Not to be confused with [Raft][raftc] (by Diego Ongaro and
    John Ousterhout), a distributed consensus algorithm I used while
    at [Pusher][].

[Raft]: https://en.wikipedia.org/wiki/Raft_(novel)
[Xeelee Sequence]: https://en.wikipedia.org/wiki/Xeelee_Sequence
[raftc]: https://raft.github.io/
[Pusher]: https://pusher.com/

## Link Roundup

- [The United States Congress is an elegant stack machine](https://tech.davis-hansson.com/p/congress-is-a-vm.html)
- [Denmark Offers to Buy U.S.](https://www.newyorker.com/humor/borowitz-report/denmark-offers-to-buy-us)
- [Issue 172 :: Haskell Weekly](https://haskellweekly.news/issues/172.html)
- [This Week in Rust 299](https://this-week-in-rust.org/blog/2019/08/13/this-week-in-rust-299/)
- [Ranking Evaluation API | Elasticsearch Reference](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-rank-eval.html)
