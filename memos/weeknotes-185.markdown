---
title: "Weeknotes: 185"
taxon: weeknotes-2022
date: 2022-04-03
---

## Work

Another week down, and I'm now on a project.  I'm working with another
dev to make our big monolith more scalable by reducing the load on one
of the larger database tables.  So I've been thinking about API
boundaries and database partitioning schemes and refactoring, with an
eye to potentially moving this whole subsystem off into a separate
service with its own database once it's untangled.

The team I'm on owns a lot of the core functionality which the rest of
GoCardless builds upon, and also that code is a tangled mess.  So it
feels pretty similar to being on the Platform Health team at GDS,
which I think was a great team to start on because I got exposed to
all sorts of different areas of the stack pretty early on, which
helped me build a good mental model of how GOV.UK worked.  Hopefully
my start on the Financial Orchestration team at GoCardless will be
just as fruitful.


## Books

No books this week.


## Gaming

Sadly, my Tuesday night game has come to an end.

It turned out that nobody was really that enthusiastic about the
campaign itself, we were all just happy to be playing *a* game.  Which
can be fine, but there were also a few issues we had with the game and
so it became a problem.

The group's decided to give D&D a go, but since I'm in two OSR games
right now (a Stars Without Number game every other Saturday and a
Whitehack game every other Sunday), I decided that that would be a bit
too much D&D for me and so bowed out.


## resolved

No significant changes this week, but I wrote a memo on [how DNS
works][].

[how DNS works]: how-dns-works.html


## Miscellaneous

I switched my personal finance dashboard over to using Prometheus, via
[promscale][], a time-series database built on top of postgres, and I
give the Prometheus queries I'm using for my key metrics in my
[personal finance memo][].

My dashboard used to use InfluxDB 1.  But InfluxDB 1 doesn't have a
very good query language, so I had to do [quite a lot of
pre-processing][] of my [hledger][] data in the daily ETL run.  Rather
than just dump my transaction data and upload it, I instead ended up
generating a new metric for each sort of query I wanted.

This made the dashboard really simple, but the script pretty
complicated.  Sometimes it would even time out uploading the data to
InfluxDB, and I'd have to go tweak the upload batch size.  It was kind
of a pain.

I wanted to change it, and Prometheus seemed the best
choice.[^influx2] But how do you get historic data into Prometheus?
At the time, it didn't support backfilling old data (and it only got
that feature pretty recently), and while Prometheus does support
fetching data from InfluxDB 1, I couldn't get that to work.

[^influx2]: There's also InfluxDB 2, which has a much more powerful
  query language than InfluxDB 1, but I don't use it for anything
  else.  So I'd be learning a brand new database technology just for
  one dashboard I check maybe once a fortnight.

So I shelved the idea, and decided to just live with my suboptimal
script.

...until this week, when it started timing out again.  Enough was
enough.  Time to return to the Prometheus documentation and get this
working.

This time I found [promscale][].  It has an API to load a bunch of
data with arbitrary timestamps, and to delete data.  Just what I need.
I also rewrote my script in python, by consuming hledger's CSV output,
rather than using it as a Haskell library as my old script did.

And now it's [so much simpler][].

[promscale]: https://github.com/timescale/promscale
[personal finance memo]: personal-finance.html
[quite a lot of pre-processing]: https://github.com/barrucadu/hledger-scripts/blob/master/hledger-to-influxdb.hs
[hledger]: https://hledger.org/
[so much simpler]: https://github.com/barrucadu/nixfiles/blob/ba59fce93c1bf615fde1a7556d39b5faebe29914/hosts/nyarlathotep/jobs/hledger-export-to-promscale.py


## Link Roundup

- [Why Rust mutexes look like they do](https://cliffle.com/blog/rust-mutexes/)
- [RFC 9225: Software Defects Considered Harmful](https://www.rfc-editor.org/rfc/rfc9225.html)
- [Instrumentation - Prometheus](https://prometheus.io/docs/practices/instrumentation/)
