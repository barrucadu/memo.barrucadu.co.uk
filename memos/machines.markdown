---
title: Machines
tags: howto, possessions, tech
date: 2018-07-14
audience: Not you.
---

Naming convention
-----------------

*Beings* (elder gods, outer gods, people, etc) in the Cthulhu Mythos for local machines; *places* in
the Cthulhu Mythos for remote machines (even though there's only one of those currently).


Physical machines
-----------------

### azathoth ###

> [O]utside the ordered universe [is] that amorphous blight of nethermost confusion which blasphemes
> and bubbles at the center of all infinity—the boundless daemon sultan Azathoth, whose name no lips
> dare speak aloud, and who gnaws hungrily in inconceivable, unlighted chambers beyond time and
> space amidst the muffled, maddening beating of vile drums and the thin monotonous whine of
> accursed flutes.

Purpose
  ~ Primary desktop machine

Operating System
  ~ Windows 10 / NixOS dual-boot

Configuration
  ~ nixfiles/azathoth.nix

Issues
  ~ Wifi is more flakey than carter, in both Windows and Linux; may be worth investing in a new NIC.

### nyarlathotep ###

> It is understood in the land of dream that the Other Gods have many agents moving among men; and
> all these agents, whether wholly human or slightly less than human, are eager to work the will of
> those blind and mindless things in return for the favour of their hideous soul and messenger, the
> crawling chaos Nyarlathotep.

Purpose
  ~ Home server

Operating System
  ~ NixOS

Configuration
  ~ nixfiles/nyarlathotep.nix

Issues
  ~ Same wifi issue (and card) as azathoth.
  ~ Sometimes fails to boot, have yet to reproduce this when a monitor is plugged in.

#### Post-boot set-up ####

rtorrent
  ~ As barrucadu:<br/>
    `tmux new-session -srtorrent -d rtorrent`

bookdb
  ~ As barrucadu in /srv/http/bookdb:<br/>
    `tmux new-session -sbookdb -d "./bookdb run bookdb.conf"`

### carter ###

> In the car they found the hideously carved box of fragrant wood, and the parchment which no man
> could read. The Silver Key was gone—presumably with Carter. Further than that there was no certain
> clue.

Purpose
  ~ Portable machine

Operating System
  ~ macOS Sierra 10.12.3

Configuration
  ~ System-wide configuration is fairly vanilla.

Issues
  ~ None

#### Post-boot set-up ####

syncthing:
  ~ `tmux new-session -ssyncthing -d ~/syncthing/syncthing`

### yig ###

> It seems that Yig, the snake-god of the central plains tribes—presumably the primal source of the
> more southerly Quetzalcoatl or Kukulcan—was an odd, half-anthropomorphic devil of highly arbitrary
> and capricious nature. He was not wholly evil, and was usually quite well-disposed toward those
> who gave proper respect to him and his children, the serpents; but in the autumn he became
> abnormally ravenous, and had to be driven away by means of suitable rites.

Purpose
  ~ Portable machine

Operating System
  ~ NixOS

Configuration
  ~ nixfiles/yig.nix

Issues
  ~ None

There isn't really any reason to use this over carter.

Virtual machines
----------------

### innsmouth ###

> During the winter of 1927–28 officials of the Federal government made a strange and secret
> investigation of certain conditions in the ancient Massachusetts seaport of Innsmouth. The public
> first learned of it in February, when a vast series of raids and arrests occurred, followed by the
> deliberate burning and dynamiting—under suitable precautions—of an enormous number of crumbling,
> worm-eaten, and supposedly empty houses along the abandoned waterfront. Uninquiring souls let this
> occurrence pass as one of the major clashes in a spasmodic war on liquor.

Host
  ~ Linode

Purpose
  ~ Publically-accessible services
  ~ SOCKS proxy endpoint

Operating System
  ~ NixOS

Configuration
  ~ nixfiles/innsmouth.nix

Issues
  ~ None

#### Post-boot set-up ####

irc
  ~ As barrucadu:<br/>
    `tmux new-session -sirc -d irssi`

yukibot
  ~ As barrucadu in ~/projects/yukibot:<br/>
    `./run-yukibot`

#### Miscellaneous ####

- The git hooks for gitolite assume some programs exist in `$PATH`.
