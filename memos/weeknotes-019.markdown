---
title: "Weeknotes: 019"
taxon: weeknotes-2019
date: 2019-01-27
---

## Work

- Work continues on upgrading our elasticsearch cluster to version 5.
  This week I finished [making rummager elasticsearch 5 compatible][],
  and now we've run into the nitty gritty of how this is actually
  going to work: how we can run two elasticsearch clusters and two
  rummagers at once (to gradually migrate); how to set up a new app
  (for this second rummager); how we can get elasticsearch 5 into our
  continuous integration; and how this is all going to fit around the
  AWS Migration Team moving apps between hosting providers.

[making Rummager elasticsearch 5 compatible]: https://github.com/alphagov/rummager/pull/1403

## Miscellaneous

- I decided to tackle some of the [dejafu roadmap][], which led to
  preparing a new release soon to be version [2.0.0.0][]:
  - Everything deprecated has been removed.
  - [#119][]: length-bounding now works for random testing, as well as
    systematic testing.
  - [#202][]: I've replaced the hacky `dontCheck` and `systematically`
    functions with a more principled interface which rules out some
    incorrect uses of the API.

  There are a few more things I want to get done before cutting the
  release:

  - [#177][]: invariants which get checked between scheduling points.
  - [#225][]: a function to abort a test execution early.
  - More tutorial-style documentation in the Test.DejaFu module.  For
    this I'll be looking at other testing libraries and seeing how
    they present their documentation.

  Because this is a super-major version bump, I'll be writing a short
  migration guide and also some sort of release announcement to share
  to [/r/haskell][] and the [haskell-cafe][].

- After roughly 6 days of fermentation, I started flavouring my second
  batch of kombucha.  I'm flavouring the whole thing in one go (other
  than a little bit left behind to keep the starter culture alive),
  with 400g of crushed cherries and a little squash.  I'm planning on
  flavouring it for at least three days this time before bottling it
  for carbonation.

- I finished migrating all my passwords from [LastPass][] to
  [KeePassXC][], something I started in October when I realised it was
  a bit hypocritical of me to trust LastPass with secrets but not AWS.
  Now I'm trusting KeePassXC and [Syncthing][], but it's easy to
  verify that KeePassXC is locally encrypting my passwords, and I
  could migrate away from Syncthing (eg, to just using ssh/scp) with
  little effort.

  One of my monthly chores is to review old passwords, so each month
  I've been moving some more over (and moving passwords over as I use
  them), and closing old accounts I don't need any more.  From next
  month I'll start rotating old credentials.

[dejafu roadmap]: https://github.com/barrucadu/dejafu/issues?q=is%3Aissue+is%3Aopen+label%3Aroadmap
[2.0.0.0]: https://github.com/barrucadu/dejafu/compare/2000
[#119]: https://github.com/barrucadu/dejafu/issues/119
[#202]: https://github.com/barrucadu/dejafu/issues/202
[#177]: https://github.com/barrucadu/dejafu/issues/177
[#225]: https://github.com/barrucadu/dejafu/issues/225
[/r/haskell]: https://old.reddit.com/r/haskell/
[haskell-cafe]: https://mail.haskell.org/mailman/listinfo/haskell-cafe
[LastPass]: https://www.lastpass.com/
[KeePassXC]: https://keepassxc.org/
[Syncthing]: https://syncthing.net/

## Link Roundup

- [Game Developer Uses DMCA Notice to 'Free' Its Game from Steam Publisher](https://torrentfreak.com/game-developer-uses-dmca-notice-to-free-its-game-from-steam-publisher-190124/)
- [HLint Unused Extension Hints](https://neilmitchell.blogspot.com/2019/01/hlint-unused-extension-hints.html)
- [HTTP(S) interception for my IoT lab](https://symbiotic.technology/lab/2019/01/25/ssl.html)
- [Issue 143 :: Haskell Weekly](https://haskellweekly.news/issues/143.html)
- [Surprises of the Haskell module system (part 2)](https://ro-che.info/articles/2019-01-26-haskell-module-system-p2)
- [This Week in Rust 270](https://this-week-in-rust.org/blog/2019/01/22/this-week-in-rust-270/)
