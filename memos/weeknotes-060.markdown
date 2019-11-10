---
title: "Weeknotes: 060"
tags: weeknotes
date: 2019-11-10
audience: General
---

## Work

- Another developer on the team has been looking into using [Learning
  to Rank][] to improve our search results, as it's what all the cool
  people are doing.  We had a long pairing session on Friday getting
  the code into a more production-ready state so we can investigate it
  more properly.

- I finished off my spelling suggestions investigation and came up
  with a few candidates to try out.  One of those is getting the top 5
  spelling suggestions from Elasticsearch, and doing our own ranking
  of them---because Elasticsearch seems to give far too much weight to
  term frequency, compared to term similarity.  We want to swing the
  balance in the other direction, but figuring out how much will be
  tricky.

- I killed off a [legacy search endpoint][] which was [only used by
  whitehall][].  All the tech debt big enough to track which has been
  fixed this quarter has been search-related: either we're
  super-productive, or we've got a lot of free time.

[Learning to Rank]: https://github.com/tensorflow/ranking
[legacy search endpoint]: https://github.com/alphagov/search-api/pull/1776
[only used by whitehall]: https://github.com/alphagov/whitehall/pull/5122

## Miscellaneous

- I read [A Crown of Swords][] (by Robert Jordan), the seventh book in
  the Wheel of Time series.

- I decided to learn some [Kubernetes][], and how better to learn a
  container orchestration system than with a distributed system I
  already know well?  So my weekend project has been [getting GOV.UK
  running on Kubernetes][], though all I've managed so far is
  finder-frontend...

  My plan is to get a bunch of the frontend services running against
  the public GOV.UK APIs then, once those all seem to be working,
  progressing backwards through the stack: getting content-store and
  MongoDB working, search-api and Elasticsearch, and so on.

- I wrote a memo on [using GADTs for alternative datatype
  representations][].

[A Crown of Swords]: https://en.wikipedia.org/wiki/A_Crown_of_Swords
[Kubernetes]: https://kubernetes.io/
[getting GOV.UK running on Kubernetes]: https://github.com/barrucadu/govuk-k8s
[using GADTs for alternative datatype representations]: alternate-datatype-representations.html

## Link Roundup

- [C Compilers Disprove Fermat’s Last Theorem](https://blog.regehr.org/archives/140)
- [Compilers and Termination Revisited](https://blog.regehr.org/archives/161)
- [The Lost Key of QWERTY](http://widespacer.blogspot.com/2016/03/the-lost-key-of-qwerty.html)
- [Introducing Dexter, the Automatic Indexer for Postgres](https://ankane.org/introducing-dexter)
- [Parse, don’t validate](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/)
- [I was an astrologer – here's how it really works, and why I had to stop](https://www.theguardian.com/lifeandstyle/2019/nov/06/i-was-an-astrologer-how-it-works-psychics)
- [Building a microcloud with a few Raspberry Pis and Kubernetes (Part 1)](https://mirailabs.io/blog/building-a-microcloud/)
- [Bypassing GitHub's OAuth flow](https://blog.teddykatz.com/2019/11/05/github-oauth-bypass.html)
- [Transforming GOV.UK: the future of digital public services](https://gds.blog.gov.uk/2019/11/05/transforming-gov-uk-the-future-of-digital-public-services/)
- [Generating castles for Minecraft™ using Haskell](http://www.timphilipwilliams.com/posts/2019-07-25-minecraft.html)
- [This Week in Rust 311](https://this-week-in-rust.org/blog/2019/11/05/this-week-in-rust-311/)
- [Issue 184 :: Haskell Weekly](https://haskellweekly.news/issue/184.html)
