---
title: Home Network
taxon: techdocs
published: 2021-03-22
modified: 2022-10-07
---

![The pile of network hardware.](home-network/hardware.jpg)

1. Wireless access point (UniFi FlexHD)
2. Server (nyarlathotep)
3. 6U network cabinet, with:
   1. 24-port keystone patch panel, with:
      1. 4x USB power
      2. 4x blank
      3. Ethernet (azathoth)
      4. Ethernet (nyarlathotep)
      5. Ethernet (Raspberry Pi)
      5. 11x blank
      7. Ethernet (AP)
      8. Ethernet (WAN)
   2. Router (UniFi DreamMachine Pro)
   3. Switch (UniFi Switch 24 (non-PoE))
   4. Mesh plate
   5. Shelf, with Raspberry Pi
   6. 8-way C13 power distribution unit, with:
      1. Router
      2. Switch
      3. AP
      4. Server
      5. Raspberry Pi
      6. USB power

Plus a surge-protected 8-way mains extension lead and a pile of spare
cat6 cables, for guest use.

---

![The network topology.](home-network/map.png)

- [azathoth][] is my desktop machine, and is running a NixOS / Windows
  10 dual boot.  I mostly use NixOS for programming and for work
  (which is, mostly, programming); and Windows 10 for everything else.

- [nyarlathotep][] is my general-purpose server and also a NAS, and is
  running NixOS.  As you can see in the photo above, nyarlathotep sits
  atop the network cabinet; I'll probably upgrade to a rack and a
  suitable chassis at some point.

- The [pi-hole][] is providing DNS, and is running Raspbian.  I have
  plans to put NixOS on this too and rename it to [yog-sothoth][].

Noise is a concern, as everything is set up in my living room, which
is where guests staying overnight sleep.  So to keep everything quiet
at night (and at all times) I'm using [Noctua][] fans running at as
low an RPM as I can get them.

[azathoth]: https://github.com/barrucadu/nixfiles#azathoth
[nyarlathotep]: home-network.html#nyarlathotep
[pi-hole]: https://pi-hole.net/
[yog-sothoth]: https://en.wikipedia.org/wiki/Cthulhu_Mythos_deities#Yog-Sothoth
[Noctua]: https://noctua.at/

---

I'm using Ubiquiti's managed [UniFi networking equipment][], which is
overkill for the small network I have, but it's all very nice.

350Mbit WAN comes in through my Virgin Media router (running in modem
mode), into my UniFi Dream Machine Pro's WAN port, which is connected
to a UniFi Switch 24 (non-PoE) and a UniFi FlexHD Access Point.

I have three VLANs with some firewall rules set up between them:

| Name               | VLAN ID | IP Range     | Firewall rules                                                       |
|--------------------+---------+--------------+----------------------------------------------------------------------|
| Wired              |       1 | 10.0.0.0/24  | Can talk to hosts in VLANs 1 and 10                                  |
| Wireless           |      10 | 10.0.10.0/24 | Can talk to hosts in VLANs 1 and 10                                  |
| Untrusted Wireless |      20 | 10.0.20.0/24 | Can send DNS traffic to the pi-hole and HTTP traffic to nyarlathotep |

