---
title: "Weeknotes: 042"
taxon: weeknotes-2019
date: 2019-07-07
---

## Work

- This week was firebreak, the gap between quarters in which we work
  on different things.  This time the powers that be decided all the
  communities (developers, content designers, etc) should work on a
  community-wide project.  The project we developers decided on was
  throwing out our rather painful and slow development VM in favour of
  a new thing based on docker.  There was already a prototype, which
  one developer had written for their own use, so the task was to get
  as many of the remaining apps done as reasonably possible within a
  week, and to make any other improvements which seemed relevant.

  The result is [govuk-docker][].  It's not quite done yet---there are
  missing apps, and there's no way to load in production data
  yet---but it's a good result.  In some free time I expended my own
  [GOV.UK shell scripts][].

- I also wrote [another rota generator][], this time for the content
  support rotas.  The rota for next quarter is already done, so the
  tool hasn't had any use yet, but there's always next time.  To get
  this done I had to implement a notion of "soft constraints":
  constraints that get relaxed if no satisfying solution is found.
  Trying the relaxations one after the other would be slow, so I also
  parallelised the rota generator.

- I got a statement of my pension from the Civil Service pensions
  people.  It includes prominent mention of how much my estate would
  be paid if I were to die in service... do they know something about
  my future I don't?

[govuk-docker]: https://github.com/alphagov/govuk-docker/
[GOV.UK shell scripts]: https://github.com/barrucadu/dotfiles/blob/master/zsh/.zsh/90-gds
[another rota generator]: https://github.com/barrucadu/govuk-rota-generators

## Miscellaneous

- I've got a lot of things bookmarked to be read "later".  The list
  keeps growing because I find things I want to read faster than I get
  through them.  Some of the bookmarks are years old, and still not
  read.  This week I tried to read a few of the older ones, and the
  links had all rotted since I first found them in 2016.  Are the
  pages gone?  Merely moved?  Whatever the case, they're not where I
  knew them to be, and I didn't get redirected to a new location.  It
  would be nice if people didn't remove things from the internet, or
  at least served a proper [410 error][] page when it's an intentional
  removal.

[410 error]: https://httpstatuses.com/410

## Link Roundup

- [PhD Abstracts | Journal of Functional Programming](https://www.cambridge.org/core/journals/journal-of-functional-programming/article/phd-abstracts/06E7785894BD9EAC9903940267B9A4DF)
- [AIs named by AIs](https://aiweirdness.com/post/185883998702/ais-named-by-ais)
- [TeX: A tale of two worlds](https://bitbashing.io/tex.html)
- [It’s Time for a Modern Synthesis Kernel](https://blog.regehr.org/archives/1676)
- [This Week in Rust 293](https://this-week-in-rust.org/blog/2019/07/02/this-week-in-rust-293/)
- [Making site search work smarter for users](https://insidegovuk.blog.gov.uk/2019/07/05/making-site-search-work-smarter-for-users/)
- [The programmer as decision maker](https://blog.ploeh.dk/2019/03/18/the-programmer-as-decision-maker/)
- [Virtue Ethics - Stanford Encyclopedia of Philosophy](https://plato.stanford.edu/entries/ethics-virtue/)
- [Issue 166 :: Haskell Weekly](https://haskellweekly.news/issues/166.html)
