---
title: Phased Real-Time Combat for Call of Cthulhu
taxon: games
published: 2020-06-21
modified: 2020-07-04
---

Combat in Call of Cthulhu is supposed to be dangerous, chaotic, and
fast-paced[^themes].  Investigators aren't supposed to wade through
fields of blood hacking down dozens of enemies like in *some* RPGs.

[^themes]: This ties in very well with other themes of the game:
  investigators being just normal people thrown into dire situations
  over their heads; the mythos being a terrible threat which you can
  rarely confront directly and live; and for combat to be almost a
  failure state, when investigation and other more subtle techniques
  fail.

However, while the standard combat system does manage to feel
dangerous[^danger], I don't think it manages to feel fast-paced or
chaotic.  I've found combats to be a drag at times, with a short
amount of in-game time taking a much larger amount of out-of-game time
to resolve.

[^danger]: Investigators have low health relative to even mundane
  weapons: a single lucky bullet can kill someone outright.

Call of Cthulhu uses a pretty standard combat system: combat is
divided into rounds, in each round there is an unambiguous order in
which each combatant gets to act, and after each combatant acts
another round begins with (probably) the same order.  This is great
for D&D-style tactical combat, as it allows the players to treat the
fight almost like a boardgame, putting their effort into figuring out
the optimal moves.  I don't think it works so well if combat is
supposed to feel chaotic though.

This memo does away with the strict turn order, and brings chaos back
to combat.  The system is based on [Phased Real-Time Combat][].

This has not been play-tested yet.

[Phased Real-Time Combat]: https://spellsandsteel.blogspot.com/2018/10/phased-real-time-combat-solution-you.html


Round structure
---------------

<aside class="highlight">
This section replaces "The Combat Round" on page 102 of the 7th
edition *Keeper's Rulebook*.
</aside>

A round is broken down into these phases:

1. **Hints:** Keeper hints at what the enemies are doing
2. **Orders:** Players declare their actions
3. **Fast spells:** Cast instantaneous spells
4. **Fast actions:** Fire readied guns and act with 100 or more DEX
5. **Slow actions:** Other attacks, manoeuvres, or skill checks
6. **Movement:** Movement and fleeing
7. **Slow spells:** Cast non-instantaneous spells

All actions resolved in the same phase conceptually happen at the same
time.

The *Keeper's Rulebook* lists the following actions which are suitable
to perform on your turn during combat:

- Initiating an attack using a suitable combat skill[^multi_attack].
- Performing a fighting manoeuvre.
- Fleeing.
- Casting a spell.
- Performing some other action requiring time and perhaps a dice roll,
  such as picking a lock.

[^multi_attack]: Some monsters can perform multiple attacks in a
  single round.

Additionally, you can choose to wait for another combatant to act
before performing your action if your action is in the same or an
earlier phase.

### Action resolution

In each resolution phase, there will generally be clear groups of
actions which have to be resolved together and which can be resolved
independently of any other groups.  For example, if there are four
combatants engaged in melee as two pairs, each pair can be resolved
independently.

Even within a group of combatants all fighting each other, order only
matters in some situations.  For example, all attack rolls can be
resolved simultaneously, unless a combatant will be incapacitated or
killed, in which case their attack and the killing blow need to be
resolved in order.

Where order matters, combatants make an opposed DEX check.  If there
is a tie:

- **PC vs NPC:** the PC wins.
- **Otherwise:** flip a coin.

**Concentration and interruption:** certain actions require the
character performing them to have uninterrupted concentration.  For
example, casting a non-instantaneous spell requires the character to
maintain concentration between declaring the spell and casting it.  If
a character making such an action is successfully attacked, grappled,
or otherwise interrupted, the effect does not take place.


Why?
----

I think this approach has a few big advantages over the standard round
structure:

**More closely matches the fiction:** with a sequential round
structure, we're often *told* that things are *really* happening at
the same time in the fiction, but I think that is basically impossible
to justify.  You know everything that happened before your turn in the
round, so you're almost certainly going to base your move on that.
But if things are happening simultaneously, you shouldn't be able to
do that.

To use the needlessly complex-sounding jargon term, this is an example
of *ludonarrative dissonance*: the narrative and the mechanics are in
conflict.

**Less disjointed:** if everyone acts in turn order, a round of combat
just becomes a monotonous recital of disjointed actions, jumping
between all the combatants.  Have you ever read a combat scene in a
book, or seen one in a film, where it just shows what everyone is
doing, one after the other?  No!  The narrative jumps between groups
of characters, showing their part of the fight as its own miniature
scene before jumping to another group.

By focusing on these small integrated scenes, the combat as a whole
feels faster-paced.

**More chaotic:** because you have a much narrower view of what's
going on---you know the orders the PCs say, but only get hints of what
the NPCs plan---it's much harder to strategise like you would in a
D&D-style tactical combat minigame.  The fight becomes much more
unpredictable and chaotic, as you have to take into account the fact
that: (a) you don't have perfect knowledge of what many of the other
combatants are doing by the time it rolls around to your turn; and (b)
you don't even know the order in which your part of the fight is going
to resolve.
