---
title: "Weeknotes: 022"
taxon: weeknotes-2019
date: 2019-02-18
---

## Open Source

- I released [dejafu-2.0.0.0][] ([announcement here][]).  There are a
  couple of open issues for small bugs and potential performance
  issues, I might look into those next.

[dejafu-2.0.0.0]: http://hackage.haskell.org/package/dejafu-2.0.0.0
[announcement here]: https://mail.haskell.org/pipermail/haskell-cafe/2019-February/130694.html

## Work

- We decided to use an AWS managed elasticsearch cluster, because even
  if it doesn't gain us much (or anything) the long-term strategy is
  to avoid managing things we can have managed for us.  This does mean
  it will be easier to move to elasticsearch 6, as we won't need to
  upgrade from our ancient version of puppet.

- I was on leave on Thursday and Friday.

## Miscellaneous

- I've had friends staying over for the last few days, so there's been
  a lot of boardgaming.  Having now played another couple of chapters
  of the [Betrayal Legacy][] campaign, I think it's really good.  The
  gradual introduction of locations and game mechanics, tied into a
  story which is driven by the players to some extent, works pretty
  well.

  We also played some [Tragedy Looper][], where the players have to
  repeat the same few days over and over again until they can avert
  the tragedy (after first figuring out what's going on).  It's pretty
  much [Higurashi no Naku Koro ni][] the boardgame---the characters on
  the game box even look like younger versions of [Umineko no Naku
  Koro ni][] characters---but it's a formula which works well.

- I watched all of the episodes (so far) of [That Time I Got
  Reincarnated as a Slime][].  It's yet another [isekai][] (this seems
  to be the age of isekai anime), but it's done really well, and the
  20-minute episodes feel far shorter than they are.  I'm looking
  forward to seeing how the series continues.

[Betrayal Legacy]: https://boardgamegeek.com/boardgame/240196/betrayal-legacy
[Tragedy Looper]: https://boardgamegeek.com/boardgame/148319/tragedy-looper
[Higurashi no Naku Koro ni]: https://en.wikipedia.org/wiki/Higurashi_When_They_Cry
[Umineko no Naku Koro ni]: https://en.wikipedia.org/wiki/Umineko_When_They_Cry
[That Time I Got Reincarnated as a Slime]: https://en.wikipedia.org/wiki/That_Time_I_Got_Reincarnated_as_a_Slime
[isekai]: https://en.wikipedia.org/wiki/Isekai

## Link Roundup

- [What’s up with SET TRANSACTION SNAPSHOT?](https://thebuild.com/blog/2019/02/11/whats-up-with-set-transaction-snapshot/)
- [This Week in Rust 273](https://this-week-in-rust.org/blog/2019/02/12/this-week-in-rust-273/)
- [Freer Monads, More Better Programs](http://reasonablypolymorphic.com/blog/freer-monads/index.html)
- [Spacecraft Travel From All Over Galaxy To Honor End Of Opportunity Rover’s Life](https://www.theonion.com/spacecraft-travel-from-all-over-galaxy-to-honor-end-of-1832602862)
- [Issue 146 :: Haskell Weekly](https://haskellweekly.news/issues/146.html)
