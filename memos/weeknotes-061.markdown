---
title: "Weeknotes: 061"
tags: weeknotes
date: 2019-11-17
audience: General
---

## Open Source

- I released [concurrency-1.8.1.0][], adding a `newTVarConc` method to
  `MonadConc`:

  ```haskell
  -- | Create a @TVar@. This may be implemented differently for speed.
  --
  -- > newTVarConc = atomically . newTVar
  --
  -- @since 1.8.1.0
  newTVarConc :: a -> m (TVar (STM m) a)
  newTVarConc = atomically . newTVar
  ```

  The `IO` instances uses `newTVarIO`.

[concurrency-1.8.1.0]: http://hackage.haskell.org/package/concurrency-1.8.1.0

## Work

- This week had a bunch of little things:

  - I made spelling suggestions [only bold the corrected words][],
    which required [a small change in search-api][] to get
    Elasticsearch tell us what those words are.

  - I fixed a nearly two-year-old issue [with a two-line diff][].

  - I switched off one A/B test (shingles: results were sadly
    inconclusive) and switched on another (a change to how we rank
    spelling suggestions).

  - I shrunk our search-api and Elasticsearch resources down to what
    they were before we recently scaled up.

  - I made [a red graph less red][].

  - And I [removed an old dependency][], making the code shorter while
    I was at it.

- I was off on Thursday to go look at some flats in [Rickmansworth][].
  More on that later.

[only bold the corrected words]: https://github.com/alphagov/finder-frontend/pull/1734
[a small change in search-api]: https://github.com/alphagov/search-api/pull/1786
[with a two-line diff]: https://github.com/alphagov/search-api/pull/1790
[a red graph less red]: https://github.com/alphagov/govuk-puppet/pull/9838
[removed an old dependency]: https://github.com/alphagov/smart-answers/pull/4217
[Rickmansworth]: https://en.wikipedia.org/wiki/Rickmansworth

## Miscellaneous

- I read [The Path of Daggers][] (by Robert Jordan), the eighth book
  in the Wheel of Time series.

- I continued with my project to get [GOV.UK running on Kubernetes][],
  and have made some good progress this week:

  - [Concourse][] builds docker images for all the apps ([PR#1][])
  - The frontend apps are running in production-mode against the live GOV.UK apis ([PR#5][])
  - I'm using Amazon's [Elastic Kubernetes Service][] to manage the cluster ([PR#8][])

  I've got some really neat stuff set up, for example:

  - An app which requests storage will automatically provision and attach an EBS volume
  - An app which accepts external traffic will automatically provision an ALB and set up a Route53 entry

  I've started to work on the publishing apps, but I've not done much
  more than deploy content-store and a proof-of-concept MongoDB
  instance.  I'd like to also deploy search-api, router-api, and
  router (with their respective databases); putting in some fake data;
  and seeing if it all works.  Once that proof-of-concept has been
  tested, I'd then like to switch to using the AWS managed
  Elasticsearch and Document DB, rather than running them myself.

- In the process of switching govuk-k8s to using EKS, I also switched
  it from nginx to [Caddy][], because it turns out nginx has some
  really strange ideas about hostnames:

  > This also switches from nginx to caddy because nginx has some
  > interesting ideas about hostnames:
  >
  > 1. If given statically, nginx resolves all hostnames at start-up.
  >
  >    - If a hostname doesn't resolve, nginx doesn't start.  This is
  >      a problem because the ALBs won't exist until the apps are
  >      deployed.
  >
  >    - If a hostname is changed to point to a different IP, nginx
  >      won't pick up that change either.
  >
  > 2. If given dynamically (in a variable), nginx forces you to
  >    construct the proxy URL yourself.
  >
  >    - It seems exceedingly difficult to construct a URL based on
  >      user-supplied input which doesn't open a possibility of SSRF.
  >
  > Caddy solves both of these problems by just behaving sensibly with
  > hostnames.

  I've known about Caddy for a while, but not tried it before.  The
  configuration is way simpler than nginx, as it has more sensible
  defaults.  I'm planning to switch all my servers from nginx to Caddy
  now.

- I went to see three flats in Rickmansworth on Thursday, and decided
  to rent one of them.  It's a five minute walk from the tube station,
  which itself is about an hour away from the station next to work.
  My criteria when looking for a flat were:

  - No more than an hour and a half from work
  - The commute to work is a single tube journey / bus ride / whatever
  - Can get at least 300Mb internet (preferably Hyperoptic, but that proved far too limiting)
  - Has space for: VR gaming, table-top gaming, and a computer desk

  My current flat is pretty small, and I've had to move my computer
  every time I wanted to use the table for boardgames, which sucks a
  lot.  The flat I picked is over twice the size, and has a second
  bedroom which I can turn into a home office.

[The Path of Daggers]: https://en.wikipedia.org/wiki/The_Path_of_Daggers
[GOV.UK running on Kubernetes]: https://github.com/barrucadu/govuk-k8s
[Concourse]: https://concourse-ci.org/
[PR#1]: https://github.com/barrucadu/govuk-k8s/pull/1
[PR#5]: https://github.com/barrucadu/govuk-k8s/pull/5
[Elastic Kubernetes Service]: https://aws.amazon.com/eks/
[PR#8]: https://github.com/barrucadu/govuk-k8s/pull/8
[Caddy]: https://caddyserver.com/

## Link Roundup

- [This Week in Rust 312](https://this-week-in-rust.org/blog/2019/11/12/this-week-in-rust-312/)
- [NixOS Weekly #14 - Hercules CI launch, performance improvements in nixpkgs, single dependency kubernetes clusters](https://weekly.nixos.org/2019/14-hercules-ci-launch-performance-improvements-in-nixpkgs-single-dependency-kubernetes-clusters.html)
- [Issue 185 :: Haskell Weekly](https://haskellweekly.news/issue/185.html)
- [2019 State of Haskell Survey results](https://taylor.fausak.me/2019/11/16/haskell-survey-results/)
