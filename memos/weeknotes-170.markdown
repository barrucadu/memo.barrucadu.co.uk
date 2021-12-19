---
title: "Weeknotes: 170"
taxon: weeknotes-2021
date: 2021-12-19
---

## Work

I spent this week working on splitting up our giant postgres and mysql
RDS instances, giving each app its own instance so that database
upgrades are less of a major task: if everything uses one or two huge
instances, then to upgrade the huge instances all the apps need to be
made compatible and have downtime scheduled at the same time.  It's a
lot of work.  Having many, smaller, instances makes downtime and
suchlike much easier to manage.

It's been quite nice doing some infrastructure work, as I don't get to
play around with that much these days.  The new infrastructure is now
in place, but we still need to migrate the data.  But that's a task
for next month.

I'm now off work for a week, back for a few days between Christmas and
New Year, and then back to work properly from the 4th of January.


## Books

This week I read:

- [A Fall of Moondust][] by Arthur C. Clarke

  When we were little, we all read stories about the terrifying power
  of quicksand which, with one wrong step, would swallow up the unwary
  without a trace.  And then we grew up, and found that quicksand
  isn't actually a major day-to-day threat after all.  This book takes
  quicksand, and asks "what if it were *in space?*"

  A Fall of Moondust is set in a tourist cruise across the "sea of
  thirst" on the Moon: a fictitious "sea" of very fine rock particles,
  produced by moon rocks expanding and contracting in the heat of the
  sun every day for billions of years.  With no atmosphere and very
  low gravity, this sand is more like a fluid, swallowing anything
  more dense beneath its perfectly flat surface.  Apparently this was
  once an idea which serious scientists worried about, but thankfully
  we now know the moon to be pretty solid.

  It was a fun story of a crisis and subsequent daring rescue, only
  slightly marred by the old-fashioned assumption that in a crisis
  situation, the natural order of things is for the women to make
  drinks and serve refreshments while the men get on with solving the
  problem.

[A Fall of Moondust]: https://en.wikipedia.org/wiki/A_Fall_of_Moondust


## Gaming

This week the long-paused D&D campaign was properly cancelled, and the
GM started a game of [Whitehack][].  We had planned to do a [West
Marches][] style campaign, but we got fewer players than we'd hoped,
so it'll likely be a wilderness exploration focussed campaign where we
have several PCs, and mix and match who goes on which adventure.

I'm looking forward to trying it out.  Whitehack is firmly in the OSR
sphere, but has a nice twist on the traditional class system: the
classes themselves are quite broad and interesting, able to handle
many different character archetypes, and a lot of the specificity
you'd get in other class systems comes from noting down which "groups"
you belong to.

For example, my character has the Strong (fighty) class, but is
flavoured as a war god's priest, and so he gets situational benefits
from his "Warrior" and "Priest" groups.  It's a bit more flexible than
many class-based systems, in which I'd have to chose between a warrior
or a priest, and couldn't have both.

[Whitehack]: https://whitehackrpg.wordpress.com/
[West Marches]: https://arsludi.lamemage.com/index.php/78/grand-experiments-west-marches/


## Link Roundup

### Roleplaying Games

- [Combat Maneuvers, The Easy Way](https://oddskullblog.wordpress.com/2021/11/15/combat-maneuvers-the-easy-way/)
- [The Two Worlds of RPGs](https://knightattheopera.blogspot.com/2021/11/the-two-worlds-of-rpgs.html)
- [Fuck Balance](https://cavegirlgames.blogspot.com/2021/11/fuck-balance.html)
- [Fixing Religion: Augury, Blasphemy, and Oaths](https://goblinpunch.blogspot.com/2020/06/fixing-religion-augury-blasphemy-and.html)
