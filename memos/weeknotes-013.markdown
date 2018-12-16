---
title: "Weeknotes: 013"
tags: weeknotes
date: 2018-12-16
audience: General
---

## Ph.D

- After much procrastination and needless delay, I'm almost done.
  This week I fixed up the abstract, conclusions, and future
  work---none of which took particularly long once I sat down to do
  it.

  I've also updated the title page to say "January 2019".

  For next steps, I've got a couple of things to check:

  - That all the code snippets I give have type signatures.
  - That each of the three "contribution" chapters says how it applies
    beyond Haskell.
  - That I haven't accidentally broken the university's formatting
    requirements.

  Then I can resubmit!

  I'd also like to know if this is it, pass or fail, or if there's
  room for another round of revisions if the examiners have comments.
  If the former, I'll make sure my internal examiner is very happy
  with it before formally resubmitting.

## Work

- We did some more load testing, this time focussed on the dynamic
  content, to see what effect the changes made since the [previous
  load test][] have had.  It's much better now.

- This week I've been on call for out-of-hours support since 17:30 on
  Wednesday, and will be until 09:30 next Wednesday.  The way it works
  is that there are three people on call: the least experienced is the
  "primary" (this is me), there's a more experienced "secondary", and
  then someone from the management team beyond that.  When something
  goes wrong, the primary gets called; they can acknowledge the
  problem and start working on it, or escalate to the secondary, who
  can then acknowledge or escalate.  If it gets to the third person I
  assume they start ringing up other people who could help.  The
  reason the less experienced person is the primary contact is
  because, if it were otherwise, they'd never learn anything as the
  more experienced person wouldn't ever call for their help.

  While there are many things that can go wrong, only a few will call
  someone out of hours.  So, of course, I naturally got pulled into
  something on Friday at 17:30, before leaving the office.  It's been
  uneventful since then though.

[previous load test]: /weeknotes-012.html

## Miscellaneous

- For [Advent of Code day 11][] I had the opportunity to use a
  [summed-area table][], a neat data structure I'd not come across
  before.  If you have an `n` by `m` matrix, you can build a
  summed-area table in `O(nm)` time, which then lets you calculate the
  sum of all the elements in any arbitrary submatrix in constant time.

- I made [lemon and poppy seed muffins][] on Saturday.  They turned
  out pretty well for the first thing I've ever baked.  It's a good
  thing my measuring spoons include the weird US measurements like
  "cups" though.

- I started reading [Tribe of Mentors][], by Tim Ferriss.  In which he
  sent 11 questions to a bunch of successful people, and published the
  best answers.  I quite like this one by Susan Cain:

  > **When you feel overwhelmed or unfocused, what do you do?**
  >
  > I love espresso and would happily consume it all day.  But I only
  > allow myself one latte a day, and I save it for when I'm doing my
  > creative work---partly because it jump-starts my mind almost
  > magically, and partly because this has trained me, Pavlovian
  > style, to associate writing with the pleasure of coffee.

[Advent of Code day 11]: https://adventofcode.com/2018/day/11
[summed-area table]: https://en.wikipedia.org/wiki/Summed-area_table
[lemon and poppy seed muffins]: https://www.a-kitchen-addiction.com/bakery-style-lemon-poppy-seed-muffins/
[Tribe of Mentors]: https://tribeofmentors.com/

## Link Roundup

- [Australia Becomes First Western Nation to Ban Secure Encryption](https://www.extremetech.com/internet/281991-australia-becomes-first-western-nation-to-ban-secure-encryption)
- [Darwinian data structure selection](https://blog.acolyer.org/2018/12/14/darwinian-data-structure-selection/)
- [Fixpoints in Haskell](https://medium.com/@cdsmithus/fixpoints-in-haskell-294096a9fc10)
- [GHC: From Bug to Merge](http://neilmitchell.blogspot.com/2018/12/ghc-from-bug-to-merge.html)
- [Inside the court of Ashurbanipal, king of the world](https://www.1843magazine.com/culture/look-closer/inside-the-court-of-ashurbanipal-king-of-the-world)
- [Issue 137 :: Haskell Weekly](https://haskellweekly.news/issues/137.html)
- [Scientists identify vast underground ecosystem containing billions of micro-organisms](https://www.theguardian.com/science/2018/dec/10/tread-softly-because-you-tread-on-23bn-tonnes-of-micro-organisms)
- [This Week in Rust 264](https://this-week-in-rust.org/blog/2018/12/11/this-week-in-rust-264/)
- [Thoughts on bootstrapping GHC](http://www.joachim-breitner.de/blog/748-Thoughts_on_bootstrapping_GHC)
- [United Monoids](https://blogs.ncl.ac.uk/andreymokhov/united-monoids/)
