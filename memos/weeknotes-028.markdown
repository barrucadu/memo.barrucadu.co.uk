---
title: "Weeknotes: 028"
taxon: weeknotes-2019
date: 2019-03-31
---

## Work

- We hit another big Elasticsearch problem, namely synonyms weren't
  working.  The Elasticsearch documentation isn't terribly helpful,
  but I've managed to glean that there are two types of synonyms.

  Explicit mappings:

  ```
  a, b, c => d, e, f
  ```

  Which means "match any token sequence on the LHS and replace with
  all alternatives on the RHS".

  Equivalent synonyms:

  ```
  a, b, c
  ```

  Whose behaviour depends on the `expand` parameter in the schema.  If
  `expand` is true (the default), it is equivalent to:

  ```
  a, b, c => a, b, c
  ```

  If `expand` is false, it is equivalent to:

  ```
  a, b, c => a
  ```

  We had a problem where it seemed equivalent synonyms were behaving
  as if `expand` were set to false, though that wasn't set in our
  configuration, didn't appear in the index configuration
  Elasticsearch reported, and explicitly setting it to true didn't
  change matters.  A weird situation, but [explicitly expanding all
  the synonyms][] fixed the problem.  Hopefully this is the last big
  issue.

- A smaller problem we found is that reindexing the AWS managed
  Elasticsearch is slow.  *Really* slow.  Our current non-managed
  Elasticsearch 2 cluster can reindex all of its documents (copy them
  from one index into another) in about 45 minutes.  Our new managed
  Elasticsearch 5 cluster, which is using machines roughly as powerful
  as our Elasticsearch 2 machines, takes about two and a half hours.
  Figuring out why is a problem for next quarter.

- Beyond that, we were mostly working on small tasks: enabling
  search-related Jenkins jobs, switching on the monitoring, updating
  documentation, pulling the latest data from Elasticsearch 2, and
  preparing to switch applications over.

- March the 29th, an important day the Civil Service has long been
  preparing for, was this week.  I am talking, of course, about pay
  day.

[explicitly expanding all the synonyms]: https://github.com/alphagov/search-api/pull/33

## Miscellaneous

- I changed ISP to Hyperoptic, who finished wiring my building for
  fibre this week.  I went for the plan advertised as up to symmetric
  gigabit, in practice I get about 920Mbps down and 950Mbps up, which
  is awesome.  I can actually stream things now, without it pausing
  every 15s to buffer.  Pretty much anything I want to download only
  takes a couple of minutes at most.  It's also got IPv6, which I've
  never had on a home internet connection before, with my own public
  `/64`.  The only small downside is that IPv4 is behind [CGN][],
  though I could get a static IPv4 address for £5/month.

- I bought a couple of new books which I've had my eye on for a while:
  [Roadside Picnic][], by Arkady and Boris Strugatsky; and [Void
  Star][], by Zachary Mason.  They should be arriving in the next few
  days.  I'm running dangerously low on shelf space (as usual), but
  even lower on space to put new shelves...

[CGN]: https://en.wikipedia.org/wiki/Carrier-grade_NAT
[Roadside Picnic]: https://en.wikipedia.org/wiki/Roadside_Picnic
[Void Star]: https://en.wikipedia.org/wiki/Void_Star

## Link Roundup

- [Bowling on a Tardis](https://unknownparallel.wordpress.com/2012/11/05/bowling-on-a-tardis/)
- [Fractals and Monads – Part 3](https://dkwise.wordpress.com/2019/02/19/fractals-and-monads-part-3/)
- [Metamorphic Testing](https://www.hillelwayne.com/post/metamorphic-testing/)
- [Higher-rank types in Standard Haskell](https://blog.poisson.chat/posts/2019-03-25-higher-rank-types.html)
- [Why we created a Platform Health team on GOV.UK](https://insidegovuk.blog.gov.uk/2019/03/27/why-we-created-a-platform-health-team-on-gov-uk/)
- [This Week in Rust 279](https://this-week-in-rust.org/blog/2019/03/26/this-week-in-rust-279/)
- [FOI release: costs and care of Palmerston, the cat](https://www.gov.uk/government/publications/foi-release-costs-and-care-of-palmerston-the-cat)
- [Issue 152 :: Haskell Weekly](https://haskellweekly.news/issues/152.html)
