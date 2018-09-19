---
title: The Academic Mindset and Me
tags: life, research
date: 2017-12-06
audience: Narrow
notice: I was coming out of a bad place when I wrote this.
---

As I come towards the end of my Ph.D, it's hard not to look back on it
and reflect.  Those who know me in person know that I almost dropped
out once and now, even though I didn't go that far, I am still certain
that I don't want a job in academia.

There's nothing wrong with academia, it's just not the place for me.


## A Difference in Archetype

My research has been in concurrency testing.  I think most developers
who have had to debug concurrent programs would agree that it's a
pain, and that they'd love tools which make it easier.

Well, wouldn't you love to hear that there's a concurrency testing
tool for Linux/pthread programs!  It works by instrumenting, and then
repeatedly executing, the compiled binary, so the cognitive overhead
of using it is low.  This tool is called [Maple][1], it's described in
an [OOPSLA paper from 2012][2], and... it hasn't really been updated
since then.  It received a few maintenance commits up until early
2015, but that's it.  It doesn't run on anything newer than Ubuntu
12.04.

[1]: https://github.com/jieyu/maple
[2]: https://dl.acm.org/citation.cfm?id=2384651

Maple could be a fantastically useful tool.  It could easily have
become a standard tool for Linux developers in the five years since
its release.  But instead it was used to get a paper written about how
the approach was feasible, and then discarded.

I'm not saying the authors are *wrong* for having done this, but it's
a good illustration of an archetype I have come to call the
**Researcher**.  **Researchers** may do practically focused research,
and they may well do so out of a genuine motivation to enable better
tooling or processes for working programmers.  But they are not
interested in maintaining this tooling, just in working out its
theory.

Now let's look at my research.  I wrote the [Déjà Fu][3] library to
test concurrent Haskell programs.  While I did research in the process
of implementing it, the research was primarily motivated by wanting to
make Déjà Fu better.  I've put a lot of effort into making it
user-friendly, and I do have a couple of users now!  I do
non-researchy things like work on documentation and think about what
makes a convenient API.  I fall into an archetype I call the
**Developer**.

[3]: https://github.com/barrucadu/dejafu

Overstating the matter to make the difference clear: the **Developer**
is interested in making things and in doing research to make those
things better; whereas the **Researcher** is interested in doing
research about things and may, regrettably, have to on occasion
implement a thing to evaluate their work.

Both archetypes can do "implementation-driven" research, which is the
previous wording I used to try and describe this difference in
motivation.  Understandably, the person I was trying to communicate
this to didn't get it: they were a **Researcher** and from their
perspective their research *is* implementation-driven.  But not in the
way which I meant it.

Most people in academia, at least in a university setting, are
**Researchers** out of necessity.  I suspect **Developers** would be
more common in industry research labs, where the concerns and
motivations are typically more practical and more short-term.


## Where else?

So I don't want to be a researcher at a university, though I do enjoy
doing research and like to think about hard problems.

For now I'm looking for jobs in interesting areas like infosec and
distributed systems.  While not exactly research, there are a lot of
hard problems, and being able to keep up with what's coming out of
academia will probably be a useful skill.
