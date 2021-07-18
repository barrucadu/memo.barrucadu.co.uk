---
title: "Weeknotes: 148"
taxon: weeknotes-2021
date: 2021-07-18
---

## Work

This week the other backend dev on the team was off, so I mostly spent
my time working through tech debt and making small improvements.  I
also wrote a handover doc (as I'm off next week) explaining what I'd
done and what I suggest be done next.

Migrating from our old email subscription management thing to the new
thing, and then deleting all the old code, was very satisfying.
That's been a small blight on our architecture since we launched last
year, and would have prevented us from migrating to the new auth
solution (when that is available).

Say no to non-standard OAuth flows.  If people start to ask things
like "what if the user doesn't return after registering in the auth
service, can we make it still save their data?" just don't do it.

I also did a bit of performance debugging, adding some timing metrics,
removing some network requests, and reducing allocations in a couple
of places.  Our latency error budget was trending upwards on Friday,
so that seems to have been a good set of changes.

Next week I'm off work.  I don't have plans to go anywhere or do
anything, it's just time to relax.


## Books

I've only been reading Traveller supplements this week.


## Miscellaneous

![Temperature measurements from my living room, showing a current temperature of 29.6C](weeknotes-148/temperature.png)

It's too hot.
