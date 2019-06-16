---
title: "Weeknotes: 039"
tags: weeknotes
date: 2019-06-16
audience: General
---

## Work

- I fixed an issue with atom feeds for "finders": pages which find
  things, like
  [https://www.gov.uk/search/all](https://www.gov.uk/search/all) and
  [https://www.gov.uk/aaib-reports](https://www.gov.uk/aaib-reports).
  Previously [finder-frontend][], the app which renders finders, would
  only serve an atom feed if the *default* sort order for the finder
  is by recency.  We wanted a feed for `/search/all`, but that
  defaults to sorting by popularity, so no feed.  I made
  finder-frontend [fix the sort order for feeds][], rather than just
  refuse to serve them.

- The rest of the week had a lot of Elasticsearch 6 stuff, and the end
  is finally in sight.  The ES6 cluster is deployed to our production
  and staging environments (previously it was just in integration);
  [search-api is able to talk to both clusters][] (not my work); and
  we've got a plan for A/B testing the switch from Elasticsearch 5.
  There are only two blockers remaining before the A/B test can start:
  we need to import all the data from Elasticsearch 5, and we're going
  to have a chat with some AWS solutions architects to check we have
  the right machine specs for our workload.

[finder-frontend]: https://github.com/alphagov/finder-frontend
[fix the sort order for feeds]: https://github.com/alphagov/finder-frontend/pull/1184
[search-api is able to talk to both clusters]: https://github.com/alphagov/search-api/pull/1569

## Miscellaneous

- I decided to try my hand at some decorative typesetting, and picked
  the King James Bible.  I've [put it up on GitHub][], and have now
  got the Pentateuch done [with only one really ugly part][].  It's
  been a fun learning experience as I've not tried anything like this
  before.  A long time ago, in preparation for writing [my Ph.D
  thesis][], I read [Butterick's Practical Typography][] to gain some
  basic knowledge, but there's still much to learn.

- I've now been using [DuckDuckGo][] as my main search engine for a
  few weeks now, and it's pretty good.  This came out of an experiment
  at work to figure out what a "good search experience" and a "bad
  search experience" is: turns out Google doesn't have a monopoly on
  good search experiences.

[put it up on GitHub]: https://github.com/barrucadu/bible
[with only one really ugly part]: https://github.com/barrucadu/bible/issues/3
[my Ph.D thesis]: https://www.barrucadu.co.uk/publications/thesis.pdf
[Butterick's Practical Typography]: https://practicaltypography.com/
[DuckDuckGo]: https://duckduckgo.com/

## Link Roundup

- [Fans Are Better Than Tech at Organizing Information Online](https://www.wired.com/story/archive-of-our-own-fans-better-than-tech-organizing-information/)
- [The world in which IPv6 was a good design](https://apenwarr.ca/log/20170810)
- [Book Design Basics Part 1: Margins and Leading](http://theworldsgreatestbook.com/book-design-part-1/)
- [Book Design Basics Part 2: Optical Margins, Indents and Periods](http://theworldsgreatestbook.com/book-design-part-2/)
- [Book Design Basics Part 3: Running The Numbers](http://theworldsgreatestbook.com/book-design-part-3/)
- [Book Design Basics: Small Capitals – Avoiding Capital Offenses](http://theworldsgreatestbook.com/book-design-part-5/)
- [Issue 163 :: Haskell Weekly](https://haskellweekly.news/issues/163.html)
- [This Week in Rust 290](https://this-week-in-rust.org/blog/2019/06/11/this-week-in-rust-290/)
- [stack-2.1.1 release](https://www.fpcomplete.com/blog/ann-stack-2.1.1-release)
- [ICFP 2019 Accepted Papers](https://icfp19.sigplan.org/track/icfp-2019-papers#event-overview)
- [Good Omens Stylometry](http://www.elizabethcallaway.net/good-omens-stylometry)
