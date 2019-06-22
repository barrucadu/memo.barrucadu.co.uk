---
title: "Weeknotes: 005"
tags: weeknotes
date: 2018-10-21
audience: General
---

## Personal

* This was a fairly uneventful week.

## Ph.D

* I finished off the corrections for chapter 7 of my thesis.  Only
  chapters 1, 4, 8, and 9 to go.

## Work

* I started deleting our logging machines ([Weeknotes: 003][]), and
  then stopped to open a support ticket with our hosting provider.
  Our CDN is set up to stream real-time logs to the machines I was
  deleting, and write logs on a 15-minute delay to an S3 bucket.  We
  didn't want to lose the real-time logs, so I changed things around
  to save the real-time logs on another machine, for a short period of
  time.  All seemed to going smoothly, except that our CDN couldn't
  talk to the new machine!  We think the updated firewall rules should
  work, and our Reliability Engineering team also had a look, but no
  dice.  So now we're wondering if something is up with the hosting
  provider.  They haven't got back to me yet.

* I paired with another developer to fix [a rounding issue in our
  holiday entitlement calculator][].  As I understand it, holiday
  entitlement should be rounded up in all cases, but in some cases we
  were rounding down.  There was also another problem with trying to
  calculate your holiday entitlement based on hours worked, rather
  than days worked: it assumed everyone worked 5 days a week.  After
  this has been code reviewed, it'll be sent to the relevant
  department ([BEIS][] in this case) for fact-checking, where a
  subject-matter expert will try out a bunch of different scenarios to
  verify that it's correct.  Hopefully they'll give us their
  scenarios, so we can then add them to the testsuite.

* I spent the rest of time preparing some [Gatling][] test scenarios,
  for load-testing the GOV.UK frontend apps.  This is mostly in
  response to brexit: what if we suddenly get far more traffic than
  we've ever had before?  I've been writing the test plans (I'm sure
  the GitHub repository will be publicly visible at some point) and
  learning how Gatling works, when we're happy with the plans we'll
  need to run them, which will probably involve provisioning a bunch
  of EC2 instances to generate the needed load, or maybe even using
  Gatling's enterprise edition.  Gatling uses [Scala][], which I've
  never touched before, but it's similar enough to Java and Haskell
  that I can sort of get by.

[Weeknotes: 003]: weeknotes-003.html
[a rounding issue in our holiday entitlement calculator]: https://github.com/alphagov/smart-answers/pull/3726
[BEIS]: https://www.gov.uk/government/organisations/department-for-business-energy-and-industrial-strategy
[Gatling]: https://gatling.io/
[Scala]: https://www.scala-lang.org/

## Miscellaneous

* My [Call of Cthulhu][] campaign is starting up again next weekend,
  so I did some preparation after catching up on the [Encounter
  Roleplay][] play-through of [Masks of Nyarlathotep][].  It's been
  really useful to see how a more experienced Keeper runs some of the
  things my players are likely to encounter.  My first session went
  pretty well, but things can always be better.

[Call of Cthulhu]: https://en.wikipedia.org/wiki/Call_of_Cthulhu_(role-playing_game)
[Encounter Roleplay]: https://www.youtube.com/channel/UCX8hVbCr29pjxA1Xlhwm5Qg
[Masks of Nyarlathotep]: https://www.youtube.com/playlist?list=PL4a6HmwLLXpc9GUXRz3su9sBPRG8VdYdr

## Link Roundup

* [Announcing Profiterole - GHC Profile Viewer](https://neilmitchell.blogspot.com/2018/10/announcing-profiterole-ghc-profile.html)
* [Building successful online communities: Evidence-based social design](https://acawiki.org/Building_successful_online_communities:_Evidence-based_social_design)
* [Delivering Continuous Delivery, continuously](https://www.theguardian.com/info/developer-blog/2015/jan/05/delivering-continuous-delivery-continuously)
* [Etsy’s experiment with immutable documentation](https://codeascraft.com/2018/10/10/etsys-experiment-with-immutable-documentation/)
* [Excerpt from: Mark Wilson (1985). Drawing With Computers. Perigee Books, pp. 24-25.](http://www.kmjn.org/snippets/wilson85_screenshot.html)
* [Haskell Community Priorities for GHC](https://docs.google.com/forms/d/e/1FAIpQLSdh7sf2MqHoEmjt38r1cxCF-tV76OFCJqU6VabGzlOUKYqo-w/viewform)
* [How new-lines affect the Linux kernel performance](https://nadav.amit.zone/linux/2018/10/10/newline.html)
* [Issue 129 :: Haskell Weekly](https://haskellweekly.news/issues/129.html)
* [Japan's Hometown Tax](https://www.kalzumeus.com/2018/10/19/japanese-hometown-tax/)
* [Jon Skeet on Twitter "Latest time zone data (2018f) breaks Noda Time, because we foolishly assume that "hour of day" will be in the range 0-23 inclusive."](https://twitter.com/jonskeet/status/1052843655516442624)
* [Notes on test coverage](https://jml.io/2018/10/notes-on-test-coverage.html)
* [REPT: reverse debugging of failures in deployed software](https://blog.acolyer.org/2018/10/17/rept-reverse-debugging-of-failures-in-deployed-software/)
* [This Week in Rust 256](https://this-week-in-rust.org/blog/2018/10/16/this-week-in-rust-256/)
* [Why You Need a Reading Plan](https://www.artofmanliness.com/articles/why-you-need-a-reading-plan/)
* [Writing Documentation When You Aren’t A Technical Writer — Part One](https://blog.stoplight.io/writing-documentation-when-you-arent-a-technical-writer-part-one-ef08a09870d1)
* [Writing Documentation When You Aren’t A Technical Writer — Part Two](https://blog.stoplight.io/writing-documentation-when-you-arent-a-technical-writer-part-two-59997587cc2a)
