---
title: "Weeknotes: 047"
tags: weeknotes
date: 2019-08-11 23:00:00
audience: General
---

## Work

- I added a "document type" facet to the [Transparency and Freedom of
  Information finder][], because people who look at that sort of
  content need that.  On Monday I'll have to republish all the
  organisation pages, so the "Corporate reports" and "Transparency
  data" links go to an appropriately scoped search.

- I added a hidden document type facet to the [all-content finder][],
  so now you can scope a search to (for example) [only teacher
  misconduct panel outcomes][].  It's a hidden facet because there are
  a lot of document types and we don't really want to reveal that
  complexity to users, and different departments tend to use them
  slightly inconsistently, but occasionally a department does want to
  be able to link to a very tightly scoped search over its content.

- I've got [a PR to change some confusing wording for the statistics
  finder][].  You can sort statistics announcements by "oldest", which
  means "soonest" because all their timestamps are in the future
  (because they're upcoming statistics).  An open problem is what
  better word to use for sorting in the reverse order, as currently
  it's "latest".

- I rewrote [the script which puts Google Analytics popularity data
  into our internal search rankings][] in Python 3, from Python 2.7.  One more
  script down before the 2020 Python 2 end-of-life deadline, probably
  many more to go...  The [2to3][] tool was really good and handled
  most of the work, but there were a few cases where `str` and `bytes`
  were being confused, which needed manual fixing.

[Transparency and Freedom of Information finder]: https://www.gov.uk/search/transparency-and-freedom-of-information-releases
[all-content finder]: https://www.gov.uk/search/all
[only teacher misconduct panel outcomes]: https://www.gov.uk/search/all?content_store_document_type=decision&organisations[]=teaching-regulation-agency&organisations[]=general-teaching-council-for-england
[a PR to change some confusing wording for the statistics finder]: https://github.com/alphagov/finder-frontend/pull/1299
[the script which puts Google Analytics popularity data into our internal search rankings]: https://github.com/alphagov/search-analytics
[2to3]: https://docs.python.org/2/library/2to3.html

## Miscellaneous

- On Thursday I went to a [manga exhibition at the British Museum][].
  It was pretty interesting, in addition to all the displays, they had
  some video interviews with manga editors of what the industry was
  like from their perspective.  There was a lot of focus on the
  history and influences of manga (as you'd expect), but also some
  more modern developments.  One thing which stood out to me as
  strange is that there wasn't any mention of the slice of life genre,
  which is pretty big.  They had every other genre you could think of,
  but no slice of life.  A strange omission.

- I bought [Downward to the Earth][], by Robert Silverberg; [Raft][],
  by Stephen Baxter; and [The Art of Spirited Away][], by Studio
  Ghibli.

[manga exhibition at the British Museum]: https://www.britishmuseum.org/whats_on/exhibitions/manga.aspx
[Downward to the Earth]: https://en.wikipedia.org/wiki/Downward_to_the_Earth
[Raft]: https://en.wikipedia.org/wiki/Raft_(novel)
[The Art of Spirited Away]: https://www.goodreads.com/book/show/429853.The_Art_of_Spirited_Away

## Link Roundup

- [Issue 171 :: Haskell Weekly](https://haskellweekly.news/issues/171.html)
- [This Week in Rust 298](https://this-week-in-rust.org/blog/2019/08/06/this-week-in-rust-298/)
