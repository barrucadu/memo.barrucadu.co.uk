---
title: Sylea Rising (2022-11 to ?) notes
taxon: games-campaigns
published: 2022-11-27
toc:
- anchor: overview
  children:
  - anchor: pitch
  - anchor: foot-view
  - anchor: roadmap
- anchor: house-rules
- anchor: setting-bible
  children:
  - anchor: non-default-assumptions
  - anchor: timeline
  - anchor: polities-of-lishun-sector
  - anchor: factions
- anchor: party
- anchor: resources
- division: Session notes
- anchor: session-0
---

<aside class="highlight">This campaign is ongoing and this memo contains spoilers.</aside>

Overview
--------

### Pitch

> The Ziru Sirka, the great interstellar empire of the Vilani, lasted for two
> thousand years.  But inability to manage such a large expanse of territory
> caused a slow decline, which ultimately led to its conquest by the Terrans,
> and the establishment of their great interstellar empire: the Rule of Man.
>
> But the Rule of Man lasted a scant few centuries before it, too, collapsed
> under its own weight.  This time, nothing replaced it.  The galaxy fell into
> anarchy, worlds were cut off from one another, technologies were lost, and
> many civilisations simply failed to survive: this is the Long Night, and this
> is when our game is set.
>
> In the Long Night many small pocket empires rose, and fell.  You are all
> scouts, ex-military, and similar sorts, employed by the government of the
> Sylean Federation, one of the larger pocket empires of the Long Night.  It's
> survived for 650 years now, but Sylea, too, is feeling the strain of
> administration at interstellar distances, and is also currently at war with
> two other pocket empires: the Interstellar Confederacy and the Chanestin
> Kingdom.  Can Sylea solve its problems, or will it perish like so many others?
>
> **Player buy-in:** The player characters are all explorers working government
> contracts to reach out to worlds not heard from in centuries (or millennia),
> to establish peaceful relations where possible, or maybe just to plunder them
> if the world is dead---after all, who's to say you handed in *everything* you
> found to the government inspectors?  It's post-apocalypse in space.  There
> will be space dungeons.  But it's also about the rise of the Sylean Federation
> into something even greater, so there's plenty of scope for this to turn into
> a more political game if you want.

### 10,000-Foot View

We're using **Traveller** to play a **post-post-apocalypse exploration-focussed
campain**.  We're using a custom setting derived from the official Traveller
lore, but aren't worrying about slavishly sticking to that: **published lore is
an inspiration, not a constraint**.

There's **no overarching plot or set game length**, this is an **episodic**
campaign which we'll play for as long as it's fun.  We want **lots of
exploration**, **character stories** as well as **space stories**, and
**small-scale politics**.  **Interstellar politics is in the background**, we're
not directly interacting with that sort of thing.

We play a pretty grounded game: **actions have consequences** and **you can
die**, but it's **not a meatgrinder**.  Also **space-magic is silly**, if it
does come up at all, **psionics is only for a very rare big-boss NPC**.

#### An action-packed period of history

Every in-game month:

- `2d3-1` more worlds join the Sylean Federation
- Make a [faction turn](campaign-notes-2022-11-sylea-rising.html#factions)

Players hear of any developments close to the start of the session: newspapers,
TV or radio broadcasts, overheard talk, etc.

### Roadmap

1. Murder on Arcturus Station

**Future:**

- Witchburner (maybe?)

**Adventure templates:**

- Transport a survey team to a new world and shenanigans happen


House Rules
-----------

### Advancement

When a skill is used successfully, mark it.  At the end of an adventure, roll
`1d6-1` for each marked skill and gain 1 experience point in it if the roll is
higher than the skill level.  Unmark all the skills.

Gaining a skill at level 0, or taking it from level 0 to level 1, costs 1xp;
costs double each level thereafter.


Setting Bible
-------------

![Lishun Sector, year -1](campaign-notes-2022-11-sylea-rising/lishun-poster.png)

- [Poster](campaign-notes-2022-11-sylea-rising/lishun-poster.png) ([players](campaign-notes-2022-11-sylea-rising/lishun-poster--players.png))
- [Sector data](campaign-notes-2022-11-sylea-rising/lishun-sector-data.txt) ([players](campaign-notes-2022-11-sylea-rising/lishun-sector-data--players.txt))
- [Metadata](campaign-notes-2022-11-sylea-rising/lishun-metadata.xml) ([players](campaign-notes-2022-11-sylea-rising/lishun-metadata--players.xml))

Scripts:

- [Tweak UWPs](campaign-notes-2022-11-sylea-rising/tweak-uwps.py)
- [Generate "Worlds of Lishun Sector" HTML](campaign-notes-2022-11-sylea-rising/generate-worlds-html.py)

### Non-Default Assumptions

- TL 12 is the best technology available, the Sylean Federation and its
  neighbours haven't reached TL 13 yet (some TL 13 tech may exist as early
  prototypes, but is not generally available)

