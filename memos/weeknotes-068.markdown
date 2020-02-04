---
title: "Weeknotes: 068"
taxon: weeknotes-2020
date: 2020-01-05
---

## Work

I spent most of the week (I was off on Tuesday afternoon and
Wednesday) continuing to work on getting our [learning-to-rank][]
training and deployment pipeline set up in [Concourse][] and [Amazon
SageMaker][], finally getting to the point where I have something
which we can deploy and test.  There's been a lot to learn, and it
doesn't help that none of the AWS APIs document the permissions you
need, so there has been a lot of guesswork.

I implemented a small UI change to [disable the "most viewed" option
when someone enters a search query][].  Yes, it's not all machine
learning and faffing around with clouds, there's a never-ending list
of small improvements we can make.

Finally, I opened an RFC about [putting attachment data into content
items][], to enable more neat programmatic use of our content, both
internally and externally.

[learning-to-rank]: https://en.wikipedia.org/wiki/Learning_to_rank
[Concourse]: https://concourse-ci.org/
[Amazon SageMaker]: https://aws.amazon.com/sagemaker/
[disable the "most viewed" option when someone enters a search query]: https://github.com/alphagov/finder-frontend/pull/1835
[putting attachment data into content items]: https://github.com/alphagov/govuk-rfcs/pull/116

## Miscellaneous

I went to see the [new Star Wars film][], which was honestly a bit
disappointing.  It was entertaining enough, but there was a lot which
wasn't explained.  The first sentence of the opening text was
something like "Palpatine is back."  Did we learn *how* he came back?
No, he's just back.  But at least we saw the Knights of Ren, who we'd
not seen before despite Kylo Ren being introduced to us in [The Force
Awakens][] as "commander of the Knights of Ren".

I got a couple of new games in the recent Steam sale:

- [Baba Is You][]: a puzzle game about manipulating the rules of the
  game, which are represented as blocks you can push around and
  change.

- [Call of Cthulhu][]: a Lovecraftian detective horror game with
  possibly a time-travel element (at least, judging from the vision my
  character had when he woke up at the start).  I'm getting a [Shadow
  over Innsmouth][] vibe from it so far, but that's probably just
  because it seems to have some sort of ocean cult.  There's no
  evidence (yet) that there are fish-people too.

- [The Sims 3][] plus a few bits of DLC: it's fun, I can live out wild
  fantasies like "be a shut in but also rich".  Looking after pets is
  super hard though, and I've lost three to social services for
  neglect so far.  Looking after babies is *much* easier, somehow.
  Unfortunately the game seems to have a resource leak of some kind,
  as after about 15 minutes it slows down quite a lot if I try to run
  it on higher speeds (regular speed is fine, but everything takes
  ages...), and the only fix I've found so far is to restart it.  It
  wasn't always this way, so it's probably a problem with my save, but
  I'm not sure how to solve it.

I read a bunch of books this week, including finishing off the Wheel
of Time series.  I read:

- [Towers of Midnight][] and [A Memory of Light][] (by Robert Jordan
  and Brandon Sanderson), the final two books of the Wheel of Time.
  The ending was pretty good, nice and dramatic, with lots of plot
  theads being tied up.  There were some parts which were a bit iffy
  though (hover to reveal text):

  <div class="spoiler">

  - Graendal put the four great captains leading the Last Battle under
    Compulsion from Tel'aran'rhiod, making them subtly lose their
    fights.  But if she can do that, why didn't she just compel
    someone close to Rand (like Min or Rhuarc) to kill, harm, or
    mislead him?  Rand shields his dreams, but does he also shield the
    dreams of everyone around him?

  - In his fight with Rand, Moridin's trump card was killing Alanna.
    Her bond to Rand would drive him into extreme rage at her death,
    making him unable to act as carefully as he needed to.  But did
    Moridin really think Alanna would choose *the end of the world*
    over just releasing her bond?  It only makes sense if Alanna was a
    darkfriend who suddenly had a change of heart, but there's no
    other evidence for that theory.  Verin worked closely with Alanna,
    but nothing about Alanna was mentioned when Verin turned over her
    list of Black Ajah sisters, so if Alanna was a darkfriend Verin
    explicitly protected her (but why protect her and betray the
    rest?) or didn't know.

  - When Rand created a vision of a world without the Dark One,
    everyone had the same look as someone forcibly turned to the dark:
    they had been forcibly turned to the light and lost some of their
    humanity.  But unless the Dark One arises from the dark thoughts
    of man (which the mythology doesn't support), there's no reason
    men can't be evil in a world with no Dark One.  There just
    wouldn't be a god of evil actively trying to corrupt people and
    destroy the world.  Was that vision actually created by the Dark
    One to make Rand despair?

  </div>

- [In the Court of the Yellow King][] (edited by Glynn Barrass), a
  collection of short stories in the King in Yellow mythos.  They were
  all pretty different (covering vikings, Elvis, operas, drugs, and
  more) but all fit into the mythos.  I don't know what it is exactly,
  but there's just something I enjoy about the setting: a dark god on
  a distant world reaching out to Earth by spreading books, plays, and
  music which, when you read, watch, or listen to them, turn you
  insane and open you to his influence.  The King is very much a god
  of the empty spaces beyond man: but rather than a more traditional
  domain like the wilderness or the ocean, his domain is creative
  imagination.

I've started on [The Rise and Fall of the Third Reich][], which I
don't think I'll get through quite as quickly as I did the fiction.

[new Star Wars film]: https://en.wikipedia.org/wiki/Star_Wars:_The_Rise_of_Skywalker
[The Force Awakens]: https://en.wikipedia.org/wiki/Star_Wars:_The_Force_Awakens
[Baba Is You]: https://store.steampowered.com/app/736260/Baba_Is_You/
[Call of Cthulhu]: https://store.steampowered.com/app/399810/Call_of_Cthulhu/
[Shadow over Innsmouth]: http://www.hplovecraft.com/writings/texts/fiction/soi.aspx
[The Sims 3]: https://store.steampowered.com/app/47890/The_Sims_3/
[Towers of Midnight]: https://en.wikipedia.org/wiki/Towers_of_Midnight
[A Memory of Light]: https://en.wikipedia.org/wiki/A_Memory_of_Light
[In the Court of the Yellow King]: https://www.goodreads.com/book/show/23441192-in-the-court-of-the-yellow-king
[The Rise and Fall of the Third Reich]: https://en.wikipedia.org/wiki/The_Rise_and_Fall_of_the_Third_Reich

## Link Roundup

- [Defunctionalization: Everybody Does It, Nobody Talks About It](https://blog.sigplan.org/2019/12/30/defunctionalization-everybody-does-it-nobody-talks-about-it/)
- [confusing coleopterists / 🤔🐞: breeding bugs in the latent space](https://www.cunicode.com/works/confusing-coleopterists/)
- [This Week in Rust 319](https://this-week-in-rust.org/blog/2019/12/31/this-week-in-rust-319/)
- [Issue 192 :: Haskell Weekly](https://haskellweekly.news/issue/192.html)
