---
title: "Weeknotes: 182"
taxon: weeknotes-2022
date: 2022-03-13
---

## Work

I started my new job at [GoCardless][] on Tuesday.

I've never worked in finance before, and their infrastructure is built
on Kubernetes, which I only have a basic knowledge of, but most of the
code is Rails, which I've been using for years now at GDS.  Of course,
every project using a particular framework does so in its own
idiosyncratic way, but there tend to be more similarities than
differences.

So some things are new, other things are not so new.

My team seems nice, and owns some of the core components which the
rest of the business depend on.  It's satisfying to work on something
big and important.

I basically spent this week reading documentation and running through
the technical onboarding.  I've got some more business-focussed
onboarding sessions next week, but I'm hoping to start contributing
code as well.  I much prefer to dive straight in and learn by doing
over just reading and shadowing.

I'll still be mostly working from home, which is great.  Everyone on
the team tries to come into the office on Wednesdays, but other than
that it's up to whatever you feel like.

Since this all is now closed-source private sector work, I'm not
entirely sure what the future of this section of my weeknotes holds.
It'll certainly be more general, and maybe it'll be more focussed on
big-picture career things than the day-to-day.

[GoCardless]: https://gocardless.com/


## Books

This week I read:

- Volumes 7, 8, and 9 of [So I'm a Spider, So What?][] by Okina Baba

  I've got to the big plot twist which I saw people online vaguely
  hinting at, and which I'd looked up in advance because I just do
  that sort of thing (if a book is ruined by spoilers, it's not a good
  book).  It definitely feels like a good place to have an anime
  series cliffhanger, so I wonder if series two will do that.  It
  would only be four books (since the first series covered volumes 1
  through 5), which is a little short, but I'm sure it could work out:
  volume 7 has a lot of action, which could easily take up a few
  episodes.

  I'm now half-way through volume 10, so I expect to finish all the
  translated volumes next week.

[So I'm a Spider, So What?]: https://en.wikipedia.org/wiki/So_I%27m_a_Spider,_So_What%3F


## resolved

Not that much progress on [my DNS server][] this week.  I did make one
big decision though: I decided to bring authoritative zones into
scope.  Previously I'd decided that static records were enough, but I
think that properly supporting zones will be easier in the long run.

I'm not yet running `resolved` for my LAN DNS.  But I'm close now.
Before I switch that on I want to:

- Implement the zone file parser
- Add the necessary configuration to support [RFC 6761][]
- Package it for NixOS

Nearly there now.

I also wrote [a memo on how the cache works][], which got featured in
[This Week in Rust 433][].

Code wise, I merged two PRs:

- [Implement zones & refactor nonrecursive resolution](https://github.com/barrucadu/resolved/pull/41)

  Which is a significant change to the nonrecursive resolution: it
  makes the code look much more like [the algorithm in RFC 1034][];
  unifies my implementation of static records and root hints; and lets
  me return authoritative NXDOMAIN responses for local zones.

  With this in place, I can now start on implementing a parser for
  zone files, which will let me remove the existing (much more
  verbose) configuration mechanism, and means I'll be able to
  implement [RFC 6761][] with, hopefully, no code changes
  whatsoever---just configuration.

- [Drop support for non-IN record classes](https://github.com/barrucadu/resolved/pull/44)

  Since I don't have access to CSNET, the Chaos network, or the Hesiod
  network, supporting records for them just makes the code more
  verbose, since I have to check that classes are consistent all over
  the place.  By just dropping support for those classes entirely, I
  simplified a bunch of logic.

And I opened the following new issues:

- [Review & implement RFCs 2181, 4343, and 4592](https://github.com/barrucadu/resolved/issues/34)

  These three RFCs clarify a bunch of implementation concerns.  Not
  all the content is relevant to what I've built, but I definitely
  want to go through them all to see if I've made any common mistakes.

- [Implement RFC 6761: Special-Use Domain Names](https://github.com/barrucadu/resolved/issues/35)

  This RFC defines some special domain names which should be answered
  based on local information, rather than forwarded to the root
  nameservers.  This issue was a major driving force in me deciding to
  support authoritative zones: if I support authoritative zones, this
  RFC is just a configuration change; but it's a code change if I
  don't.

- [Wildcard queries should consult authoritative nameservers](https://github.com/barrucadu/resolved/issues/36)

  I noticed a discrepancy when running `dig A barrucadu.co.uk && dig
  ANY barrucadu.co.uk`.  `resolved` only returns the `A` record for
  the `ANY` query, whereas my Pi-hole forwards the query upstream and
  returns *all* the records.

- [Basic overview of how DNS works](https://github.com/barrucadu/resolved/issues/38)

  This is a documentation issue, to just write a little something
  about how the protocols and types work.

- [Document how configuration works](https://github.com/barrucadu/resolved/issues/39)

  This is another documentation issue.  When `resolved` supports zone
  files, it'll be very helpful to just have a quick summary of the
  format.  And also what all the other configuration options are.

- [Add a `dig`-like executable](https://github.com/barrucadu/resolved/issues/42)

  Really, this should have been the first thing I built.  Instead, I
  built a whole nameserver before thinking that a little tool to query
  an upstream nameserver and print out the result would be a handy
  debugging aid.  Sure, there's `dig` itself, but debugging my DNS
  resolution by starting the server and querying it so that it'll in
  turn query an upstream nameserver, is more awkward than just
  querying that upstream nameserver directly.

- [Add executable to convert a hosts file into a zone file](https://github.com/barrucadu/resolved/issues/43)

  This probably won't be very useful.  But it should also be very
  simple to implement.  So why not?

- [Package for NixOS](https://github.com/barrucadu/resolved/issues/45)

  This is, I think, the only **must have** before I can switch over my
  LAN DNS.  I need to actually be able to build and run `resolved`
  from my NixOS configuration, so that I can manage it in exactly the
  same way as I manage all the other services on my systems.

[my DNS server]: https://github.com/barrucadu/resolved
[a memo on how the cache works]: dns-cache.html
[This Week in Rust 433]: https://this-week-in-rust.org/blog/2022/03/09/this-week-in-rust-433/
[the algorithm in RFC 1034]: https://datatracker.ietf.org/doc/html/rfc1034#section-4.3.2
[RFC 6761]: https://datatracker.ietf.org/doc/html/rfc6761


## Link Roundup

### Finance

- [How do banks move your money?](https://wise.com/gb/blog/how-do-banks-move-your-money)
- [How Faster Payments Works](https://www.fasterpayments.org.uk/how-faster-payments-works)

### Programming

- [DNS resolution issue in Alpine Linux](https://christoph.luppri.ch/fixing-dns-resolution-for-ruby-on-alpine-linux)
- [The Code Review Pyramid](https://www.morling.dev/blog/the-code-review-pyramid/)

### Roleplaying games

- [The Danger Room](https://www.youtube.com/watch?v=eIas_87wTg4)
