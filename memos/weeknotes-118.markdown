---
title: "Weeknotes: 118"
taxon: weeknotes-2020
date: 2020-12-20
---

## Work

This week I finally finished the cross-domain analytics feature I'd
been working on for a while.  I've got a few other tasks still in
progress, but the technical work for those is more or less done and
I'm just waiting for things like final content for error messages.

Other than that I've mostly been picking up small refactorings and
bugfixes, and helping people with their tasks.  I'm off work from
Wednesday next week until the 4th, so I don't want to leave anything
unfinished.


## Books

This week I read:

- [The Bonehunters][] by Steven Erikson, the sixth of the [Malazan Book of the Fallen][].

  It's all starting to come together now: the Malazans, Icarium, Karsa
  Orlong, and the Letherii are all being drawn together.  It seems
  like Lether is where a lot of the immediate drama will unfold.  I'm
  also looking forward to seeing how the Warren / Hold situation
  develops: will Lether get proper sorcery, or will modern mages be at
  a big disadvantage in Lether?

- Volumes 20 and 21 of [Nana][], by Ai Yazawa.

  I was pretty blown away by volume 21.  Nana went on hiatus a little
  after Ai Yazawa contracted an illness and had to go to hospital, so
  I assumed that volume 21 would just have a more-or-less normal
  amount of plot development, and the story would just... stop.

  Well that's not what happened.  Some big events happened in volume
  21 and, while the story isn't *finished*, in that there are still
  unresolved plot threads, it felt like a good place to have an
  ending.  It certainly didn't feel like the story was just dropped.

[The Bonehunters]: https://en.wikipedia.org/wiki/The_Bonehunters
[Malazan Book of the Fallen]: https://en.wikipedia.org/wiki/Malazan_Book_of_the_Fallen
[Nana]: https://en.wikipedia.org/wiki/Nana_(manga)


## The Plague

London and the surrounding area have been put into a new [Tier 4][],
and [Christmas rules changed][], so I guess I'm staying in my flat for
the festive period.

I wish the decision had been made a few days earlier, so I wouldn't
need to go through the hassle of getting my train tickets refunded.  I
can understand why they held out for so long though, being the
party---or the Prime Minister---which cancelled Christmas can't be
good for your chances in future elections.

[Tier 4]: https://www.gov.uk/guidance/tier-4-stay-at-home
[Christmas rules changed]: https://www.gov.uk/guidance/guidance-for-the-christmas-period


## Time Tracking

I've now been doing this for a week and a half.  I think I'm starting
to form some habits (noting down time at the turn of the hour, or when
changing tasks), but I still have hours of missing time a day.  Much
of that will be me just wasting time on the internet, as I'm not
tracking that, but some of it will be improper measuring.  I'd like to
get down to consistently having under 2 hours of missing time a day

I found an interesting issue with stacked charts in Grafana, which is
that if the data for a time period is missing some value which was in
the previous period, it just copies the previous one over.  Which
meant that, for example, my chart was showing that I spent 4 hours
playing TTRPGs on Monday, because I didn't have any data in that
category for Monday but I did for Sunday.

So I had to amend my timedot-to-influxdb script to report explicit
zeroes for activities which I didn't do, and then had to implement
some reporting of whether a day is a weekend day or not, so I could
get all my work time charts right again.

I'll need to figure something out for handling days off in my work
charts, because at the moment if I take a day off the chart will
report that as me doing 8 hours less work than I should have done.
Maybe I'll just end up with a list of dates off in a file.


## Miscellaneous

The end of the year approaches, and with it a bunch of recurring
to-dos.  Maybe I should rethink having weekly chores, monthly chores,
quarterly chores, and annual chores; all of which become due on the
31st of December.


## Link Roundup

- ["No." - Running The Game #94](https://www.youtube.com/watch?v=6St9pH4-16E)
- [Security in Plain English: What are Red, Blue, and Purple Teams?](https://www.secureauth.com/blog/security-in-plain-english-what-are-red-blue-and-purple-teams-2/)
- [Enumerating Trees](https://doisinkidney.com/posts/2020-12-14-enumerating-trees.html)
