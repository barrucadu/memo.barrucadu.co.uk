---
title: "Weeknotes: 094"
taxon: weeknotes-2020
date: 2020-07-05
---

## Open Source

I made a new release of [dejafu][] fixing [an issue with the atomic
restoration of masking state][] when an exception is thrown inside a
restored mask.

This test case now always returns either `Left ThreadKilled` or `Left
UserInterrupt`:

```haskell
do
  var <- newEmptyMVar
  tId <- uninterruptibleMask $ \restore -> fork $ do
    result <- (Right <$> restore (throw UserInterrupt)) `E.catch` (pure . Left)
    putMVar var result
  killThread tId
  v <- takeMVar var
  pure (v :: Either AsyncException ())
```

Unlike before, when it would sometimes deadlock instead.

[dejafu]: https://github.com/barrucadu/dejafu
[an issue with the atomic restoration of masking state]: https://github.com/barrucadu/dejafu/issues/324


## Work

This week we finished our discovery, so on the dev side of things we
were finishing up all the in-progress work and reviewing our
documentation.  Next week we've got a lot of whole-team activities
looking at the bigger picture of what we're working on, before moving
onto the next phase of prototyping.


## The Plague

Things are starting to re-open, but I don't expect it to have much of
an impact on me.


## Books

This week I read:

- [Tales of the Dying Earth][] by Jack Vance

    There's definitely some ideas I'll be taking from this to make my
    fantasy worlds more fantastical.  Even small things like saying
    "in all candour" instead of "verily", "honestly", or "truthfully"
    can make a place feel really different from the standard
    fantasy-medieval-Europe.

    I also think Vancian magic seems like a really neat way of making
    magic feel mysterious, but they removed it from D&D 5e in favour
    of something more flexible!  Pah!

- [Sly Flourish's Return of the Lazy Dungeon Master][] by Michael E. Shea

    Some good ideas in here, though bits of it are a bit D&D-centric.
    I like the idea of using Fate-style aspects when preparing
    interesting locations, to jog your memory and help you improvise;
    rather than my current approach which is to write a bunch of prose
    and re-read it mid-session.

    Also the idea of preparing lists of random names *ahead of time*
    has somehow never occurred to me before.  It may be because I've
    only run games online (with one exception), so whenever I needed a
    name I've *then* fired up the random name generator.

- [The Kobold Guide to Worldbuilding][] by Janna Silverstein *et al.*

    Some really good advice in here, and I think I'm sold on getting
    the rest of the Kobold Guide books.  It's a collection of essays
    by fanatsy authors and game designers, drawing on their practical
    experience to advise new world-builders.  There's some good
    discussion of the assumed tropes of fantasy (eg, that the world is
    almost always post-apocalyptic); on how you can use things like
    geography and history to make a more believable world; on how to
    build societies, cultures, city-states, and more; and on religion,
    magic, and technology.  I think the essays on mystery cults and
    secret societies, in particular, will pay dividends in my Call of
    Cthulhu games.

[Tales of the Dying Earth]: https://en.wikipedia.org/wiki/Dying_Earth
[Sly Flourish's Return of the Lazy Dungeon Master]: https://slyflourish.com/returnofthelazydm/index.html
[The Kobold Guide to Worldbuilding]: https://koboldpress.com/kpstore/product/kobold-guide-to-worldbuilding/


## Miscellaneous

Turns out it's pretty easy to [make flapjacks][].  I should use this
new knowledge carefully.

[make flapjacks]: https://www.bbcgoodfood.com/recipes/yummy-golden-syrup-flapjacks


## Link Roundup

- [Issue 218 :: Haskell Weekly](https://haskellweekly.news/issue/218.html)
- [This Week in Rust 345](https://this-week-in-rust.org/blog/2020/06/30/this-week-in-rust-345/)
- [#06 - NixOS Weekly](https://weekly.nixos.org/2020/06-nixos-weekly-2020-06.html)
- [Splittable pseudo-random number generators in Haskell: random v1.1 and v1.2](https://www.tweag.io/blog/2020-06-29-prng-test/)
- [Neural Networks seem to follow a puzzlingly simple strategy to classify images](https://medium.com/bethgelab/neural-networks-seem-to-follow-a-puzzlingly-simple-strategy-to-classify-images-f4229317261f)
- [The Only Dungeon Map You'll Ever Need](https://slyflourish.com/your_only_dungeon_map.html)
