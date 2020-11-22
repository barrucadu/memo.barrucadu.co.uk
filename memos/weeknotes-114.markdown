---
title: "Weeknotes: 114"
taxon: weeknotes-2020
date: 2020-11-22
---

## Work

This week didn't feel very productive for me; but the last few weeks
have been pretty busy so I guess that's ok.  We're shifting a bit from
"building the prototype" mode into "maintaining the service" mode,
though we're far from the end of the experiments we want to do.


## Books

This week I read:

- Volumes 10 and 12 of [Overlord][] by Kugane Maruyama.

  Having read nothing but Culture books for a few weeks, I wanted a
  little break.

[Overlord]: https://en.wikipedia.org/wiki/Overlord_(novel_series)


## Games

This week I finished The Disintegrator, the Pulp Cthulhu one-shot I
ran for my Wolves of God group.  It went well, but I *really* need to
get better at time estimates.  It took two four-hour sessions, but I
initially thought I'd get the whole thing done in one.


## Miscellaneous

This past week and a half has been a nightmare for computer issues.

Last week I got a new NZXT computer case and cooler, moved the
internals over, and immediately started to have problems with Windows
having graphical glitches and freezing after a few hours of use. So...

- I wondered if the new cooler wasn't working properly, but I kept an
  eye on the CPU temperature and it never seemed particularly high
  when a freeze happened.

- I checked all the cables, found a loose GPU power cable, fixed it,
  and thought "aha, that'll be it".  It was not.

- I checked the Windows Event Log, and saw a *lot* of bad block
  errors.  The SMART data looked pretty bad, and the errors had
  started over the previous couple of days, so I thought "aha, the
  NVMe drive is rapidly failing".  I replaced it, but the problem
  remained.

- I checked Windows Update, and saw a big cumulative update had been
  installed.  I did some googling and found reports of freezes, so I
  thought "aha, that'll be it".  I rolled it back, but it kept
  freezing.

- I checked the RAM in memtest and found two of the sticks and one of
  the slots were throwing a *lot* of errors.  This was pretty annoying
  as I had *just* upgraded my RAM, and it looked like two sticks were
  bad!  I removed the two bad sticks, thought "*now* it'll surely be
  fixed!" But it was not.

- Finally, I realised that the cooler is controlled by some NZXT
  software, which manages the speed and its RGB lighting.  Could that
  be it?  Maybe!  I found [a thread on the NZXT forums][] about people
  experiencing freezes in Windows when running NZXT CAM to control a
  Kraken cooler with an AMD CPU... which matches my set-up exactly!
  So I stopped CAM starting on boot and Windows has now been running
  for about 48 hours without freezing, which is a new record.

So I'm pretty sure it's the NZXT CAM software.  It fits the timing.
It explains why I've only seen freezes in Windows and not Linux.  But
it doesn't explain why my NVMe drive and RAM suddenly became
unhealthy; I guess they could be an unrelated failure, or maybe I
zapped something with static electricity when moving to the new case.

I thought about putting the old cooler back on, but the new one works
fine without the CAM software.  So it's a bit annoying but not too
much of a problem.

At some point though I'll have to replace the motherboard, as one of
the RAM slots definitely seems busted.

[a thread on the NZXT forums]: https://linustechtips.com/topic/1223050-new-pc-strange-windows-freezes-probable-cause-nzxt-cam/page/1/


## Link Roundup

- [ALIEN Starter Set - RPG Review](https://www.youtube.com/watch?v=j6PXUl4DyYA)
