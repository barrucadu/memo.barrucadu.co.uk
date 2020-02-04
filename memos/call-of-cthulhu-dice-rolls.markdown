---
title: More Graphs than You Ever Wanted about Call of Cthulhu Skill Rolls
tags: call of cthulhu
date: 2019-05-11
---

Conflict in RPGs can be resolved in two ways: *narratively*, where
resolution is handled entirely through role-playing; and
*mechanically*, where the rules give a way to determine which side (if
any) "wins".

In Call of Cthulhu, the mechanical way is for the Keeper[^gm] to name
a skill and for the player to roll a pair of percentile dice[^pd],
succeeding if they roll equal to or below their skill level.  The
higher your skill, the fewer possible dice results there are above it,
so the more likely you are to succeed.

[^gm]: Keeper of Arcane Lore, Game Master, Dungeon Master,
  Storyteller; whatever you want to call it.

[^pd]: A pair of d10s, where one is the "tens" place and the other is
  the "ones" place.  A 0 on both dice is interpreted as 100.

There are a couple of caveats: 1 is always a success and 100 is always
a failure.

![Chance of success for a skill roll.](call-of-cthulhu-dice-rolls/basic.png)

If this was all there were to it, it wouldn't be very interesting.
What if you're doing something especially difficult?  Something that
should challenge even an expert?  To dial up the intensity, skill
rolls have three difficulty levels: *normal*, which is as above;
*hard*, where you need to roll under half your skill; and *extreme*,
where you need to roll under a fifth of your skill.

![Chance of success for a skill roll, showing all three difficulties.](call-of-cthulhu-dice-rolls/difficulties.png)

Normal rolls are for things that would challenge a competent person.
Hard rolls are for things that would challenge a professional.
Extreme rolls are for things at the border of human ability.


## Pushing a failed roll

Let's say our player character Xander is searching for a book about
Yig, the Father of Serpents, in an occult book shop.  The keeper calls
for a **Library Use** roll, and Xander fails.  I guess he doesn't find
the book, everyone go back home.

Not quite.

A player can try to *push* a failed roll, making the roll again, if
they can justify it.  This isn't just a re-roll, time always passes
between rolls.  So perhaps Xander turns the shop upside down, pulling
books out of their shelves, risking being thrown out by the shopkeeper
(and not being welcome back) or having the police called on him.  The
consequences of failing a pushed roll should be worse than for a
non-pushed roll.

Unsurprisingly, pushing a roll gives you a better chance at success:

![Chance of success for a pushed skill roll, showing all three difficulties.](call-of-cthulhu-dice-rolls/pushed.png)


## Bonus dice

Perhaps Xander isn't just searching any old book shop, it could be one
he knows very well.  Maybe he even works there, and has an
encyclopaedic knowledge of its inventory.  In such circumstances, the
keeper may grant the player a *bonus die*: an additional "tens" die,
where the player keeps the lower of the two "tens" values.

Lower rolls are better, so this gives Xander a greater chance of
success:

![Chance of success for a skill roll with a bonus die, for hard difficulty.](call-of-cthulhu-dice-rolls/bonus.png)

A little disappointingly, it seems that getting a bonus die is exactly
the same as pushing the roll.  Though pushing a roll with a bonus die
is better yet.


## Penalty dice

On the other hand, perhaps Xander has an unusually hard time searching
for the book.  Maybe there's someone in the shop looking for him, and
Xander has to not only look for the book but also avoid the other
person.

In this case the skill-based task itself (finding the book) isn't more
difficult, but something about the way in which the task is conducted
(avoiding the other person) is.  So making the skill roll hard when it
would have been normal, or extreme when it would have been hard,
doesn't really fit.

For this, the keeper can require the player to roll a *penalty die*.
This is exactly the same as a bonus die, but rather than keeping the
*lower* of the two "tens" values, the player keeps the *greater*.

Xander will have a hard time indeed:

![Chance of success for a skill roll with a penalty die, for hard difficulty.](call-of-cthulhu-dice-rolls/penalty.png)


## Opposed rolls

