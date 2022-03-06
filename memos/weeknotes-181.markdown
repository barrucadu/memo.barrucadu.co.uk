---
title: "Weeknotes: 181"
taxon: weeknotes-2022
date: 2022-03-06
---

## Books

This week I read:

- Volumes 4, 5, and 6 of [So I'm a Spider, So What?][] by Okina Baba

  All quite fun again, it's nice to have something easy to read in the
  evenings after spending all my days working on my DNS server (see
  below).  I guessed that the anime went up to the end of volume 6,
  but actually it stopped at the end of volume 5.  And I think that
  was the right decision, volume 6 had a bunch of character
  development and worldbuilding (as well as action), and it would have
  been a stretch to fit all that into the show.  A second season of
  the anime has been announced (no release date yet), so I'm looking
  forward to that.

[So I'm a Spider, So What?]: https://en.wikipedia.org/wiki/So_I%27m_a_Spider,_So_What%3F


## Programming

My DNS server has moved on quite a bit since [last week][].  Back then
it couldn't even recursively resolve names: now it can!  Here's a
summary of the changes:

- [Put it on GitHub][]
- Implemented [recursive resolution][]
- Implemented [a size-bounded LRU cache][]
- Added [fuzz tests][], using [cargo-fuzz][]
- Added [some benchmarks][], to guide future improvements
- Added [support for hosts files][]
- Made it [actively reject unknown record types][]
- Added [an option to specify which interface to bind to][]
- And improved the code quality in various ways: tightening up types,
  removing unsafe functions, adding unit tests, etc

I could actually use it for my home DNS now, as a replacement for
my [Pi-hole][]: the last blocker for using existing DNS blocklists was
hosts file support and that's there now.

Before I switch over though I want to add support for zone files, so
that I can read [the root.hints file][].  Currently I specify the IPs
directly in a configuration file:

```yaml
root_hints:
  - "198.41.0.4"     # a.root-servers.net
  - "199.9.14.201"   # b.root-servers.net
  - "192.33.4.12"    # c.root-servers.net
  - "199.7.91.13"    # d.root-servers.net
  - "192.203.230.10" # e.root-servers.net
  - "192.5.5.241"    # f.root-servers.net
  - "192.112.36.4"   # g.root-servers.net
  - "198.97.190.53"  # h.root-servers.net
  - "192.36.148.17"  # i.root-servers.net
  - "192.58.128.30"  # j.root-servers.net
  - "193.0.14.129"   # k.root-servers.net
  - "199.7.83.42"    # l.root-servers.net
  - "202.12.27.33"   # m.root-servers.net
```

...but manually reading one configuration file to stick values into
another isn't a great workflow.  They don't change very often but,
still, it's not ideal.

Once I can read zone files, I'll be able to use the root.hints file,
and also specify custom records in the standard format, like:

```
$ORIGIN lan.

nyarlathotep      300    IN    A        10.0.0.3
*.nyarlathotep    300    IN    CNAME    nyarlathotep
```

[Section 5 of RFC 1035][] has the format.  Annoyingly it's *not quite*
line-oriented: parentheses can be used to indicate a value extends
over a multiple lines.

There are some other nice-to-haves, like dropping the config file
entirely in favour of command-line arguments, improving logging, and
reloading all the zone & hosts files with SIGHUP.  But those can come
later.

[last week]: weeknotes-180.html#programming
[Put it on GitHub]: https://github.com/barrucadu/resolved
[recursive resolution]: https://github.com/barrucadu/resolved/blob/master/src/resolver/mod.rs
[a size-bounded LRU cache]: https://github.com/barrucadu/resolved/pull/15
[fuzz tests]: https://github.com/barrucadu/resolved/tree/master/fuzz/fuzz_targets
[cargo-fuzz]: https://rust-fuzz.github.io/book/cargo-fuzz.html
[some benchmarks]: https://github.com/barrucadu/resolved/tree/master/benches
[support for hosts files]: https://github.com/barrucadu/resolved/pull/26
[actively reject unknown record types]: https://github.com/barrucadu/resolved/pull/27
[an option to specify which interface to bind to]: https://github.com/barrucadu/resolved/pull/29
[Pi-hole]: https://pi-hole.net/
[the root.hints file]: https://www.iana.org/domains/root/files
[Section 5 of RFC 1035]: https://datatracker.ietf.org/doc/html/rfc1035#section-5


## Link Roundup

- [Why I invented “dash encoding”, a new encoding scheme for URL paths](https://simonwillison.net/2022/Mar/5/dash-encoding/)
