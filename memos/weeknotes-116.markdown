---
title: "Weeknotes: 116"
taxon: weeknotes-2020
date: 2020-12-06
---

## Work

I spent much of this week writing documentation and thinking about
things, sometimes in the other order.  One of the things I've been
thinking about is how cross-domain analytics will work with GOV.UK
Accounts

GOV.UK uses cross-domain analytics (only if the user has consented to
cookies on both domains, of course) to give a joined up view of how
users interact with government.  So naturally this has to work with
GOV.UK Accounts too, or we'll have an ever-growing blind spot in this
joined up view.

Cross-domain analytics works by sticking a `_ga` query param onto
cross-domain links, which the analytics code at the link destination
picks up.  The problem is that with accounts, most of the cross-domain
stuff is in the form of OAuth journeys: we have cross-domain
*redirects*.  So we have non-cross-domain links which *may* do a
cross-domain redirect; for example, navigating from an unauthenticated
part of a service to an authenticated part, the link is a normal
internal link, but it'll redirect a logged-out user to the accounts
domain.

So I spent some time thinking through all the cases:

- is the link from the accounts domain or the service domain?
- is the link to an authenticated or an unauthenticated page?
- does the user have an active session on the service domain?
- does the user have an active session on the accounts domain?

For each, figuring out which links a user will click on, which
redirects will happen, and where a `_ga` param needs to be passed
along for the cross-domain analytics to all fit together.

Geez, the web would be much simpler[^secure] if any domain could read
cookies from any other domain!

[^secure]: And less secure.  Ah, if only we could just trust everyone
  to not be malicious!

## Books

This week I read:

- [Midnight Tides][] by Steven Erikson, the fifth of the [Malazan Book of the Fallen][].

  This was an interesting one, as I had a lot of difficulty figuring
  out when it was set.  Malazan can jump across continents and time
  when it changes from one book to the next, but this was particularly
  tricky.  It's the story of the Tiste Edur people, before Trull
  Sengar was abandoned in a warren for his crimes.  So it's clearly
  *before* the other books, but how long before?

  The humans in this book use the Tiles of the Holds, not the Deck of
  Dragons, and even that's considered a more modern alternative to the
  traditional Edur sorcery, so is it in the distant past, thousands of
  years before the other books?

  There's more evidence throughout the book which let me place it
  fairly accurately in the timeline by the end, but it took most of
  the book to get there.

[Midnight Tides]: https://en.wikipedia.org/wiki/Midnight_Tides
[Malazan Book of the Fallen]: https://en.wikipedia.org/wiki/Malazan_Book_of_the_Fallen

## Advent of Code

[Advent of Code][] started this week, and I've started doing it in
Haskell (as usual).  My solutions are [on GitHub][].

As always, there's a theme.  And the theme for this year is that
you're going on holiday to a tropical island, not feeling up to the
chill of the North Pole this year.  We're only a week in, so it's been
pretty easy so far.  I'm looking forward to seeing what challenges
will come.

[Advent of Code]: https://adventofcode.com/
[on GitHub]: https://github.com/barrucadu/aoc/tree/master/2020

## Miscellaneous

I knocked off a few things from my to-do list this week:

- I discovered [rTorrent][] has a [daemon mode][], which let me [get
  rid of my janky systemd-unit-which-starts-tmux approach][], and so
  solved an issue I had with rTorrent sometimes not restarting
  properly after a system upgrade.  That's been a problem for years,
  so it's nice to finally solve it.

- I set up [unifi-poller][], so I could [get UniFi metrics into
  Prometheus (and so Grafana)][], something I've wanted for a couple
  of months now.

- I also [updated my list of RPG one-shot ideas][], now with more
  detail and more systems.  Some of these I've run before, others
  would be new to me.

I'm now down to the fewest outstanding tasks on [my to-do Trello
board][] *ever*: 28.  Now, some of those are pretty long-term tasks
like "save £50k house deposit", but it's weird to think that the end
is finally in sight for tasks which I have to actively do (as opposed
to just wait for).  Of course, new tasks come up all the time, but the
backlog is finally almost empty.

It's hard to overstate just how integral this to-do system has become
to my life.  I've completed 1008 tasks since June 2018, and I don't
think that would have happened without the board.

[rTorrent]: https://github.com/rakshasa/rtorrent
[daemon mode]: https://github.com/rakshasa/rtorrent/wiki/Daemon_Mode
[get rid of my janky systemd-unit-which-starts-tmux approach]: https://github.com/barrucadu/nixfiles/commit/d99e02eb1699baed830109cd85aa35fb2d12ca98
[unifi-poller]: https://github.com/unifi-poller/unifi-poller
[get UniFi metrics into Prometheus (and so Grafana)]: https://github.com/barrucadu/nixfiles/compare/d99e02eb1699baed830109cd85aa35fb2d12ca98..0e89fdc2e94d749fad42f1a7d05de8a716e0aa77
[updated my list of RPG one-shot ideas]: one-shot-ideas.html
[my to-do Trello board]: self-organisation.html

## Link Roundup

- [How to Play Evil Characters - RPG Philosophy](https://www.youtube.com/watch?v=MRgTu6FTHgI)
- [Rolling Up Characters - Let the random in...](https://infodump.ghost.io/rolling-up-characters-let-the-random-in/)
- [Shuffling things up: Applying Group Theory in Advent of Code](https://blog.jle.im/entry/shuffling-things-up.html)