If a player character goes up against someone significant (another
player character, or a major NPC), the keeper may call for an *opposed
roll*.  Both sides roll, and the side with the greater degree of
success (critical > extreme > hard > normal > failure) wins.  If both
sides achieve the same degree of success, the one with the higher
skill wins.  Opposed rolls can't be pushed.  If the skill of one side
is over 100 points greater than the other side (this would normally
indicate that they're not human), they automatically win.

Opposed rolls are the standard in melee combat, but should only be
used for particularly dramatic moments outside of it.  Otherwise it
would become tedious, and introduce an unnecessarily high risk of
failing narratively unimportant rolls.

Let's say Xander finds the book and leaves the shop.  In the street, a
big man firmly grips Xander's shoulder and tries to draw him down an
alley.  In such a case, the keeper would probably eyeball the relevant
character sheets and say something like "this guy is rather bigger and
stronger than you, so breaking his grip and escaping into the crowd
will be a hard **Brawl** roll."  It would only become an opposed roll
if Xander tried to fight back.

On the other hand, imagine this sequence of events played out:

1. Xander, desperately searching for a spell to banish Yig and aware
   he is being tailed by one of Yig's cult, ducks into a small occult
   book shop.

2. The cultist follows Xander in, but loses sight of him in the
   shelves.

3. The keeper calls for a hard **Library Use** roll with a penalty
   die; the shop is disorganised, and it'll be difficult to search
   while avoiding the cultist.

4. Xander fails.  The keeper says that the cultist hasn't found him
   yet, and that he can push it, but if he fails the pushed roll the
   cultist will definitely find him.

5. Xander pushes the roll, and fails.  He is spotted by the cultist.

6. As the cultist approaches, Xander realises that their skin looks
   unusually... squamous.  It's not a human cultist at all, it's a
   serpent person, one of the leaders of the cult!

7. The serpent person recites a strange chant, and Xander begins to
   feel overwhelmingly lethargic, and can't move his limbs.

This is clearly a significant conflict between a player character and
an important NPC, so an opposed roll would be fitting.  **POW** is the
attribute commonly used to cast or resist magic, so the keeper calls
for an opposed **POW** roll.

Let's say the serpent person is called Yassith.  We'll assume
Yassith's **POW** is no more than 100 greater than Xander's.

![Chance of Xander's success in an opposed roll.  [Click for full size](call-of-cthulhu-dice-rolls/opposed.png).](call-of-cthulhu-dice-rolls/opposed.thumb.png)

Here Xander's skill level is along the X axis and Yassith's skill
level is along the Y axis.  The colour shows Xander's chance of
winning the opposed roll; lighter is better.

There's a very visible discontinuity along the line x = y.  There are
two factors at play here: firstly, if your skill level is higher than
your opponent's (even only slightly), you're more likely to win; and
secondly, a tie is only possible when both contenders have the same
skill level.

Opposed rolls can have bonus or penalty dice.  In fact, the rules say
that bonus and penalty dice are primarily for use with opposed rolls,
but I'm not sure I agree with that.  I tend to think of the difficulty
level of a skill roll as reflecting the inherent difficulty of the
task (finding a book in a disorganised shop), regardless of conditions
in which it is performed, and the bonus or penalty dice account for
these extra environmental factors (needing to hide from a cultist).

Xander might get a bonus die if he had a talisman which shielded him
from the magic:

![Chance of Xander's success in an opposed roll, with a bonus die.  [Click for full size](call-of-cthulhu-dice-rolls/opposed-bonus.png).](call-of-cthulhu-dice-rolls/opposed-bonus.thumb.png)

It looks pretty similar, but try comparing it side-by-side with the
previous heatmap.  It's a bit brighter.

Alternatively, Xander might get a penalty die if he hadn't slept well
the night before, and was already not at his best:

![Chance of Xander's success in an opposed roll, with a penalty die.  [Click for full size](call-of-cthulhu-dice-rolls/opposed-penalty.png).](call-of-cthulhu-dice-rolls/opposed-penalty.thumb.png)

Goodbye, Xander.


## Appendix: All the lines on one graph

![All the lines on one graph.  [Click for a larger version with a legend](call-of-cthulhu-dice-rolls/all.png).](call-of-cthulhu-dice-rolls/all.thumb.png)


## Appendix: Scripts

### Success probability line charts

This script generates the graph with all the lines on.  Adjust the
`for` loops at the bottom to control which lines are rendered.

```python
#! /usr/bin/env nix-shell
#! nix-shell -i python3 --packages "python3.withPackages(ps: [ps.matplotlib])"

import itertools
import matplotlib.pyplot as plt
import math


def simulate(target, combine=None):
    successes = 0
    trials = 0
    dice = itertools.product(range(10), range(10), range(10))
    if combine is None:
        dice = itertools.product(range(10), range(10), range(1))
        combine = lambda a, b: a
    for (ones, tensA, tensB) in dice:
        if ones == 0:
            if tensA == 0:
                tensA = 10
            if tensB == 0:
                tensB = 10
        if 10*combine(tensA, tensB) + ones <= target:
            successes += 1
        trials += 1
    return successes / trials


def chance(level, difficulty='normal', push=False, bonus=False, penalty=False):
    scale = 1
    if difficulty == 'hard':
        scale = 2
    elif difficulty == 'extreme':
        scale = 5

    # base chance of success is (1d100 <= level / scale)
    target = math.floor(level / scale)
    # rolling 1 is always a success and rolling 100 is always a
    # failure
    target = min(99, max(1, target))

    # get base probability of success
    if bonus:
        base = simulate(target, combine=min)
    elif penalty:
        base = simulate(target, combine=max)
    else:
        base = simulate(target)

    # chance of success without pushing
    straight = base

    # chance of success with push on failure
    pushed = straight + (1 - straight) * straight

    return pushed if push else straight

plt.xkcd()
plt.figure(figsize=(20,20))

for difficulty in ['normal', 'hard', 'extreme']:
    for push in [False, True]:
        for penalty in [False, True]:
            for bonus in [False, True]:
                if bonus and penalty:
                    continue
                label = difficulty.capitalize()
                if push or bonus or penalty:
                    label += ' ('
                    if push:
                        label += 'pushed'
                        if bonus or penalty:
                            label += ', '
                    if bonus:
                        label += 'with bonus'
                    elif penalty:
                        label += 'with penalty'
                    label += ')'
                xs = range(1, 100)
                ys = [chance(x, difficulty=difficulty, push=push, bonus=bonus, penalty=penalty) for x in xs]
                plt.plot(xs, ys, label=label)

plt.legend()
plt.xlabel('Level')
plt.ylabel('Probability of success')
plt.savefig('rolls.png')
```

### Opposed roll heatmaps

This generates the non-bonus non-penalty version.  Adjust the
`combine` function to get those.  This also doesn't account for skill
differences of 100 (an automatic failure), so the heatmap will be
wrong if the skill level range is extended.

```python
#! /usr/bin/env nix-shell
#! nix-shell -i python3 --packages "python3.withPackages(ps: [ps.matplotlib])"

import itertools
import matplotlib.pyplot as plt


def degree(roll, skill):
    if roll == 1:
        return 0
    if roll <= skill / 5:
        return 1
    if roll <= skill / 2:
        return 2
    if roll <= skill:
        return 3
    return 4


def simulate(skill1, skill2, combine=None):
    successes = 0
    trials = 0
    dice = itertools.product(range(10), range(10), range(10), range(10), range(10))
    if combine is None:
        dice = itertools.product(range(10), range(10), range(10), range(1), range(10))
        combine = lambda a, b: a
    for (ones1, ones2, tens1A, tens1B, tens2) in dice:
        if ones1 == 0:
            if tens1A == 0:
                tens1A = 10
            if tens1B == 0:
                tens1B = 10
        degree1 = degree(10*combine(tens1A, tens1B) + ones1, skill1)
        degree2 = degree(10*tens2 + ones2, skill2)
        if degree1 < degree2:
            successes += 1
        elif degree1 == degree2:
            if skill1 > skill2:
                successes += 1
            elif skill1 == skill2:
                # ties are really unlikely so just ignore them
                continue
        trials += 1
    return successes / trials


plt.xkcd()
plt.figure(figsize=(20,20))

combine = None

skillrange = list(range(1,101))

data = [
    [ simulate(skill1, skill2, combine=combine) for skill1 in skillrange
    ] for skill2 in skillrange
]

data.reverse()

plt.imshow(data, cmap='hot')

ticks = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
plt.xticks(ticks)
plt.yticks(ticks, reversed(ticks))

plt.xlabel("Xander's level")
plt.ylabel("Yassith's level")
plt.savefig('heat.png')
```
