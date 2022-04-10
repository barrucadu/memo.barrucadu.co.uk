---
title: "Weeknotes: 186"
taxon: weeknotes-2022
date: 2022-04-10
---

## Work

I have now been at GoCardless for a month.

Which is kind of surprising really, it doesn't *feel* that long, but
yes, my calendar confirms that the 8th of March is a month ago.  I
think I'm settling in fairly well.  There's obviously still a lot
about the domain that I don't know, but that cloud of known unknowns
is shrinking little by little.  I've been spending my spare
time[^spare] looking through the codebase to figure out how everything
fits together, and I spent most of last week refactoring one of the
components we own.

This reminds me, I should check that "your first 30 / 60 / 90 days"
thing I was sent about things to learn and do and see how I'm doing
with that.

[^spare]: Spare time at work, not spare time out of work.


## Books

This week I read:

- [Gateway][] by Frederick Pohl

  This is about a depressing future-Earth, where food is a slime grown
  on oil and coal because the world is so overpopulated conventional
  farming can't keep up.  It's about an asteroid, full of alien
  spacecraft which can travel around the galaxy, and the hope that one
  of them will bring back some knowledge that can salvage the world.
  But mostly it's about one man, who gambles everything he has on
  becoming a space explorer, and becomes traumatised by his
  experiences.

  The narrative is split into two parts.  The first part is following
  the main character, Robinette Broadhead, as he moves to Gateway and
  starts his career there.  The second part, which is interleaved with
  the first part, is Robinette's discussions about these experiences
  with his robotic psychiatrist many years later.  It's a great little
  story where both sides of the narrative build up to the climax
  together: in the one where we the readers see what happened on
  Robinette's final mission that made him so rich, and in the other
  where he himself uncovers that repressed memory and confronts the
  root of his trauma.

- [The Book of Gaub][] from Lost Pages

  This is an RPG sourcebook about weird magic and a mysterious entity
  called Gaub.  The number seven is thematically important, with the
  Seven Fingers of the Hand of Gaub each having seven associated
  spells, a cabal of Gaub cultists having seven members, and various
  monsters, magical effects, and strange catastrophes incorporating
  seven somewhere: seven fingers, seven days, seven options, seven
  people...

  It assumes an OSR-like system, but doesn't have much in the way of
  concrete mechanics, so it looks like it'd be pretty easy to adapt to
  any other fantasy system.

  This is exactly the sort of OSR content I prefer.  A lot of OSR
  stuff, I feel, goes way to far towards the weird, in an attempt to
  stand out.  But if everything is bizarre and trope-subverting, then
  it loses its impact.  The Book of Gaub is close enough to your
  standard fantasy to fit into most games, but is also just slightly
  *weird*, where introducing it could significantly alter the tone of
  the game, and suggest that there is something deeper and darker than
  what is usually apparent.

  And also the book itself is really nice looking, which always helps.

[Gateway]: https://en.wikipedia.org/wiki/Gateway_(novel)
[The Book of Gaub]: https://shop.lostpages.co.uk/products/the-book-of-gaub-print-pdf-soundtrack


## Self Hosting

I made a few changes to my self-hosted set-up this week: I've
*stopped* hosting git, *started* hosting a wiki, and made a couple of
discoveries about systemd units.

Let's start with the systemd units.  I learned about the `BindPaths`
and `DynamicUser` options:

