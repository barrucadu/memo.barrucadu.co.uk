---
title: "Weeknotes: 007"
tags: weeknotes
date: 2018-11-04
audience: General
---

## Ph.D

* Another unproductive week.  As I've been [using Trello to track my
  to-do lists][], I decided to see how many thesis-related tasks I've
  done since July (I started using Trello mid-way through June, so am
  ignoring it for fairness):

  * July: 12 cards
  * August: 13 cards
  * September: 4 cards
  * October: 6 cards

  I think this shows fairly clearly that I've been putting off the
  more tedious corrections until the end.

[using Trello to track my to-do lists]: /self-organisation.html

## Work

* I did a little work on shrinking content items in our database.
  Every page on GOV.UK has a JSON content item, which you can access
  at `/api/content/<path>`.  For example, [the content item for the
  FCO organisation page][].  There are two fields in these content
  items which can get pretty big: the `details` hash and the `links`
  hash.  The `details` hash is kind of unavoidable complexity, it
  contains all the information about that thing.  The `links` hash is
  effectively a pre-computed `JOIN`: it contains everything relevant
  to the page, by default the full `details` hash for each linked
  content item.  The reason we have `links` is so that we only have to
  look up one thing in our database to render a single page (most of
  the time).

  Unfortunately including the full `details` hash of every linked
  thing blows up the size of our content items, which causes problems
  elsewhere.  So we've begun some work to figure out which fields are
  actually required, and only including those.  For example, for child
  organisations [we only need the "logo" and "brand" fields][].  For
  "contact"-type links, I found [we could remove the "contact type"
  field][].  There are a bunch more link types, and we are going to
  look at what we can remove from all of them.

  This isn't just a disk space concern, these large content items take
  longer than necessary to process and to copy around, so this work
  improves publishing latency as well.

* I covered someone's shift on support on Tuesday, the day after [the
  budget came out][].  Perhaps I should have foreseen this, but there
  was an urgent ticket from HMRC about two of their documents which
  hadn't published properly; so I spent a few hours on that.

  Fortunately I had been [evaluating a fix the day before][], so I
  could just continue that.  Unfortunately we then discovered that
  this fix broke [information pages for "World Locations"][].  We've
  had a lot of problems with this particular publishing application
  since mid-September, which almost all stem from the unforeseen
  consequences of a fairly fundamental change.  Legacy code is a pain.

* My work on [load-testing the GOV.UK frontend apps][] got
  open-sourced this week.  It turned out that there was actually no
  need to make it private at all; I could have had it open from the
  get-go.

* A change to the [holiday entitlement calculator][] which got [sent
  to BEIS for a fact-check][] came back, with more changes needed.
  The problem is that holiday entitlement is calculated in terms of
  "days", but they've not explicitly said what a "day" is if you work
  hourly.  Based on their comments, I think a "day" is a period of `n`
  hours, where `n` is the number of hours worked in a week divided by
  the number of calendar days worked in a week: in other words it
  assumes your weekly hours are distributed evenly across the calendar
  days you work.  We're sending them a list of examples to check, to
  validate this assumption.

[the content item for the FCO organisation page]: https://www.gov.uk/api/content/government/organisations/foreign-commonwealth-office
[we only need the "logo" and "brand" fields]: https://github.com/alphagov/publishing-api/pull/1349
[we could remove the "contact type" field]: https://github.com/alphagov/publishing-api/pull/1364
[the budget came out]: https://www.gov.uk/government/topical-events/budget-2018
[evaluating a fix the day before]: https://github.com/alphagov/whitehall/pull/4440
[information pages for "World Locations"]: https://github.com/alphagov/whitehall/pull/4465
[load-testing the GOV.UK frontend apps]: https://github.com/alphagov/govuk-load-testing
[holiday entitlement calculator]: https://www.gov.uk/calculate-your-holiday-entitlement
[sent to BEIS for a fact-check]: /weeknotes-005.html#work

## Miscellaneous

* I finished reading Dune Messiah and am now reading Children of Dune.

* I'm trying out [Monica][], a personal CRM (Customer Relationship
  Management) tool.  At the moment I'm just using it for contact
  information, but you can track a lot more stuff about people: where
  and when you met them, their relationships to other people, when you
  last had a conversation with them and what it was about, etc.  I've
  added a few online contacts and am going to try using it like an
  address book for a while.

