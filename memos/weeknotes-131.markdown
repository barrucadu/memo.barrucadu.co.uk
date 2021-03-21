---
title: "Weeknotes: 131"
taxon: weeknotes-2021
date: 2021-03-21
---

## Open Source

I released patch versions of [concurrency][] and [dejafu][] fixing a
couple of compilation errors under GHC 9.0.1.  There's been a change
to type inference in the presence of higher-ranked types, meaning code
like this no longer typechecks:

```haskell
forkWithUnmask :: MonadConc m => ((forall a. m a -> m a) -> m ()) -> m (ThreadId m)
-- forkWithUnmask = ...

fork :: MonadConc m => m () -> m (ThreadId m)
fork ma = forkWithUnmask (const ma)
```

The `const` just isn't polymorphic enough, and has to be changed to:

```haskell
fork :: MonadConc m => m () -> m (ThreadId m)
fork ma = forkWithUnmask (\_ -> ma)
```

A little disappointing, but I'm sure it's changed for a good reason.
Which may be something like "this was an unavoidable consequence of
fixing a soundness error somewhere."

dejafu now supports GHC 9.0, 8.10, 8.8, 8.6, 8.4, 8.2, and 8.0.  Yet
the documentation only promises to support [the latest four GHC
releases][].  GHC 8.0 was released in 2016 and I don't think many
people are using it any more.  [Even Debian Stable is on GHC 8.4][].

Supporting older versions requires using CPP and living with warnings
from newer compilers (for doing some things in the old way).  I'm
going to look into how much of a benefit dropping a few old versions
would be, and make a call.

[concurrency]: http://hackage.haskell.org/package/concurrency-1.11.0.1
[dejafu]: http://hackage.haskell.org/package/dejafu-2.4.0.2
[the latest four GHC releases]: https://dejafu.readthedocs.io/en/latest/ghc.html
[Even Debian Stable is on GHC 8.4]: https://packages.debian.org/search?keywords=ghc

## Work

Friday marked [one year at home][]: my last day in the office, since
which I've only gone out for shopping.  It's been an interesting year
for sure.  I quite like working from home, and I won't be in a rush to
go back.

This week I've been mostly working on API contract testing, using
[Pact][].  I've not written tests like this before, so it's been a new
thing to learn.  This is the last thing to do before we can switch on
continuous deployment for our new API app, so it'll be good to get it
done.

I've also been writing API documentation, but stopped when I noticed
one of the endpoints had a fairly awkward interface which could be
simplified.  I found this a lot when I was writing documentation or
blog posts for dejafu.

[one year at home]: at-home-for-one-year.html
[Pact]: https://docs.pact.io/


## Books

This week I read:

- [The Forge of God][] by Greg Bear.

  I found this a really gripping read.  I had been struggling through
  a collection of short stories, decided to pick this up as a break,
  and tore through it in two nights.  It's about first contact, but a
  confusing one: two sets of aliens arrive on Earth, telling very
  different stories.  One says that the end of the world is nigh, the
  other says that they're here to usher humanity into a new golden
  age.

  The story follows the scientists around the apocalyptic alien who
  are trying to figure out what's *really* going on.

[The Forge of God]: https://en.wikipedia.org/wiki/The_Forge_of_God


## CI / CD

After setting up secrets management for Concourse [last week][] I
continued with simplifying and rewriting things, and moved all of my
Concourse pipelines to the repositories which use them.  For example,
[the pipeline to deploy this site][].

I now have [a small repository][] with the rest of my cloud
configuration in.

I also set up [GitHub Actions][] more consistently across my repos:
some of them had Actions, some didn't.  Now they all do, doing some
basic linting & correctness checks.  To help keep the Actions I'm
using up to date, I enabled [Dependabot][] for everything too.

Dependabot then immediately opened a bunch of PRs updating old Python
dependencies I'd frozen months or years ago and never touched since.
Handy.

I'm now pretty happy with my CI / CD set-up, and have [written a
memo][] about it, though there are a few more areas of potential
improvement.

[last week]: weeknotes-130.html
[the pipeline to deploy this site]: https://github.com/barrucadu/memo.barrucadu.co.uk/blob/master/concourse/pipeline.yml
[a small repository]: https://github.com/barrucadu/ops
[GitHub Actions]: https://github.com/features/actions
[Dependabot]: https://dependabot.com/
[written a memo]: ci-cd.html


## Gaming

We began the England chapter of Masks of Nyarlathotep in my [Call of
Cthulhu campaign][].  I tried to write a good intro / recap
summarising what they've got themselves into so far.  The players had
a bit of an "oh shit" moment when they realised just how much time
they used up by going to Australia, and how likely it is that tales of
their exploits in New York have spread to the rest of the cults by
now.

[Call of Cthulhu campaign]: campaign-notes-2020-05-call-of-cthulhu.html


## Miscellaneous

I changed up the layout of this site a little, drawing inspiration
from [my RPG blog][].  I think it's a big improvement, and it's also
somewhat more mobile friendly, with memos dropping to a single-column
display at 800px and listings at 600px.

[my RPG blog]: https://www.lookwhattheshoggothdraggedin.com/



## Link Roundup

### Programming

- [Continuous Typography](https://maxkoehler.com/posts/continuous-typography/)
- [Continuous Typography Tester](https://maxkoehler.com/work/continuous-type-tester/)
- [What I've Learned From 10+ Years of Personal Projects](https://benbernardblog.com/what-ive-learned-from-10-years-of-personal-projects/)

### Roleplaying Games

- [Ask Questing Beast 4: Runehammer and Miscast](https://www.youtube.com/watch?v=N10hFki4C94)
