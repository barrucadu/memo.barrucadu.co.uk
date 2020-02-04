---
title: "Weeknotes: 016"
taxon: weeknotes-2019
date: 2019-01-06
---

## Ph.D

- I wrote up a document briefly saying how I met all the mandatory
  corrections, [as suggested by my supervisor][], and it's a good
  thing I did because I had missed out a minor one.  It was only a one
  sentence change, but still.

  So the final-final thesis and the document are with my supervisor,
  he'll get back to me at some point about with a suggestion of what
  to do next.

[as suggested by my supervisor]: weeknotes-014.html

## Work

- I was off Monday and Tuesday, and then spent the rest of the week
  fixing minor things, like [removing a really annoying part of our
  smart-answers testsuite][].  I also spent some time planning what
  I'll be doing next week, which is firebreak: the break between
  quarters to do whatever you want, as long as it's useful.  I'm going
  to have a go at making a support rota generator, as making that is
  currently a tedious manual process.

[removing a really annoying part of our smart-answers testsuite]: https://github.com/alphagov/smart-answers/pull/3816

## Miscellaneous

- I came back to an old project, a [brainfuck interpreter using LLVM
  to JIT-compile the code][].  Except it's not really a JIT, as it
  compiles the entire program before jumping into it.  I thought I
  could improve that, but it turns out my idea didn't work.  Writing a
  good JIT is hard, who'd have thought it?

- I found a nice-looking bolognese recipe, tweaked it, and [wrote it
  up][] after it turned out really well.

- I decided to look into fermentation, and have started making some
  [kombucha][].  I'm using [a nice dark tea][] for the base---a
  fermented tea to make a fermented drink---and have a few ideas for
  flavours that might go well with the earthy taste of the tea:
  unflavoured, pear, cherry, ginger, and carrot.  I'll be trying it
  daily from tomorrow, to check if it's done fermenting and ready to
  move on to the flavouring stage.

[brainfuck interpreter using LLVM to JIT-compile the code]: https://github.com/barrucadu/quickie
[wrote it up]: recipe-bolognese.html
[kombucha]: https://en.wikipedia.org/wiki/Kombucha
[a nice dark tea]: https://what-cha.com/malawi-2018-leafy-ripe-dark-tea/

## Link Roundup

- [Bye bye Mongo, Hello Postgres](https://www.theguardian.com/info/2018/nov/30/bye-bye-mongo-hello-postgres)
- [How I wound up finding a bug in GNU Tar](https://utcc.utoronto.ca/~cks/space/blog/sysadmin/TarFindingTruncateBug)
- [Issue 140 :: Haskell Weekly](https://haskellweekly.news/issues/140.html)
- [Let’s Stop Ascribing Meaning to Code Points](https://manishearth.github.io/blog/2017/01/14/stop-ascribing-meaning-to-unicode-code-points/)
- [Motivation Over Discipline](https://www.artofmanliness.com/articles/motivation-over-discipline/)
- [Prime Diophantine Equations](http://mathworld.wolfram.com/PrimeDiophantineEquations.html)
- [There are 5, 6, NINE (or 63*, depending how you count) different ways to write multi-line strings in YAML.](https://stackoverflow.com/questions/3790454/in-yaml-how-do-i-break-a-string-over-multiple-lines/21699210#21699210)
- [This Week in Rust 267](https://this-week-in-rust.org/blog/2019/01/01/this-week-in-rust-267/)
- [Write your Own Virtual Machine](https://justinmeiners.github.io/lc3-vm/)
- [YAML: probably not so great after all](https://arp242.net/weblog/yaml_probably_not_so_great_after_all.html)
