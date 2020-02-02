---
title: "Weeknotes: 072"
tags: weeknotes
date: 2020-02-02 22:30:00
audience: General
---

## Work

### Machine learning stuff

We had another good week of ML-enhanced search, with click through
rates continuing to climb.  We're now ready to switch over from one
model we trained a while back to deploying a new model every day, I'll
be flipping that switch tomorrow morning.

Our hypothesis is that, by regularly retraining the model, it should
get better over time, and also be able to respond to trends.

### RFC

[The RFC I had open][] has been accepted, so sooner or later
(hopefully sooner) GOV.UK will have nice machine-readable information
about document attachments.  I've written up some cards to do the
implementation work, I'll probably whizz through some of the easier
ones myself, and then leave the more complex ones to be prioritised as
part of the team's normal work.

[The RFC I had open]: https://github.com/alphagov/govuk-rfcs/pull/116

## Miscellaneous

### Books

I read The Fellowship of the Ring, and started The Two Towers.  I'm
still working my way through The Rise and Fall of the Third Reich.

I ordered a few devops books: the two Google SRE books, the Phoenix
Project, and the Unicorn Project.  They should arrive some time next
week.

### Call of Cthulhu

After 28 sessions, spread across about a year and a half, with [nearly
400,000 words of notes][], my Call of Cthulhu campaign has come to an
end.

Now I need to decide what the next game will be.

[nearly 400,000 words of notes]: masks-of-nyarlathotep.html

### Dhall for Kubernetes

[Dhall][] is a typed configuration language which can generate other
formats like yaml or json.  I've known about it for a while, but never
had a reason to use it.  However, this week I came across a blog post
about [using Dhall to generate Kubernetes config][].  I thought "hey,
I've got a load of super-verbose Kubernetes config", and I decided to
try it out.

[I'll let the metrics on the pull request speak for themselves.](https://github.com/barrucadu/govuk-k8s/pull/10)

It's certainly a lot less verbose and, because the [dhall-kubernetes
library][] is generated from the Kubernetes API spec, I know that any
config which passes the Dhall type-checker will work with Kubernetes
(as long as I use the version of the library which matches my
Kubernetes version, which I didn't at first).  That's *much* nicer
than having some configuration partially apply.

I feel like ops tooling has a problem with non-atomic commits:
terraform can fail part-way through and leave your cloud
infrastructure half-provisioned; kubectl will happily apply a bunch of
configuration, then barf on a syntax error, and not roll back what
it's already done; puppet just doesn't clean up after itself (and,
again, can fail part way through).  Some of this may be unavoidable,
but I suspect these problems could be a lot more avoidable than they
are right now, and type-checking configuration is one small step
towards that ideal.

[Dhall]: https://dhall-lang.org/
[using Dhall to generate Kubernetes config]: https://christine.website/blog/dhall-kubernetes-2020-01-25
[dhall-kubernetes library]: https://github.com/dhall-lang/dhall-kubernetes

### Migrating away from Google Apps

I decided to make cards on my Trello board for the bits of Google Apps
I still use and, this week, I found an alternative to using Google
Photos for getting photos off my phone.  Just plugging it in.

I don't know why I'd never tried that before.

### Planning and Prioritisation

[Last time][] I wrote about how I was planning to adjust my Trello
system by separating "important" and "urgent" tasks, and doing
something like sprint planning.  Well, I've now been using that system
for about a week now.  I didn't actually have that many important
tasks to do, so it seems I did get through them well enough with the
old system, but it wasn't exactly easy to tell at a glance what was
important and what wasn't.  But this week I feel like I've got through
more important things than usual.

I'll be tweaking the system for the next couple of weeks and, when I'm happy with it, I'll update the [Self Organisation][] memo.

[Last time]: weeknotes-071.html
[Self Organisation]: self-organisation.html

## Link Roundup

- [The Infinite Loop That Wasn't: A Holy Grail Bug Story](https://mgba.io/2020/01/25/infinite-loop-holy-grail/)
- [Berry paradox](https://en.wikipedia.org/wiki/Berry_paradox)
- [Zero-downtime Postgres migrations - the hard parts](https://gocardless.com/blog/zero-downtime-postgres-migrations-the-hard-parts/)
- [Finding Mona Lisa in the Game of Life](https://kevingal.com/blog/mona-lisa-gol.html)
- [The Analytic/Synthetic Distinction](https://plato.stanford.edu/entries/analytic-synthetic/)
- [Today I Learned That Not Everyone Has An Internal Monologue And It Has Ruined My Day.](https://ryanandrewlangdon.wordpress.com/2020/01/28/today-i-learned-that-not-everyone-has-an-internal-monologue-and-it-has-ruined-my-day/)
- [Charting new territory](https://medium.economist.com/charting-new-territory-7f5afb293270)
- [Issue 196 :: Haskell Weekly](https://haskellweekly.news/issue/196.html)
- [This Week in Rust 323](https://this-week-in-rust.org/blog/2020/01/28/this-week-in-rust-323/)
