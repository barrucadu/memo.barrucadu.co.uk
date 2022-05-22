---
title: "Weeknotes: 192"
taxon: weeknotes-2022
date: 2022-05-22
---

## Work

This was a short little week, only really two days of normal work.  On
Monday and Tuesday we had a hackathon, and I joined in with a couple
of other developers making some changes to the job queueing library we
use, a fork of [que][], in particular we renamed it and all of its
database tables to "kent", which is the site of a very long queue.
This is so we could, potentially, migrate back to original que at some
point by running it in parallel with our fork while we transition.

Wednesday and Thursday were normal team work, continuing on the same
project.

And then on Friday we had a company-wide day off.  There are four of
those Fridays each year, and they're in addition to the normal paid
time off, which is quite nice.

[que]: https://github.com/que-rb/que


## Books

No books finished this week, though I've got a few things on the go.


## Roleplaying Games

### RPG Blog

This week I wrote a post on [fleshing out clan Iuwoi][], one of the
Aslan clans involved in the adventure *The Borderland Run* by Mongoose
Publishing.  I greatly enjoyed this module and, even though they
didn't manage to achieve what they wanted, so did the players.

[fleshing out clan Iuwoi]: https://www.lookwhattheshoggothdraggedin.com/post/iuwoi.html

### Forbidden Lands

I like the look of [Forbidden Lands][] enough to run a one-shot, and
this week I've been reading it more closely with an eye to possibly
running a campaign.  If the one-shot goes well, I'll buy the full
rules, and make a decision.

But from what I can see, the game has a few weird problems I'd
probably have to house-rule to fix:

The first major problem is that it's a hex-crawling game but you can't
get *actually lost* when travelling around.  When you move to a new
hex the party's pathfinder makes a check and, if they fail, you might
get lost *in the new hex*.  So you always manage to move into the hex
you intend to, you just might then have to get your bearings or
overcome some obstacle before you can then move to another one.

This is kind of weird because getting lost and not knowing which hex
you're in seems like a big part of hexcrawls to me.  I think this is
because the game world has a canonical map which you're supposed to
share with the players and mark their progress on, and it's a bit hard
to play the "ooh, which hex are you *really* in?" game when there is
an objective world map.

So I'd probably change the "leading the way mishaps" table to have a
higher chance of getting lost and, rather than get lost in the new
hex, roll a d6 to determine which adjacent hex the party actually
enter (where rolling for the hex they wanted to enter means they just
stay in the same hex).

The second major problem, which may be addressed in the full rules, is
that there's actually no rules for exploring a hex.  It just says that
exploration is done in the same quarter-day units as all other
activities.  Which leads me to conclude that either:

1. Anything to explore is supposed to be really obvious.  The
   challenge isn't in finding the secrets, but in dealing with them.
2. The GM is just supposed to just make a ruling every time the
   players want to explore.

The latter feels like a glaring omission for a game so heavily based
around hexcrawling, so it must be the former.  Which is alright I
guess, but I would prefer to have both obvious and non-obvious things
in the world.  Everything being obvious kind of works in the default
setting, which is that nobody has really travelled for the last few
centuries due to the Blood Mist, so that's why there's all this
obvious stuff lying around untouched.  But that justification doesn't
work in a different setting.

So I'd probably copy some exploration / surveying rules from another
system.  Or make something up.  For example, this could work: "every
person-quarter spent surveying the hex (if multiple people are
surveying they have to split up and survey different areas) grants a
cumulative 1 in 6 chance of finding all the secrets", which then means
it takes a single person at most a day-and-a-half to survey a hex, and
less time if they have help.

There are some other niggling things, like weather not affecting the
chance of a good night's rest outdoors, and not being able to forage
while travelling (which is understandable but I'd probably allow it if
travelling along a road or other obvious landmark), and a
quarter-day's rest or sleep restoring *all* damage.  But those are
lesser issues which can be more easily resolved.  Overall, it looks
good, and despite these two major flaws I'm still pretty confident
I'll like it.

[Forbidden Lands]: https://freeleaguepublishing.com/en/games/forbidden-lands/

### Dolmenwood

I've also been looking into [Dolmenwood][] this week.  I started
watching [a fun Dolmenwood actual-play using the OSE rules][][^ap] and
I'm now pretty confident it would be a hit with my group.  I've got
the current draft books from [the patreon][], and have been skimming
through them between watching episodes.

[^ap]: I'm not usually a fan of actual-plays, I find just listening to
  or watching other people play a game not that fun.  But recently
  I've started getting into them as a means of *learning* a system,
  setting, or adventure, and I quite like them for that.  When getting
  ready to run *The Borderland Run* in my Traveller campaign, I
  watched an actual-play of that which I took some ideas from.  It's
  helpful to see how another GM approaches a situation; but I don't
  think I'd watch one I wasn't learning anything from.

I'm not really sure about running a one-shot though.  It feels like a
lot of the fun of Dolmenwood is in getting to know the NPCs and
places, and the strange adventures to be had are just one part of
that, so I'm not too sure how to give it a whirl without just
announcing this will be our next campaign.

I think I might be souring on the idea of a one-shot, as in a one or
two session self-contained adventure, entirely.  I'm finding that one
thing I enjoy quite a lot in a game is developing relationships
between the party and NPCs, and there's basically no scope for that in
a one-shot.  This means that, while a one-shot can be a good way to
try out a system or setting, they're not really a good way to get a
feel for what a campaign would be like.  I'm thinking of pivoting
towards short campaigns of five to ten sessions instead.  But that's a
much higher time commitment, which makes them a bit more awkward to
fit in around other campaigns...

I'm also not sure what system to use for it.  I don't *really* want to
use OSE.  Will Forbidden Lands be fitting?  We'll see.  I'm not
looking forward to having to convert all the monsters, stats, spells
(etc) though.

[Dolmenwood]: https://necroticgnome.com/products/welcome-to-dolmenwood
[a fun Dolmenwood actual-play using the OSE rules]: https://www.youtube.com/playlist?list=PLtBYin1uOBmDo5G8PCb-1JttO-HCyZYcQ
[the patreon]: https://www.patreon.com/necroticgnome

### Virtual Tabletops

Running Traveller in Foundry went well, so well in fact that the other
GM in the group (who's running [Whitehack][]) suggested moving their
game to Foundry too.

There's one player who missed the session, so I want to try it out
with them present before deciding to drop my Roll20 subscription, but
it's looking promising.[^roll20]

[^roll20]: It looks like ending my subscription shouldn't actually
  *lose* anything, all character stats will remain even though I lose
  my custom character sheets, and all uploads will remain even though
  I get less space, but I'd still prefer to know everyone is
  definitely on board before taking the potentially destructive step.

[Whitehack]: https://whitehackrpg.wordpress.com/


## Link Roundup

### Roleplaying games

- [Dolmenwood: Progress Report 2022](https://necroticgnome.com/blogs/news/dolmenwood-campaign-setting-update)
- [Syareahtaorl: The Loakhtarl Clan ](https://greatdungeonnorth.blogspot.com/2022/05/syareahtaorl-loakhtarl-clan.html)

### Miscellaneous

- [Finding Binary & Decimal Palindromes](https://ashdnazg.github.io/articles/22/Finding-Really-Big-Palindromes)