- Jump-3 has been invented but isn't available outside military / government use
  yet.

### Timeline

- **300,000 BC**
  - Ancients take primitive humans from Terra and seed the galaxy with humanity.
- **4721 BC**
  - Vilani (from Vland) discover jump drive.
- **756 BC**
  - Ziru Sirka ("Grand Empire of the Stars") founded, dissolving previous interstellar Vilani states.

    At its height, the Ziru Sirka will control over 15,000 worlds spread across 27 sectors of space.
- **2088 AD**
  - Terrans (from Terra / Earth) discover jump technology.
- **2097 AD**
  - First contact between the Terrans and the Vilani.
- **2115 AD**
  - The Interstellar Wars between the Terran Confederation and the Ziru Sirka begin.
- **2316 AD**
  - The Interstellar Wars between the Terran Confederation and the Ziru Sirka end with the surrender of the Ziru Sirka.
  - Terran Confederation dissolved, replaced by Rule of Man (a military state run by hereditary fleet admirals).
  - Terrans name themselves "Solomani", after their origin star, to reflect that not all of their people are from Terra.
- **2744 AD**
  - Rule of Man collapses, period of anarchy known as the "Long Night" begins.
- **2944 AD**
  - Last claimant to the throne of the Rule of Man dies on Sylea, which he made his capital.
- **3871 AD**
  - Sylean Federation founded.
- **4026 AD**
  - Contact between Sylen Federation and Vland established.
- **4041 AD**
  - Trade corridor between Sylea and Vland established through the Ukan, Lishun, and Vland sectors.

    *This is where our game is set!*
- **4464 AD**
  - Sylean Federation begins to introduce its first Jump-3 prototype ships.
  - Cleon Zhunastu born.
- **4491 AD**
  - Cleon Zhunastu becomes Grand Duke of Sylea and President of the Grand Senate, and begins a period of greatly increased diplomacy, trade, and expansion.
- **4520 AD**
  - *This is when our game begins!*

### Polities of Lishun Sector

In addition to these larger polities, there are many independent worlds.  These
are intentionally not fleshed out.  Dead worlds, archaeological finds, hostile
aliens, strange facilities, caches of technology... anything could be out there.

#### Sylean Federation

The Sylean Federation controls several hundred worlds mostly within about 30
parsecs of Sylea, in Ukan sector (rimward).  Lishun sector is more or less
beyond the frontier: officially, the Sylea / Vland trade corridor in the Shuun
and Welling subsectors is part of the Federation, but is wild and dangerous with
rampant piracy beyond the range of starport and planetary defenses.

**Governance:** Worlds are largely self-governing, with each appointing a
senator to the Grand Senate on Sylea, which has the hereditary Grand Duke of
Sylea as its president.

The Grand Senate determines laws for both Sylea and the whole Federation, there
isn't a separate Sylean government.  While Sylea is the only world directly
ruled by the Grand Senate, the oldest worlds of the Federation are civil service
bureaucracies ruled by their senators.  Other worlds, especially out here far
from Sylea, are far more varied.

The current Grand Duke is the 56-year-old Cleon Zhunatsu, a very popular leader
who has overseen rapid expansion of the Federation.

**Society:** The society is equitable, with Syleans, Solomani, and Vilani all
mixing together in all tiers of society, though ethnic Syleans are
over-represented in the Senate.  Humans make up the vast majority of the
population, though there are also trace numbers of Aslan and Droyne, and a small
subpopulation of Vargr.

**Recent history:** The recent history of the Sylean Federation is the recent
history of the current ruling dynasty, the Zhunastu family.  Felix Zhunastu, the
previous Grand Duke, persuaded the Grand Senate to grant the president broad and
expansive powers.  He also used the Zhunastu family fortune to acquire several
key corporations and merge them into the Zhunastu Industries megacorporation,
which mostly deals with research and development, holds several military
contracts, and has developed the first prototype jump-3 ships.

When Felix died, he left behind his heir the 27-year-old Cleon Zhunastu, who
assumed the roles of Grand Duke of Sylea, president of the Grand Senate, and
chairman of Zhunastu Industries.

Cleon founded the Sylean Federation Scout Service, which triggered a period of
rapid expansion, a mixture of recruitment and conquest.  Many currently
independent worlds are considering membership, having either applied themselves
or having been invited due to their economic, technological, or strategic
merits.

Cleon has been president for 30 years now, and shows no sign of slowing down.
It's widely known that he plans to bring even more worlds under Sylean control,
expanding further into Lishun sector once Ukan sector is more firmly under
control.  The people are generally optimistic for the future, and look forward
to seeing what change he brings next.

