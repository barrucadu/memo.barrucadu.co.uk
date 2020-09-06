---
title: "Weeknotes: 103"
taxon: weeknotes-2020
date: 2020-09-06
---

## Work

This week I came back to a team with broad consensus on what we want
to do for a live experiment, and a very basic tech prototype, which
was a nice change.

We still need to do some work to bring together the design prototypes
used in user research with the tech prototypes---which so far have
been developing completely independently---but I'm now less worried
that we're careening towards the self-selected "live experiment launch
date" without any hope of achieving it.


## Books

This week I read:

- [The Art of Miyazaki's Spirited Away][], from the Studio Ghibli Library.

  This was mostly lots of art, with commentary from some of the staff
  involved; but there was also a section about the use of CG in
  Spirited Away which I found interesting.

  For example, they say that 24-bit colour makes a fade from dark to
  light have more noticeable jumps in colour than you can get from cel
  animation, and even if you use 48-bit colour, the hardware to output
  it isn't widely available.  I'm not convinced about that, but I'm
  neither a professional animator, nor someone who has a 48-bit
  display available to test things on...

  They also developed some software to introduce visual noise, because
  in practice when you paint something you don't get a region of
  perfectly consistent colour, there's always variations; but computer
  colour is perfectly consistent, and so can look wrong when combined
  with non-CG art.

- [Veins of the Earth][], by Patrick Stuart and Scrap Princess.

  This is a sourcebook for [Lamentations of the Flame Princess][]
  about the [Underdark][], a vast underground network of cave systems
  supporting all sorts of weird life.  The book really plays into
  darkness, with the "lux" (fuel for one hour of light) being the
  primary currency in the Underdark, and all the monsters having
  descriptions of what they sound and smell like.  There's rules for
  player characters navigating caves and dealing with starvation and
  madness, and for game masters on how to generate 3D hexmaps of the
  terrain.

  While the mechanics and monster stats would need to be tweaked to
  work in a non-OSR system, there's a lot of good ideas in there which
  should apply to any fantasy setting with an underground component
  more or less unmodified.  I don't have a game like that planned any
  time soon, but when I am next running a fantasy campaign I'll
  definitely be taking some ideas.

- [The Rule of Benedict][], by Benedict of Nursia.

  This is an interesting insight into what Catholic beliefs and
  practices were like back in the 500s.  It's pretty different to
  general Christian attitudes which I've come across these days.

  For example, the Christian Union at my university (who gave me lots
  of free food in their futile attempts at conversion) were very much
  of the attitude that deeds are not enough to get into Heaven, and
  more than that, they're *so* ineffectual that so long as you accept
  Jesus in your heart, you will be forgiven of all your sins.

  This is not the opinion of Benedict.  According to him, you not only
  have to accept Jesus, you also have to be humble, silent, obedient
  to the abbot, and in general a very virtuous person.  Otherwise you
  would go to Hell for your sins.  He frequently argues against
  talking, of all things, because talking leads to sin.  Even to the
  point of forbidding monks from asking questions during the evening
  meal if they don't understand the bible reading, because that might
  encourage talking!

  The book is an interesting mixture of general commentary on sin and
  virtue, and highly practical rules like which psalms to sing on a
  Sunday evening in the winter, or how to dress if you need to leave
  the monastery for a long journey.

[The Art of Miyazaki's Spirited Away]: https://www.goodreads.com/book/show/429853.The_Art_of_Spirited_Away
[Veins of the Earth]: https://www.drivethrurpg.com/product/209509/Veins-of-the-Earth
[Lamentations of the Flame Princess]: https://tvtropes.org/pmwiki/pmwiki.php/TabletopGame/LamentationsOfTheFlamePrincess
[Underdark]: https://forgottenrealms.fandom.com/wiki/Underdark
[The Rule of Benedict]: https://en.wikipedia.org/wiki/Rule_of_Saint_Benedict


## Games

This week I ran a one-shot of [Traveller][], we had a session for
character creation on Wednesday, and then played through a scenario I
prepared in our usual game slot on Sunday.  It went pretty well, I
managed to cover a nice variety of the game's subsystems, though the
space combat I'd prepared ended up being avoided when the players
escaped really effectively.

I tried out the fancy dynamic lighting on [Roll20][], but had to
abandon it about 15 minutes into the session because it kept crashing
one player's browser; so I had to switch back to drawing regions of
light and dark around the player character's tokens as they moved
around a derelict spaceship with no lights.  Not great, but it was
functional at least.  The Roll20 character sheet for Mongoose
Traveller is a bit confusing too, and doesn't work as well as we'd
have liked.

Roll20 is a bit of a disappointment, I keep toying with the idea of
trying out one of the fancier-looking virtual tabletops, like
[Foundry][], but they're all more expensive...

[Traveller]: https://www.mongoosepublishing.com/
[Roll20]: https://roll20.net/welcome
[Foundry]: https://foundryvtt.com/


## Miscellaneous

Not much to report this week.  I've been working on my [bookmarks
tool][] a bit; I think I've hit the difficult part of a search engine:
scraping web pages well.  Extracting all the text from the page is
easy enough, but it's nice to be able to do things like strip out
navigation or "related posts" sidebars so the search is over the
actual meat of the page.  Fortunately the scope of this tool is small
enough that I can just implement lots of special cases.

I also slightly tweaked the templates and CSS for this site
([`438bb24`][], [`c649e6f`][], [`82986bf`][]) so the index page gets a
score of 100, up from 98, on Google's [PageSpeed Insights][] tool.

[bookmarks tool]: https://github.com/barrucadu/bookmarks
[`438bb24`]: https://github.com/barrucadu/memo.barrucadu.co.uk/commit/438bb246bdbec29bbf2bfdd7af6369e2b8fb79d6
[`c649e6f`]: https://github.com/barrucadu/memo.barrucadu.co.uk/commit/c649e6f8adc23103157f56337c1b0b9293b91c6d
[`82986bf`]: https://github.com/barrucadu/memo.barrucadu.co.uk/commit/82986bfde27fa268763a156c5342def753088f14
[PageSpeed Insights]: https://developers.google.com/speed/pagespeed/insights/

## Link Roundup

- [Massacring C Pointers](https://wozniak.ca/blog/2018/06/25/1/index.html)
- [mintotp](https://github.com/susam/mintotp)
- [Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html)
- [The Local Variable Aversion Antipattern](http://www.soulcutter.com/articles/local-variable-aversion-antipattern.html)
- [What is the purpose of issuing laws/regulations without penalty?](https://politics.stackexchange.com/questions/26724/what-is-the-purpose-of-issuing-laws-regulations-without-penalty)
