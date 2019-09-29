---
title: "Weeknotes: 053"
tags: weeknotes
date: 2019-09-22
audience: General
---

## Work

- The team finished trying out a remote sprint, and we all returned to
  the office on Wednesday and talked about how we found it.  While it
  was nice waking up at 08:55 for an 09:10 start, my work/life balance
  suffered a bit (the two are probably not unrelated), and I found I
  got less done each day.  On Tuesday I got barely anything done.

  If we try this again I'll need to improve my routine to strengthen
  the separation between work and not-work: I'm thinking coming into
  the office on Monday and Friday, and also doing something special in
  the start and end of the at-home days.

- We're now in the final stages of switching to Elasticsearch 6 (I
  hope).  The A/B test is at 50/50 and things were looking great on
  Friday.  Unless something catastrophic happened over the weekend,
  we'll switch to 0/100 on Monday.  Switching to 0/100, rather than
  just turning ES5 off, is good because we have an easy roll-back
  method in case something *does* break.  When we're happy ES6 is all
  good, we'll retire ES5 and switch off the test.

- [A small change to sitemap files][]: they now give the timestamp of
  the most recent update to the page, rather than the timestamp of the
  most recent "major" update to the page.  Major updates send out
  email alerts, so people tend not to mark an update as major, so we
  worried that our sitemaps were discouraging search engines from
  re-crawling pages which had had a bunch of minor changes.

- I deployed [a change to how we handle quoted query fragments][].
  Quoted fragments are now required, and unquoted fragments are
  optional, which is closer to how Google does things.

  So now these queries are all different:

  - [`office banter`](https://www.gov.uk/search/all?keywords=office+banter&order=relevance): both words optional, but preferred.
  - [`office "banter"`](https://www.gov.uk/search/all?keywords=office+%22banter%22&order=relevance): `office` optional (but preferred), `banter` required.
  - [`"office" banter`](https://www.gov.uk/search/all?keywords=%22office%22+banter&order=relevance): `office` required, `banter` optional (but preferred).
  - [`"office" "banter"`](https://www.gov.uk/search/all?keywords=%22office%22+%22banter%22&order=relevance): both words required.
  - [`"office banter"`](https://www.gov.uk/search/all?keywords=%22office+banter%22&order=relevance): the phrase `office banter` required.

[A small change to sitemap files]: https://github.com/alphagov/search-api/pull/1692
[a change to how we handle quoted query fragments]: https://github.com/alphagov/search-api/pull/1686

## Miscellaneous

- I started flat hunting again, looking into London commuter towns,
  rather than trying to stay in the city.  Helpfully, I found an
  article [from this year ranking them][].  I might actually end up
  with a shorter (in duration) commute by living further out.

  The Greater London area is non-Euclidean.

- I spent a lot of time reading the [Ars Magica][] rulebooks, and also
  Wikipedia articles on [Platonic][] and [Aristotelian][] realism, and
  thinking... and came up with a somewhat contrived, but not too
  awkward, [metaphysical backing for Hermetic magic][].  I expect
  there will be a moment in game where we end up resolving an unclear
  bit of the rules in a way which contradicts my theory, making the
  exercise fun but ultimately fruitless.

[from this year ranking them]: https://www.totallymoney.com/commuter-hotspots/information/
[Ars Magica]: https://en.wikipedia.org/wiki/Ars_Magica
[Platonic]: https://en.wikipedia.org/wiki/Platonic_realism
[Aristotelian]: https://en.wikipedia.org/wiki/Aristotle%27s_theory_of_universals
[metaphysical backing for Hermetic magic]: hermetic-metaphysics.html

## Link Roundup

- [Easier Relevance Tuning in Elasticsearch 7.0](https://www.elastic.co/blog/easier-relevance-tuning-elasticsearch-7-0)
- [How to crash a plane - Nickolas Means](https://vimeo.com/showcase/4045988/video/173246615)
- [Air Force General Proposes New Defense System ‘Just a Fuckton of Bullets’](https://thehardtimes.net/harddrive/air-force-general-proposes-new-defense-system-just-a-fuckton-of-bullets/)
- [Issue 177 :: Haskell Weekly](https://haskellweekly.news/issues/177.html)
- [This Week in Rust 304](https://this-week-in-rust.org/blog/2019/09/17/this-week-in-rust-304/)
- [Free coffee](https://blog.plover.com/law/free-coffee.html)
- [DLR insurance business](https://blog.plover.com/misc/dlr-insurance-business.html)
- [Making Haskell run fast: the many faces of reverse](https://blog.poisson.chat/posts/2019-09-13-reverse.html)
- [System Does Matter](http://www.indie-rpgs.com/_articles/system_does_matter.html)
