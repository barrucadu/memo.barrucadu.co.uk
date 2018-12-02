---
title: "Weeknotes: 011"
tags: weeknotes
date: 2018-12-02
audience: General
---

## Ph.D

- I finished chapter 1, the introduction.  Now all I have left to do
  is to:
  - make sure the conclusions ties back into the new introduction,
  - make sure all the further work is in the further work chapter,
  - rewrite the abstract to include the motivation and relevance of
    the work.

  Almost there!

## Work

- I [wrote a script][] to generate query strings for our finders (like
  the [AAIB reports finder][]), so we can load test them.  Most
  finders have way too many (or infinitely many) possible queries to
  test them all, so it generates a random sample.  Here are some
  examples:

  - [`{"aircraft_category"=>["sport-aviation-and-balloons", "commercial-fixed-wing", "general-aviation-rotorcraft", "unmanned-aircraft-systems", "commercial-rotorcraft"], "report_type"=>["correspondence-investigation"], "date_of_occurrence[from]"=>"30-4-31", "date_of_occurrence[to]"=>"57-4-25"}`](https://www.gov.uk/aaib-reports?aircraft_category%5B%5D=sport-aviation-and-balloons&aircraft_category%5B%5D=commercial-fixed-wing&aircraft_category%5B%5D=general-aviation-rotorcraft&aircraft_category%5B%5D=unmanned-aircraft-systems&aircraft_category%5B%5D=commercial-rotorcraft&date_of_occurrence%5Bfrom%5D=30-4-31&date_of_occurrence%5Bto%5D=57-4-25&report_type%5B%5D=correspondence-investigation)
  - [`{"aircraft_category"=>["general-aviation-rotorcraft", "sport-aviation-and-balloons", "commercial-rotorcraft"], "report_type"=>["safety-study", "pre-1997-monthly-report", "formal-report", "annual-safety-report", "field-investigation"], "date_of_occurrence[from]"=>"21-10-16", "date_of_occurrence[to]"=>"15-8-24"}`](https://www.gov.uk/aaib-reports?aircraft_category%5B%5D=general-aviation-rotorcraft&aircraft_category%5B%5D=sport-aviation-and-balloons&aircraft_category%5B%5D=commercial-rotorcraft&date_of_occurrence%5Bfrom%5D=21-10-16&date_of_occurrence%5Bto%5D=15-8-24&report_type%5B%5D=safety-study&report_type%5B%5D=pre-1997-monthly-report&report_type%5B%5D=formal-report&report_type%5B%5D=annual-safety-report&report_type%5B%5D=field-investigation)
  - [`{"aircraft_category"=>["commercial-fixed-wing"], "report_type"=>["pre-1997-monthly-report", "special-bulletin", "foreign-report", "annual-safety-report"], "date_of_occurrence[from]"=>"30-6-8", "date_of_occurrence[to]"=>"69-2-12"}`](https://www.gov.uk/aaib-reports?aircraft_category%5B%5D=commercial-fixed-wing&date_of_occurrence%5Bfrom%5D=30-6-8&date_of_occurrence%5Bto%5D=69-2-12&report_type%5B%5D=pre-1997-monthly-report&report_type%5B%5D=special-bulletin&report_type%5B%5D=foreign-report&report_type%5B%5D=annual-safety-report)
  - [`{"aircraft_category"=>["general-aviation-fixed-wing", "sport-aviation-and-balloons", "unmanned-aircraft-systems"], "report_type"=>["annual-safety-report"], "date_of_occurrence[from]"=>"33-8-29", "date_of_occurrence[to]"=>"61-12-15"}`](https://www.gov.uk/aaib-reports?aircraft_category%5B%5D=general-aviation-fixed-wing&aircraft_category%5B%5D=sport-aviation-and-balloons&aircraft_category%5B%5D=unmanned-aircraft-systems&date_of_occurrence%5Bfrom%5D=33-8-29&date_of_occurrence%5Bto%5D=61-12-15&report_type%5B%5D=annual-safety-report)
  - [`{"aircraft_category"=>["commercial-rotorcraft"], "report_type"=>["field-investigation", "pre-1997-monthly-report", "foreign-report", "special-bulletin", "annual-safety-report", "safety-study"], "date_of_occurrence[from]"=>"71-5-24", "date_of_occurrence[to]"=>"99-6-30"}`](https://www.gov.uk/aaib-reports?aircraft_category%5B%5D=commercial-rotorcraft&date_of_occurrence%5Bfrom%5D=71-5-24&date_of_occurrence%5Bto%5D=99-6-30&report_type%5B%5D=field-investigation&report_type%5B%5D=pre-1997-monthly-report&report_type%5B%5D=foreign-report&report_type%5B%5D=special-bulletin&report_type%5B%5D=annual-safety-report&report_type%5B%5D=safety-study)
  - [`{"aircraft_category"=>["commercial-fixed-wing"], "report_type"=>["field-investigation"], "date_of_occurrence[from]"=>"81-2-15", "date_of_occurrence[to]"=>"7-2-11"}`](https://www.gov.uk/aaib-reports?aircraft_category%5B%5D=commercial-fixed-wing&date_of_occurrence%5Bfrom%5D=81-2-15&date_of_occurrence%5Bto%5D=7-2-11&report_type%5B%5D=field-investigation)
  - [`{"aircraft_category"=>["general-aviation-fixed-wing"], "report_type"=>["foreign-report"], "date_of_occurrence[from]"=>"4-5-31", "date_of_occurrence[to]"=>"2-1-7"}`](https://www.gov.uk/aaib-reports?aircraft_category%5B%5D=general-aviation-fixed-wing&date_of_occurrence%5Bfrom%5D=4-5-31&date_of_occurrence%5Bto%5D=2-1-7&report_type%5B%5D=foreign-report)
  - [`{"aircraft_category"=>["commercial-fixed-wing"], "report_type"=>["correspondence-investigation", "pre-1997-monthly-report", "special-bulletin", "safety-study"], "date_of_occurrence[from]"=>"67-11-27", "date_of_occurrence[to]"=>"82-8-8"}`](https://www.gov.uk/aaib-reports?aircraft_category%5B%5D=commercial-fixed-wing&date_of_occurrence%5Bfrom%5D=67-11-27&date_of_occurrence%5Bto%5D=82-8-8&report_type%5B%5D=correspondence-investigation&report_type%5B%5D=pre-1997-monthly-report&report_type%5B%5D=special-bulletin&report_type%5B%5D=safety-study)
  - [`{"aircraft_category"=>["unmanned-aircraft-systems"], "report_type"=>["formal-report"], "date_of_occurrence[from]"=>"1-9-2", "date_of_occurrence[to]"=>"37-3-25"}`](https://www.gov.uk/aaib-reports?aircraft_category%5B%5D=unmanned-aircraft-systems&date_of_occurrence%5Bfrom%5D=1-9-2&date_of_occurrence%5Bto%5D=37-3-25&report_type%5B%5D=formal-report)
  - [`{"aircraft_category"=>["general-aviation-rotorcraft", "commercial-rotorcraft", "general-aviation-fixed-wing", "commercial-fixed-wing"], "report_type"=>["correspondence-investigation"], "date_of_occurrence[from]"=>"59-10-5", "date_of_occurrence[to]"=>"23-1-7"}`](https://www.gov.uk/aaib-reports?aircraft_category%5B%5D=general-aviation-rotorcraft&aircraft_category%5B%5D=commercial-rotorcraft&aircraft_category%5B%5D=general-aviation-fixed-wing&aircraft_category%5B%5D=commercial-fixed-wing&date_of_occurrence%5Bfrom%5D=59-10-5&date_of_occurrence%5Bto%5D=23-1-7&report_type%5B%5D=correspondence-investigation)

- I finished up some work from [a few weeks ago][] by [removing an
  unnecessary field from link expansion][].  Unfortunately it's not a
  very big win.  The most significant change in this series was the
  first one we did, [shrinking organisation links][].

[wrote a script]: https://github.com/alphagov/govuk-load-testing/tree/master/test-data-scripts/finder-facets
[AAIB reports finder]: https://www.gov.uk/aaib-reports
[a few weeks ago]: /weeknotes-007.html
[removing an unnecessary field from link expansion]: https://github.com/alphagov/publishing-api/pull/1397
[shrinking organisation links]: https://github.com/alphagov/publishing-api/pull/1349

## Miscellaneous

- On Monday I watched the [InSight probe landing on Mars][].

- [dejafu][] got a small flurry of interest, and is [on its way back
  to Stackage][].  It seems there's been some interest in using dejafu
  at [DFINITY][], a blockchain startup.  One day I'll figure out why
  there are so many Haskell blockchain startups---or even why there
  are any blockchain startups at all.

- I started playing [Sunless Skies][], a game by the [Fallen London][]
  people in early access.  You play the captain of a locomotive
  exploring the skies for Queen and Empire.  It's pretty fun, and
  hard; but fortunately when you die and start over again, you inherit
  a bit of what your last captain had, so it gradually gets easier.

[InSight probe landing on Mars]: https://mars.nasa.gov/insight/
[dejafu]: https://github.com/barrucadu/dejafu
[on its way back to Stackage]: https://github.com/commercialhaskell/stackage/pull/4197
[DFINITY]: https://dfinity.org/
[Sunless Skies]: http://www.failbettergames.com/sunless-skies/
[Fallen London]: https://www.fallenlondon.com/

## Link Roundup

- [Advent of Code 2018](https://adventofcode.com/)
- [Code of Ur-Nammu](https://en.wikipedia.org/wiki/Code_of_Ur-Nammu)
- [CraSSh](https://cras.sh/)---this is the page about the issue, not the page that will crash your browser.
- [How we spent two weeks hunting an NFS bug in the Linux kernel](https://about.gitlab.com/2018/11/14/how-we-spent-two-weeks-hunting-an-nfs-bug/)
- [I Put Words on this Webpage so You Have to Listen to Me Now](https://christine.website/blog/experimental-rilkef-2018-11-30)
- [Implementing unsafeCoerce correctly using unsafePerformIO](https://www.reddit.com/r/haskell/comments/a1bz5h/implementing_unsafecoerce_correctly_using/)
- [Issue 135 :: Haskell Weekly](https://haskellweekly.news/issues/135.html)
- [Police Arrest Brothers Who Sold a Fake Goya … and Were Paid with Fake Cash](https://news.artnet.com/art-world/police-arrest-brothers-who-sold-a-fake-goya-and-were-paid-with-fake-cash-262919)
- [Progress Clocks | Blades in the Dark](https://bladesinthedark.com/progress-clocks)
- [Text-Only NPR.org : The Nuts And Bolts Of Writing A New Constitution](https://text.npr.org/s.php?sId=133657355)
- [The Thing (listening device)](https://en.wikipedia.org/wiki/The_Thing_(listening_device))
- [The noncentral fallacy - the worst argument in the world?](https://www.lesswrong.com/posts/yCWPkLi8wJvewPbEp/the-noncentral-fallacy-the-worst-argument-in-the-world)
- [This Week in Rust 262](https://this-week-in-rust.org/blog/2018/11/27/this-week-in-rust-262/)
- [You really don’t want to get this, but keep reading to know what this is](https://nyaa.si/view/1097157)
