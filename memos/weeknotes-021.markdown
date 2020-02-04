---
title: "Weeknotes: 021"
taxon: weeknotes-2019
date: 2019-02-10
---

## Open Source

- I built [Adjoint's libraft tests][] against dejafu-2.0.0.0, with [a
  minimal diff to the package.yaml and stack.yaml][], and the tests
  compiled and ran just fine.  So despite changing the fundamental
  abstraction in dejafu and the types of all the testing functions, I
  managed to avoid any breaking changes in the common case.  Nice!

- I wrote a [migration guide for dejafu 1.x to 2.x][].  All that
  remains now is to review the rest of the documentation.

[Adjoint's libraft tests]: https://github.com/adjoint-io/raft/blob/master/test/TestDejaFu.hs
[a minimal diff to the package.yaml and stack.yaml]: https://gist.github.com/barrucadu/3ef0b43e904cd536a31302e9f82f83ff
[migration guide for dejafu 1.x to 2.x]: https://github.com/barrucadu/dejafu/commit/4744aa7544b6dc5765e0b8a57ac734fec777130c

## Ph.D

- I decided to do the optional correction the examiners gave me, which
  was to talk about related work by Kostis Sagonas.  I looked through
  his recent work, and found two papers which looked pretty relevant:

  - [Systematic Testing for Detecting Concurrency Errors in Erlang
    Programs][], which I suspect is *the* related work they wanted me
    to talk about, which describes a tool for systematically testing
    concurrent Erlang programs.  It's similar to [Pulse][], another
    Erlang concurrency testing tool, but uses iterative pre-emption
    bounding to explore schedules, rather than random exploration.
    Unlike dejafu, it doesn't use dynamic partial-order reduction, so
    in principle it will explore more executions than necessary.

    Interestingly, this and dejafu both use the same optimisation:
    avoiding scheduling threads which will immediately block without
    updating any shared state.  If a thread does that, then there'll
    be a context switch immediately, so there's no point in scheduling
    the thread.  Just schedule the thread which will be context
    switched to instead.  I don't think I read about this idea
    elsewhere (and I didn't consider it interesting enough to mention
    in my thesis until I read about it here), so it's a case of
    independent discovery.

  - [Optimal Dynamic Partial Order Reduction with Observers][], which
    really reminds me of some other related work I've talked about in
    my thesis called "[Maximal Causality Reduction][]".  Maximal
    Causality Reduction and Optimal DPOR with Observers are both based
    on the insight that, if you have bunch of writes to the same
    shared state, their order only actually matters if there exists a
    read which will observe the ordering difference.  This lets you
    prune a bunch of additional schedules on top of regular DPOR.

    It would be really nice to implement one of these algorithms in
    dejafu, but they both have quite strong restrictions on how
    threads can interact, and these restrictions don't hold in
    Haskell.  Maybe in the future!

[Systematic Testing for Detecting Concurrency Errors in Erlang Programs]: https://concuerror.com/assets/pdf/ICST2013.pdf
[Pulse]: http://publications.lib.chalmers.se/records/fulltext/125252/local_125252.pdf
[Optimal Dynamic Partial Order Reduction with Observers]: https://link.springer.com/chapter/10.1007/978-3-319-89963-3_14
[Maximal Causality Reduction]: https://parasol.tamu.edu/~jeff/academic/mcr.pdf

## Work

- I set up a new non-manged elasticsearch 5 cluster in our integration
  environment, fixed a bunch of configuration issues which that
  revealed, and verified that updates from publishing applications are
  now making it across.  Then I started looking at importing data from
  the elasticsearch 2 cluster---I expected that to just work, but it
  didn't, so next week I'll be trying to figure out why a few tens of
  thousands of documents didn't get imported.

- We continued working out the costs and benefits of a managed cluster
  vs a non-managed one.  Initially we were in favour of a managed
  cluster, but the balance has shifted somewhat as we've looked into
  it a bit more.  A managed cluster limits what you can do (you have
  to do things in the way the provider allows), and using a managed
  cluster still requires knowledge of elasticsearch in GOV.UK, to fix
  our apps when a new elasticsearch version makes a breaking API
  change. Our existing non-managed elasticsearch 2 cluster just works,
  and people barely need to touch it, so I have to wonder what exactly
  the benefits of a managed cluster are.  In addition, we also have
  all the puppet and terraform written to provision a non-managed
  cluster, but we'd need to figure out how to set up a managed one and
  connect it to our apps.

## Miscellaneous

- I renewed my passport using [the online service][].  I got my
  replacement passport in the same week I submitted the form, which
  was impressively fast.

- I flavoured and bottled some pear and ginger kombucha I've had
  fermenting for a while.  This one is using a mix of green and black
  tea, rather than puerh, and fermented a lot more slowly.  I'm hoping
  that this will avoid the bad taste of my two previous batches.

- My [Call of Cthulhu][] campaign reached the thrilling conclusion of
  the current chapter.  This was the first direct confrontation with
  the mythos the players have had since the prologue chapter, and the
  session involved using dynamite to blow up a bunch of magical
  zombies and a sorcerer.  Their sanity greatly damaged, the
  investigators have set sail to London to follow the trail of clues.

- I've been playing a lot of [Runescape][].

[the online service]: https://www.gov.uk/apply-renew-passport
[Call of Cthulhu]: https://www.chaosium.com/call-of-cthulhu-rpg/
[Runescape]: https://www.runescape.com/

## Link Roundup

- [Term/Type Punning in Haskell](https://int-index.com/posts/haskell-punning)
- [Categories with Monadic Effects and State Machines](https://coot.me/posts/categories-with-monadic-effects.html)
- [The inside story of the great KFC chicken shortage of 2018](https://www.wired.co.uk/article/kfc-chicken-crisis-shortage-supply-chain-logistics-experts)
- [Lost HP Lovecraft work commissioned by Houdini escapes shackles of history](https://www.theguardian.com/books/2016/mar/16/hp-lovecraft-harry-houdini-manuscript-cancer-superstition-memorabilia)
- [How QuantifiedConstraints can let us put join back in Monad](http://ryanglscott.github.io/2018/03/04/how-quantifiedconstraints-can-let-us-put-join-back-in-monad/)
- [The Boeing 777 Flies on 99.9% Ada](http://archive.adaic.com/projects/atwork/boeing.html)
- [Kenyan Govt. Protests as National Anthem Hit With YouTube Copyright Complaint](https://torrentfreak.com/kenyan-govt-protests-as-national-anthem-hit-with-youtube-copyright-complaint-190206/)
- [Can't Unsee](https://cantunsee.space/)
- [This Week in Rust 272](https://this-week-in-rust.org/blog/2019/02/05/this-week-in-rust-272/)
- [Mapping a universe of open source software](https://www.tweag.io/posts/2019-02-06-mapping-open-source.html)
- [NixOS Weekly #02 - 19.03 feature freeze, EU grants, reproducibility, Nix in Debian](https://weekly.nixos.org/2019/02-1903-feature-freeze-eu-grants-reproducibility-nix-in-debian.html)
- [Bootstrapping a Type System](http://journal.stuffwithstuff.com/2010/10/29/bootstrapping-a-type-system/)
- [A Rape in Cyberspace](http://www.juliandibbell.com/texts/bungle_vv.html)
- [Issue 145 :: Haskell Weekly](https://haskellweekly.news/issues/145.html)
- [How to Write Technical Posts (so people will read them)](https://reasonablypolymorphic.com/blog/writing-technical-posts/)
- [#15290 (QuantifiedConstraints: panic "addTcEvBind NoEvBindsVar") – GHC](https://ghc.haskell.org/trac/ghc/ticket/15290)
- [Proxy arguments in class methods: a comparative analysis](https://ryanglscott.github.io/2019/02/06/proxy-arguments-in-class-methods/)
- [Servant Route Smooshing](https://www.parsonsmatt.org/2018/03/14/servant_route_smooshing.html)
- [Closing the Loop: The Importance of External Engagement in Computer Science Research](https://blog.regehr.org/archives/1582)
- [Paths to External Engagement in Computer Science Research](https://blog.regehr.org/archives/1586)
- [Funky coordinate systems](https://blog.plover.com/math/coordinate-systems.html)
- [Rust: A unique perspective](https://limpet.net/mbrubeck/2019/02/07/rust-a-unique-perspective.html)
