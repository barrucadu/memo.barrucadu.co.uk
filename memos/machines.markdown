---
title: Machines
taxon: techdocs
date: 2019-12-17
exclude_from_feed: yes
---

Naming convention
-----------------

- **Local machines:** beings (elder gods, outer gods, people, etc) in the Cthulhu Mythos
- **Remote machines:** places in the Cthulhu Mythos

Local machines
--------------

### azathoth

> [O]utside the ordered universe [is] that amorphous blight of nethermost confusion which blasphemes
> and bubbles at the center of all infinity—the boundless daemon sultan Azathoth, whose name no lips
> dare speak aloud, and who gnaws hungrily in inconceivable, unlighted chambers beyond time and
> space amidst the muffled, maddening beating of vile drums and the thin monotonous whine of
> accursed flutes.

- **Purpose:** primary desktop machine
- **Operating System:** Windows 10 / NixOS dual-boot
- **Monitoring:** no
- **Backups:** no

### nyarlathotep

> It is understood in the land of dream that the Other Gods have many agents moving among men; and
> all these agents, whether wholly human or slightly less than human, are eager to work the will of
> those blind and mindless things in return for the favour of their hideous soul and messenger, the
> crawling chaos Nyarlathotep.

- **Purpose:** general purpose server and NAS
- **Operating System:** NixOS
- **Monitoring:** yes
- **Backups:** yes

Virtual machines
----------------

### dunwich

> Outsiders visit Dunwich as seldom as possible, and since a certain
> season of horror all the signboards pointing toward it have been
> taken down. The scenery, judged by any ordinary aesthetic canon, is
> more than commonly beautiful; yet there is no influx of artists or
> summer tourists. Two centuries ago, when talk of witch-blood,
> Satan-worship, and strange forest presences was not laughed at, it
> was the custom to give reasons for avoiding the locality. In our
> sensible age—since the Dunwich horror of 1928 was hushed up by those
> who had the town’s and the world’s welfare at heart—people shun it
> without knowing exactly why.

- **Host:** Hetzner Cloud
- **Purpose:** publicly accessible services, SOCKS proxy endpoint, and IRC bouncer
- **Operating System:** NixOS
- **Monitoring:** yes
- **Backups:** yes

#### Post-boot set-up

```bash
# irc
tmux new-session -sirc -d irssi

# yukibot (in /projects/yukibot)
./run-yukibot live-configuration.toml
```

Other
-----

### lainon.life

- **Host:** OVH (Kimsufi)
- **Purpose:** lainchan radio and storing lainchan backups
- **Operating System:** NixOS
- **Monitoring:** yes
- **Backups:** no

#### Notes

The radio services need to start in a specific order,
`~/restart-all.sh` can fix them if they don't start properly
