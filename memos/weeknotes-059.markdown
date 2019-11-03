---
title: "Weeknotes: 059"
tags: weeknotes
date: 2019-11-03
audience: General
---

## Work

- We spotted an odd spelling suggestion, where the suggestion seemed
  too different to the original query.  So I dug into how suggestions
  work.  Elasticsearch uses a *distance metric* as part of its ranking
  for spelling suggestions.  It compares the suggestion to the
  original query and comes up with a number.  That number feeds into
  how it chooses the best suggestion.

  We currently use the default metric, `internal`:

  > The default based on `damerau_levenshtein` but highly optimized
  > for comparing string distance for terms inside the index.

  [Damerau-Levenshtein][] distance and [Levenshtein][] distance are
  classic distance metrics for ordered sequences.  They count how many
  of the following operations you need to do to transform one sequence
  into the other.  The allowed operations are:

  - Deleting a character
  - Inserting a character
  - Replacing one character with another
  - And, in Damerau-Levenshtein but not Levenshtein, transposing two
    characters

  For example, "dog" has a Levenshtein distance of 2 from "god":

  1. Replace "d" with "g"
  2. Replace second "g" with "d"

  But it only has a Damerau-Levenshtein distance of 1:

  1. Transpose "d" and "g"

  Damerau-Levenshtein is generally good because it captures a lot of
  common typos.  But we have some evidence to suggest that it's not
  right for us.

  Currently, if you search for ["change adress"][], the top suggestion
  is "change across".  This is not good.  However, if I change the
  distance metric to `levenshtein`, the top suggestion is "change
  address", and "change across" isn't even in the top 5.  This is
  good, but strange.

  I don't understand why it makes a difference in this case, as
  according to both metrics "change address" is only a distance of 1
  from "change adress" (insert a "d"), whereas "change across" is a
  distance of 2 from "change adress" (replace "d" with "c", replace
  "e" with "o").  Nevertheless, it *does* make a difference.  I assume
  Elasticsearch is doing something special and not using a "pure"
  Damerau-Levenshtein.  I also assume it's something to do with us
  wanting to correct phrases as a whole, rather than just correcting
  individual terms: there are more pages matching ["change across"][]
  than there are matching ["change address"][].

  We've not made the change in production yet.  I think the next thing
  for us to do here is to change the metric in our integration
  environment and see how the suggestions for the top 10,000 or so
  queries change.  We could even A/B test this and see how it affects
  the suggestion acceptance rate.

- On GOV.UK search pages, there's a sidebar with some expandable
  "facets" (or "filters", depending on who you ask).  For example, the
  [/search/all page][] has "Show only", "Organisation", "Person", and
  "World location".  They're good tools for power users to narrow
  their search, but there are a *lot* of organisations, people, and
  world locations.

  [I put together a prototype][] of making those last three facets
  dynamic: they only show entries relevant to your current search.
  For example, if you select the Foreign and Commonwealth Office, then
  you'll only get people and world locations for which there is
  content tagged both to the FCO and that person or location.  If you
  select a person, the world locations will be narrowed further (and
  vice versa).

  It's *done* in terms of meeting the requirements and not introducing
  any new bugs, but now that there is a prototype it needs some
  product review to determine if it's actually a good thing to do.

- [Rails 6 came out recently][], so it's time to upgrade everything on
  GOV.UK.  Thankfully there's a migration script which handles *most*
  of it for you.  I had a go at [finder-frontend][].  I've been having
  flashbacks to upgrading [Overleaf][] (well, Overleaf classic) from
  Rails 4 to Rails 5.

- I deployed an A/B test for incorporating bigrams into ranking, which
  [I investigated a few weeks ago in the team hackathon][].  Hopefully
  they'll help as much with real queries as they did with our test
  queries.

[Damerau-Levenshtein]: https://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance
[Levenshtein]: https://en.wikipedia.org/wiki/Levenshtein_distance
["change adress"]: https://www.gov.uk/search/all?keywords="change+adress"
["change across"]: https://www.gov.uk/search/all?keywords="change+across"
["change address"]: https://www.gov.uk/search/all?keywords="change+address"
[/search/all page]: https://www.gov.uk/search/all
[I put together a prototype]: https://github.com/alphagov/finder-frontend/pull/1691
[Rails 6 came out recently]: https://edgeguides.rubyonrails.org/6_0_release_notes.html
[finder-frontend]: https://github.com/alphagov/finder-frontend/pull/1709
[Overleaf]: https://www.overleaf.com/
[I investigated a few weeks ago in the team hackathon]: weeknotes-056.html

## Miscellaneous

- I read [Lord of Chaos][] (by Robert Jordan), the sixth book in the
  Wheel of Time series.

- Fed up with not really understanding how CSS handles conflict
  resolution, I finally sat down and read the MDN docs, and then
  [implemented the cascade algorithm][] myself.  My code agrees with
  Firefox on the one example I tried, so I think that's a win.

- I updated all my servers so that [LetsEncrypt certificates wouldn't
  start failing to renew][].

[Lord of Chaos]: https://en.wikipedia.org/wiki/Lord_of_Chaos
[implemented the cascade algorithm]: css-cascade.html
[LetsEncrypt certificates wouldn't start failing to renew]: https://github.com/NixOS/nixpkgs/pull/71953

## Link Roundup

- [Understanding searches better than ever before](https://www.blog.google/products/search/search-language-understanding-bert)
- [The Great(er) Bear - using Wikidata to generate better artwork](https://shkspr.mobi/blog/2019/11/the-greater-bear-using-wikidata-to-generate-better-artwork/)
- [Building personal search infrastructure for your knowledge and code](https://beepb00p.xyz/pkm-search.html)
- [The Extended Mind](https://1000wordphilosophy.com/2014/05/19/the-extended-mind/)
- [This Week in Rust 310](https://this-week-in-rust.org/blog/2019/10/29/this-week-in-rust-310/)
- [Issue 183 :: Haskell Weekly](https://haskellweekly.news/issue/183.html)
- [Haskell2020 Is Dead, but All Hope Is Not Lost](http://reasonablypolymorphic.com/blog/haskell202x/index.html)
- [The reasonable effectiveness of the continuation monad](https://blog.poisson.chat/posts/2019-10-26-reasonable-continuations.html)
- [A monad is just a submonad of the continuation monad, what's the problem?](https://blog.poisson.chat/posts/2019-10-27-continuation-submonads.html)
- [Low-latency garbage collector merged for GHC 8.10](http://www.well-typed.com/blog/2019/10/nonmoving-gc-merge/)