##### Uundas Union

The Uundas Union is a fragmented polity, disparate worlds which survived the
Long Night somewhat intact using a fleet of left-over Ziru Sirka cargo ships
maintained by the decaying high tech facilities on Uundas.  But now those
facilities have degraded to the point that the Union has to buy old Sylean ships
and use the repair facilities of Raluug starport to keep its internal trade
afloat.

**Relationship with the Sylean Federation:** Somewhere between a small trading
partner and a captive government.  The significantly more powerful economy and
technological base of the Sylean Federation is slowly forcing the Union towards
assimilation, something the more independence-minded worlds of the Union are not
happy with.

##### Paran League

The government of Paran is a distant remnant of the Ziru Sirka bureaus, with the
world, and the league, ruled by an ancient hereditary caste of bureaucrats who
operate by the maxim "from each according to his ability, to each according to
his needs."  Each member world of the League sends excess production to Paran,
where the bureaucrats distribute it to worlds where it's needed.  Member
governments are subordinate to the bureaucrats of Paran, but are mostly left to
rule without interference, on the assumption that those who live on a world
understand what it and its people need better than those who live elsewhere.

**Relationship with the Sylean Federation:** The bureaucrats of Paran are
unfriendly to those they view as official envoys of the Sylean Federation: to
them, the Federation has more than it could possibly need, and so has a duty to
distribute that excess to others at no cost.  However, they don't go so far as
turning away Sylean traders.

##### Gishgi People's Assembly

Long ago, the people of Gishgi threw off the authoritarian yoke of their
masters, killing and literally eating the rich in a grand revolution.  They took
their crusade to the stars and liberated another six worlds, installing on each
world a governing Assembly of the People, with each Planetary Assembly sending a
number of representatives (proportional to the population) to the Supreme
Assembly of the People, based on Gishgi.  Now, centuries later, another five
worlds have been added to the Assembly, and the Secretary-General of the Supreme
Assembly of the People rules with the aid of the State Secret Police as an
unpopular totalitarian ruler.

**Relationship with the Sylean Federation:** The Sylean Federation has been
officially branded a Threat to the Mental Wellbeing and Contentment of the
People, and Sylean ships barred from the People's Assembly's territory.

##### Our Kingdom

<aside class="highlight">The PCs haven't encountered this polity yet.</aside>

TODO

**Relationship with the Sylean Federation:** TODO

##### Grand Duchy of Ankii An

<aside class="highlight">The PCs haven't encountered this polity yet.</aside>

TODO

**Relationship with the Sylean Federation:** TODO

##### Irzemuu Federation

<aside class="highlight">The PCs haven't encountered this polity yet.</aside>

TODO

**Relationship with the Sylean Federation:** TODO

##### Kuunguu Confederation

<aside class="highlight">The PCs haven't encountered this polity yet.</aside>

TODO

**Relationship with the Sylean Federation:** TODO

##### Kimuum Free Worlds

<aside class="highlight">The PCs haven't encountered this polity yet.</aside>

TODO

**Relationship with the Sylean Federation:** TODO

##### 7th Disjuncture

<aside class="highlight">The PCs haven't encountered this polity yet.</aside>

TODO

**Relationship with the Sylean Federation:** TODO

##### Gzoerrghzae Fleet

<aside class="highlight">The PCs haven't encountered this polity yet.</aside>

TODO

**Relationship with the Sylean Federation:** TODO

##### Ksouruz Pact

<aside class="highlight">The PCs haven't encountered this polity yet.</aside>

TODO

### Factions

Faction turn procedure:

- For each faction in the region of the PCs, make a fortune roll to see how
  things are going generally.  This is reflected in military presence, NPC
  attitudes, local news stories (etc).

- For each faction, make a fortune roll and tick clocks.  The progression of
  these clocks should be obvious and generate adventures (which may also tick /
  untick clocks).

Factions clocks: **TODO**


Party
-----

The player characters and shared party stuff (eg, a spaceship).


Resources
---------

Links to things.


2022-11-27 --- Session 0
------------------------

### Prep

1. Go through setting
  - History
  - Non-default assumptions
  - Lishun Sector
2. Discussion
3. Create characters

#### History

