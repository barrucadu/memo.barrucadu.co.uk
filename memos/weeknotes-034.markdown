---
title: "Weeknotes: 034"
taxon: weeknotes-2019
date: 2019-05-12
---

## Open Source

- I released new patch versions of [both][], [irc-conduit][], and
  [irc-client][] in response to updates to dependencies.

[both]: http://hackage.haskell.org/package/both
[irc-conduit]: http://hackage.haskell.org/package/irc-conduit
[irc-client]: http://hackage.haskell.org/package/irc-client

## Work

- This week I fixed how Elasticsearch works in our local development
  environment and continuous integration; wrote up the work needed to
  move to Elasticsearch 6 (I'm hoping we can do an in-place upgrade,
  rather than spin up a second cluster again); and read a bunch of
  fairly dry documentation, because I'll be the line manager for
  someone starting on Monday.

## Miscellaneous

- I graphed [some Call of Cthulhu dice roll probabilities][], playing
  around with [matplotlib][]'s xkcd-style graphs.  I think the line
  charts look pretty good, but I'm not so sure about the heatmaps.
  The coloured squares are precise for the wiggly axes.

[some Call of Cthulhu dice roll probabilities]: call-of-cthulhu-dice-rolls.html
[matplotlib]: https://matplotlib.org/

## Link Roundup

- [This Week in Rust 285](https://this-week-in-rust.org/blog/2019/05/07/this-week-in-rust-285/)
- [Some Tricks for List Manipulation](https://doisinkidney.com/posts/2019-05-08-list-manipulation-tricks.html)
- [Issue 158 :: Haskell Weekly](https://haskellweekly.news/issues/158.html)
- [Color Survey Results](https://blog.xkcd.com/2010/05/03/color-survey-results/)
- [Threading responsibly](https://mazzo.li/posts/threads-resources.html)
- Some posts on The Morning Paper about Heidi Howard's recent Ph.D thesis:
  - [Distributed consensus revised – Part I](https://blog.acolyer.org/2019/05/07/distributed-consensus-revised-part-i/)
  - [Distributed consensus revised – Part II](https://blog.acolyer.org/2019/05/08/distributed-consensus-revised-part-ii/)
  - [Distributed consensus revised – Part III](https://blog.acolyer.org/2019/05/10/distributed-consensus-revised-part-iii/)
- Some posts by Joe Neeman about patch theory, [pijul][], and [ojo][]:
  - [Part 1: Merging and patches](https://jneem.github.io/merging/)
  - [Part 2: Merging, patches, and pijul](https://jneem.github.io/pijul/)
  - [Part 3: Graggles can have cycles](https://jneem.github.io/cycles/)
  - [Part 4: Line IDs](https://jneem.github.io/ids/)
  - [Part 5: Pseudo-edges](https://jneem.github.io/pseudo/)

[pijul]: https://pijul.org/
[ojo]: https://github.com/jneem/ojo
