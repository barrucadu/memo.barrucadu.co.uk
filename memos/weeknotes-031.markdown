---
title: "Weeknotes: 031"
tags: weeknotes
date: 2019-04-21
audience: General
---

## Work

- I reviewed and deployed a change to redirect the old whitehall
  consultations finder to [a new one built in finder-frontend][].  The
  [statistics finder][] will hopefully be done soon too.  Moving
  functionality from whitehall into other apps lets us reduce
  complexity in whitehall itself, and centralise related features
  (like all search things being in finder-frontend), which makes it
  much easier to have consistent behaviour for similar things across
  GOV.UK.

- I continued cleaning up the old elasticsearch 2 stuff:

  - Destroying 3 VMs in our integration environment and shutting down
    6 each in our production and staging environments.
  - Removing all of the code for elasticsearch 2 and the old search
    app from our puppet.
  - Fiddling around with GitHub repositories.
  - Ensuring everything refers to the new search app, rather than the
    old one (which we'd aliased to refer to the new one).

  [I seem to delete a lot of code][].

- I did some thinking about switching the GOV.UK continuous
  integration to Concourse, which in principle a few of us are working
  on this quarter in our spare time.  Nothing has been said or done
  about that in a few weeks, so I might send an email around to those
  involved and see if (a) they still want to be involved and (b) what
  people want to do, and what time they can put in.  Now that we've
  all had a couple of weeks on our new teams, hopefully everyone will
  have a better idea of when they can work on things.

- My line manager asked me if I would be open to be becoming a line
  manager, I said yes, and the next morning HR emailed me to say I'd
  be the line manager for someone starting in a few weeks.  They don't
  wait around.

[a new one built in finder-frontend]: https://www.gov.uk/search/policy-papers-and-consultations?content_store_document_type%5B%5D=open_consultations&content_store_document_type%5B%5D=closed_consultations
[statistics finder]: https://www.gov.uk/government/statistics
[I seem to delete a lot of code]: https://github.com/alphagov/govuk-puppet/pull/9009

## Miscellaneous

- I made a new layout for this site.  It's suspiciously similar to one
  of the entries in this week's link roundup.

- I read [Peopleware: Productive Projects and Teams][], which I last
  read some years ago.  It's primarily aimed at people managing a
  whole team, so there's not much which is directly applicable to my
  role, but it's still full of good advice and interesting anecdotes.

- I started reading [Void Star][], but I'm not far enough through to
  really have an opinion yet.

- The [rewrite of BookDB][] with Elixir and Vue.js is going well.
  It's nice to see how simple implementing filtering and sorting a
  table is with Vue, as that's something I've wanted for a while.  I
  think probably the next step is to embed the initial list of books
  in the page, rather than making an ajax request immediately after
  page load, and also supporting filtering on a field by the URL (eg,
  [https://www.barrucadu.co.uk/bookdb/location/London](https://www.barrucadu.co.uk/bookdb/location/London)).

- My [Concourse CI on NixOS][] memo made it to [this instalment of
  NixOS Weekly][].

- I played around GOV.UK content data using [Gephi][] and wrote
  [Mapping GOV.UK][] to share some of the fancier graphs.

[Concourse CI on NixOS]: concourseci-nixos.html
[this instalment of NixOS Weekly]: https://weekly.nixos.org/2019/07-nixos-19-03-release-ipfs-ci-integrations-and-documentation-feedback.html
[Peopleware: Productive Projects and Teams]: https://en.wikipedia.org/wiki/Peopleware:_Productive_Projects_and_Teams
[Void Star]: https://en.wikipedia.org/wiki/Void_Star
[rewrite of BookDB]: https://github.com/barrucadu/bookdb-new
[Gephi]: https://gephi.org/
[Mapping GOV.UK]: mapping-govuk.html

## Link Roundup

- [How to Track Your Kids (and Other People's Kids) With the TicTocTrack Watch](https://www.troyhunt.com/how-to-track-your-kids-and-other-peoples-kids-with-the-tictoctrack-watch/)
- [NixOS Weekly #07 - NixOS 19.03 release, IPFS, CI integrations and documentation feedback](https://weekly.nixos.org/2019/07-nixos-19-03-release-ipfs-ci-integrations-and-documentation-feedback.html)
- [This Week in Rust 282](https://this-week-in-rust.org/blog/2019/04/16/this-week-in-rust-282/)
- [Haskell Weekly :: Issue 155](https://haskellweekly.news/issues/155.html)
- [Every Day Recursion Schemes](https://shmish111.github.io/2019/04/13/recursion-schemes-patterns/)
- [How to fool the "try some test cases" heuristic: Algorithms that appear correct, but are actually incorrect](https://cs.stackexchange.com/questions/29475/how-to-fool-the-try-some-test-cases-heuristic-algorithms-that-appear-correct)
- [Explaining Code using ASCII Art](https://blog.regehr.org/archives/1653)
- [Population Mountains](https://pudding.cool/2018/12/3d-cities-story/)
- [Stacked Borrows Implemented](https://www.ralfj.de/blog/2018/11/16/stacked-borrows-implementation.html)
- [Finding Bugs in Cassandra's Internals with Property-based Testing](http://cassandra.apache.org/blog/2018/10/17/finding_bugs_with_property_based_testing.html)
