---
title: "Weeknotes: 023"
taxon: weeknotes-2019
date: 2019-02-24
---

## Work

- I was off on Monday.

- I did some work to make it possible to remove the elasticsearch 2
  search service and switch entirely to the new elasticsearch 5 one.
  This [was pretty straightforward][], and is an essential part of
  testing the switch-over in integration and staging (and then doing
  it in production).

- The rest of the week I worked on changing our elasticsearch index
  schemas to be compatible with elasticsearch 6.  Elasticsearch 6
  [only allows you to have a single type in each index][], but we have
  several.  We decided to add our own type field (rather than split
  everything up into separate indices) as a simple-ish solution.
  Naturally this [required a lot of changes][], as the communication
  with elasticsearch isn't nicely isolated to just one place.  A nicer
  solution, possible if that had been the case, would be to just
  modify the one module which talks to elasticsearch, allowing the
  rest of the code to keep using the old `_type` field.

  Importing data and querying things seems to work.  On Monday I'm
  going to test out publishing things and make sure they still arrive
  in the index with the correct type.  This change to mapping types is
  the single biggest issue with migrating to elasticsearch 6, so we
  definitely want to solve it sooner rather than later, even though
  we're still aiming to migrate only to elasticsearch 5 this quarter.

[was pretty straightforward]: https://github.com/alphagov/govuk-puppet/pull/8707
[only allows you to have a single type in each index]: https://www.elastic.co/guide/en/elasticsearch/reference/6.0/removal-of-types.html
[required a lot of changes]: https://github.com/alphagov/search-api/pull/9

## Miscellaneous

- I read [Annihilation][], the first book of the [Southern Reach
  trilogy][] by Jeff VanderMeer, about a part of the United States
  designated "Area X", which is surrounded by an invisible border and
  within which strange things happen.  There's a [2018 film
  adaptation][] which I enjoyed, but it's pretty confusing.  The book
  manages to be more eerie and also make more sense.

  Area X in the film gave me a strong [The Colour out of Space][]
  feeling.  The book much less so, it felt more unique while retaining
  the general sense of cosmic horror.

- I finished off the fermented carrots I made last month, and have
  started fermenting some chillies, onions, and smoked garlic, for a
  hot sauce.  I'll know in about a month if it's worked out.

[Annihilation]: https://en.wikipedia.org/wiki/Annihilation_(VanderMeer_novel)
[Southern Reach trilogy]: https://en.wikipedia.org/wiki/Southern_Reach_Trilogy
[2018 film adaptation]: https://en.wikipedia.org/wiki/Annihilation_(film)
[The Colour out of Space]: http://www.hplovecraft.com/writings/texts/fiction/cs.aspx

## Link Roundup

- [Freer Monads: Too Fast, Too Free](https://reasonablypolymorphic.com/blog/too-fast-too-free/index.html)
- [This Week in Rust 274](https://this-week-in-rust.org/blog/2019/02/19/this-week-in-rust-274/)
- [Issue 147 :: Haskell Weekly](https://haskellweekly.news/issues/147.html)
- [I trained an A.I. to generate British placenames](https://medium.com/@hondanhon/i-trained-a-neural-net-to-generate-british-placenames-9460e907e4e9)
- [Git: [PATCH v4 1/8] technical doc: add a design doc for the evolve command](https://www.spinics.net/lists/git/msg352255.html)
- [NixOS Weekly #03 - Kubenix, kernel regressions and jobs](https://weekly.nixos.org/2019/03-kubenix-kernel-regressions-and-jobs.html)
- [Pleroma's First Release! 0.9.9](https://blog.soykaf.com/post/pleroma-release-0.9.9/)
- [NTP FAQ: How is Time synchronized?](http://www.ntp.org/ntpfaq/NTP-s-algo.htm#AEN1853)
- [Marie Kondo readers can’t wait until her TV fans get to the ‘red wedding’](https://www.thebeaverton.com/2019/02/marie-kondo-readers-cant-wait-until-her-tv-fans-get-to-the-red-wedding/)
- [Which Face is Real?](http://www.whichfaceisreal.com/index.php)
- [Introducing draft pull requests](https://github.blog/2019-02-14-introducing-draft-pull-requests/)
