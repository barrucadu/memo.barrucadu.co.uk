---
title: "Weeknotes: 126"
taxon: weeknotes-2021
date: 2021-02-14
---

## Work

### Logging in to GOV.UK

This week [the RFC][] was accepted, so we now have a broad consensus
across the programme about how logging in to GOV.UK will work.  Well,
a broad consensus amongst the people who cared to read and comment on
it, at least.  There were a few significant changes to my original
idea, which have resulted in a simpler proposal, so it's good that we
went through the RFC process.

I've written up a bunch of cards to do the implementation work, and
hope we can get on with that over the next couple of weeks.

[the RFC]: https://github.com/alphagov/govuk-rfcs/pull/134

### Multi-factor Authentication

I finished off and deployed an improvement to our current MFA
implementation this week.  Previously we sent users a 5-digit code via
SMS every time they logged in.  Now there is an option to remember a
device for 30 days (by setting a cookie), which skips MFA.  MFA is
still needed if you want to change your email address, password, or
MFA device.

Another dev on the team is looking into [WebAuthn][], a standard way
of doing MFA which works with Yubikeys, biometric scanners, private
keys, and so on.  We had to learn about [secure contexts][] to get
this working on our local dev set-ups.

[WebAuthn]: https://webauthn.guide/
[secure contexts]: https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts

### The future of the team

Finally, there have been some more revelations of what the future of
the team will look like, and how the grand plan for a single
cross-government account will progress.  Things are getting more
concrete, and I've seen a speculative (internal) roadmap, which is
reassuring.


## Books

This week I read:

- [The Crippled God][] by Steven Erikson, the tenth and last of the [Malazan Book of the Fallen][].

  Wow, what a series!  This is going to leave a fantasy-shaped hole
  for a while, I'll need to look into the other books outside of the
  main series.

  Even during this big dramatic end-of-series book, with the fate of
  the world in the balance, Steven Erikson still found room for
  humour.  <span class="spoiler">A group of T'lan Imass are facing
  down an enemy army, when they're suddenly drenched with the blood of
  Fener.  Miraculously, they're reborn!  Mortal once more!  Onos
  T'oolan thinks "this was poorly timed."</span>

  Do I recommend Malazan?  Definitely yes.

- The first issue of [Knock!][], an OSR zine which got kickstarted recently.

  There's a lot of good stuff in this.  Most (or even all?) of it is
  blog posts.  Some of it I had read before, most of it I hadn't, so
  that was fine.  I think they're looking for more original content
  for the second issue.  The typesetting is great, each article has a
  unique style, which works because they're all self-contained.

[The Crippled God]: https://malazan.fandom.com/wiki/The_Crippled_God
[Malazan Book of the Fallen]: https://en.wikipedia.org/wiki/Malazan_Book_of_the_Fallen
[Knock!]: https://www.themerrymushmen.com/our-products/


## Miscellaneous

I've started putting together a new blog on RPGs.  I'm pretty happy
with the design and structure now, but I want to get a few posts
published and a bunch more written before I start to publicise it.
Current ideas for topics are:

- GM tips & tools
- Mechanics & theory
- Reviews / overviews of systems and supplements
- Link roundups (probably not weekly though)
- Short adventures

For example, after I play Troika! with my Call of Cthulhu group, I'll
write up one post on how we found Troika! and one on the scenario I'm
designing.

Previously I had mused on starting a series of memos about software I
use, but I suspect I don't really have anything interesting to say
about most of my software choices.  It would just be writing for the
sake of writing.  Whereas I think I do have interesting things to say
about RPGs.


## Link Roundup

### DevOps

- [Running Nomad for home
  server](https://mrkaran.dev/posts/home-server-nomad/)

### Video Games

- [The Color of Corruption - How Purple Is Used in Video Games](https://www.youtube.com/watch?v=L51xc6iqeaU)

### Roleplaying Games

- [Electric Bastionland: Into the Odd City Supplement Review](https://www.youtube.com/watch?v=OfF8tT7nzWo)
- [Ultraviolet Grasslands and the Black City: Psychedelic Metal DnD Review](https://www.youtube.com/watch?v=ApiXFV8QKvo)
- [Bounded Player Agency](https://deathtrap-games.blogspot.com/2021/01/bounded-player-agency.html#comment-form)
- [MONSTER REACTION SUBTABLE FOR OLD SCHOOL D&D](https://matrixghosttransmissions.blogspot.com/2020/08/reaction-subtable-for-old-school-d.html)
- [Matt Rundle's Anti-Hammerspace Item Tracker](http://rottenpulp.blogspot.com/2012/06/matt-rundles-anti-hammerspace-item.html)
- [[Homebrew] Project Hecatomb](http://vorpalmace.blogspot.com/2020/12/homebrew-project-hecatomb.html)
