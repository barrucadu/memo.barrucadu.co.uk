---
title: "Weeknotes: 145"
taxon: weeknotes-2021
date: 2021-06-27
---

## Work

This week I did some work to let people log in with their GOV.UK
account to manage their email subscriptions, which needed me to make
some changes [in email-alert-api][] and [in email-alert-frontend][].

It's behind a feature flag for now, and there will be some frontend
and behavioural changes to implement once designs are finalised, but
at long last it's looking like we can start to resolve the problem of
there being two totally separate account mechanisms on www.gov.uk (a
problem which we introduced).

I also spent a bunch of time trying to work out some SLO alerts we
could implement, somewhat hindered by the ancient version of Graphite
we have (it doesn't even have a `movingSum` function!), and ultimately
ended up with some not-so-great alerts.  Then I discovered that, since
scaling our instances up a week ago, nginx metrics haven't been being
reported to Graphite anyway!  Well, that's a problem for next week.

I'm looking forward to when we're not on such old and crumbling
infrastructure.

[in email-alert-api]: https://github.com/alphagov/email-alert-api/pull/1638
[in email-alert-frontend]: https://github.com/alphagov/email-alert-frontend/pull/1076


## The Plague

I've now had my first jab.  My GP didn't say anything about booking a
second appointment, so I guess I'm waiting for them to contact me
about that in several weeks time.


## Books

This week I read:

- [Ilium][] by Dan Simmons.

  What if you had the Trojan War, but all the Greek gods are actually
  technologically-advanced "post-Humans" living on Olympus Mons and
  it's in the far future and there are autonomous robots living in the
  moons of Jupiter?  It sounds crazy, but it's great.  I've read this
  before, some years ago, and it holds up on this second reading.

  Next I'll be moving on to the sequel, Olympos, which gets even
  crazier.

[Ilium]: https://en.wikipedia.org/wiki/Ilium_(novel)


## Gaming

I've begun preparing for a Traveller campaign.  I'm planning to run a
session 0 and first short story arc in the next Call of Cthulhu break,
which will likely be in late September.  I've bought the core rulebook
and some of the supplements, and am noting down ideas for a space
pirate campaign.

So I've consuming all Traveller-related media I can find, including [a
Traveller-themed album!][]

We *could* play [Pirates of Drinax][] (2nd edition), and maybe the
campaign will turn into that if the players decide to become
privateers, but at least to start with I'm planning for the campaign
to be pretty episodic and without much of an overarching plot, beyond
the player's goals.

[a Traveller-themed album!]: https://www.youtube.com/watch?v=zhEb6NBZKBs
[Pirates of Drinax]: https://wiki.travellerrpg.com/The_Pirates_of_Drinax


## Link Roundup

### Roleplaying games

- [How to make a Traveller Sandbox](https://batintheattic.blogspot.com/2009/04/how-to-make-traveller-sandbox.html)
- [Random event tables – a week in Jumpspace](https://mytravelleruniverse.com/2017/05/11/random-event-tables-a-week-in-jumpspace/)
- [Run Simple Adventures](https://slyflourish.com/run_simple_adventures.html)

### Software Engineering

- [Representing SHA-256 Hashes As Avatars](https://francoisbest.com/posts/2021/hashvatars)
