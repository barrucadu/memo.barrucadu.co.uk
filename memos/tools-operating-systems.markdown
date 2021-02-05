---
title: "Tools I Use: Operating Systems"
taxon: general-tools
draft: true
---

![The NixOS and Windows 10 logos.](tools/operating-systems.png)


NixOS
-----

[NixOS][] is a Linux distribution built around the [Nix][] package
manager / build system.  I run it on all my servers, and dual-boot it
with Windows 10 on my desktop.

Nix follows the principles of *pure functional programming*.  Package
build scripts are defined with a real programming language, unlike the
mess that is Make, CMake, and Autotools.

Packages are immutable, and they must explicitly specify everything
they depend on, rather than implicitly depending on some mutable
global system state.  If you miss a dependency from your build script,
your package just won't build: even if the dependency is installed.
If you change a build script, the package gets rebuilt, and so does
everything that depends on it.

Reproducibility is a big selling point.

Nix**OS** treats your system configuration just like a Nix build
script.  You specify what you want installed and how you want it
configured, and it'll set everything up for you: downloading or
compiling packages (you can override a package's build script if you
need), producing configuration files, generating systemd units, and so
on.

It means I can put my entire system configuration in version control,
[and I do][], and makes backups really simple as I just need to copy
my data and my NixOS configuration.  No need to take full-filesystem
snapshots to make sure you don't miss an obscure but necessary config
file.

You can even take this to an extreme and [wipe your / on boot][], just
to prove that all of the necessary state in your system is accounted
for.

How's that for reproducible configuration-as-code?

[NixOS]: https://nixos.org/
[Nix]: https://nixos.org/manual/nix/stable/
[and I do]: https://github.com/barrucadu/nixfiles
[wipe your / on boot]: https://grahamc.com/blog/erase-your-darlings

Windows 10
----------

[Windows 10][] is an operating system which needs no introduction.
Windows is the most popular OS in the world, and has been for decades.
I dual-boot it on my desktop with NixOS.

I used to mostly use Windows 10 for games, but it's also grown on me
as a general-use OS.  It's definitely still not my preferred choice
for programming, but for browsing the web and chatting to people, it's
pretty good.

[Windows 10]: https://www.microsoft.com/en-gb/windows/