The untrusted wireless is for phones and smart devices which don't
make it easy to see what they're doing.  And my work laptop.  Normal
computers (eg, a guest's laptop) go straight on the trusted wireless
network.

I've got a few custom DNS records set up for various static IP
addresses:

```
address=/router.lan/10.0.0.1
address=/pi.hole/10.0.0.2
address=/nyarlathotep/10.0.0.3

# for https://github.com/alphagov/govuk-docker
address=/dev.gov.uk/127.0.0.1

# for general use
address=/localhost/127.0.0.1

# these should be CNAMEs but windows doesn't resolve them
address=/help.lan/10.0.0.3
address=/nas.lan/10.0.0.3

# firefox in windows has started redirecting http://nyarlathotep to http://www.nyarlathotep.com ???
# so add in a domain with a dot, which it seems happier with
address=/nyarlathotep.lan/10.0.0.3
```

The `help.lan` and `nas.lan` rules are for guests.  Visiting
`http://help.lan` tells you what VLAN you're on, gives a summary of
the firewall rules, and gives guest credentials for the NAS (if not on
VLAN 20).  `http://help.lan` is served by nyarlathotep, so to restrict
access to the other domains it's serving, it 302-redirects to
`http://help.lan` if the user is on VLAN 20.

[UniFi networking equipment]: https://unifi-network.ui.com/


Nyarlathotep
------------

Services and configuration are covered in [my NixOS config][].

[my NixOS config]: https://github.com/barrucadu/nixfiles#nyarlathotep

### Storage

#### System

nyarlathotep uses a 250GB SSD as the system volume (connected via
PCI-e), with a ZFS partition and a vfat partition (the UEFI system
volume).

The ZFS partition consists of one zpool with volumes:

- **`local/volatile/root`**: mounted at `/`
- **`local/persistent/home`**: mounted at `/home`
- **`local/persistent/nix`**: mounted at `/nix`
- **`local/persistent/persist`**: mounted at `/persist`
- **`local/persistent/var-log`**: mounted at `/var/log`

This `local/volatile/root` dataset is configured in the ["erase your
darlings"][] style: everything is deleted by rolling back to an empty snapshot
at boot.  Any state which needs to be persisted is in `/persist`, and managed
through configuration and symlinks.

The `local/persistent` dataset has automatic snapshots configured.

["erase your darlings"]: https://grahamc.com/blog/erase-your-darlings

#### NAS

nyarlathotep uses 8 hot-swap SATA bays configured as a zpool of
mirrored pairs for NAS:

```
Mirror Device  Mirror Device
     0 A            0 B
     1 A            1 B
     2 A            2 B
     - A            - B
```

The "A" volume of each pair is connected to the motherboard SATA
controller and the "B" volume of each pair to a PCI-e SATA controller.

The HDD serial numbers are:

1. **0A:** `ata-ST10000VN0004-1ZD101_ZA206882`
2. **0B:** `ata-ST10000VN0004-1ZD101_ZA27G6C6`
3. **1A:** `ata-ST10000VN0004-1ZD101_ZA22461Y`
4. **1B:** `ata-ST10000VN0004-1ZD101_ZA27BW6R`
5. **2A:** `ata-ST10000VN0008-2PJ103_ZLW0398A`
5. **2B:** `ata-ST10000VN0008-2PJ103_ZLW032KE`

The zpool currently has a single dataset:

- **`data/nas`**: mounted at `/mnt/nas`

The `data` dataset has automatic snapshots configured.


Future projects
---------------

I've got a few thoughts on future projects and expansions for this
set-up, but given how much I spent on the last upgrade these are all
likely to be a few years off at least.

### Get a rack

Currently I have a network cabinet, and a non-rackmount server
chassis.  I could instead get a larger rack, an appropriate server
chassis, and use that for everything.

The main downsides to this are cost (just by virtue of being rack
compatible it seems everything gets more expensive) and noise (with
less space in the chassis fans have to work harder).  Ease of
transport is also a consideration, as I'm only renting my current
flat.

So this is probably something I'd only do after finding a place I
intend to stay at long-term; ideally where I can have a dedicated
computer room and run ethernet cables through the walls.

### Redundant WAN

Currently I rely on just the one ISP for internet.  They're usually
pretty good, but sometimes issues do occur.  My UDM Pro supports a
second WAN source, so I could get a 4G / 5G modem and set up automatic
failover if the primary goes down.

### Upgrade to PoE

Currently I have a Raspberry Pi and a UniFi Access Point powered by
regular power cables.  Both of these devices are capable of being
powered by a switch with PoE (with some extra hardware for the Pi),
which would reduce other cables.

However, PoE switches are significantly more expensive.  So I could
either get a small PoE switch for the limited number of devices I
have, or save this upgrade for when I have use for more PoE-connected
devices.  For example, if I get a house and need to set up multiple
access points.

### Upgrade to 10Gbit

Totally overkill, but it could be cool to get a switch which supports
10Gbit connections, and also 10Gbit NICs for azathoth and
nyarlathotep.

I think I would need to rebuild nyarlathotep before doing this, as it
doesn't have a free PCI-e port.

### Raspberry Pi cluster

People have designed [3D-printable rack mounting gear for Raspberry
Pis][], and since reading an article about [a Raspberry Pi cluster][]
I've been tempted.  I wasn't very keen on Kubernetes when I last tried
it; at work we use Cloud Foundry, and it's pretty easy to deploy
things to, so I'd probably look into running that first.

I could move some of the services off nyarlathotep onto this Pi
cluster, though I'd probably still want to use nyarlathotep as backing
storage.

[3D-printable rack mounting gear for Raspberry Pis]: https://www.youtube.com/watch?v=splC57efBFQ
[a Raspberry Pi cluster]: https://mirailabs.io/blog/building-a-microcloud/
