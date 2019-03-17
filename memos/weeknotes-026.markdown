---
title: "Weeknotes: 026"
tags: weeknotes
date: 2019-03-17 19:30:00
audience: General
---

## Open Source

- Fixed a small bug in dejafu to do with throwing an asynchronous
  exception to the current thread while it's masked.  The
  `Control.Exception` documentation says:

  > Note that if `throwTo` is called with the current thread as the
  > target, the exception will be thrown even if the thread is
  > currently inside `mask` or `uninterruptibleMask`.

  So, this should result in `True`:

  ```haskell
  do me <- myThreadId
     catch (uninterruptibleMask_ (killThread me))
           (\ThreadKilled -> pure True)
  ```

  However, dejafu would instead consider the thread blocked, as it's
  trying to throw an exception to an uninteruptible thread.  This was
  [issue #267][].  I fixed it in [PR #297][], which was released as
  [dejafu-2.0.0.1][].

[issue #267]: https://github.com/barrucadu/dejafu/issues/267
[PR #297]: https://github.com/barrucadu/dejafu/pull/297
[dejafu-2.0.0.1]: http://hackage.haskell.org/package/dejafu-2.0.0.1

## Work

- This week I was on support for Monday and Tuesday, back with my team
  on Wednesday, and then on leave on Thursday and Friday, so I didn't
  get much actual work done.  Probably the highlight is that I
  switched over the [licence finder][] to elasticsearch 5.  I
  continued with switching over all the other apps in our staging
  environment, which revealed a few issues.  Some of those I fixed,
  others I left at the end of Wednesday.

- A couple of weeks ago I applied to be a senior developer.  I got
  word that I've made it through the initial weeding out phase, and
  will have an interview at some point in the next four to five weeks.

[licence finder]: https://www.gov.uk/licence-finder

## Miscellaneous

- I wrote a silly memo about [`sed`-as-a-service][].

- I blended the chillies I'd begun fermenting three weeks ago to make
  a hot sauce.  The end result is alright, it's got quite a kick to
  it, but it doesn't really have much flavour beyond spice.  It works
  well as a burger topping.  I've seen a few recipes which call for
  fruit, so I think I'll try that next time.

- I made some [water kefir][], which turned out much better than my
  previous attempts at kombucha.  I infused it with pear, and I'm now
  making a second batch with just sugar water.  Being able to make it
  in 48 hours is definitely a big advantage.

- My [Masks of Nyarlathotep game][] resumed on Saturday, after missing
  a session due to a few people being away.  The investigators arrived
  in London, and decided to split up and look for clues.  They did a
  bunch of sneaking around, but haven't found any concrete leads to
  the cult their good friend Jackson Elias was investigating.

  There are a couple of relevant (real-world) deaths around this time
  of year:

  - Friday was the anniversary of H. P. Lovecraft's death.  Sadly, I
    didn't realise until Friday evening, so we couldn't play the game
    then in honour of his memory.

  - Larry DiTillio, author of the first edition of the Masks of
    Nyarlathotep campaign and writer for a lot of TV stuff (including
    [Babylon 5][]), died after a period of illness on Saturday.  I
    only learned about this on Sunday morning, but it feels fitting we
    were playing Masks on his final day.

[`sed`-as-a-service]: /sed-as-a-service.html
[water kefir]: https://en.wikipedia.org/wiki/Tibicos
[Masks of Nyarlathotep game]: /masks-of-nyarlathotep.html
[Babylon 5]: https://en.wikipedia.org/wiki/Babylon_5

## Link Roundup

- [Why can’t I set the font size of a visited link?](https://jameshfisher.com/2019/03/08/why-cant-i-set-the-font-size-of-a-visited-link)
- [NixOS Weekly #05 - Cachix private caches, Termux, Artwork for 19.03, a rant](https://weekly.nixos.org/2019/05-cachix-private-caches-termux-artwork-for-19-03-a-rant.html)
- [This Week in Rust 277](https://this-week-in-rust.org/blog/2019/03/12/this-week-in-rust-277/)
- [Issue 150 :: Haskell Weekly](https://haskellweekly.news/issues/150.html)
- [Replace JSON with Dhall: DynamoDB case study](https://msitko.pl/blog/2019/03/13/replace-json-with-dhall.html)
