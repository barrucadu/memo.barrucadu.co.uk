---
title: "Weeknotes: 035"
tags: weeknotes
date: 2019-05-19
audience: General
---

## Work

- On Monday I became a line manager.  My new starter arrived, I showed
  him around, got his kit, and dropped him off with his team.  I
  haven't been on line management training yet, so I'm more or less
  making this up as I go along.

- I did some investigation into how we could upgrade to
  Elasticsearch 6.  The current plan is:

  1. Upgrade the version of the ES client library to 6, without
     breaking ES5 compatibility (done).
  2. Spin up an ES6 cluster.
  3. Modify search-api to index all documents to both clusters (ES5
     and ES6).
  4. Fix any problems with indexing into ES6, without breaking ES5
     compatibility.
  5. Modify search-api to be able to query either cluster, specified
     by a parameter passed by the caller.
  6. Fix any problems with querying from ES6, without breaking ES5.
  7. Gradually dial up the amount of queries sent to ES6 instead of
     ES5.
  8. Switch off the ES5 cluster when no more queries are going to it.

  This is a different approach to the one we took for going from ES2
  to ES5, where we had a second search application.  That was a bit of
  a pain at times, I'm hoping that this will be less so.

- We had a couple of sessions, lead by a performance analyst and a
  user researcher on the team, to talk about how we think people use
  GOV.UK's search, and to come up with hypotheses we can try out.

  One of mine was about how quoted search terms work:

  - Searching for [`"tax your vehicle"`][] finds things which contain
    that phrase (rather than things which contain any of "tax",
    "your", and "vehicle" in any order).  It returns 31 results.
  - Searching for [`micropig bread`][] finds things which contain at
    least one of those keywords.  It returns 300 results.

  What would you expect searching for `"tax your vehicle" micropig
  bread` to return?  331 results, perhaps?

  It actually returns [95,459 results][].  This is because the quoted
  phrase logic only applies if your *entire* query is quoted.  So
  `"tax your vehicle" micropig bread` is searching for documents which
  contain any of `tax`, `your`, `vehicle`, `micropig`, or `bread`.
  That's a lot of documents.

  So one of my hypotheses was "people expect search to behave
  consistently, so if we make quoted subqueries work in the same way
  as quoted queries, then we should see less query refinement."

- On Friday the Platform Health team had a belated Christmas party
  (the previous one having been delayed due to brexit), we went out
  for food, minigolf, and drinks.

[`"tax your vehicle"`]: https://www.gov.uk/search/all?keywords=%22tax+your+vehicle%22&order=relevance
[`micropig bread`]: https://www.gov.uk/search/all?keywords=micropig+bread&order=relevance
[95,459 results]: https://www.gov.uk/search/all?keywords=%22tax+your+vehicle%22+micropig+bread&order=relevance

## Miscellaneous

- I rediscovered [Interpolation Search][], which is like binary search
  but tries to be smarter about where to split the search space.

- I woke up on Saturday with a cold, which is still pretty bad now, on
  Sunday evening.  Not really how I wanted to spend my weekend.

[Interpolation Search]: /interpolation-search.html

## Link Roundup

- [On Recursive Reference, John Morton (1976)](https://johnmorton1000.files.wordpress.com/2014/11/1976-recursive.pdf)
- [Adversarial Examples Are Not Bugs, They Are Features](http://gradientscience.org/adv/)
- [Issue 159 :: Haskell Weekly](https://haskellweekly.news/issues/159.html)
- [This Week in Rust 286](https://this-week-in-rust.org/blog/2019/05/14/this-week-in-rust-286/)
- [NixOS Weekly #09 - autobake, setup.nix for Python, macOS stdenv updates, nixfmt, Elm tooling, gitignore and a job](https://weekly.nixos.org/2019/09-autobake-setup-nix-for-python-macos-stdenv-updates-nixfmt-elm-tooling-gitignore-and-a-job.html)
- [Release early and often](http://www.haskellforall.com/2019/05/release-early-and-often.html)
- [The kilo is dead. Long live the kilo!](https://news.mit.edu/2019/kilo-standard-change-0516) - which requires an update to the [Weights and Measures Act (1985), Schedule 1, Part V](http://www.legislation.gov.uk/ukpga/1985/72/schedule/1/part/V)
- [New features planned for Python 4.0](http://charlesleifer.com/blog/new-features-planned-for-python-4-0/)
- [Viewing Matrices & Probability as Graphs](https://www.math3ma.com/blog/matrices-probability-graphs)
- [GHC's Specializer: Much More Than You Wanted to Know](https://reasonablypolymorphic.com/blog/specialization/index.html)
