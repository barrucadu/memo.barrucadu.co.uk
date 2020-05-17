---
title: "Weeknotes: 087"
taxon: weeknotes-2020
date: 2020-05-17
---

## Open Source

A couple of new releases of [the concurrency package][] this week,
thanks to [Mitchell Rosen][] for opening the issues.  I've added the
`getMaskingState` and `unsafeUnmask` functions to `MonadConc`, and
released new versions of [dejafu][] supporting them too.

Mitchell tried to open a PR for one of the changes, but my Travis
config turned out not to be very friendly towards outside
contributions.  So I migrated to using [GitHub Actions][] for CI and
[Concourse][] for CD.  More on that later.

[the concurrency package]: http://hackage.haskell.org/package/concurrency
[dejafu]: https://hackage.haskell.org/package/dejafu
[Mitchell Rosen]: https://github.com/mitchellwrosen
[GitHub Actions]: https://github.com/features/actions
[Concourse]: https://cd.barrucadu.dev/


## Work

I took this week off work to relax.


## Books

I did a lot of reading this week, and also thought about a what books
I *want* to read in the future.

### Books I Read

- **The Dream-Quest of Unknown Kadath**, a graphic novel adaptation by
  [I. N. J. Culbard][].  I've got a few of his adaptations, and
  they're all pretty great.  There are a lot more he's done which I
  *don't* own yet, but I definitely want to.

- **Neuromancer**, by [William Gibson][].  I started reading this the
  previous week, but finished it off this week.  I liked it, I see why
  it captured popular culture so much.  In the 1980s it must have been
  incredibly forward-looking.  It's still pretty forward-looking now.
  I'll get the rest of the books in the trilogy at some point.

- **The Fall of Icarus** and **A Cup of Sake Beneath the Cherry
  Trees**, in the [Penguin Little Black Classics][] collection.  I
  really like these books: lots of tiny classics (or tiny excerpts of
  classics), published in books which cost £1 or £2 each.

- **The Final Empire** and **The Well of Ascension**, by [Brandon
  Sanderson][].  These are the first purely-Sanderson books I've read:
  I'd read the [Wheel of Time][] books he finished, but nothing else.
  I liked the setting and the story, he quickly built up an
  interesting world and an engaging plot which had me read each book
  in almost one sitting each.  I've got the third book in the Mistborn
  trilogy on its way.

- **The Book of Monelle**, by [Marcel Schwob][].  This was an
  influential book in the early French symbolist movement, and I can
  see why.  It's a collection of short stories, written as he watched
  the girl he loved slowly die of tuberculosis.  Sometimes you can
  just breeze through a collection of stories, but I had to take a
  little break after each one to digest it.  The translation I've got,
  by Kit Schluter, is very well done: it's easy to read and, while I
  can't compare with the original, it feels like it kept the emotion
  and the powerful writing.

- **Trouble with Lichen**, by [John Wyndham][].  What happens when two
  biochemists discover a rare type of lichen which slows down ageing?
  Everything goes wrong, that's what.

[I. N. J. Culbard]: https://en.wikipedia.org/wiki/Ian_Culbard
[William Gibson]: https://en.wikipedia.org/wiki/William_Gibson#Neuromancer
[Penguin Little Black Classics]: http://www.littleblackclassics.com/
[Brandon Sanderson]: https://en.wikipedia.org/wiki/Brandon_Sanderson
[Wheel of Time]: https://en.wikipedia.org/wiki/The_Wheel_of_Time
[Marcel Schwob]: https://en.wikipedia.org/wiki/Marcel_Schwob
[John Wyndham]: https://en.wikipedia.org/wiki/John_Wyndham

### Books I Want to Have Read

I have (or had) a lot of lists of books to read: some were entries on
my to-do list; many were scattered across my bookmarks; and still more
were in various Amazon wishlists.  And most of them I'd not reviewed
since first noting them down 5+ years ago.  In practice, I almost
never looked at the lists, and just bought things which caught my eye.
That's not a bad way to buy books but, in that case, why not just
delete the lists?

