---
title: "Weeknotes: 003"
taxon: weeknotes-2018
date: 2018-10-07
---

## Personal

* I realised that last year was the 15th anniversary of my first
  published program, a game called [Monster Builder][] on the
  [BYOND][] platform, which I made in early 2002.  Really it was just
  a small modification of an existing game, whose name I can't
  remember.  In 2004 I gave a copy of the source code to someone, they
  posted it online, and I got mad and deleted the original game.  I
  then put it back online in 2006.

  You can tell it's from a long time ago because I still capitalised
  "Barrucadu".  In fact, that account on BYOND is the source of the
  name: it was a joint account for me and my brother.  He wanted to be
  a marine biologist at the time but, alas, couldn't quite spell
  "barracuda".

[Monster Builder]: https://secure.byond.com/games/Barrucadu/MonsterBuilder
[BYOND]: https://secure.byond.com/

## Ph.D

* I implemented the feedback I got on my operational semantics last
  week, and that section is now looking pretty good.

## Work

* I was still on support Monday and Tuesday this week:

    * I had another [data.gov.uk][] harvesting problem to fix.  That's
      quite the ordeal for a Monday morning.

    * We got a support ticket to move some content from [Natural
      England][] to the [Rural Payments Agency][] (RPA), and the
      ticket came with a "preliminary list" of pages needing changes.
      I thought "preliminary, that means incomplete---I wonder if they
      just want all Natural England content changing?"  So I asked:

      > Hi NAME,
      >
      > There are 1524 documents in Whitehall Publisher where Natural
      > England is the lead organisation, and 197 where Natural
      > England is a supporting organisation.  This includes all
      > documents, even those which have never been published (the
      > only edition is a draft, for example), and which have been
      > withdrawn or superseded.  I have attached a list.
      >
      > Would you like them all changed to the RPA, or just the ones
      > in the your spreadsheet?  I can do this for you today.
      >
      > Michael Walker | GOV.UK Developer

      I'm sure you can see where this is going.  RPA guy said to go
      ahead and change them all.  I made the change.  The next morning
      we got an urgent support ticket from Natural England asking why
      all their content had been moved.  Whoops.

* After getting off support, I started to look into some memory issues
  we've been having with our [asset-manager][] and [publishing-api][]
  applications; usage had roughly doubled since we started using [AWS
  X-Ray][].  In the asset-manager, I found that enabling X-Ray caused
  each thread to use an additional ~100MB resident memory (from 87 to
  192): given that it's just recording the target and duration of HTTP
  requests and sending them to a daemon on localhost, this seemed
  crazy!

  I tracked down the problem to enabling tracing of requests made
  using the [aws-sdk][] gem.  Tracing of regular [net_http][] requests
  is, ironically, fine.  So [we disabled tracing of aws-sdk
  requests][] and [raised an issue on aws-xray-sdk][].

* I finished off the work from "[Weeknotes: 001][]" on making
  [transition][] pull its stats from an S3 bucket, it just needs
  deploying.  Once we're satisfied that the new code is doing the
  right thing, we can delete 5GB of logs stretching back 6 years, and
  also the three machines (one in each of production, staging, and
  integration) which exist solely to process them.

* I asked why something was the way it was, and got linked to the
  Trello card *I wrote* about why it was the way it was.  I then
  changed the way it was, so it no longer is as it was.

[data.gov.uk]: https://data.gov.uk
[Natural England]: https://www.gov.uk/government/organisations/natural-england
[Rural Payments Agency]: https://www.gov.uk/government/organisations/rural-payments-agency
[asset-manager]: https://github.com/alphagov/asset-manager
[publishing-api]: https://github.com/alphagov/publishing-api
[AWS X-Ray]: https://aws.amazon.com/xray/
[aws-sdk]: https://rubygems.org/gems/aws-sdk/
[net_http]: https://www.rubydoc.info/stdlib/net/Net/HTTP
[we disabled tracing of aws-sdk requests]: https://github.com/alphagov/govuk_app_config/pull/61
[raised an issue on aws-xray-sdk]: https://github.com/aws/aws-xray-sdk-ruby/issues/13
[Weeknotes: 001]: weeknotes-001.html
[transition]: https://github.com/alphagov/transition

