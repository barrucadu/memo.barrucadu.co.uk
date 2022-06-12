---
title: "Weeknotes: 195"
taxon: weeknotes-2022
date: 2022-06-12
---

## Work

I spent most of this week playing around Postgres's [table
partitioning][], with the [pg_party][] gem.  It was easier to get
working than I thought, the actual code change to switch over one of
our big data processing pipeline to using a range-partitioned table,
creating partitions as it needs them, wasn't very complex.

Of course, the devil is in the details: doing this without any
downtime, in a way we can roll back, and with the best partition size
to optimise performance.  But I think I have solutions for all those
too.

Unfortunately, [postgres 14 has a data corruption bug with concurrent
index creation][], so we have to wait for that to be fixed (and our
production database upgraded) before we can actually start to build
some of this partitioning stuff for real.

[table partitioning]: https://www.postgresql.org/docs/current/ddl-partitioning.html
[pg_party]: https://github.com/rkrage/pg_party
[postgres 14 has a data corruption bug with concurrent index creation]: https://www.postgresql.org/message-id/165473835807.573551.1512237163040609764%40wrigleys.postgresql.org


## Books

No books this week, I was too busy inhaling lore and rules for my new
RPG campaign.


## Roleplaying Games

### Forbidden Lands

On Sunday I finished running Winter's Daughter in [Forbidden Lands][].
The PCs explored the tomb of Sir Chyde, having just reached it at the
end of last session, and re-united him with his fairy lover, Princess
Snowfall-at-Dusk.  As their reward, they made off with a *lot* of
loot, and a good wish: to always have food, water, and shelter when
needed.

On the whole, I'm not a huge fan of the Forbidden Lands system.  It
worked well enough when we were in the dungeon or in combat, but I
found the hexcrawling rules a bit flawed and the encumbrance system
far too punishing.  Given that the hexcrawling rules are the main
reason to use Forbidden Lands over another system, I don't think I'll
be returning to it.

Furthermore, I've had an epiphany that D&D-style XP is likely the best
way to encourage the sort of fantasy I want in my games, so to that
end I've started a full Dolmenwood campaign in:

[Forbidden Lands]: https://freeleaguepublishing.com/en/games/forbidden-lands/

### Old School Essentials

Yes, [OSE][], which Dolmenwood and Winter's Daughter are actually
written for.  I've started a campaign in my Saturday group themed
around the PCs being cartographers from the Royal Geographical
Institute of some larger empire which Dolmenwood belongs to, sent to
produce the first comprehensive and fully accurate map of the region.

I think this is a great premise.  There's so much weird, fun, and
interesting stuff in every corner of Dolmenwood, and this premise
gives the players a strong roleplaying reason to comprehensively
search it, and so encounter all of these things.  I've also adopted a
house rule giving XP for exploration:

- Exploring a hex gives 100xp (each) for the first hex, 200xp for the
  second, 300xp for the third (etc), resetting when you return to a
  town.
- Overcoming a hidden thing (intentionally left vague) gives 50xp, on
  top of any other XP gained doing that.

This rule gives a mechanical incentive to have thorough mapping
expeditions, which introduces a fun tension: if they don't go to a
town, they can't resupply, which creates risk.  I'm looking forward to
seeing what emergent play comes of this.

This is my first time running OSE, so there's a learning curve, but
the system is generally pretty simple and has a "do what feels right"
philosophy.  For example, in the first session one player wanted to
cautiously approach what they thought to be a distraction (a crying
child in the middle of the road), and asked "how do I do that?", I
said "just say that you're doing it, and you're doing it."  In the
moment, I gave them a +2 to their surprise roll, and so they ended up
noticing the ambush that had been set.  In a more mechanically rigid
system, that sort of on-the-fly ruling would be discouraged.

[OSE]: https://necroticgnome.com/collections/rules


## Link Roundup

### Roleplaying Games

- [Conviction](https://goblinpunch.blogspot.com/2016/04/conviction.html)
- [d100 - Why This Hireling Decided To Join](https://blog.d4caltrops.com/2022/05/d100-why-this-hireling-decided-to-join.html)
- [The Dungeon as a Mythic Underworld](http://www.philotomy.net/musing/mythic_underworld/)

### Programming

- [Caches In Rust](https://matklad.github.io/2022/06/11/caches-in-rust.html)
