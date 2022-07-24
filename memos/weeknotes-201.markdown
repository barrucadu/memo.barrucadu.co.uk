---
title: "Weeknotes: 201"
taxon: weeknotes-2022
date: 2022-07-24
---

## Books

No books, only sweat.


## Roleplaying Games

### A hiatus

Alas, an insurmountable combination of factors has cropped up, and my
Traveller / Whitehack group is on hiatus until the 11th of September.
We're keeping the slot open for boardgames or whatever, and there
*might* be a one-shot or two, but campaigns will not be happening.
There's no one thing which has made us want to stop, it's just
unfortunate coincidence that a few different issues have all cropped
up at once.

Though, the timing is a bit of a shame because we're only a couple of
sessions back into Traveller after the previous break, and I'd planned
to get us to a sensible stopping point in several sessions time, but
now we're stopping in the middle anyway.

Oh well.

### But also an opportunity?

I don't really want to try to get back into Traveller and remember
everything that was going on in a month and a half's time.  Since I
was leaning towards ending this game anyway, I've decided to just do
it.  On the 11th of September we won't be playing Traveller, we'll be
having a session 0 for a new game.

But what new game?

I was quite attracted to the idea of doing a modern-day Call of
Cthulhu campaign, where the players run a paranormal investigation
Youtube channel, inspired by [Seth Skorkowsky's review of Viral][] and
a modern-day conversion of The Haunting I saw somewhere a while back.
It would be a fun investigation-of-the-week game, where weeks or
months might pass in game before the investigators stumble onto
another *real* case.

But then I came across a very interesting looking game: [Wicked
Ones][], a FitD game about being evil monsters running a dungeon and
working towards some sort of nefarious master plan.  There's a free
version (with some omissions), and it looks pretty interesting.
Definitely unlike anything we've done before.  I'm quite enamoured of
it.  And (fortuitous timing!) there's even [a Kickstarter for a nice
offset-print edition and large expansion][] coming soon.

So, if we're looking for a change, perhaps Wicked Ones is worth a
shot.

[Seth Skorkowsky's review of Viral]: https://www.youtube.com/watch?v=yARYswKpalw
[Wicked Ones]: https://banditcamp.io/wickedones/
[a Kickstarter for a nice offset-print edition and large expansion]: https://www.kickstarter.com/projects/banditcamp/wo-ua-hardcover


## Miscellaneous

### Air conditioning!

It was very hot on Monday and Tuesday, and at about 3AM Tuesday
morning, I caved, and bought a portable AC unit.

I got a 12,000 BTU BLACK+DECKER BXAC40008GB unit.  It's alright, I
have it in my bedroom right now as, while heat can be very unpleasant
during the day, it's even worse if it stops me sleeping at night.
Besides, if it's hot during the day when I'm working from home, I can
work from my bedroom.  If it gets hot during the day and I'm using my
desktop, so I can't just go upstairs... I guess I just sweat, as
before.

I'd hoped to use a series of fans to channel cool air from my bedroom
to my living room, and cool the whole flat with one unit, but that
doesn't really work.  I can get a cool breeze in the living room
around my feet, which is certainly nice, but nowhere near enough.  The
unit is kind of heavy, so I don't really want to drag it up and down
the stairs.

So I'm toying with the idea of getting a ~6m flexible tube, which I
can tape to the front of the unit and use to move the cool air
directly into my living room.  That would work, albeit with reduced
efficiency due to heat loss through the sides of the tube.  Or maybe I
should bite the bullet and get a second AC unit for my living room,
now that I've tasted the forbidden fruit of being able to conjure up
cool 20C air on demand at home.

### UK windows suck

While an AC unit is certainly a boon to keeping cool, I think it's
only really necessary because the thermal design of my flat sucks.  My
flat, along with most British buildings, has a major flaw:

There are no shutters on the windows.

The sun hits the windows, and they effectively become radiators.  I
can *feel* the air getting warmer as I approach a window being hit by
direct sunlight, even one covered with an opaque curtain.

If the sun just... didn't hit the windows, a massive source of heat
would be eliminated.  Hot countries figured this out centuries ago,
they put wooden shutters on the outsides of their windows.  But for
some reason we don't in the UK.

### Backups

This weekend I did something I'd been putting off for a long time: I
finally [moved my backup scripts into my NixOS configuration][].

Previously, my NixOS config defined two systemd timers (one for
incremental backups and one for full backups), which ran a login shell
as my user, `cd`'d to my home directory, and ran a script I had
checked out there.

Not so great:

- I had this random script in a separate repository, not part of my
  NixOS config.
- I ran the script in the most coarse-grained way possible: a login
  shell as my user, with a load of stuff in the PATH and environment.
- Some changes to my NixOS config would require corresponding changes
  in the backup scripts repo, and then I'd need to update them in sync
  on every machine.
- It used the same plaintext secrets repo that [I mostly moved away
  from last week][].

So, I bit the bullet and finally nix-ified my backup scripts.  Rather
than just copy them in as-is, I took the opportunity to make some
improvements.  For example, the `services.bookdb` module defines [the
bookdb backup script][], so enabling bookdb gets you bookdb backups,
and also all the stuff about bookdb's docker set-up is in one place.

With secrets and backups done, the last bit of my config which depends
on a repository checked out to the right place on the filesystem is
[my monitoring scripts][].  I *want* to replace that with
[Alertmanager][], but I can't do that until [an issue with ZFS node
stats is fixed][]: I want to alert on a pool becoming unhealthy, but
that metric got caught in the blast radius and is not gathered right
now.

[moved my backup scripts into my NixOS configuration]: https://github.com/barrucadu/nixfiles/pull/109
[I mostly moved away from last week]: https://github.com/barrucadu/nixfiles/pull/96
[the bookdb backup script]: https://github.com/barrucadu/nixfiles/blob/3d8bc43f533ed00d9d7c336246c63c3f30aed0c4/services/bookdb.nix#L57-L60
[my monitoring scripts]: https://github.com/barrucadu/nixfiles/blob/3d8bc43f533ed00d9d7c336246c63c3f30aed0c4/modules/monitoring-scripts.nix
[Alertmanager]: https://prometheus.io/docs/alerting/latest/alertmanager/
[an issue with ZFS node stats is fixed]: https://github.com/prometheus/node_exporter/issues/2068#issuecomment-1136020314


## Link Roundup

### Roleplaying games

- [Town Mode Lesson 1: Town with a Capital T](https://theangrygm.com/town-mode-town-with-a-capital-t/)
- [Town Mode Lesson 2: What Happens in Town Mode](https://theangrygm.com/what-happens-in-town-mode/)
