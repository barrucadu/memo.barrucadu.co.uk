---
title: "Weeknotes: 038"
tags: weeknotes
date: 2019-06-09
audience: General
---

## Work

- More fixing of Elasticsearch issues.  The biggest was [replacing the
  now-removed `indices` query][], but now that that's done we only
  have one thing to do: changing the text similarity metric.
  Replacing the `indices` query was a bit tricky, because the
  recommended migration has had [a known problem since February
  2017][].  It's a bit disappointing that a feature was removed when
  the suggested alternative had a significant flaw, and I implemented
  a fairly nasty work-around to preserve the behaviour we wanted.

- We had a call with AWS about Elasticsearch, and talked through what
  sort of things we currently do and want to do.  We're going to have
  another call with some of their "solutions architects" to make sure
  our cluster architecture is the best choice for our needs, and also
  to talk through our upgrade to Elasticsearch 6.

- We had an incident with access control, where the GitHub teams which
  we use for authenticating into Jenkins and the like got accidentally
  deleted.  So there was a fun hour of manually adding people back to
  the teams and quickly hacking together a script to sort out the
  hundreds of repositories we have.  This has apparently happened
  twice before, done by two different (now three different) people, so
  it seems the UI for removing someone from a team on GitHub isn't
  great.

- A long time ago now I applied to be a senior developer, I had an
  interview and didn't hear anything.  Finally on Friday the results
  came out, and I'm now a senior.

[replacing the now-removed `indices` query]: https://github.com/alphagov/search-api/pull/1568
[a known problem since February 2017]: https://github.com/elastic/elasticsearch/issues/23306

## Miscellaneous

- My landlord told me that he's selling the flat and will be serving
  me my three months notice at the end of this month.  So I guess I
  need to find somewhere new to live...

## Link Roundup

- [This page is a truly naked, brutalist html quine.](https://secretgeek.github.io/html_wysiwyg/html.html)
- [This Week in Rust 289](https://this-week-in-rust.org/blog/2019/06/04/this-week-in-rust-289/)
- [Putting the stack back into Stacked Borrows](https://www.ralfj.de/blog/2019/05/21/stacked-borrows-2.1.html)
- [Hedgehog on a REST API](http://magnus.therning.org/posts/2019-05-30-000-hedgehog-on-a-rest-api.html)
- [Issue 162 :: Haskell Weekly](https://haskellweekly.news/issues/162.html)
- [TCP/IP over Amazon Cloudwatch Logs](https://medium.com/clog/tcp-ip-over-amazon-cloudwatch-logs-c1cf08f2296c)
- [Why would you use ContT?](https://ro-che.info/articles/2019-06-07-why-use-contt)
- [Lizards Rapidly Evolve After Introduction to Island](https://www.nationalgeographic.com/animals/2008/04/lizard-evolution-island-darwin/)
- [Testable IO in Haskell](http://andyfriesen.com/2015/06/17/testable-io-in-haskell.html)
- [7 absolute truths I unlearned as junior developer](https://monicalent.com/blog/2019/06/03/absolute-truths-unlearned-as-junior-developer/)
- [This may be the ocean’s most horrifying monster (and you’ve probably never heard of it)](https://jellybiologist.com/2018/10/31/this-may-be-the-oceans-most-horrifying-monster-and-youve-probably-never-heard-of-it/)
- [Here's My Type, So Initialize Me Maybe (mem::uninitialized is deprecated)](https://gankro.github.io/blah/initialize-me-maybe/)
