---
title: "Weeknotes: 155"
taxon: weeknotes-2021
date: 2021-09-06
---

**This was written a day late as I was busy over the weekend.**


## Work

This was a quiet week.  Bank holiday on Monday, and the other backend
developer on the team has been off, so it's just been me and whoever I
can get PR reviews from.

I've continued working on the integration with the new Digital
Identity auth service, and also on our approach to caching in the
presence of personalisation (I am really growing to dislike that
word), which can be summed up as "personalisation is progressive
enhancement".

### Auth integration

Possibly the most impactful thing I did was to organise my integration
to-do list and to make a second list of things I want done by the end
of the sprint (as the full list is not possible).

So rather than one big entry like "finish account management &
security" I now have "TODO (for us): use correct account management &
security URLs in each environment" and "TODO (for DI): finish account
management & security frontends, and pick final URLs".  We are not the
DI team, so the more things I can note down as "(for DI)", the better.

There are a few "TODO (both)" entries, for larger features which need
some co-design before we can work out exactly what each team has to
implement.

I then worked through a bunch of the "TODO (for us)" entries, and
we're on track to meet my sprint goals, which is nice.

### Caching personalised pages

I think there are three ways a page might depend on the user's session
(or lack thereof), and by thinking about what ways a particular page
*should* use, we can avoid losing caching entirely.

- There's **core functionality**: things like authenticating,
  credential management, resuming things you've saved, and so on.
  This is best rendered entirely server-side (or in the CDN), as it
  has to work for all users, and plain HTML and CSS with no JavaScript
  is good for that.  This stuff is typically uncacheable.

- There's **navigation**: things like showing the appropriate "sign
  in" or "sign out" link in the header.  The defining feature here is
  that this depends on *whether* the user has a session or not, but
  not on *who* the user is.  This is part of why I dislike the term
  "personalisation", as it's not personalised.

- There's **everything else**: which is a fuzzy category for things
  which depend on who the user is, but which aren't core
  functionality, and so could potentially be implemented in more
  cache-friendly ways, like by JavaScript.  This is what we can treat
  as a progressive enhancement.

This is a helpful way to think about the problem, because it
transforms a hard technical problem ("how do we rearchitect GOV.UK for
a world where almost nothing is cacheable?") to a few less hard
technical and design problems.  Those problems are:

- "How do we rearchitect GOV.UK for a world where core account
  functionality is uncacheable?" --- well, we probably don't need to.
  Most things aren't core functionality, so this stuff has
  comparatively little load.  Just slightly scaling up should do it
  (if that's even necessary).

- "How do we handle caching of pages which have account navigation
  elements?" --- we can cache two copies of the page, one for logged
  in users and one for logged out users, and use some CDN magic to
  ensure that we're not having a cache miss for each individual user.

- "How do we design for the case where JavaScript is unavailable or
  slow?" --- if everything non-core and non-navigational is
  implemented client-side, we need good default states and to avoid
  (or minimise) a "flash of unpersonalised content".

Each way a page might depend on the user's session has a different
question.  But that question is scoped to a more specific problem, and
we still keep caching for most of GOV.UK.  This is progress!


## Books

This week I didn't finish any books, but I read some of volume 1 of
[Magistellus Bad Trip][], which a friend is the English translator
for.  The text is fine.  It's light novel-y, but that's to be
expected.  But the story is garbage.  I gave it a shot, but the
suspension of disbelief required was just... too much.

The premise is that there's an online VR stock trading game, set in a
virtual city-state, but also with guns, AI paramilitary troops and,
generally, all the stuff you need to make a game about stock trading
fun.  You can drive fast cars, shoot people to get their stuff, eat
virtual food (which, thanks to the VR tech, is actually tasty but
physically unfulfilling), spend it in virtual strip clubs, and so on.
That's cool.  I like that setting.

Where it goes bad, though, is that it explains that this VR game has
become super influential in reality too.  If you ruin an individual in
the game, well, if they've invested enough of their own money (there's
a one-to-one conversion ratio with the Yen), then you ruin them in
reality too because now their money is gone!  Taking it up a notch,
there are entire countries whose economies depend on this game.

That *could* be an interesting premise, if the VR game weren't so
gamey!  The plot of the first volume is about a "cheat level" shotgun,
which is so powerful you could become the richest person in the game,
ruining everyone else, and therefore causing a global financial
collapse.  And, while the stakes are high, and the characters *say*
that the stakes are high, they still all act like this is just a game.

It's just too much.  I did steal the name "Magistellus" for my
Traveller character though.

[Magistellus Bad Trip]: https://dengeki.fandom.com/wiki/Magistellus_Bad_Trip


## Gaming

Due to a rearrangement, on Tuesday I played a fourth RPG session in
four days: Stars Without Number on Saturday, D&D on Sunday, Call of
Cthulhu on Monday, and Traveller on Tuesday.  That was fun, but it's
nice having *some* of my evenings to myself.

I'm definitely enjoying having a weekly Traveller game.  Even though
we're not getting more done in a session than in my other games, it
just *feels* faster-paced not needing to wait a fortnight between
sessions.  Though, I don't think I'd want to play a single game for
six months before changing to something else.  Having other groups
playing different games is good too.


## Miscellaneous

On the 1st, my home server monitoring alerted me of a potential disk
failure.  That was worrisome, but thankfully it turned out to be not
so bad.  I'm still not entirely sure what the problem was, but it went
away after cleaning dust out of the case and ensuring the SATA cables
were firmly connected.

I [wrote up an incident report][] covering my debugging steps.

[wrote up an incident report]: incident-20210901-nyarlathotep-zpool-degraded.html


## Link Roundup

### Roleplaying Games

- [Starship Maintenance](https://greatdungeonnorth.blogspot.com/2021/08/starship-maintenance.html)
- [Traveller RPG Ship Travel Time Calculator](https://www.cyborgprime.com/traveller-rpg-blog/traveller-rpg-ship-travel-time-calculator)

### Software Engineering

- [Migrating from Docker to Podman](https://marcusnoble.co.uk/2021-09-01-migrating-from-docker-to-podman/)

### Mathematics

- [Supershapes (Superformula)](http://paulbourke.net/geometry/supershape/)
