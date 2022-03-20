---
title: "Weeknotes: 183"
taxon: weeknotes-2022
date: 2022-03-20
---

## Work

Week 2 of GoCardless.  I started writing code this week; just some
fairly simple refactoring and configuration changes, but it was nice
to start to get hands-on.  I'm definitely not the sort of person who
likes to spend weeks just reading documentation or pairing before
starting to do some independent productive work.

If you take reddit as gospel, you'd think that it takes 6+ months for
someone to start to be able to independently contribute, which feels
insane to me.  If anything, I'd have preferred to start even sooner,
last week rather than this.

I did still have a bunch of things to read, and onboarding sessions to
go to, and of course I'm still lacking a lot of domain knowledge, but
I'm getting there.


## Books

This week I read:

- Volumes 10, 11, and 12 of [So I'm a Spider, So What?][] by Okina Baba

  There's two strands of story in this series, separated by 15 years.
  It's mostly been following the earlier strand for the last several
  volumes, but now the two are almost in sync: they're only a few
  months apart.  I think it's worked well as a storytelling device:
  all the reincarnations who were born as monsters got a significant
  head start on those who were reincarnated as humans, because
  monsters mature much more quickly, so they're more mature and are
  making decisions more consciously, whereas the human reincarnations
  are still a bunch of teenagers who, it seems, are being used by
  their more nefarious elders.

  Kind of weird to read a story where the demon lord is the good guy.
  But it's enjoyable.

[So I'm a Spider, So What?]: https://en.wikipedia.org/wiki/So_I%27m_a_Spider,_So_What%3F


## resolved

I got there: I'm using [my DNS server][] for my LAN DNS: it's acting
as an authoritative nameserver for the `lan.` domain, under which I
have all my other hosts (like `nyarlathotep.lan.` and `nas.lan.`), and
recursively resolving other queries.  This is very cool.

Of course, after actually switching over to it for real, I found some
bugs.  The worst two were excessive copying of DNS blocklists (kind of
bad when [the blocklist I use][] has 99,000+ entries) and a weird
inability to resolve domains where Cloudflare is the authoritative
DNS.

But those are fixed now, and I've implemented a bunch of other
improvements too.

[my DNS server]: https://github.com/barrucadu/resolved
[the blocklist I use]: https://github.com/StevenBlack/hosts/blob/master/hosts

This week I merged the following exciting PRs:

- [Add a new type for hosts files, with `Into` / `TryFrom` conversions for zones](https://github.com/barrucadu/resolved/pull/46)

  I realised that I was *talking about* hosts files in various parts
  of the code, but they didn't actually exist as a type.  Hosts files
  were parsed & merged into the zone structure in one go.  So, to make
  the logic more closely fit the explanation, I made them a thing.

- [Implement a zone file parser & move static records into zone files](https://github.com/barrucadu/resolved/pull/51)

  This was a big step.  With this, I could get rid of the janky and
  verbose configuration needed to implement static records, and read
  zone files directly!  Woo!

  Not quite enough to read the real root hints file yet though, as
  that also contains AAAA records which I need to either support or
  ignore.

- [Replace configuration file with command-line arguments](https://github.com/barrucadu/resolved/pull/52)

  With zone files supported, the configuration file was just a list of
  paths and the name of a network interface.  Since my longer-term
  goal was to support reloading hosts and zone files, I decided to
  just pass those directly as command-line arguments.

- [Implement RFC 3596: DNS Extensions to Support IP Version 6](https://github.com/barrucadu/resolved/pull/54)

  This was a nice and simple RFC, just defining the AAAA record type.
  I still haven't implemented the ability to query upstream
  nameservers over IPv6, because I don't have IPv6 at home.

- [Use real root hints file](https://github.com/barrucadu/resolved/pull/56)

  Is this the single coolest PR of the week?  Perhaps!

  The change is straightforward: it's just committing a new zone file
  to the repository.  But it's *the upstream zone file from IANA*.

- [Add fuzz tests for zone format & fix issues](https://github.com/barrucadu/resolved/pull/58)

  I won't lie, it was a bit dissatisfying having to fix issues with my
  zone file parser so soon.  Especially as the changes in this PR are
  pretty significant But it's better to have found the issues than
  not.

  I'm now going to fuzz test parsers as a matter of course.  Fuzz
  testing is just unreasonably effective.

- [Add fuzz tests for hosts file format & fix issues](https://github.com/barrucadu/resolved/pull/59)

  The humble hosts file, so straightforward, surely my implementation
  of this is perfect?  Nope!

- [Add utility programs to convert between hosts files and zone files](https://github.com/barrucadu/resolved/pull/62)

  For a while now I'd planned to add a program to convert a hosts file
  into a zone file (called `htoz`, naturally).  But when I started
  writing it I realised "hey, there are two two-state variables here,
  surely I should have *four* programs?"

  And so `htoh`, `htoz`, `ztoh`, and `ztoz` were born.

  Since hosts files can only hold A and AAAA records, `ztoh` is lossy
  (unless you pass a flag to make it error on unconvertable records
  instead).  And while `htoh` and `ztoz` sound useless, they do at
  least normalise the output, which could be handy.

  Despite adding four new programs, a refactoring in this PR actually
  ended up *reducing* the side of the repository, which I'm kind of
  proud of.

- [Implement reloading configuration on SIGUSR1 (also fixes memory leak / performance issue)](https://github.com/barrucadu/resolved/pull/67)

  We got there in the end, one of my earliest goals: the ability to
  reload the configuration, asynchronously, without restarting the
  server!  I worried about the performance impact of this, because it
  means sticking the configuration inside a read-write lock, but it
  turns out that the performance penalty of copying the configuration
  on every request, which I was doing, was *way* worse.

- [Make cache size configurable](https://github.com/barrucadu/resolved/pull/68)

  You know what's slow?  Going to three or four different nameservers
  to resolve a hostname.  That costs precious milliseconds!  So, to
  speed things up, `resolved` will cache records.

  How many records?  512.  That's a big number, right?

  Turns out no.  When you take NS and CNAME records into account, you
  get a lot of records!  And also 512 takes up almost no memory at
  all!  The cache size on my home server is now 1,000,000.

- [Model non-recursive resolver as a pseudo-nameserver, and non-authoritative zones as an override layer on top of the rest of the domain name system](https://github.com/barrucadu/resolved/pull/70)

  A big title for a big PR.  This is basically just a refactoring PR,
  but it solves a pretty fundamental problem in the code.

  There are two (well three, but we'll get to that later) resolvers:
  the recursive resolver and the non-recursive resolver.  Essentially
  the difference is that the recursive resolver queries upstream
  nameservers, whereas the non-recursive resolver only queries static
  records and the cache.  But we don't want the recursive resolver to
  *always* query remote nameservers: what about cached records?  So
  before making any such queries it also queries the non-recursive
  resolver

  Unfortunately, if it got an answer from the non-recursive resolver,
  it would then just return that to the user.  That sounds good, but
  is actually bad!  For example, let's resolve `cache.nixos.org`:

  ```
  $ dig cache.nixos.org
  ...
  ;; ANSWER SECTION:
  cache.nixos.org.        3595    IN      CNAME   dualstack.v2.shared.global.fastly.net.
  dualstack.v2.shared.global.fastly.net. 55 IN A  151.101.14.217
  ```

  That `CNAME` record has a much longer TTL than that `A` record.  In
  fact, this looks to be a common way to handle CDNs.  I guess for
  failovers?  The CDN operators can change the address
  `cache.nixos.org` points to, without also having to control the
  `cache.nixos.org` DNS directly.

  So, what happens if we query `cache.nixos.org`, wait for a couple of
  minutes, and do it again?  The `A` record will have expired, the
  non-recursive resolver will return *only* the `CNAME` record, and
  the recursive resolver will return just that to the client.  Making
  the client unable to get an IP address for `cache.nixos.org`.
  Whoops.

  Now, the recursive resolver *already handles* incomplete responses
  from upstream nameservers just fine.  So... I made the non-recursive
  resolver effectively just an upstream nameserver as far as the
  recursive resolver is concerned (albeit one it accesses by calling a
  function, not one it accesses over the network).  I had to do some
  restructuring of the non-recursive resolver to make that happen, but
  I think it's worth it.

- [Add a forwarding resolver](https://github.com/barrucadu/resolved/pull/73)

  Finally, I have reached feature-parity with the Pi-hole!  By adding
  this feature I'll never actually use.  This is the third resolver I
  alluded to before.

  If a forwarding address is given, `resolved` won't use its standard
  recursive resolver for recursive queries.  Instead it'll just pass
  the query on to the given nameserver to handle, and cache the
  result.

- [Implement RFC 6761 - Special-Use Domain Names](https://github.com/barrucadu/resolved/pull/74)

  Another RFC down.  This one is just a configuration change.

  Well, ok, it's *just* a configuration change because I put in the
  work to properly support authoritative zones.  In fact, seeing this
  RFC is *why* I decided to implement a zone file parser and support
  being an authoritative nameserver in the first place.

- [Fix Cloudflare ignoring queries - do not set RA flag in queries](https://github.com/barrucadu/resolved/pull/75)

  I only discovered this bug after switching my LAN over to using
  `resolved`.

  You don't appreciate the little things in life, like speedy DNS
  resolution, until you've lived without it for a few days.

  For some bizarre reason, Cloudflare's authoritative nameservers
  reject queries where the RA flag is set.  I don't think the RA flag
  *means anything* in queries, so since `resolved` is a recursive
  resolver I was just setting it in every message, whether it was a
  query or not.  Cloudflare doesn't return an *error*, it just doesn't
  respond *at all*.

  I spent so many hours trying to debug this.  It was especially
  infuriating since `dig` worked fine.  I spent so long staring at
  packet captures from wireshark, and missed this one-bit difference
  between what `resolved` was sending and what `dig` was sending.  I
  thought maybe it was a firewall or OS issue, and tried other
  variations of those.  Nope.  I was completely lost.

  As often happens, after getting some sleep and returning to the
  problem in the morning, I spotted that one byte `dig` was sending
  was 0 and that same byte in my query was 255.  Bingo.

  Really, I should have stopped debugging this and taken a break
  sooner than I did.  Computers aren't magic, so as soon as I found
  myself thinking "these queries are identical, and yet are somehow
  being distinguished", I should have realised it was time to stop and
  come back with fresh eyes later.  We can always improve our
  practices.

- [Add `--authoritative-only` flag to disable recursion / forwarding](https://github.com/barrucadu/resolved/pull/76)

  The final nail in the coffin for "being an authoritative nameserver
  is out of scope".

  You could get almost the same effect by just not giving any root
  hints or a forwarding address, which would make all queries which
  couldn't be answered non-recursively fail, but the RA flag would
  still be set in responses.  So this PR switches off the RA flag and
  doesn't recursively resolve no matter what the other configuration
  has.

And the following less exciting PRs:

- [Refactor: rename `protocol::wire_types` to `protocol::types`](https://github.com/barrucadu/resolved/pull/47)
- [Fix `clippy` exit code in CI, and also lint tests](https://github.com/barrucadu/resolved/pull/53)
- [Regenerate `fuzz/Cargo.lock`](https://github.com/barrucadu/resolved/pull/55)
- [Make domain name handling more consistent: they're ASCII and end with a dot!](https://github.com/barrucadu/resolved/pull/57)
- [Fix panic in benchmarks](https://github.com/barrucadu/resolved/pull/60)
- [Remove unnecessary serde dependency](https://github.com/barrucadu/resolved/pull/61)
- [Ignore interface-specific addresses in hosts files](https://github.com/barrucadu/resolved/pull/71)

And opened several issues, all but one of which have already been
closed:

- [Occasional stack overflows](https://github.com/barrucadu/resolved/issues/69)

So it's been a pretty productive week!  And it's certainly very cool
to be running my own DNS server in my LAN.  There are still issues to
resolve, and RFCs to implement, but I could stop now and this would
already be more than good enough.

This project has definitely been a good learning experience.  DNS is a
huge eventually-consistent distributed database based on a
hierarchical web of trust, but it isn't actually that complex.  I'm
planning to write a "how DNS works" memo soon, before I start to
forget all the little details.


## Link Roundup

### Roleplaying Games

- [Starting Your Campaign - Running RPGs](https://www.youtube.com/watch?v=Aqpw9BjyaMk)

### Programming

- [Nix Pills](https://nixos.org/guides/nix-pills/index.html)
- [My most impactful code](https://blog.lawrencejones.dev/most-impactful/)
