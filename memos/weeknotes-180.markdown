---
title: "Weeknotes: 180"
taxon: weeknotes-2022
date: 2022-02-27
---

## The War in Ukraine

Well, this week has certainly been something.  The fog of war makes
much uncertain, but I've been watching the BBC coverage to keep as
up-to-date as I can.  I found [this article by Bret Devereaux][] a
good explanation of the background and potential outcomes.

Ukraine is doing better than I expected.  Better than Russia expected
too, it seems.  But Russia is huge: unless internal pressure makes
Putin back down, I don't have much faith that the Ukrainians could
defeat the entire Russian army.

We'll have to wait and see what the future brings.

[this article by Bret Devereaux]: https://acoup.blog/2022/02/25/miscellanea-understanding-the-war-in-ukraine/


## Books

This week I read:

- [Microservices Patterns][] by Chris Richardson

  I decided to get this book because the engineering manager for the
  team I'll be joining at [GoCardless][] casually threw around terms I
  wasn't familiar with, like "two-phase commit" and "saga pattern",
  when we talked.  I googled for those and found the website for this
  book, which looked promising.

  But now having read it I think I should have just stuck with the
  website.

  It has some overlap with [Designing Data-Intensive Applications][],
  but covers that material much less well.  There's a consistent
  example throughout (a Just Eat or Deliveroo-like service), which is
  nice to have, but the Java examples throughout the book were not so
  useful: they use the author's custom Java microservice framework
  (which has a silly name: [Eventuate Tram][]), and they were also
  pretty abbreviated.

  The book, like Java, is also quite verbose.  The author religiously
  follows the "say what you're going to say, say it, and then say what
  you said" mantra.  That's fine for chapters.  But every section was
  like that, and every subsection ended with a phrase like "Now that
  we've seen how to use [topic of this subsection], let's look at
  [topic of next subsection]."  For example:

  ![Why use one sentence when three will do the job?](weeknotes-180/repetitive.jpg)

  Putting aside those issues, I also think it's aimed at someone with
  less experience than me.  The latter chapters of the book are
  dedicated to topics like testing, deployment, and monitoring.  All
  very potentially interesting things!  But the testing chapter starts
  out by assuming the reader is unfamiliar with automated testing,
  since apparently most companies still do mainly manual testing.
  There was a surprisingly good section about kubernetes and service
  meshes, though.

- Volumes 2 and 3 of [That Time I Got Reincarnated as a Slime][] by Fuse

  In contrast to my poor impression of [volume 1][], these were
  alright.  I'm still not convinced, so I'll read another few volumes
  before deciding to buy the whole series, but I'm no longer going to
  immediately drop it.  In particular, the amount of space dedicated
  to character development improved---including some scenes the anime
  skipped---and the prose just felt better.  In fact, the prose felt
  *so much* better that I checked whether the translator had been
  changed, but no, same guy as volume 1.

  It's still not brilliant though.  For example, in volume 2 the chief
  of the lizardmen is thrown in jail as a result of his son's coup.
  While he's in his cell, he imagines how terrible it must be for the
  women and children sheltering from the invading orc army.  The book
  then cuts away to other characters for several pages.  When it
  returns to the chief, he is no longer in his cell, he is now armed
  and defending the women and children from orcs.  I thought maybe I
  missed something, so I re-read those sections a few times, but I
  don't think I did.  Did the author just... forget that the chief is
  supposed to be locked in a cell, his hands in chains, in a different
  room entirely?  Seems so.  In the anime, the chief is locked up
  until he gets rescued: a scene notably absent from the book.

[Microservices Patterns]: https://microservices.io/about.html
[GoCardless]: https://gocardless.com/
[Designing Data-Intensive Applications]: https://dataintensive.net/
[Eventuate Tram]:  https://eventuate.io/abouteventuatetram.html
[That Time I Got Reincarnated as a Slime]: https://en.wikipedia.org/wiki/That_Time_I_Got_Reincarnated_as_a_Slime
[volume 1]: weeknotes-179.html


## Programming

I've been working on implementing a little DNS resolver over the past
couple of days.  I'm writing this in asynchronous Rust, using the
tokio runtime.  Currently I'm following the two main DNS RFCs:

- [RFC 1034][]: DOMAIN NAMES - CONCEPTS AND FACILITIES
- [RFC 1035][]: DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION

The goal is to have a recursive resolver with custom records and
blocklists: something that could serve as a [Pi-hole][] replacement.
I've now got a basic non-recursive resolver, which can give answers
based on static records configured in a config file, and the outline
of a recursive resolver.

The DNS wire format is a bit cryptic, but I got there in the end, and
it's cool to see [my resolver working with `dig`][].

My immediate goals are:

1. Finish the recursive resolver
2. Implement caching
3. Add tests

Getting there would be pretty cool, as I'd then have a
proof-of-concept (if somewhat clunky to operate) recursive resolver.
To make it pleasant to use I'd then need to add:

1. A parser for zone files, to read:
   - [the root hints file][]
   - static records
2. A way to read a DNS blocklist from a file
3. A way to trigger an asynchronous reload of the root hints and
   blocklist

I think if I get all this done, I could feasibly replace my Pi-hole.
Running a hand-written DNS resolver for my local network would be very
neat.  And then, if I still needed things to do, a couple of stretch
goals could be:

- A Prometheus metrics endpoint
- Fuzz testing of the network packet handling logic
- Working through more modern DNS RFCs (eg, adding support for AAAA
  records, DNSSEC, or DoH)

[RFC 1034]: https://datatracker.ietf.org/doc/html/rfc1034
[RFC 1035]: https://datatracker.ietf.org/doc/html/rfc1035
[Pi-hole]: https://pi-hole.net/
[my resolver working with `dig`]: https://twitter.com/barrucadu/status/1497700900235882500
[the root hints file]: https://www.iana.org/domains/root/files

## Link Roundup

- [The Ultra-Introverts Who Live Nocturnally](https://www.theatlantic.com/family/archive/2022/02/ultra-introverts-nocturnal-lives/622856/)
- [Why is the ISS being retired and what will happen to it?](https://www.sciencefocus.com/news/why-is-the-iss-being-retired-and-what-will-happen-to-it/)
- [NASA’s Lunar Gateway: The plans for a permanent space station that will orbit the Moon](https://www.sciencefocus.com/space/nasa-lunar-gateway/)
