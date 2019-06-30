---
title: "Weeknotes: 041"
tags: weeknotes
category: Week Notes
date: 2019-06-30
audience: General
---

## Work

- It's the end of the quarter, so the pace has slowed, we've mostly
  been focussing on making sure everything is done and documented.
  Here are the highlights:

  - [Advanced search is gone][], as regular search is now advanced
    enough.  Doing search in only one way will let us [simplify a lot
    of the finder-frontend code][], so we can implement new things
    more easily.

  - There's [a new facet to browse by supergroup][] in the search
    (click "+ Show more search options").  A supergroup is a
    collection of document types.  We didn't want to call the facet
    "Supergroup", because that then requires *explaining* what
    document types are, so instead after a lot of deliberation we
    called it "Show only".

  - I started writing up [the decisions made to update to
    Elasticsearch 6][], but because we've not started serving search
    queries from ES6 yet that'll hang around incomplete for a while.

- Next week is firebreak, the gap between the quarters, and all the
  developers on GOV.UK are going to split into small teams and work on
  dockerising everything for local development, as the VM we currently
  use has issues.

[Advanced search is gone]: https://github.com/alphagov/finder-frontend/pull/1214
[simplify a lot of the finder-frontend code]: https://github.com/alphagov/finder-frontend/pull/1232
[a new facet to browse by supergroup]: https://www.gov.uk/search/all
[the decisions made to update to Elasticsearch 6]: https://github.com/alphagov/search-api/blob/msw/es6-adr/doc/arch/adr-009-elasticsearch6-upgrade.md

## Miscellaneous

- I was thinking about integer linear programming (ILP), after being
  asked about making another rota generator at work.  [I've written
  before][] about modelling rotas with ILP.  I was thinking about how
  it would be nice if the rota-generating code looked more like the
  maths.  So I put together [a little programming language for ILP][]
  (still incomplete!), which gets most of the way there.

- I've been reading [The Historian][] by Elizabeth Kostova, which is a
  horror-themed mystery about the legend of Dracula, which perhaps
  isn't merely legendary after all.  The story involves a few layers:
  the chronologically earliest character involved is an academic
  called Rossi; Rossi left letters and his research to his student
  Paul; and Paul is the father of the narrator.  Each character got
  pulled into the Dracula legend in their own way (partly by their
  predecessor, other than for Rossi), and conducts their own
  investigation.  The story is from the point of view of the narrator,
  sharing what she knew about the earlier characters and her own
  investigation.  It's pretty good so far, as of the end of part 1 (a
  quarter or so of the way in).

- I'm investigating switching from Chrome to Firefox, and [have
  discovered that they render fonts differently][].  Fonts are
  noticeably larger in Firefox.  Bold is bolder.  Glyph outlines are
  more jagged.  Kerning just looks off somehow.  These are all the
  case in both Windows and Linux.  Not a great first impression, I
  have to say.

[I've written before]: scheduling-problems.html
[a little programming language for ILP]: ilp-generator.html
[The Historian]: https://en.wikipedia.org/wiki/The_Historian
[have discovered that they render fonts differently]: https://twitter.com/barrucadu/status/1145103412813553666

## Link Roundup

- [49% of all Google searches are no-click, study finds](https://searchengineland.com/49-of-all-google-searches-are-no-click-study-finds-318426)
- [Today, I used laziness for ...](https://www.reddit.com/r/haskell/comments/5xge0v/today_i_used_laziness_for/)
- [How Verizon and a BGP Optimizer Knocked Large Parts of the Internet Offline Today](https://blog.cloudflare.com/how-verizon-and-a-bgp-optimizer-knocked-large-parts-of-the-internet-offline-today/)
- [This Week in Rust 292](https://this-week-in-rust.org/blog/2019/06/25/this-week-in-rust-292/)
- [The Anti-Phonetic Alphabet](http://www.panix.com/~vr/alphabet.html)
- [Issue 165 :: Haskell Weekly](https://haskellweekly.news/issues/165.html)
- [NixOS Weekly #10 - Redox on NixOS, ad-hoc container images, nix-mode.el, static site deploys, a job](https://weekly.nixos.org/2019/10-redox-on-nixos-ad-hoc-container-images-nix-mode-el-static-site-deploys-a-job.html)
- [Nixery - ad-hoc container images - powered by Nix](https://nixery.appspot.com/)
- [Optimising Docker Layers for Better Caching with Nix](https://grahamc.com/blog/nix-and-layered-docker-images)
- [Pleroma 1.0.0](https://blog.soykaf.com/post/pleroma-1.0/)
- [SKS Keyserver Network Under Attack](https://gist.github.com/rjhansen/67ab921ffb4084c865b3618d6955275f)
- [Understanding the npm dependency model](https://lexi-lambda.github.io/blog/2016/08/24/understanding-the-npm-dependency-model/)
