---
title: "Weeknotes: 018"
tags: weeknotes
date: 2019-01-20
audience: General
---

## Ph.D

- I submitted my revised thesis on Thursday, and it was sent to the
  examiners on Friday.  Hopefully it won't be too long before I hear
  back.  It's possible I could be given more corrections to do, but
  only minor corrections with a three-month deadline, not the
  year-long major corrections I did have.

## Work

- It's a new quarter, and I am on a new team.  I'm on a small team
  working on upgrading our [elasticsearch][] set-up from 2.something
  to 5 or, ideally, 6.  This is a bit challenging because none of us
  know anything about elasticsearch.  Fortunately, the needed changes
  appear to be confined to [rummager][]---which powers the site
  search, finders, etc---and [licence-finder][]---which powers... the
  [licence finder][].

[elasticsearch]: https://www.elastic.co/products/elasticsearch
[rummager]: https://github.com/alphagov/rummager
[licence-finder]: https://github.com/alphagov/licence-finder
[licence finder]: https://www.gov.uk/licence-finder

## Miscellaneous

- I made [the first real change to dejafu since July][], just fixing
  up a confusing interface, but it took me a while to do because I'd
  forgotten a lot.  I've not been very motivated to work on dejafu
  with the thesis looming (and the last significant change was fixing
  [a bug I discovered while writing something up][]), but now that
  that's submitted it's a more enticing prospect again.  I've also
  been thinking about how to fix a fairly nasty wart that can lead to
  runtime errors, and I think I've got a good solution.  Watch this
  space.

- I tried my kombucha again after another few days, and there was no
  change in carbonation.  So I've definitely messed up the first batch
  a bit.  But I think I know what the major mistakes were, so I've
  started a second batch which I hope will go better.

[the first real change to dejafu since July]: https://github.com/barrucadu/dejafu/pull/295
[a bug I discovered while writing something up]: https://github.com/barrucadu/dejafu/pull/284

## Link Roundup

- [Adding new DNA letters make novel proteins possible](https://www.economist.com/science-and-technology/2019/01/19/adding-new-dna-letters-make-novel-proteins-possible)
- [Coding Machines](https://www.teamten.com/lawrence/writings/coding-machines/)
- [Dhall - Year in review (2018-2019)](http://www.haskellforall.com/2019/01/dhall-year-in-review-2018-2019.html)
- [Issue 142 :: Haskell Weekly](https://haskellweekly.news/issues/142.html)
- [NixOS Weekly #01 - TerraNix, Debian packaging, elm2nix, RaspberryPi 3+](https://weekly.nixos.org/2019/01-terranix-debian-packaging-elm2nix-raspberrypi-3.html)
- [Operant Conditioning by Software Bugs](https://blog.regehr.org/archives/861)
- [Postgres full-text search is Good Enough!](http://rachbelaid.com/postgres-full-text-search-is-good-enough/)
- [SELF-REFERENTIAL APTITUDE TEST, by James Propp](http://faculty.uml.edu/jpropp/srat-Q.txt)
- [The Bug Slip](https://www.jackkinsella.ie/articles/the-bug-slip)
- [The Embroidered Computer](http://www.ireneposch.net/the-embroidered-computer/)
- [This Is a Blog Post. It Is Not a “Blog.”](https://slate.com/culture/2013/05/blog-post-vs-blog-this-blog-post-is-not-a-blog.html)
- [This Week in Rust 269](https://this-week-in-rust.org/blog/2019/01/15/this-week-in-rust-269/)
- [Unix folklore: using multiple sync commands](https://utcc.utoronto.ca/~cks/space/blog/unix/TheLegendOfSync)
- [Why I Hate Advocacy](https://www.perl.com/pub/2000/12/advocacy.html/)
