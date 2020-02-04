---
title: "Weeknotes: 015"
taxon: weeknotes-2018
date: 2018-12-30
---

## Miscellaneous

- I've been back home this week for Christmas.

- I finished [Advent of Code][] this week ([my solutions are on
  github][]).  I particularly enjoyed [day 23 part 2][], which is to
  find the coordinate in range of most nanobots.  Or, to put it in a
  more abstract setting, to find the point in 3-dimensional manhattan
  space which is contained within the most spheres.  This was a
  challenge to come up with a good solution for, as I've not done much
  computational geometry stuff before.

  The solution I came up with ended up being the same as most other
  people, as it turns out.  The insight is that it's cheap to check if
  a sphere overlaps a *region* of space, and it's cheap to split a
  region into smaller regions, knowing which spheres overlap each such
  subregion.  So you can recursively partition the space until you get
  to a region of a single point, with more overlapping spheres than
  any other region.  If you explore regions in order of how many
  overlapping spheres they have (using a priority queue), you
  effectively rapidly zoom in on the best point, and don't even
  consider most of the space.  I got the idea by thinking of how you
  would solve this by eye in a 2d space with translucent circles on a
  huge piece of paper: you'd try to find the darkest bits of paper
  first and then examine those more closely.

[Advent of Code]: https://adventofcode.com/2018/
[my solutions are on github]: https://github.com/barrucadu/aoc
[day 23 part 2]: https://adventofcode.com/2018/day/23

## Link Roundup

- [Announce: Stackage LTS 13 with ghc-8.6.3](https://www.stackage.org/blog/2018/12/announce-lts-13)
- [Domain Registrar Can be Held Liable for Pirate Site, Court Rules](https://torrentfreak.com/domain-registrar-can-be-held-liable-for-pirate-site-court-rules-181224/)
- [Issue 139 :: Haskell Weekly](https://haskellweekly.news/issues/139.html)
- [The Essence of Datalog](https://dodisturb.me/posts/2018-12-25-The-Essence-of-Datalog.html)
- [The vanished grandeur of accounting](https://www.bostonglobe.com/ideas/2014/06/07/the-vanished-grandeur-accounting/3zcbRBoPDNIryWyNYNMvbO/story.html)
- [This Week in Rust 266](https://this-week-in-rust.org/blog/2018/12/25/this-week-in-rust-266/)
