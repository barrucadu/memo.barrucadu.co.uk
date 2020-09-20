---
title: "Weeknotes: 105"
taxon: weeknotes-2020
date: 2020-09-20 21:00:00
---

## Work

After what felt like an endless number of planning meetings and other
discussions, we finally got back into programming things this week!
There's been a few interesting little problems to solve, as the
desired designs didn't really match what we'd been building so far, so
some rethinking had to be done; but figuring out how things should
work is the fun part of this job.


## Books

This week I read:

- Volumes 14 and 15 of [Nana][], by Ai Yazawa.

  I've also got volumes 18, 19, 20, and 21 sitting on the shelf... but
  volumes 16 and 17 haven't arrived yet.  That's kind of a pain.

I've decided to drop my goal of getting to 104 books (2 books a week)
this year, as I've noticed myself feeling pressured to read shorter
books so I can reach that two-books-a-week average.  I'm only one book
behind now, so I may well reach 104 books, but I don't want to feel
bad about taking a week to read a single long book.

[Nana]: https://en.wikipedia.org/wiki/Nana_(manga)


## Games

This week my Pulp Cthulhu campaign got into Masks of Nyarlathotep
proper, with a dramatic opening in Room 410 that lead to the death of
one of the cultists.  This is a very nonlinear campaign compared to
what we've done before, and the opening in particular is a bit of an
info-dump, but the players are liking it so far.

For a bit of variety I'm thinking of running one-shots in other
systems between each chapter of the campaign, as it is a very long
one.


## Miscellaneous

I decided to give my home network a bit of an upgrade, so I've ordered
a bunch of new toys.  For nyarlathotep (my home server): a larger case
(with hot-swap HDD bays!); a new SSD to use as the OS drive; a PCI-E
SATA card; and some more RAM.  For my network in general: a 6U
cabinet, 24-port patch panel, switch, and power distribution unit.

I feel like building a network rack must be some sort of nerd rite of
passage.

I also [redid my DNS][], switching to [OctoDNS][], because Terraform
is kind of rubbish for DNS: it always wants to recreate every record,
even if nothing has changed.  OctoDNS is much better behaved.

[redid my DNS]: https://github.com/barrucadu/awsfiles/pull/1
[OctoDNS]: https://github.com/github/octodns

## Link Roundup

- [Julia Lopez speech at techUK's 'Building the Smarter State' Conference](https://www.gov.uk/government/speeches/julia-lopez-speech-at-techuks-building-the-smarter-state-conference)