Relatedly, I had read a blog post a while ago about [why you should
have a reading plan][], and I'd wanted to come up with one, but it
felt like a daunting task.

This week I set out to tackle both problems.

First I unified all my book wishlists.  Some of the lists I just
deleted entirely without looking at (what are the chances I've lost
something irreplacable?  very slim), but most of them I read, and
pruned books I no longer wanted, or already owned, or which I couldn't
find in print (unless it was an out-of-print book I really wanted).

This resulted in a single list of 300 or so books.

I then started to think about a reading plan.  Many people read the
classics, or biographies of statesmen, or histories of a certain
period: these are all well-defined categories.  So I felt that my
reading plan should be more structured than just a list of 300 books I
happened to like the sound of.

I could read the classics, that's certainly a conventional approach,
but also I don't find it very appealing.  Then it struck me.  When I'm
in a book shop and don't know what to buy, I've found that a very safe
bet is something in the [SF Masterworks][] collection.  Every book in
that collection which I've bought, I've enjoyed.

So here's my reading plan:

- The [SF Masterworks][] collection
- The [Fantasy Masterworks][] collection
- The [Penguin Little Black Classics][] collection

All collections of classics, but not *the* classics.

And now my list of books has 535 entries.  That should keep me busy
for the next decade or so.

[why you should have a reading plan]: https://www.artofmanliness.com/articles/why-you-need-a-reading-plan/
[SF Masterworks]: https://en.wikipedia.org/wiki/SF_Masterworks
[Fantasy Masterworks]: https://en.wikipedia.org/wiki/Fantasy_Masterworks


## CI and CD

At work, we've recently decided to start using [GitHub Actions][] for
CI, and to migrate away from our self-hosted [Jenkins][] instances.
There are a lot of advantages (which I won't go into here, but [here's
the RFC should you want to read it][]), and this decision put GitHub
Actions on my radar.

For my own stuff, I've been using [Travis][], but I hadn't been too
happy about using it since May 2018, when it was announced [that open
source things would be migrating to travis-ci.com][].  The promised
migration hasn't happened yet, two years later, and I've been warily
expecting all my CI to just break and require me to do some
maintenance at some point.  Uncertainty is not good.

GitHub Actions looked pretty good, so I decided to migrate dejafu's
[CI to Actions][] and its [CD to Concourse][].

I think it went pretty well.  I've not had an opportunity to actually
*test* the CD side of it yet, but the CI has been working nicely.
I've decided to migrate the rest of my Haskell libraries
over---[irc-ctcp][], [irc-conduit][], [irc-client][], and
[both][]---they're all deeply in maintenance mode, but consistency is
good.

[Jenkins]: https://www.jenkins.io/
[here's the RFC should you want to read it]: https://github.com/alphagov/govuk-rfcs/pull/123
[Travis]: https://travis-ci.org/
[that open source things would be migrating to travis-ci.com]: https://blog.travis-ci.com/2018-05-02-open-source-projects-on-travis-ci-com-with-github-apps
[CI to Actions]: https://github.com/barrucadu/dejafu/pull/321
[CD to Concourse]: https://github.com/barrucadu/barrucadu.dev/compare/22b3ff63833edd658a3b978d6ce70dbb0bd8af61..57ebfcbf9abfd7fdcc8890c9fc3a04f20305bfb0
[irc-ctcp]: https://github.com/barrucadu/irc-ctcp
[irc-conduit]: https://github.com/barrucadu/irc-conduit
[irc-client]: https://github.com/barrucadu/irc-client
[both]: https://github.com/barrucadu/both

## Link Roundup

- [This Week in Rust 338](https://this-week-in-rust.org/blog/2020/05/12/this-week-in-rust-338/)
- [Issue 211 :: Haskell Weekly](https://haskellweekly.news/issue/211.html)
- [The neoliberal era is ending. What comes next?](https://thecorrespondent.com/466/the-neoliberal-era-is-ending-what-comes-next/61655148676-a00ee89a)
- [Mapped: how long did it take to travel the world 100 years ago?](https://www.telegraph.co.uk/travel/news/What-travelling-was-like-100-years-ago/)
