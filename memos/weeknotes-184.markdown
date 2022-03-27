---
title: "Weeknotes: 184"
taxon: weeknotes-2022
date: 2022-03-27
---

## Work

This week I deployed my first two PRs to production: a refactoring
pulling out some classes into a new module and a configuration change
updating many many cronjobs to run at the correct local time after
today's DST switch.

It's kind of funny how DST was a problem at GOV.UK, with its ancient
Icinga set-up for which I manually changed the "in-hours /
out-of-hours" thresholds twice a year,[^ch] and it's still a problem
at GoCardless, which is using a fancy modern Kubernetes set-up.

Some things never change.

[^ch]: Hey, if a GOV.UK person reads this you should check if that's
  been done.


## Books

This week I read:

- Volume 13 of [So I'm a Spider, So What?][] by Okina Baba

  Well, I'm caught up.  The English translation of volume 14 isn't out
  until June.  It's been a fun story so far.  It definitely feels like
  it's building up towards a climax, and I look forward to see what
  comes next with the two timelines now being in sync.  I do think
  that worked really well as a storytelling device, and we now have
  the problem of how to persuade the human reincarnations that the
  monster reincarnations are right about what must be done, when the
  human reincarnations have been living a lie for so long.  But oh
  wait, way back at the end of volume 5, the hero levelled up his
  Taboo skill, and all the truth of the world was poured into his
  brain...

- Volumes 1 and 2 of [Delicious in Dungeon][] by Ryoko Kui

  Another fun story, this time about delving into a dungeon and eating
  the monstrous inhabitants therein.  There *is* a story, which is
  that one of the adventurers in their party got eaten by a dragon,
  and so the other adventurers need to get them back before being
  digested, so they can be resurrected.  Where does the monster-eating
  come into this you ask?  Well, the reason they had a bad time with
  the dragon was because they were all distracted by hunger, you see.

  It's a pretty thin premise, but it's a comedy manga so that's fine.
  There's just enough story to keep things moving, but the story isn't
  the point, the humour is.

  Annoyingly, I can't find an English translation of volume 3 in
  physical form.  Volumes 1, 2, and then 4 onwards are easy.  But 3?
  I might just have to read that one online, and leave a gap on my
  shelves.  I don't like leaving gaps.

[So I'm a Spider, So What?]: https://en.wikipedia.org/wiki/So_I%27m_a_Spider,_So_What%3F
[Delicious in Dungeon]: https://en.wikipedia.org/wiki/Delicious_in_Dungeon


## resolved

This week I've focussed on observability and improving the code
quality.  The two major new features are **structured logging** and
**Prometheus metrics**.

The log output now looks like this:

```
{"level":"INFO","fields":{"message":"UDP request","peer":"10.0.0.3:33602"},"target":"resolved"}
{"level":"INFO","fields":{"message":"ok","question":"barrucadu.co.uk. IN A","authoritative_hits":"0","override_hits":"0","blocked":"0","cache_hits":"1","cache_misses":"0","nameserver_hits":"0","nameserver_misses":"0","duration_seconds":"0.000094706"},"target":"resolved"}
{"level":"INFO","fields":{"message":"pruned cache","expired":"18","pruned":"0"},"target":"resolved"}
```

There are some other formats available too, for example, timestamps
are included by default but I've disabled them for the systemd unit as
that already does timestamps.

My dashboard, which uses most of the new metrics, looks like this:

![DNS resolver dashboard](weeknotes-184/dns-dashboard.png)

And it's already giving some interesting insights!

For example, my cache size limit is 1,000,000 records, but it only
holds ~4400 right now.  It looks like new records are being added only
a little faster than old records are expiring.  Which makes me wonder
about whether it would be worth having some sort of automatic cache
renewal for entries which get a lot of hits: when the expiry time gets
close, pre-emptively make a request to the upstream nameservers and
replace the cached entry, so that queries can just continue hitting
the cache.

Another thing is the upstream nameserver misses: these are queries
which couldn't be answered locally, got sent upstream, and still
couldn't be answered.  These are bad because it means `resolved` (and
the clients!) are wasting time on a query which won't produce anything
useful.  Well, the gradient of that line changes suddenly, it becomes
less steep, right?  And the requests per second dropped off pretty
obviously too.  That's because I noticed there were a lot of queries
for `azathoth.`, which is the hostname of my desktop computer, being
sent upstream.  This turned out to be from a syncthing
misconfiguration I've now fixed, so those queries stopped.

This week I merged the following PRs:

- [Introduce `Label` type for domain names & add note about RFC 4343 to README](https://github.com/barrucadu/resolved/pull/81)
- [Implement RFC 2782: the SRV record type](https://github.com/barrucadu/resolved/pull/83)
- [Add RFC 3597-compliant `Display` and `FromStr` instances to `RecordClass` and `RecordType`](https://github.com/barrucadu/resolved/pull/84)
- [Add Prometheus metrics](https://github.com/barrucadu/resolved/pull/86)
- [Gather Prometheus metrics from the resolvers](https://github.com/barrucadu/resolved/pull/87)
- [Refactor: split `lib-dns-resolver` out of `bin-resolved`](https://github.com/barrucadu/resolved/pull/88)
- [Implement logging](https://github.com/barrucadu/resolved/pull/89)
- [Add env var to set log format](https://github.com/barrucadu/resolved/pull/90)
- [Only log cache pruning if something is removed](https://github.com/barrucadu/resolved/pull/92)

And opened the following issues:

- [Review RFC 2065 & consider implementing](https://github.com/barrucadu/resolved/issues/77)
- [Implement additional section processing](https://github.com/barrucadu/resolved/issues/78)
- [Review & implement RFC 3597](https://github.com/barrucadu/resolved/issues/79)
- [Review & implement RFC 2671](https://github.com/barrucadu/resolved/issues/82)
- [Purify the recursive resolver](https://github.com/barrucadu/resolved/issues/85)
- [Consider enabling some of the pedantic clippy lints](https://github.com/barrucadu/resolved/issues/91)


## Miscellaneous

Back in 2019 I rewrote [the script which generates this site][].  I
wrote it from scratch in Python.  No fancy features, really just a bit
of plumbing around pandoc and jinja2.

Every time I've tried to use one of the big-name static site generator
tools, I've found them to be both overly complex and yet very
restrictive at the same time.  If you want to do something the
developers didn't anticipate, and that something could be as simple as
"I want a blog without dates in filenames", you have to write code.
And it's never straightforward code, because you have to hook into
this complicated sort-of-but-not-really general-purpose framework.

I'm not doing anything complex here.  It *feels* like an off-the-shelf
static site generator should be able to do what I want easily, but
I've never really found that to be the case.

This week I made the biggest conceptual change to how generating this
site works, *ever*.  I added one of the killer features of static site
generators: a cache, so that if you edit one page you don't need to
recompile the whole site.

I'd been putting this off for a while now, but since I started writing
these weeknotes the number of posts here has exploded.  Waiting 4
minutes to build the site was just unwieldy, and hampering my writing.

Surely this was a big change, right?  After all, this is one of *the*
major reasons people use static site generators rather than write
their own!

Well... [2 changed files with 31 additions and 18 deletions][].

Er, why do people use those complicated tools, again?

[the script which generates this site]: https://github.com/barrucadu/memo.barrucadu.co.uk/blob/master/build
[2 changed files with 31 additions and 18 deletions]: https://github.com/barrucadu/memo.barrucadu.co.uk/commit/182ec0aa3a9d7541c92656cb9b6092c871800db3


## Link Roundup

- [How to visualize Prometheus histograms in Grafana](https://grafana.com/blog/2020/06/23/how-to-visualize-prometheus-histograms-in-grafana/)
- [New in Grafana 7.2: `$__rate_interval` for Prometheus rate queries that just work](https://grafana.com/blog/2020/09/28/new-in-grafana-7.2-__rate_interval-for-prometheus-rate-queries-that-just-work/)
- [Choosing a Rust web framework, 2020 edition](https://www.lpalmieri.com/posts/2020-07-04-choosing-a-rust-web-framework-2020-edition/)
- [Ready for changes with Hexagonal Architecture](https://netflixtechblog.com/ready-for-changes-with-hexagonal-architecture-b315ec967749)
- [Herding elephants: Lessons learned from sharding Postgres at Notion](https://www.notion.so/blog/sharding-postgres-at-notion)
- [PostgreSQL: Documentation: 14: 5.11. Table Partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html)
