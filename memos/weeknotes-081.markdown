---
title: "Weeknotes: 081"
taxon: weeknotes-2020
date: 2020-04-05
---

## Work

This week I switched on an A/B test for showing parts in search
results.  For example, if you search for [france travel advice][] you
will, if you're in the right bucket, see a list of parts beneath some
of the results.  Parts can appear beneath the top 3 results, with up
to 10 parts per result.  On Friday we had just over a full day of
data, and click-through rate was slightly up, but we need more data to
know for sure if it's a definite improvement.  Hopefully we'll have
enough at the end of next week.

I then moved to the Platform Health team, as Search finally ended.
Platform Health was my first team at GDS, so it's not so much of a big
change.  I spent Thursday and Friday redeploying all our apps to use
Ruby 2.6.6, which fixed some CVEs, but first I had to shave a yak and
make it possible to upload new packages to our private repository
again, which got broken when it was migrated to AWS.

Going forward, it looks like I'll be leading on retiring the frontend
part of [whitehall][], which will be great, because whitehall is the
only app which does both publishing and rendering, and it takes
advantage of that to do a lot of weird and not-so-good stuff.

[france travel advice]: https://www.gov.uk/search/all?keywords=france+travel+advice&order=relevance
[whitehall]: https://github.com/alphagov/whitehall


## The Plague

The work days have blurred together.  The weekend days have also
blurred together: all Saturday I was thinking it was Sunday (even
though I had my game, and I *know* that's on Saturdays!), and the
first thing I did when I woke up this morning was to double-check that
it wasn't Monday.

Not so great.

This week I've managed to survive without having to brave the shops at
all, though I'm now totally out of bread, flour, and rice, so I'll
have to do that tomorrow.

I've been making a list of everything I've needed to buy, because it's
only been a few weeks and I've already run out of a lot of stuff.  So
far in my life I've tended to do my shopping in a just-in-time
fashion, often going shopping two or three times a week to pick up a
couple of things each time.

In the future, when shops have recovered, I'll try to make sure I have
at least a month's supplies in at all times.  Right now, if I
developed symptoms and had to self-isolate for a fortnight, I'd have
to live off takeaways and tins of soup after a few days.


## Miscellaneous

### Books

I finished reading [Blindsight][], a sci-fi first-contact story.  It
felt like it took a little time to get going, giving lots of
information about Earth when really I just wanted it to get to the
aliens, but that exposition did all mostly get tied back into the
alien action (and the horrifying truth revealed to the protagonist) by
the end.  It was a good read; the aliens, and what they represent,
were a very cool idea.

I also finished reading The Nyarlathotep Cycle, covering these short
stories:

- The Temple of Nephren-Ka, by Philip J. & Glenn A. Rahman
- The Papyrus of Nephren-Ka, by Robert C. Culp
- The Snout in the Alcove, by Gary Myers
- The Contemplative Sphinx, by Richard Tierney
- El-Pi-El's Ægypt, by Ann K. Schwader

It's fair to say that Nephren-Ka was the main character of this
collection of stories.  Overall it was a good read, but the Egyptian
focus did make things feel a bit samey after a while.  It would have
been nice if there'd been some more "alien" cosmic horror sprinkled in
too, rather than just lots and lots of Egyptian curses.

[Blindsight]: https://en.wikipedia.org/wiki/Blindsight_(Watts_novel)

### Games

This has been a fun week.  I've been reading a lot of RPG blog posts
and watching videos, and have started to note down tips I come across
that I like and which solve problems I've had in my games.  I've also
been learning things from the games I'm in; like Apocalypse World has
helped me to understand "only roll when the outcome is in doubt".  A
bad habit of mine in Call of Cthulhu was making the players roll for
everything, even if there was no real chance of failure.  But then
because the dice are random, sometimes someone *would* fail a roll,
and we'd be stuck while I tried to improvise a way out.

Just because someone is picking a lock and they have a skill called
"lockpicking" (for example), doesn't mean they need to roll it.  They
only need to roll it if there's some reason they don't just succeed:
it's a tricky lock, they're under time pressure, they're fatigued,
etc.  It sounds obvious when put like that, but it wasn't for me
running the game at the time.

On Saturday the Pokemon game I'm in switched to [a system based on
Fate Accelerated][], because we were all sick of the system we *were*
using, which was just unwieldy.  So we needed to run through character
creation again to port our characters over.

One of the things you have to do in Fate is come up with a "trouble
aspect": some character trait which causes problems for you (though it
may be helpful in some circumstances).  And I realised I'd not really
thought about character flaws like that before.  While my character
was by no means perfect, I couldn't really come up with one flaw which
was big enough to call out as *the* trouble aspect.  So I had to think
about that a bit, and then it ended up coming into play in the session
(in a positive way, as it turned out), and caused some good
roleplaying.

That's another thing I'll be keeping in mind for future games,
regardless of system.  Thinking up a major flaw (and one generic
enough to actually come up regularly in play) leads to more
interesting characters.  Even if you're in a system where it has no
mechanical significance, it's still good for roleplaying.

[a system based on Fate Accelerated]: https://www.reddit.com/r/FATErpg/comments/8vfc2u/fate_accelerated_pokemon_version_3/


## Link Roundup

- [Managing a Long-Term Fate RPG Campaign Online](http://randyoest.com/2018/managing-long-term-fate-rpg-campaign-online/)
- [Top 11 greatest Call of Cthulhu scenarios I've run](http://midasintelligence.blogspot.com/2015/10/top-10-greatest-call-of-cthulhu.html)
- [Brown; color is weird](https://www.youtube.com/watch?v=wh4aWZRtTwU)
- [The long and complicated history of why there are 360 degrees in a circle.](https://www.historytoday.com/history-matters/full-circle)
- [The end of an Era](https://www.linaro.org/blog/the-end-of-an-era/)
