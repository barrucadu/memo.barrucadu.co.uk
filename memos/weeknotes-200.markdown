---
title: "Weeknotes: 200"
taxon: weeknotes-2022
date: 2022-07-17
---

## Books

This week I read:

- Volume 14 of [Overlord][] by Kugane Maruyama

  This newest edition has a new translator.  I'll admit, I was
  worried.  The older volumes, while not exactly the pinnacle of
  English literature, were easy to read and had a certain style.
  Would that style change?  Almost inevitable, unless the new
  translator took incredible care.  Would it change for the worse?

  No.

  Wow, this reads so much better!  Thank you, new translator!  Looking
  back at [when I read volume 13][], I had a few issues with the
  translation: big tonal or topical shifts part-way through a
  paragraph and inconsistent character naming being the two major
  issues, but throughout the series there's also been a less
  significant issue, where the writing just felt... juvenile at times.
  Things like dramatically-translated sound-effects or characters
  yelling "Whaaaaaaaaat!?", and suchlike.  I'd kind of chalked that up
  to being just something you get with light novels.  But not so!
  This latest volume feels much more like a book that actually could
  have been originally written in English.  It's not all the way
  there, but something about the writing style just feels much more
  mature and *normal*; the translator even uses the word "druthers" at
  one point, which the previous one would *never* have done.

  Oh yeah, the story was enjoyable too.  But my main take-away is how
  much the style of the translator matters.

[Overlord]: https://en.wikipedia.org/wiki/Overlord_(novel_series)
[when I read volume 13]: weeknotes-142.html


## Miscellaneous

I felt like fiddling with [my NixOS configuration][] this week, and so
I finally got around to [implementing proper secrets management][],
using [sops-nix][].  No longer do I symlink a git repository of
*plaintext secrets* to `/etc/nixos/secrets`: secrets are now in my
config repo directly, encrypted, and only made available to the things
which need them.

I was initially worried about key management, as this sort of thing
can just be a case of kicking the can down the road: "ok, the secrets
are encrypted... but now I have a secret decryption key to distribute
instead".  But sops-nix solves that nicely by making it trivial to use
your SSH host key as the public key, and so your SSH *private* key
(which is already on the machine) becomes the decryption key.

No need to distribute a separate key, very handy!

It does mean that I've introduced a bit of state to my config repo
where there wasn't any before---if I need to change a machine's SSH
host key for whatever reason I need to re-encrypt its secrets---but
that's an acceptable trade-off to not needing a separate mechanism to
configuration-as-code the decryption key.

As part of this, I also [switched to a flake-based configuration][],
which was almost trivially easy and not something I should have put
off for as long as I did.

[my NixOS configuration]: https://github.com/barrucadu/nixfiles
[implementing proper secrets management]: https://github.com/barrucadu/nixfiles/pull/96
[sops-nix]: https://github.com/Mic92/sops-nix
[switched to a flake-based configuration]: https://github.com/barrucadu/nixfiles/pull/95


## Link Roundup

### Software engineering

- [The Configuration Complexity Clock](http://mikehadlow.blogspot.com/2012/05/configuration-complexity-clock.html)
