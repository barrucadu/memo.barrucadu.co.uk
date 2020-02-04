---
title: "Weeknotes: 030"
taxon: weeknotes-2019
date: 2019-04-14
---

## Ph.D

- I registered for my graduation, and had to provide a 50 character
  summary of my research topic, to be read out by the presenter.
  Sadly, the actual thesis isn't quite that concise.

## Work

- I started on the Bravigation (Brexit Navigation / Making Brexit
  Content Easier To Find) team on Monday, which involved moving to the
  other (much cooler) end of the office.  I keep walking past things
  and turning at the wrong places, but I'm sure I'll get used to it.
  There were a lot of team kickoff things, and when they weren't
  happening I mostly continued some search tidy-up work remaining from
  last quarter.

- We had a few more issues with search this week, so on Thursday and
  Friday I was taken away from my new team and put onto a temporary
  search reliability / performance investigation team.  We spent the
  two days going through the full stack---AWS managed Elasticsearch,
  [search-api][], and [finder-frontend][]---looking for areas of
  improvement.  We found two pretty bad issues:

  1. Our Elasticsearch cluster didn't have adequate resources and so
     queries were sometimes taking up to two seconds to execute, and
     we'd not spotted this previously because nobody was familiar
     enough with it.  Each individual query was running in about 20ms,
     but the queue of queries sometimes grew to 100.  We fixed this by
     adding a few more nodes to the cluster.

  2. Our nginx timeout was set to 15s, but our [unicorn][] timeout was
     60s.  This means that if a request took longer than 15s to
     process, nginx would time out (and try a different unicorn
     worker) but the original unicorn would keep on processing the
     request.  This is pretty bad, because it means that a small batch
     of slow requests can result in all of the unicorn workers tied up
     processing things nginx has given up on.  If there are no free
     unicorn workers, nginx has to drop connections.

  Put together, these explained the issue we were seeing of a very
  small increase in load resulting in a dramatic increase in errors.
  A small increase in load to Elasticsearch resulted in queries taking
  a couple of extra seconds, which made search-api slower to respond
  to finder-frontend, which made finder-frontend slower, which made
  nginx start timing out, which caused the pool of unicorn workers to
  rapidly be exhausted.  And then search breaks for everyone.

  We scaled up the Elasticsearch cluster on Thursday, and on Friday
  could see that it was performing significantly better than
  previously.  We changed the unicorn timeout on Friday, though with
  Elasticsearch performing better it's a less significant problem.
  The main lesson to take away from this is to be quite careful with
  the performance of API-style apps, as small problems can have a
  significant knock-on effect.

[search-api]: https://github.com/alphagov/search-api
[finder-frontend]: https://github.com/alphagov/finder-frontend
[unicorn]: https://bogomips.org/unicorn/

## Miscellaneous

- NixOS 19.03 came out.  Upgrading to it just worked.  A part of me
  yearns for my old Ubuntu days, where a dist upgrade was a scary
  process with a real chance of trashing your set-up if you did
  anything even remotely non-trivial.  Where's the fun in things just
  working?

- What *didn't* just work was deploying exactly the same Concourse
  configuration I have on dunwich [to nyarlathotep][].  I thought one
  of the selling points of containers is that they're trivial to
  deploy reproducibly, but...

- I made a list of all the changes I wanted to make to [BookDB][], and
  the list turned out to be pretty long.  Addressing all the changes
  with the current codebase would almost be a complete rewrite, so
  I've decided to just do that.  I'm going to use this as an
  opportunity to learn [Phoenix][], a popular Elixir web framework.  A
  lot of the changes I want are interface changes, so I'm also going
  to pick up some [Vue][].  This will be the third time BookDB has
  been totally rewritten in a different language: Python (from the
  Haskell original), then back to Haskell, now Elixir.

[to nyarlathotep]: https://github.com/concourse/concourse-docker/issues/42
[BookDB]: https://www.barrucadu.co.uk/bookdb/
[Phoenix]: https://phoenixframework.org/
[Vue]: https://vuejs.org/

## Link Roundup

- [Code Review: Approve with Suggestions](http://neilmitchell.blogspot.com/2019/04/code-review-approve-with-suggestions.html)
- [GHC 8.8 Status](https://www.haskell.org/ghc/blog/20190405-ghc-8.8-status.html)
- [A gentle introduction to symbolic execution](https://blog.monic.co/a-gentle-introduction-to-symbolic-execution/)
- [Issue 154 :: Haskell Weekly](https://haskellweekly.news/issues/154.html)
- [This Week in Rust 281](https://this-week-in-rust.org/blog/2019/04/09/this-week-in-rust-281/)
- [NixOS 19.03 release](https://discourse.nixos.org/t/nixos-19-03-release/2652)
- [Finding Property Tests](https://www.hillelwayne.com/post/contract-examples/)
- [How bad can it git? Characterizing secret leakage in public GitHub repositories](https://blog.acolyer.org/2019/04/08/how-bad-can-it-git-characterizing-secret-leakage-in-public-github-repositories/)
- [How can basic arithmetic make a self-referential sentence?](http://r6.ca/blog/20190223T161625Z.html)
- [Moving from Ruby to Rust](https://deliveroo.engineering/2019/02/14/moving-from-ruby-to-rust.html)
- [Languages I want to write](https://blog.wesleyac.com/posts/language-todos)
- [My first fifteen compilers](http://composition.al/blog/2017/07/31/my-first-fifteen-compilers/)
- [US Govt and Rightsholders Want WHOIS Data Accessible Again, to Catch Pirates](https://torrentfreak.com/us-govt-and-rightsholders-want-whois-data-accessible-again-to-catch-pirates-190413/)
- [It rather involved being on the other side of this airtight hatchway](https://devblogs.microsoft.com/oldnewthing/20060508-22/?p=31283)
