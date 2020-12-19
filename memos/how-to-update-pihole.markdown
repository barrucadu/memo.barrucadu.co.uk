---
title: "How to: update Pi-hole"
taxon: techdocs-runbooks
published: 2020-10-04
modified: 2020-12-19
---

My DNS at home is powered by [Pi-hole][], which needs to be updated
occasionally:

```bash
ssh pi@pi.hole

# update system
sudo apt-get update
sudo apt-get upgrade

# update pi-hole & blocklists
pihole -up
```

If a new kernel got installed (`raspberrypi-kernel` package), reboot.

If needed, just the blocklists can be updated with

```
pihole -g
```

[Pi-hole]: https://pi-hole.net/
