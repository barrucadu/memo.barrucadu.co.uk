---
title: "How to: update Pi-hole"
taxon: techdocs-runbooks
published: 2020-04-04
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

# update cloudflared
sudo cloudflared update
sudo systemctl restart cloudflared
```

If a new kernel got installed (`raspberrypi-kernel` package), reboot.

[Pi-hole]: https://pi-hole.net/