- `BindPaths` lets you bind-mount something *inside the service's
  filesystem namespace*, so it's a mount only available to the
  service, and which won't show up in the host's mount table (eg, with
  `findmnt`).

  This is pretty neat, as some services are annoyingly inflexible and
  need files or directories to be in certain locations.  In
  particular, for my [erase-your-darlings][] NixOS setup, I had a
  whole unit just to bind-mount the Prometheus state directory onto my
  persistent volume.  [Now I don't have to][].

- `DynamicUser` lets you allocate a random high-valued UID and GID for
  a unit on start, so it's not running as any user which already
  exists.  I used to use the `nobody` user for that, but systemd
  started warning against that at some point, because it's not as
  secure as it could be: there are files which can legitimately be
  owned by `nobody`, and you probably don't want random services to be
  able to write to them.

  So now [my `resolved` unit uses `DynamicUser=true`][].

These options are both in [the documentation][], but there's *so much
stuff* in the systemd documentation that it's kind of imposing to just
read through.  These two haven't been the first options I've
discovered after years of use, and surely won't be the last.

systemd is a great piece of software.  I was sceptical when it first
began to rise to prominence, but those doubts are all long gone.

Next, git.  I have [stopped hosting gitea][].  It's a perfectly fine
piece of software, but it was not ideal for my purposes.  It was
annoyingly stateful, with some configuration done through environment
variables and some through a configuration file inside a docker
container.  It was just slightly annoying having my private git
repositories in one place (gitea) and my public git repositories in
another place (github).  And one time I managed to nuke its state and
discovered my backup of its database was incomplete, so I had to start
from scratch... and nothing of value was lost.

So I pushed all my private repositories to github, updated my backup
script so it could handle private github repos, and dropped gitea.

Finally, a wiki.  I'm [now running wiki.js][].  I've resisted this for
a long time, trying to believe that everything should be open by
default, on this memo site.  But I've come to realise that mixing
personal-audience and public-audience writing doesn't really work for
me.  Since this site is now almost entirely public-audience stuff, I'm
just going to migrate private-audience stuff to the wiki.  I've
already done that with my recipes and found that it's actually
motivated me to add some more.

wiki.js itself is quite nice to use and run.  And it appears to store
everything, even media, in its database, so backing it up is a breeze
too.

[erase-your-darlings]: https://grahamc.com/blog/erase-your-darlings
[Now I don't have to]: https://github.com/barrucadu/nixfiles/pull/79
[my `resolved` unit uses `DynamicUser=true`]: https://github.com/barrucadu/nixfiles/pull/77
[the documentation]: https://www.freedesktop.org/software/systemd/man/systemd.exec.html
[stopped hosting gitea]: https://github.com/barrucadu/nixfiles/pull/83
[now running wiki.js]: https://github.com/barrucadu/nixfiles/pull/80


## Food Planning

I like cooking and eating nice food, but I'm also very lazy and so
left to my own devices will just make easy meals, snack, or order
takeaways all the time.

So to combat that I started planning my meals some years ago.  I've
got a little 5-week calendar on my whiteboard and, at the start of the
month, I'd work out what I wanted to make and eat.  So I might decide
to cook a big chilli in my slow cooker, which would make 10 portions,
and I'd allocate those to days across the month.  Then I'd think
"well, I don't really want two minced beef based meals back to back,
so maybe I'll make a curry for this, this, and this day..." and so on.
I got quite a bit of variety in my meals, and also specifically
allocated days where I'd try cooking something totally new.  This had
another benefit too: shopping trips became trivial to plan.  I could
just look at the calendar, see what was coming up for the next week or
so, and buy the ingredients I was out of.

It worked very well!

But at some point over the past two years, I stopped doing the big
monthly planning session.  I began to plan only *most* of a month
ahead, then only a couple of weeks, then just a week... it was so
gradual I didn't notice.  But now that I have, the difference is
stark.

So what, right?  Most people don't plan a month's food ahead of time,
and they do just fine.

Well, recall that I am very lazy.

I used to have a small repertoire of 5 or 6 meals I'd cycle through.
Not a huge amount of variety, but enough to keep things interesting,
especially if I did try a new meal a couple of times a month.  But for
the past couple of years I've switched more and more to just making
the easiest one or two meals, and very rarely trying new things.  If a
meal needs some ingredient which is harder to get (for example, I'd
need to go to an asian supermarket and there isn't one nearby), I tend
to put it off.  And I've got back into the habit of ordering one or
two takeaways a month, because the food I do make isn't providing
enough variety.

This needs to change.  Fortunately, it should be pretty easy to fix
now that I've recognised the problem: I just need to reinstate the
monthly planning sessions.  Then I know what I need to buy, I know
what I have to look forward to, and I can specifically pick out a few
days a month to try something new.

So I've put a recurring event in my calendar, for the first of the
month, to plan meals.  Let's see how it goes.


## Link Roundup

- [About Damn Times: A Campaign Event Table](https://silverarmpress.com/about-damn-time-on-campaign-events-tables/)
- [The Merchant Campaign](https://shadowandfae.blogspot.com/2022/03/the-merchant-campaign.html)
- [Small Gods and Stone Soup: Deities made for Dungeon Crawling](https://orbitalcrypt.blogspot.com/2022/03/small-gods-and-stone-soup-deities-made.html)
