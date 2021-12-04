---
title: Time Tracking
taxon: self-systems
published: 2021-12-04
superseded_by: time-tracking
---

<aside class="highlight">I've decided this system isn't working out, and ended the experiment.</aside>

![My time tracking dashboard](time-tracking-dashboard.png)

I'm experimenting with tracking my time, in roughly 15-minute
intervals.  This is something I'm still getting used to, so expect the
system to change.

To track my time at such a resolution, without it being a huge burden,
data entry needs to be quick and easy.  I've decided to use [timedot
format][], where entering a period of 15 minutes will usually be a
single character (more if I also need to type out the category).

A sample entry looks like this:

```
2020-12-31
leisure:reading  .......... ........
leisure:social   .....
sleep            6.75h
chores:systems   ..
leisure:social   ........
leisure:reading  .......................
leisure:anime    ...
```

Each dot is 15 minutes, spaces are ignored.  I've not set up tab
completion for category names yet but, even so, this is very easy to
use.

I import my timedot data into influxdb [with a script which runs
nightly][], to power [a grafana dashboard on my home server][].

[timedot format]: https://hledger.org/hledger.html#timedot-format
[with a script which runs nightly]: https://github.com/barrucadu/quantified-self-scripts
[a grafana dashboard on my home server]: https://github.com/barrucadu/nixfiles/tree/master/hosts/nyarlathotep/grafana-dashboards


What am I tracking?
-------------------

I'm not trying to track every waking minute.  That would be a lot of
work.  Instead I've got a bunch of categories which cover *most*
things that I'm interested in, but which don't include less
interesting things: like slacking off by mindlessly browsing the
internet, showering, or going to the toilet.

So I have a bit of missing time each day.  I'm currently working out
what an acceptable amount of "missing time" is, but I'm leaning
towards 2 hours or less a day.

I'm currently tracking four high-level categories, each with a few
subcategories:

- **Chores**
  - Admin
  - Food Prep
  - Regular---weekly chores, cleaning, that sort of thing
  - Shopping
  - Systems---tracking my [finances][], or [to-do list][], or time (this memo), etc
  - Tech
  - Travel
- **Leisure**
  - Anime
  - Games
  - Movies
  - Reading
  - Relax---time specifically set aside to relax, this doesn't include mindless internet browsing
  - Social
  - Systems---tinkering with how I track my finances (etc) for fun, rather than doing necessary data entry & maintenance
  - TTRPGs
    - Play
    - Prep
  - Tech
  - Writing
- **Sleep**
- **Work**
  - Admin
  - Community---things done for my role as part of the wider GDS / GOV.UK software engineering group
    - Active
    - Meetings
  - Line Management---things done for my roles as line manager & line report
    - Active
    - Meetings
  - Lunch Break
  - Team---things done for my team
    - Active
    - Meetings

I've done some of each of these things since I stated tracking on
2020-12-09.  I expect some new subcategories will be introduced when
covid is, eventually, over and physically going into work or seeing
friends become possible again.

[finances]: personal-finance.html
[to-do list]: self-organisation.html


Questions to answer
-------------------

While simply tracking this information may make me more mindful of how
I spend my time[^mindful], having questions in mind helps inform what
I *should* be tracking.

[^mindful]: For example, I've already found myself preferring to do
  tracked things (like reading or writing) over untracked things (like
  scrolling through reddit for hours).

The high-level single-number metrics I'm looking at are:

- **How much sleep am I getting?**

  It should be 8 hours a day on average.

- **How much work am I doing?**

  This should also be 8 hours a day, for work days.

- **How much time am I tracking?**

  I'll never record exactly 24 hours of activities in a day, unless I
  don't shower and spend the whole day in bed reading or something,
  but if there are consistent big gaps maybe the categories need
  tweaking.

- **When did I last have a day off?**

  Or, equivalently, how many days in a row (not counting weekends)
  have I been working?  I'm usually fairly good at taking time off
  (even during the year of the plague), but this could be a useful
  metric to keep an eye on.

- **What percentage of my waking time is leisure?**

  This is my attempt at a work-life balance metric.  On a work day,
  this should be a little under 50%: 8 hours sleep, 8 hours work, 8
  hours leisure / chores / untracked.  On weekends or days off this
  will be a little under 100%, again due to chores and untracked time.

I'm monitoring the 30-day rolling average for all of those, other than
the time since last day off metric.

I'm also monitoring **what's my breakdown of leisure time** and
**what's my breakdown of work time**, so I can answer questions like
how much time I spend in meetings vs actively working, or working on
things directly to do with my team vs things like line management.
