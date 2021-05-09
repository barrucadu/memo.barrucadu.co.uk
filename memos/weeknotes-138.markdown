---
title: "Weeknotes: 138"
taxon: weeknotes-2021
date: 2021-05-09
---

## Work

Planning my week worked well last week, so I gave it a go again this
week.  On Monday morning I noted down a few bullet points for each
day.  I didn't get everything done by the day I'd planned, but I got
everything done overall.  Just about: there's one PR still being
reviewed.

I'll try it out next week too.

### Levels of Authentication

The team finished working through this.  Everything is feature-flagged
off but, when we're ready to switch it on, it should just work.

I prefer proof to hope, so I think next week I'll switch it on in our
integration or staging environment to make sure.

### Service Level Objectives

GOV.UK doesn't really do [SLOs][].  We have an alert if the error rate
is too high, but that's just a number picked by developers, who revise
it up or down if it seems too sensitive or not sensitive enough.
There's no product commitment behind it.  We also have lots of alerts
for things which don't say anything really about our level of service,
like memory being "too low" (but unused RAM is wasted RAM!).

Introducing SLOs for GOV.UK as a whole would be a big task.  But we
can at least adopt them on our team for the [account-api][], since
everything account-related is going to go through that app.  We need
it to be fast and reliable.

So I gave a presentation on what SLIs and SLOs are and why they're
useful, drafted an SLO document & error budget policy, and now we have
SLOs on latency and error rate!  They're very conservative at the
moment, which is because we're not used to working in this way and are
planning to launch some experiments in the near future; but over time
I plan to tighten the bounds, so we get more useful indications of
quality.

[SLOs]: https://sre.google/workbook/table-of-contents/
[account-api]: https://github.com/alphagov/account-api

## Books

This week I read:

- [The Kobold Guide to Combat][] by Janna Silverstein *et al*.

  Like the other Kobold Guides, which I've talked about previously,
  this is a collection of essays, mostly by game designers.  I
  particularly liked *Military Systems at War* by Steve Winter, which
  is about different sorts of troops (I finally know what "light
  troops" are) and the make-up of various historical armies; and *A
  Note on Anatomy* by Richard Pett, which is about how different
  creatures should have different sorts of weapons to reflect their
  different anatomy, rather than just one sword in each hand and
  another held by the tail.

[The Kobold Guide to Combat]: https://koboldpress.com/kpstore/product/kobold-guide-to-combat/


## Gaming

After [moving to Thursdays last week][], so a new player could join,
they dropped out!  So we're back to Sundays.

I think there are things we could have done better.  The new player
joined while both campaigns were in the middle of plot arcs, so they
were thrown into the deep end; and also I got the impression they were
looking for a different tone of game (more wacky, whereas our games
are more serious).  Well, those are lessons to learn for next time.

The D&D GM said that in the future they might be up for running a
[West Marches][] campaign using [Whitehack][], so I've been looking
into that.  It seems a pretty nice system: the core mechanic is `d20`
roll-under-stat-but-above-difficulty (very nice), there's a very
flexible class + group (species, profession, and other such
affiliations) system, and there's spell creation.  There's also a very
cool "auction" mechanic for handling contests between characters where
a single roll won't cut it, where players effectively make bets on how
well they'll roll.

I'm looking forward to giving it a try.

[moving to Thursdays last week]: weeknotes-137.html
[West Marches]: http://arsludi.lamemage.com/index.php/78/grand-experiments-west-marches/
[Whitehack]: https://whitehackrpg.wordpress.com/


## Link Roundup

### Roleplaying Games

- [A Beginner's Guide to Old-School DnD Rulesets (OSR)](https://www.youtube.com/watch?v=JHQaed6GAHc)
- [The Black Hack 2E: OSR Ruleset Review](https://www.youtube.com/watch?v=Ra_b4Etonq4)
- [Whitehack: OSR DnD Book Review](https://www.youtube.com/watch?v=FSX4KWbm7dU)
- [Five Torches Deep: OSR Ruleset Review](https://www.youtube.com/watch?v=uV16ktQ7uvA)
- [The 2019 Questing Beast Awards!](https://www.youtube.com/watch?v=m5o5Jnn1N4c)
- [Traveller: Flatlined - RPG Review](https://www.youtube.com/watch?v=pwhJCQs69Jw)
- [The Power of Editing](https://theangrygm.com/the-power-of-editing/)
- [What Makes Exploration Exploration?](https://theangrygm.com/what-makes-exploration/)
- [Adventure Scouts!](https://wayspell.blogspot.com/2020/11/adventure-scouts.html)

### Miscellaneous

- [How do I keep my days organized with org-mode and Emacs](https://isamert.net/2021/01/25/how-i-do-keep-my-days-organized-with-org-mode-and-emacs.html)
