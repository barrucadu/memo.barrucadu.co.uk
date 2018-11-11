---
title: "Weeknotes: 008"
tags: weeknotes
date: 2018-11-11
audience: General
---

## Ph.D

* After two and a half weeks of doing nothing, I finished off chapter
  4: an introduction to property-based testing.  Now all that remains
  is the abstract, introduction, conclusions, and future work.  I left
  all of these to the end because their content largely depends on the
  rest of the thesis.

## Work

* On GOV.UK we handle draft content by having separate databases for
  draft and live content, and running two sets of frontend apps: one
  for draft and one for live.  The draft apps are protected behind
  [signon][], our single sign-on service.  Historically, our content
  item API, [which I mentioned last week][], hasn't worked for draft
  content; I fixed that.  It turned out to be a surprisingly complex
  problem, involving puppet, nginx, firewall rules, and DNS.

* I fixed a [discrepancy in our local-links-manager][] app, which is
  what handles linking to local government services from GOV.UK.  I'm
  not really sure if I actually fixed the problem, or just fixed the
  symptoms, but it's good enough for now.

* I did a bit of [refactoring of our Jenkins configuration][], to help
  avoid implicit dependencies between Jenkins jobs and how our
  machines are currently set up.

* I finally deleted our logging VMs, which I started [a month ago][].
  This isn't the first time I've retired something---if I keep this
  up, I should have switched off all of GOV.UK in about 10 years.

* I took Thursday and Friday off.  I had planned to go to [Code
  Mesh][], but in the 5 months since I submitted my request, HR didn't
  manage to buy the tickets.  Not going to the conference was
  disappointing, but having some time off was still nice.

[signon]: https://github.com/alphagov/signon
[which I mentioned last week]: /weeknotes-007.html
[discrepancy in our local-links-manager]: https://github.com/alphagov/local-links-manager/pull/334
[refactoring of our Jenkins configuration]: https://github.com/alphagov/govuk-puppet/pull/8301
[a month ago]: /weeknotes-003.html
[Code Mesh]: https://codesync.global/conferences/code-mesh-2018/

## Miscellaneous

* I did some reading:

  * I read The Checklist Manifesto, which was really good.  It's about
    how checklists became standard in surgery, which sounds like the
    driest topic imaginable, but it's full of interesting anecdotes
    from aviation, construction, finance, and the odd surgeon who
    realised the benefits before they became widespread.  It's got me
    wondering what things I should have checklists for.

  * I finished Children of Dune.  Unfortunately the rest of my Dune
    books are buried in a loft in Hull, so I can't move on to my
    favourite Dune book: God Emperor of Dune.

  I've now moved on to Lolita, which [I last read in December 2012][].

* I started writing up [my session notes from Call of Cthulhu][].

* A replacement motherboard for nyarlathotep, [my broken server][],
  arrived on Monday; but was itself busted.  I've sent it back, and I
  guess it will be next week before I get things working again.

* I think my flat is cursed, as azathoth, my desktop computer, also
  died.  So I went from having a working desktop computer and a
  working server, to both being dead in 11 days.

  Fortunately, it was the CPU that had died (somehow), so I was able
  to use the CPU that I'd bought for nyarlathotep---the same model as
  the one in my desktop.  So now I have a working desktop again, but
  I'll need to buy another processor for nyarlathotep.  Fortunately
  2012-era processors aren't that expensive.  Certainly much cheaper
  than building a new desktop computer with modern hardware.

* I've started looking into [Elixir][], and read through [the
  guides][].  It looks pretty nice, and I'm tempted to write a little
  HTTP router for it.  Such a router would inspect the request path
  and do one of:

  * Act as a reverse proxy to another server, if the request method is
    allowed.
  * Perform an "internal redirect", change the request path and
    re-route, without sending a 3xx to the client.
  * Perform an "external redirect", send a 3xx to the client.
  * Return a 410.

  A path without a route would return a 404.  The 404, 405, 410, and
  500 responses would use a static file as the response body.

  Ideally, the collection of routes would live in a database or a
  file, and a signal would trigger the router to re-load them into
  memory, probably as a trie, and atomically switch to using the new
  routes.  This is similar to the [GOV.UK router][], but written in
  Elixir rather than Go.

[I last read in December 2012]: https://www.barrucadu.co.uk/bookdb
[my session notes from Call of Cthulhu]: /masks-of-nyarlathotep.html
[my broken server]: /weeknotes-007.html
[Elixir]: https://elixir-lang.org/
[the guides]: https://elixir-lang.org/getting-started/introduction.html
[GOV.UK router]: https://github.com/alphagov/router
[in my budget]: /personal-finance.html

## Link Roundup

* [Assert yourself - The Boston Diaries](http://boston.conman.org/2018/11/06.1)
* [Good Practices for Capability URLs](https://www.w3.org/TR/capability-urls/)
* [Issue 132 :: Haskell Weekly](https://haskellweekly.news/issues/132.html)
* [Local Goal Setting](https://www.drmaciver.com/2018/11/local-goal-setting/)
* [Privacy and Tracking on the Fediverse](https://blog.soykaf.com/post/privacy-and-tracking-on-the-fediverse/)
* [Programming Quotes](http://quotes.cat-v.org/programming/)
* [Specification gaming examples in AI](https://docs.google.com/spreadsheets/u/1/d/e/2PACX-1vRPiprOaC3HsCf5Tuum8bRfzYUiKLRqJmbOoC-32JorNdfyTiRRsR7Ea5eWtvsWzuxo8bjOxCG84dAg/pubhtml)
* [The Hidden Complexity of Wishes](https://www.lesswrong.com/posts/4ARaTpNX62uaL86j6/the-hidden-complexity-of-wishes)
* [This Week in Rust 259](https://this-week-in-rust.org/blog/2018/11/06/this-week-in-rust-259/)
