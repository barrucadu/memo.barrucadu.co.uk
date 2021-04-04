---
title: "Weeknotes: 133"
taxon: weeknotes-2021
date: 2021-04-04 21:00:00
---

## Work

This was a short week.

I was on support for Monday and Tuesday---nothing exciting
happened---then back on team work on Wednesday and Thursday, before
the bank holiday Friday.

Speaking of which, we launched a small experiment on the [bank
holidays page][]: if you've consented to cookies, then there's a
button to remember your location, so that when you next visit the page
the right tab is pre-selected.  We're thinking about where else on the
platform we can use that information (eg, highlighting nation-specific
parts of content).

What else did I do?  Not much.

I finished off writing some documentation, and reviewed a PR, and made
a presentation about the accounts / personalisation architecture to
give at next week's GOV.UK Tech Fortnightly.  I also made a list of
problems with our "[Set up a new Rails application][]" docs, as it
misses a lot of steps (and gives the steps it does have in the wrong
order), and set up continuous deployment for our [release app][].

Finally, I've decided to make a work to-do list, to capture
non-team-related work, or team-related-work which is either something
for me to do specifically (as tech lead) or which is too small to be
worth writing a proper card for and taking to planning:

![Work to-do list.](weeknotes-133/to-do.jpg)

I've also been working through the [DDaT framework][], making a list
of evidence for each skill I'm supposed to have, so that I can talk
about how great I am (and ask for more money) when the skills survey
next comes around.  But that's a bit slow going.

[bank holidays page]: https://www.gov.uk/bank-holidays
[Set up a new Rails application]: https://docs.publishing.service.gov.uk/manual/setting-up-new-rails-app.html
[release app]:https://github.com/alphagov/release
[DDaT framework]: https://www.gov.uk/guidance/software-developer

## Books

This week I read:

- [Mimes][] by Marcel Schwob.

  A collection of short stories (or, "prose-songs" as the prologue
  calls them, which is ridiculously pretentious) about life in ancient
  Greece, based on the "Mimes" written by ancient poet Herodas.

  This was... ok.  I didn't find it as engaging as The King in the
  Golden Mask or as moving as The Book of Monelle.  The stories were
  well written, but I didn't feel particularly drawn into any of them.

[Mimes]: https://www.goodreads.com/book/show/14459517-mimes-with-a-prologue-and-epilogue


## RPG Blog

It's a new month, so there's a new post: [I Roll in the Open][].

> A lot of GMs advise rolling behind a screen, so you can fudge rolls
> when you get a result which would be bad for the story.  I think
> that at best fudging is unnecessary, and can be remedied by being
> more thoughtful about what rolls you ask for (and I go in to how I
> think about rolls), and at worst cheating, where you’re explicitly
> ignoring the rules of the game.

[I Roll in the Open]: https://www.lookwhattheshoggothdraggedin.com/post/roll-in-the-open.html


## Miscellaneous

I hit a bit of a snag with this VPS on Sunday morning, I did some
routine maintenance, pruning old docker volumes.  This warns you that
you can lose data, but reassures you that only volumes not attached to
a running container will go away:

```
$ docker volume prune
WARNING! This will remove all local volumes not used by at least one container.
Are you sure you want to continue? [y/N]
```

I had a quick check: [bookdb][], running; [bookmarks][], running; [RPG
blog][], running; [pleroma][], running.  All good.

I hit "y".

And saw all of those services immediately crash as docker deleted
their volumes from underneath them.  That's not supposed to happen.

Half an hour later I was back up and running, having switched all
those containers to use bind-mounts rather than named volumes, with
data restored from backups.  I've lost a few days of analytics for the
RPG blog, but nothing else is gone.

While `docker volume prune` deleting *in-use* volumes was very
annoying, and confusing (the error message says it'll do the exact
opposite!), it's good that my backup process is actually working.
This is the first time I've needed to restore a database backup, so
they were totally untested.

I also took the opportunity to [improve how I manage dockerised
services][], so now:

- they're all consistent in what options they take,
- I can run multiple instances of the same service on one machine,
- they *all* use bind-mounts for persistent data,
- there's less configuration duplication.

[bookdb]: https://bookdb.barrucadu.co.uk
[bookmarks]: https://bookmarks.barrucadu.co.uk
[RPG blog]: https://www.lookwhattheshoggothdraggedin.com
[pleroma]: https://ap.barrucadu.co.uk
[improve how I manage dockerised services]: https://github.com/barrucadu/nixfiles/pull/9


## Link Roundup

### Software Engineering

- [Default exception handler in Haskell](https://taylor.fausak.me/2021/04/03/default-exception-handler-in-haskell/)
- [Why Do Interviewers Ask Linked List Questions?](https://www.hillelwayne.com/post/linked-lists/)

### Roleplaying Games

- [Advanced Gamemastery: Spectacular Sidekicks](https://www.youtube.com/watch?v=RT1eAE-9n58)
- [Combat 201: 9 Tips for Fast & Exciting Combat Scenes - Playing RPGs](https://www.youtube.com/watch?v=gxfenhHVLFM)
- [The Reasonable DM](http://monstersandmanuals.blogspot.com/2021/03/the-reasonable-dm.html)
- [Enormous Locations & Alert – The Amazing Versatility of Mothership’s Panic Mechanic](https://dicegoblin.blog/2021/02/05/enormous-locations-alert-the-amazing-versatility-of-motherships-panic-mechanic/)
- [We Cannot Get Out: Giving The Underdark A Mines Of Moria Feel with Noise & Alerts in Dungeons & Dragons](https://dicegoblin.blog/2021/02/28/underdark-mines-of-moria-noise-alert-navigation-dungeons-dragons/)
- [I Have No Memory Of This Place: Navigating The Underdark Through Your Senses in Dungeons & Dragons](https://dicegoblin.blog/2021/02/28/i-have-no-memory-of-this-place-navigating-the-underdark-through-your-senses-in-dungeons-dragons/)
