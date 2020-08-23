---
title: "Weeknotes: 101"
taxon: weeknotes-2020
date: 2020-08-23 22:00:00
---

## Work

Sadly, things did not really get moving.  We had a sort of crisis of
confidence in a live experiment, with the user-centred design people
against it, and so the consensus-based approach GOV.UK teams tend to
adopt broke down.  We had a team meeting on Thursday to get to the
bottom of the problem, but that ended with a decision to do some more
comparison of our two experiment ideas and make the decision next
week.  At least I'm off next week, so I don't need to sit through more
meetings discussing what experiment we want to do.

It's getting difficult to come up with dev tasks to do without knowing
what we actually want to launch.


## Books

This week I read:

- [How to Use Your Enemies][] by Baltasar Gracián.

  A collection of maxims, one of which I felt was telling me off for
  reading the whole thing in a single evening ("moderation is
  necessary even in our desire for knowledge so as not to know things
  badly").

  I particularly liked "without courage, wisdom is sterile."

- [Travels in the Land of Serpents and Pearls][] by Marco Polo.

  This was a pretty easy read, and funny in parts; though maybe not in
  the way the author intended.  Marco Polo tells the story of the
  Buddha, but incredibly briefly: he just says that there's this
  pampered prince, who one day learns about old age and death, and
  leaves his palace to go travelling; then one day he dies and his
  followers tell the story of how he reincarnated many times.  That's
  it!  No mention of founding a religion, just that he learned about
  old age, went travelling, and one day died.

  An annoying part of this book is that scarcely a paragraph goes by
  without a phrase like "you should also know," "let me tell you," "I
  assure you," "I can tell you," "I will tell you" etc etc.  It's also
  a bit repetitive in parts: almost identical stories of superstitions
  about shadows and tarantulas are told twice; the same story about
  the mother of a bunch of kings keeping them from fighting by
  threatening to cut off her breasts is told twice; and the same story
  of the brahmins avoiding eating green leaves is told twice on
  adjacent pages!  For shame, Mr. Polo.

- [The Atheist's Mass][] by Honoré de Balzac.

  This Penguin Little Black Classic has both The Atheist's Mass and
  also a second short story by Balzac.  I enjoyed the first one more,
  which is about a famed doctor---Desplein---and a staunch atheist,
  who is spied attending mass several times.  His protégé eventually
  confronts him, and we get the story of Desplein's life and the man
  who helped him when he was down on his luck.

- [Sindbad the Sailor][].

  This seemed to me a better execution of the same idea as the Marco
  Polo book.  In fact, they even have a story in common!  They both
  tell of a deep valley inhabited by giant serpents; where the ground
  is made of loose diamonds; where people fetch the diamonds by
  throwing down hunks of meat (which the diamonds get stuck into), and
  then scaring away eagles who swoop down, grab, and bring back up the
  meat.

  Throughout, Sindbad is a good man, who praises God and accepts that
  everything is done by His will... but then keeps ending up in
  terrible shipwrecks.  Even though he escapes, all of his companions
  die horrible deaths.  If I were him, that would give me reason to
  doubt.

- [The Richest Man in Babylon][] by George S. Clason.

  This is a classic of personal finance advice, and it does have a lot
  of good tips... but it was nothing I hadn't already heard from more
  modern sources.  The advice boils down to "pay yourself first,"
  "live within your means," "invest in what you know," and "don't rent
  your home."

[How to Use Your Enemies]: https://www.goodreads.com/book/show/24874346-how-to-use-your-enemies
[Travels in the Land of Serpents and Pearls]: https://www.goodreads.com/book/show/24874350-travels-in-the-land-of-serpents-and-pearls
[The Atheist's Mass]: https://www.goodreads.com/book/show/24874308-the-atheist-s-mass
[Sindbad the Sailor]: https://www.goodreads.com/book/show/24874320-sindbad-the-sailor
[The Richest Man in Babylon]: https://en.wikipedia.org/wiki/The_Richest_Man_in_Babylon


## Games

My Pulp Cthulhu game reached the end of the Masks of Nyarlathotep
prologue chapter, with Nyarlathotep himself stepping in to settle
matters.  It went well, I think I had some really good descriptions
for some things.

We'll be doing a [Traveller][] one-shot next, which I expect will take
two sessions (though I haven't decided on a scenario yet), and we'll
decide on where the game is going after that.

[Traveller]: https://www.mongoosepublishing.com/


## Miscellaneous

I opened a [Premium Bonds][] account to store my emergency fund, as I
decided there wasn't much point in it sitting in my bank account
earning no interest.[^interest] Premium Bonds are a good choice for an
emergency fund; you don't want the fund to be at risk of shrinking, so
investing it is too risky.  Hopefully I'll win a little money from it
over the years.[^jackpot]

[^interest]: My account only pays interest on the first £1,500, and my
  regular balance is above that before counting my emergency fund.

[^jackpot]: The £1,000,000 jackpot would be nice.

I realised that the script which backs up my syncthing files and my
git repositories hadn't ran successfully since February, as that's
when I migrated from [gitolite][] to [gitea][] and I hadn't updated
the URLs in the script, whoops.  I've had an entry on my to-do list to
set up alerting on backup failure for a long time, but never got
around to it... so I decided to actually set it up this weekend.

I've already got uptime monitoring for my servers which sends alerts
through [AWS SNS][], so all I had to do was copy [that bit out of my
monitoring scripts][] and call it in my backup scripts.  Took 10
minutes to do that and then pull the updated scripts on all my
computers, I should have done this when I first had the idea...  I
also updated my memos on [backups][] and [monitoring][] while I was at
it.

[Premium Bonds]: https://www.nsandi.com/premium-bonds
[gitolite]: https://gitolite.com/gitolite/
[gitea]: https://gitea.io/en-us/
[AWS SNS]: https://aws.amazon.com/sns/
[that bit out of my monitoring scripts]: https://github.com/barrucadu/dotfiles/commit/cd3bc569062c0cbfc5151f4373b772bad7cb0b8e
[backups]: backups.html
[monitoring]: monitoring.html

## Link Roundup

- [Fundamental Elements of Simulationist-Immersive Roleplaying](https://www.rpg.net/columns/talesfromtherockethouse/talesfromtherockethouse51.phtml)
- [Designing Layouts in RPGs](https://www.theexplorersco.com/home/2019/7/20/exploring-layout)
- [This Week in Rust 352](https://this-week-in-rust.org/blog/2020/08/18/this-week-in-rust-352/)
- [Issue 225 :: Haskell Weekly](https://haskellweekly.news/issue/225.html)