## Miscellaneous

* My "[C is not Turing-complete][]" memo got [posted to lobste.rs][].
  A lot of people seemed to miss the point, so I added a summary of
  the argument at the top.

* I discovered how easy it is to make really tasty roasted onions
  (thick-slice the onions; mix with olive oil, sea salt, and pepper in
  a roasting tray; perhaps add some sliced garlic and/or
  worcestershire sauce; put in oven on 200C for 45 minutes, stirring
  in the middle).  I can never go back to fried onions.

* One of the RAM sockets on my desktop computer's motherboard died on
  Thursday.  The symptoms: the computer locked up, and when I
  power-cycled it, both Windows and Linux panicked during boot.
  Windows gave a blue screen with a message about an unexpected
  interrupt, Linux varied but most consistently complained about a
  [general protection fault][].

  This was a bit tricky to figure out, because the symptoms of a dead
  RAM socket are much like the symptoms of a dead RAM stick, until you
  think you've isolated the problem and it then breaks in a new way.
  So I'm down from 16GB of RAM to 12GB, which isn't much of a problem,
  but more worryingly my motherboard is possibly beginning to fail.

* I contributed [a small documentation fix to pleroma][].

* I was flipping through my academic reading list, which has been
  largely untouched since I moved to London, and came across [Can
  automated pull requests encourage software developers to upgrade
  out-of-date dependencies?][] At GOV.UK, the answer is definitely a
  resounding "yes".

[C is not Turing-complete]: c-is-not-turing-complete.html
[posted to lobste.rs]: https://lobste.rs/s/bovwsx/c_is_not_turing_complete_2017
[general protection fault]: https://en.wikipedia.org/wiki/General_protection_fault
[a small documentation fix to pleroma]: https://git.pleroma.social/pleroma/pleroma/merge_requests/364
[Can automated pull requests encourage software developers to upgrade out-of-date dependencies?]: http://chrisparnin.me/pdf/VersionBot17.pdf

## Link Roundup

I only thought of this section on Saturday evening, and I have the
memory of a goldfish, so it's a bit sparse.

* [Announcing stackage nightly snapshots with ghc-8.6.1](https://www.stackage.org/blog/2018/09/announce-ghc-8.6-on-nightlies)

* [Ask HN: What is your best advice for a junior software developer?](https://news.ycombinator.com/item?id=18128477)

  There's some good advice here, particularly about reading error
  messages.  A surprising number of people don't.

* [[Haskell-cafe] [Call for Contributions] Haskell Communities and Activities Report, November 2018 edition (35th edition)](https://mail.haskell.org/pipermail/haskell-cafe/2018-October/130071.html)

* [Michael Haufe on Twitter: "The mindset between treating types as
  guardrails and treating types as the
  semantics"](https://twitter.com/mlhaufe/status/1048343652299419649)

  I really like this distinction because I'm in the latter camp, and
  never really thought about the former.  My attitude toward types is
  "of course you must know what type something is, otherwise how can
  you do anything with it?", which naturally leads to a preference for
  static typing over dynamic typing.

* [Midnight Snacks &raquo; Show #706: 10.03.18](https://midnightsnacks.fm/show/706/10.03.18)

* [NixOS 18.09 Jellyfish: released](https://discourse.nixos.org/t/nixos-18-09-jellyfish-released/1076)

* [The page cannot be found](http://www.mhra.gov.uk/home/groups/spcpil/documents/spcpil/con1404110695043.pdf)

  This 404 page is a blast from the past.

* [Writing system software: code comments](http://antirez.com/news/124)
