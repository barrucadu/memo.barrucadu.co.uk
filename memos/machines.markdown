---
title: Machines
taxon: techdocs
published: 2017-03-01
modified: 2021-04-17
---

I run a few machines with various bits and bobs on them.  They're
hosted in three places: [Hetzner Cloud][], [Kimsufi][], and my flat.
I run these machines because they're useful and because tinkering with
them is fun.

They all run [NixOS][], and I keep their configuration [on GitHub][].
They also all share a directory in `~` with [Syncthing][], which
contains almost all of my stuff that isn't in git.

There is a naming convention based on the [Cthulhu Mythos][] of
[H. P. Lovecraft][]:

- **Local machines:** are named after beings: gods, people, etc.
- **Remote machines:** are named after places.

[Hetzner Cloud]: https://www.hetzner.com/cloud
[Kimsufi]: https://www.kimsufi.com/us/en/index.xml
[NixOS]: https://nixos.org/
[on GitHub]: https://github.com/barrucadu/nixfiles
[Syncthing]: https://syncthing.net/
[Cthulhu Mythos]: https://en.wikipedia.org/wiki/Cthulhu_Mythos
[H. P. Lovecraft]: https://en.wikipedia.org/wiki/H._P._Lovecraft


azathoth
--------

This is my primary desktop computer.  It dual-boots Windows 10 and
NixOS, so it doesn't run any services, as they may not be accessible
half of the time.

I use NixOS for programming and for work.  Windows 10 most of the rest
of the time.

I don't bother backing up either OS: everything I care about on Linux
is either in Syncthing or Git, and all of my git repositories have
remotes on GitHub or carcosa.


nyarlathotep
------------

[See the home network memo](home-network.html#nyarlathotep).


carcosa
-------

My general purpose VPS.  Currently it's running:

- [www.barrucadu.co.uk](https://www.barrucadu.co.uk) (+ a few domains which redirect to it)
- [ap.barrucadu.co.uk](https://ap.barrucadu.co.uk), a [pleroma][] instance
- [bookdb.barrucadu.co.uk](https://bookdb.barrucadu.co.uk), a read-only instance of [bookdb][]
- [memo.barrucadu.co.uk](https://memo.barrucadu.co.uk)
- [misc.barrucadu.co.uk](https://misc.barrucadu.co.uk), for temporary file sharing
- [cd.barrucadu.dev](https://cd.barrucadu.dev), CI / CD with [Concourse][]
- [git.barrucadu.dev](https://git.barrucadu.dev), git hosting with [Gitea][]
- [www.uzbl.org](https://www.uzbl.org)
- A docker registry
- My IRC client

All of the websites (on this and other machines) are run through
[caddy][], with certs from [Let's Encrypt][].

This machine backs up of my Syncthing directory and my git
repositories, and stores that in [Amazon Glacier][] using
[duplicity][].  A full backup every month, an incremental one every
week.

This machine is hosted in Hetzner Cloud.

[pleroma]: https://pleroma.social/
[caddy]: https://caddyserver.com/
[Let's Encrypt]: https://letsencrypt.org/
[Amazon Glacier]: https://aws.amazon.com/glacier/
[duplicity]: http://duplicity.nongnu.org/
[Concourse]: https://concourse-ci.org/
[Gitea]: https://gitea.io/en-us/


lainon.life
-----------

This dedicated server hosts the [lainchan][] radio station and pleroma
instance, on [lainon.life](https://lainon.life).

This machine is hosted in Kimsufi.

[lainchan]: https://lainchan.org/
