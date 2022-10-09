---
title: "Weeknotes: 212"
taxon: weeknotes-2022
date: 2022-10-09
---

## Books

No books this week!


## Roleplaying Games

A few times now the timings have worked out such that I'm running sessions of
all three campaigns in the same week.  It's fun, because they're all pretty
different, but I'm glad it's not every week, and that there's not four of them.

All went well, players in every game had a good time, and I've had to come up
with some rules for the fairy horses one group of players got with their wish at
the end of [Winter's Daughter][]:

> **Wish-granted Fairy Horse**
>
> Beautiful, silver-dappled mares and stallions of dashing grace and
> free-spirited intellect. Natives of the forests of Fairy, where they roam on
> quixotic quests. Bound to the party by a wish granted by Princess
> Snowfall-at-Dusk.
>
> **AC** 6 [13] **HD** 3+1 (15hp) **THAC0** 17 [+2]
>
> **Attacks** 2x hoof (1d6)
>
> **Move** 240' (80') **Morale** 10
>
> **Saves** D12 W13 P14 B15 S16 (2)
>
> **Alignment** Neutral. Curious, driven by wanderlust
>
> **Intelligence** 13. Sharp-witted
>
> **Speech** Sarcastic. Woldish, Sylvan
>
> **Pure Iron:**
>
> As fairies, fairy horses suffer 1 extra point of damage when hit with weapons
> of pure iron.
>
> **Summoning:**
>
> Whistle when outdoors and outside of a human settlement, and the horse will
> come.
>
> The same horse comes for the same rider every time. If the horse is killed, a
> new one replaces it.
>
> **Riders:**
>
> Fairy horses never serve a rider against their will; rider and mount treat
> each other as equals.
>
> Once per day, while the horse is summoned, gain a +2 bonus to a saving throw.
>
> **Terrain:**
>
> Where mortal horses can only be led, fairy horses can be ridden.
>
> Where mortal horses cannot be taken at all, fairy horses can be led.

[Winter's Daughter]: https://necroticgnome.com/products/dolmenwood-winters-daughter


## Miscellaneous

### Anime

The new season has started, I've been checking out a few shows and current
favourites are [Lucifer and the Biscuit Hammer][] (continued from last season),
[Mobile Suit Gundam: The Witch from Mercury][], and [My Master Has No Tail][].
I'm also going to check out [Housing Complex C][] and [Chainsaw Man][] at least,
and probably a bunch of other things too.

The backlog just keeps growing...

[Lucifer and the Biscuit Hammer]: https://anidb.net/anime/17150
[Mobile Suit Gundam: The Witch from Mercury]: https://anidb.net/anime/16700
[My Master Has No Tail]: https://anidb.net/anime/16512
[Housing Complex C]: https://anidb.net/anime/17266
[Chainsaw Man]: https://anidb.net/anime/15914

### NixOS

I did a lot of tinkering with my [NixOS config][] this week:

- I replaced all the shell scripts with `nix run` commands ([PR #133](https://github.com/barrucadu/nixfiles/pull/133))
- I switched away from my custom monitoring scripts in favour of Alertmanager ([PR #134](https://github.com/barrucadu/nixfiles/pull/134))
- I refactored all the shared config to make options more uniform and greatly expanded the README ([PR #137](https://github.com/barrucadu/nixfiles/pull/137))

Will I ever stop tinkering with it?  No.

But this is generally a nice improvement fixing a few dissatisfactory bits which
have bothered me for a while.  For example, it's now very obvious what
configuration applies to a host (just the contents of the host-specific folder
and the `shared/default.nix` file, every other file is opt-in only).  The only
large thing remaining on my radar is swapping out docker for rootless podman,
but I'm in no hurry to do that.

[NixOS config]: https://github.com/barrucadu/nixfiles


## Link Roundup

### Software engineering

- [Shell Scripts with Nix](https://www.ertt.ca/nix/shell-scripts/)
