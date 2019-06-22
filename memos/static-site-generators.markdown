---
title: I replaced a static site generator with a script to generate static sites
tags: programming, tech
published: 2019-06-22
audience: General
---

Today I threw out my cumbersome [hakyll][]-based build scripts for
memo.barrucadu.co.uk and www.barrucadu.co.uk in favour of shiny new
ones written in plain Python that don't use any frameworks at all.
I've had enough, I don't want to use static site generators any
more---scripts to generate a static site are more than enough for me,
thank you very much.

The main reasons I switched away from hakyll are:

- Haskell compile times are really bad.
- The templating system is terrible, and I've never liked it.
- It's very opinionated, and trying to do things in a different way is
  difficult.
- The API doesn't expose everything you might want, I've found myself
  copying and pasting library code so I could make minor tweaks

I considered switching to another static site generator like
[jekyll][] or [hugo][], which would have solved my problems with
hakyll... and inevitably introduced their own problems.  The thing is,
static site generators *have* to be opinionated.  If they're not, they
can't automate things like generating sitemaps, RSS feeds, blog
archives, etc.  All of the features you want from a static site
generator only work because the generator imposes some restrictions on
the way you do things.

Eventually you'll want to do something which the tool makes awkward.

[hakyll]: https://jaspervdj.be/hakyll/
[jekyll]: https://jekyllrb.com/
[hugo]: https://gohugo.io/

---

So I decided to write my own tools, but I definitely *didn't* want to
write yet another static site generator, as I'd be introducing exactly
the same problems!  Instead, I've written two bespoke scripts, [one to
generate memo.barrucadu.co.uk][] and [one to generate
www.barrucadu.co.uk][].  They have many similarities, because I did
memo.barrucadu.co.uk first and then modified it to get
www.barrucadu.co.uk, but they're two separate codebases and I could
totally change how rendering pages works (say) in one without
affecting the other.  This is some of the flexibility you lose when
you use a pre-existing static site generator.

I adopted some general principles based on my experiences with hakyll:

- Haskell compile times are bad, so write it in Python.
- I want a powerful templating system, so use [jinja2][].
- A lot of hakyll's opinions come from how it handles incremental
  builds.  I don't need incremental builds, as I regenerate the entire
  website on every deploy, so I can do away with all that complexity.

I also had some wants:

- I didn't want any URLs for pre-existing pages to change.
- I still wanted to use [pandoc][] for rendering.
- I wanted to add some features hakyll had put me off investigating:
  sitemaps; automatically determined "first published" dates for memos
  (from git history); and templating the horrible mass of html that
  was [barrucadu.co.uk/index.html][].

This page you're reading has been rendered by the new script.  It's a
little bit longer than [the old script][], and more verbose in parts,
but it's got no opinions other than those I chose.  I've also cut the
deploy time down from half an hour to five minutes.  Because it
doesn't do any incremental building, it's a bit slower to generate the
site (after the initial compile) than the old script was, but it's
still under a minute.

Maybe I'll experiment more now that it's no longer a huge pain.

[one to generate memo.barrucadu.co.uk]: https://github.com/barrucadu/memo.barrucadu.co.uk/blob/master/build
[one to generate www.barrucadu.co.uk]: https://github.com/barrucadu/barrucadu.co.uk/blob/master/build
[jinja2]: http://jinja.pocoo.org/
[pandoc]: https://pandoc.org/
[barrucadu.co.uk/index.html]: https://github.com/barrucadu/barrucadu.co.uk/blob/3b3c9e749842d2d9865ee9ffeab67ecb3a36a8f7/index.html
[the old script]: https://github.com/barrucadu/memo.barrucadu.co.uk/blob/c7301d5211167f43cafc231dc3094c5e659fba66/hakyll.hs