> 300,000 years ago, a mysterious race now called "the Ancients" took primitive
> humans from their home planet, and seeded them throughout the galaxy.  This
> has made a lot of people very angry and has been widely regarded as a bad
> move.
>
> About 7,000 years ago, the Vilani people from the planet Vland were the first
> humans to discover jump technology.  They gained the ability to travel between
> the stars.  Over those 7,000 years, they built up a vast empire, called the
> Ziru Sirka, which in their language means Grand Empire of the Stars.  At its
> height, it controlled over 15,000 worlds spread across 27 sectors of space.
>
> In about 60 years, the Terrans from the planet Earth will discover jump
> technology.
>
> In about 75 years, first contact will be made between the Terrans and the
> Vilani.
>
> And in about 100 years, war will break out between the Terran Confederation
> and the Ziru Sirka.  The Ziru Sirka is far, far bigger, but it's also in the
> midst of a long and slow decline.  Vilani society is very centralised, their
> culture is incredibly rigid, they've stagnated technologically, and with only
> jump-2 ships they simply can't effectively manage their vast territory.
>
> The war lasts about 200 years, and ends with the surrender of the Ziru Sirka.
> One imperium comes to an end, and another begins.  The Terrans---now calling
> themselves Solomani after our star---proclaim the Rule of Man, a kind of
> military state run by hereditary fleet admirals.
>
> But the Solomani couldn't halt the decline and fall of the Ziru Sirka.  After
> a scant 500 years, the Rule of Man collapsed.  And nothing replaced it.
>
> That began the Long Night, a period of galactic anarchy which saw the collapse
> of interstellar trade, diplomacy, and communication.  Many worlds couldn't
> maintain their high technology levels, or even feed their populations, with
> the imperial bureaucracy gone.  Some worlds reverted to barbarism or died out
> entirely.  Space became a lawless place where pirates and reavers preyed on
> those few brave enough to still travel between the stars.  And over a thousand
> years passed before interstellar civilisation began to re-emerge.
>
> One of the brightest lights in the darkness is the planet Sylea, last capital
> of the Rule of Man.  The Sylean Federation is now 650 years old, and that is
> where our game is set.

#### Discussion

##### Campaign

- No overarching story
- The world doesn't resolve around the PCs
- Time skips between sessions if you have no plans
- How long should the campaign last?
- Tone:
  - What kind of conflicts and adventures make sense for this game?
  - What kind of outcomes make sense for this game?
  - What kind of PCs make sense for this game?
  - Ethics (sexism, racism, slavery, etc): use it to make the bad guys obviously
    bad? Anything off limits?
  - Can PCs die?  How frequently?
    - What happens if there's a TPK?

##### Characters

- Alien PCs, yay or nay?
  - Aslan: probably pretty weird if from an Aslan enclave, so far from the
    Hierate.
  - Vargr: the Vargr Extents are just off to coreward, so ethnic Vargr are
    everywhere here.
- Psion PCs, yay or nay?
  - What about psion NPCs?
- Traveller Companion pre-career options, yay or nay?
  - Colonial Upbringing
  - Merchant Academy
  - Psionic Community
  - School of Hard Knocks
  - Spacer Community
- Advancement:
  - How did everyone feel about the standard rules?  I felt it penalised
    characters with low EDU too much.
  - Seth Skorkowsky house rule: mark skills which get used successfully, at the
    end of the adventure roll `1d6-1` for each marked skill and gain 1
    experience point if above the skill level.  Gaining a skill at level 0, or
    taking it from level 0 to level 1, costs 1xp; costs double each level
    thereafter.

### Notes

- **Discussion:**
  - Campaign:
    - **Campaign length:**
      - Until we get bored
    - **Conflicts and adventures:**
      - Lots of exploration
      - Plenty of ground stuff & character focussed stuff, not just space stuff
      - Less politics, and smaller-scale; not fate-of-space-worlds stuff
    - **Outcomes:**
      - Realistic consequences, no pulling punches
      - Gritty and scary at times
    - **PCs**
      - Anything goes
    - **Ethics**
      - Present, but abstracted or off-screen
    - **PC death**
      - Ok, but not super common
      - Decide what to do with a TPK when it happens
  - Characters:
    - **Alien PCs:**
      - Yes (but nobody wants to make one now)
    - **Psionics:**
      - Very uncommon, no psion PCs
    - **Extra pre-career options:**
      - Yes (other than psion community) (but nobody wants to use one now)
    - **Seth Skorkowsky's XP rule:**
      - Yes

- **Character creation:**
  - Characters: done
  - Benefits: done
  - Skills package: done
  - Connections: done
  - Shopping: doing between sessions


### Next time

- Ship sheets:
  - Lab Ship
  - Pinnace
- Prepare local region:
  - Flesh out major factions, worlds, and NPCs
  - Random encounter table(s)
- Murder on Arcturus Station:
  - Make Marja Aguilar one of the PC's allies
  - Pick a border world and tie it into Sylean politics
- Rumours, etc, to drive future adventures


2023-MM-DD --- Session N
------------------------

### Intro

### State

### Prep

### Notes

### Next time
