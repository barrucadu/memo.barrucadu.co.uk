---
title: "Weeknotes: 014"
taxon: weeknotes-2018
date: 2018-12-24
---

## Ph.D

- I've finished all the corrections!  I also got in touch with my
  supervisor to find out the next steps: he suggests I write a
  document briefly saying how I addressed each correction before
  resubmitting.  The good news is that there can be a further round of
  minor corrections; so if I've missed something out I can get a
  further three months to address that before the final final
  deadline.

## Work

- I was only working on Monday and Tuesday this week, from Wednesday
  onwards I've been on leave, and will be back at work on the 2nd of
  January.

- On Monday I got called in the evening about the site having issues
  (I've been [on call since last Wednesday][]), where it seemed that
  our VMs were having difficulty talking to each other.  After a
  fairly fruitless half an hour of debugging with the other on-call
  dev, the problem went away by itself.  At the moment we suspect a
  network issue with our hosting provider.

[on call since last Wednesday]: weeknotes-013.html

## Miscellaneous

- A couple of the recent Advent of Code challenges have involved
  disassembling code for a fictional CPU.  These can be pretty fun,
  but a bit tricky to solve if you're not familiar with how
  higher-level constructs like loops and conditionals get compiled
  into jumps.

  For example, [Day 19][] involved a program which computed the sums
  of the divisors of a large number.  The fictional CPU doesn't have
  division, so it worked by using loops, additions, and
  multiplications.  [There's a tale of my reverse engineering in my
  solution][], which I might write up as a full memo (along with the
  other related puzzles), as there are a few different techniques
  involved.

- I'm now visiting family until the 29th.

- This memo is a day late because time doesn't exist during holidays.

[Day 19]: https://adventofcode.com/2018/day/19
[There's a tale of my reverse engineering in my solution]: https://github.com/barrucadu/aoc/blob/master/solutions/day19/Common.hs#L148

## Link Roundup

- [Amazon reveals private Alexa voice data files](https://www.heise.de/newsticker/meldung/Amazon-reveals-private-voice-data-files-4256015.html)
- [Bootstrapping a Type System](http://journal.stuffwithstuff.com/2010/10/29/bootstrapping-a-type-system/)
- [From Set Theory to Type Theory](https://golem.ph.utexas.edu/category/2013/01/from_set_theory_to_type_theory.html)
- [Google Scholar Considered Harmful](https://www.ralfj.de/blog/2018/12/12/google-scholar.html)
- [Issue 138 :: Haskell Weekly](https://haskellweekly.news/issues/138.html)
- [Radio Garden](http://radio.garden)
- [The Anti-Mac Interface](https://www.nngroup.com/articles/anti-mac-interface/)
- [The Git Parable](http://tom.preston-werner.com/2009/05/19/the-git-parable.html)
- [The Yoda of Silicon Valley](https://www.nytimes.com/2018/12/17/science/donald-knuth-computers-algorithms-programming.html)
- [This Week in Rust 265](https://this-week-in-rust.org/blog/2018/12/18/this-week-in-rust-265/)
- [Welcome to Our Modern Hospital Where If You Want to Know a Price You Can Go Fuck Yourself](https://www.mcsweeneys.net/articles/welcome-to-our-modern-hospital-where-if-you-want-to-know-a-price-you-can-go-fuck-yourself)
- [tagging – Document configuration with tags](https://ctan.org/pkg/tagging)