* I've decided to migrate from [LastPass][] to [KeePassXC][], after
  realising [that it was a bit hypocritical of me to trust LastPass
  but not AWS][].  I'll synchronise my KeePassXC database with
  [Syncthing][], which I already use for other stuff.  Rather than
  just exporting all my passwords from LastPass and importing them to
  KeePassXC, I've decided to go through them all one at a time,
  closing old accounts I don't need any more and organising the
  passwords I do keep.

  Yesterday evening I copied across 48 passwords and closed a dozen or
  so accounts; only 99 to go.  I've also copied across my work
  passwords (previously in a separate LastPass account which used the
  same password as my personal LastPass...), and things which I never
  added to LastPass, like machine passwords and IRC NickServ
  passwords.

  I'm also taking the opportunity to get a new master password into my
  muscle-memory.

* I came across [Aether][], a distributed social *thing* with
  ephemeral content and proof-of-work to discourage spam.  It's early
  days, but looks interesting so far.  I'll be keeping an eye on
  development.

* I didn't get to the point of porting over some of the stuff I wanted
  in my [Rust LambdaMOO rewrite][], but I did do some tidying and also
  [copied across some string functions][].

* Nyarlathotep, my home server, unexpectedly died on Thursday.  It's
  had sporadic boot problems for years, but some time on Thursday it
  shut down and it hasn't managed to come back up since.  The RAM
  seems fine, I've removed the only unnecessary thing from the
  motherboard, and I even tried unplugging some of the hard drives in
  case the PSU wasn't keeping up, but with no luck.  I've ordered a
  new motherboard and processor, both some years old but good enough
  for my needs (and cheap because they're a bit older now).

[Monica]: https://www.monicahq.com/
[LastPass]: https://www.lastpass.com/
[KeePassXC]: https://keepassxc.org/
[that it was a bit hypocritical of me to trust LastPass but not AWS]: https://twitter.com/barrucadu/status/1036380342347882498
[Syncthing]: https://syncthing.net/
[Aether]: https://getaether.net/
[Rust LambdaMOO rewrite]: https://github.com/barrucadu/lambdamoo
[copied across some string functions]: https://github.com/barrucadu/lambdamoo/blob/master/rust-source/src/ascii_string.rs

## Link Roundup

* [2018 State of Haskell Survey](https://airtable.com/shr8G4RBPD9T6tnDf)
* [Issue 131 :: Haskell Weekly](https://haskellweekly.news/issues/131.html)
* [Kernel RCE caused by buffer overflow in Apple's ICMP packet-handling code (CVE-2018-4407)](https://lgtm.com/blog/apple_xnu_icmp_error_CVE-2018-4407)
* [October 21 post-incident analysis | the gitHub Blog](https://blog.github.com/2018-10-30-oct21-post-incident-analysis/)
* [Rice Cooker Pancake](https://kirbiecravings.com/rice-cooker-pancake/)
* [Swedish ISP Protests ‘Site Blocking’ by Blocking Rightsholders Website Too - TorrentFreak](https://torrentfreak.com/swedish-isp-protest-site-blocking-by-blocking-rightsholders-website-and-more-181102/)
* [Systems, not Programs](https://shalabh.com/programmable-systems/systems-not-programs.html)
* [Ten Great Adventure-Game Puzzles](https://www.filfre.net/2018/11/ten-great-adventure-game-puzzles/)
* [The Finland Conspiracy and all you need to know about it.](https://www.reddit.com/r/finlandConspiracy/comments/52f5ae/the_finland_conspiracy_and_all_you_need_to_know/)
* [The FuzzyLog: a partially ordered shared log | the morning paper](https://blog.acolyer.org/2018/11/02/the-fuzzylog-a-partially-ordered-shared-log/)
* [The Temple of the Jedi Order - GOV.UK](https://www.gov.uk/government/publications/the-temple-of-the-jedi-order)
* [This Week in Rust 258](https://this-week-in-rust.org/blog/2018/10/30/this-week-in-rust-258/)
* [Truth, lies, and tribal voters - MIT Technology Review](https://www.technologyreview.com/s/612149/truth-lies-and-tribal-voters/)
* [Wealthy Americans Assure Populace That Heavily Armed Floating City Being Built Above Nation Has Nothing To Do With Anything](https://www.theonion.com/wealthy-americans-assure-populace-that-heavily-armed-fl-1830183535)
