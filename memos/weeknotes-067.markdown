---
title: "Weeknote Special: 2019"
tags: weeknotes
date: 2019-12-29
audience: General
---

Since it's the last Sunday of the year, I thought it would be nice to
deviate from the usual weeknote template and do a wider review.


## Finance

I've made some changes to my financial habits and tracking this year,
and have at least one more planned for next year:

- I switched from Santander to Nationwide, and was very impressed by
  how smooth the current account switch service was.

- I managed to move almost all of my spending over to my American
  Express credit card which is good because I get a small percentage
  of every transaction as cashback.  A rewards credit card, with
  automatic full payment of the balance every month, is a good tool.

- I changed how I handle changes to my budget.  It used to be that, if
  I wanted to spend more than I had (eg, I wanted to buy some books
  but didn't have enough in my discretionary budget), I'd move some
  money over from a different category straight away.  So I'd end up
  with a pair of transactions like this in my journal file:

  ```
  2019-04-02 ! Allocation
      assets:cash:nationwide:flexdirect:saved:discretionary    £5.00
      assets:cash:nationwide:flexdirect:saved:food            -£5.00
  2019-04-04 * Waterstones
      expenses:books                                          £34.99
      assets:cash:nationwide:flexdirect:saved:discretionary  -£34.99
  ```

  Which works, but makes it a bit awkward to see *all* the
  reallocations you make in a month, as they're spread out in many
  small transactions.  I used to overestimate and move a bigger chunk
  of money than was actually needed, which had the effect that
  sometimes I'd then have a transaction going the other way in a few
  days time, moving some money back into the account I took it from.

  So I decided to change things and have at most one reallocation
  transaction a month, on the 1st, and I'd just add new things to that
  transaction as I need to.  I also decided to only make the minimum
  reallocation necessary, rather than overestimating.  This is good
  for two reasons:

  - All my budget changes are in the same place, so I can see how
    wrong I got it at a glance.
  - I get paid on the last working day of the month and allocate my
    income then, so with a reallocation transaction on the 1st I can
    usually fit both on screen at the same time and clearly see how I
    need to change the income allocation in the future.

  Ideally one day I won't need any reallocation transactions at all,
  because my income allocation will be good enough, and there'll be
  enough of a buffer in each category to handle unusual expenses.

This year I wanted to cut down on transactions fixing a discrepancy
between how much money I *actually* have and how much money my ledger
*says* I have.  Such discrepancies arise if I make a mistake when
recording transactions: entering a transaction twice, getting the
amount wrong, missing a transaction; that sort of thing.  This year I
made 6 adjustments:

- One for my student loan balance: I've somehow paid off rather more
  than I thought I had.  Though, the SLC haven't sent me an "annual
  statement" since 2017 (and that's the date of the latest issued one
  on their website), so the fact that I've got the balance very wrong
  isn't too incredible.

- Four for my wallet: it's easy to lose track of cash, and I've lost
  track of £15.00 this year.

- One for my bank balance: despite best efforts checking transactions
  in my ledger against transactions in my statements (I go through new
  transactions once a week), my bank account ended up with £81.38 more
  than I expected.  That probably means I've entered some transactions
  twice.

There's a bit of an issue with my weekly statement checking, in that
it's good for catching missing or incorrect transactions, but not so
good for duplicate ones.  I can fix that but it would just be a bit
more work.  A bigger problem is that I keep my ledger using a slightly
weird home-grown system: I log expenses as soon as they're incurred
(which may be before they're billed), but income only when it's
received.  This means the money in my ledger doesn't necessarily match
the money in my bank statement unless I wait a few days for any
pending transactions to clear.  It's a good system for personal
accounting, because it means I'm always pessimistic about how much
money I have, but it's not what the bank does, so it makes checking
awkward as week- or month-end balances in my ledger may be pretty
different from my bank statement.

I've decided to make one change going forward into 2020: I'm changing
how I track cash withdrawals.  Once upon a time, I had a category in
my budget for "cash to withdraw", which I would take money from when I
withdrew it, and which I'd replenish with money from a more specific
category as I actually spent it.  So I might withdraw £50 from "money
to withdraw" and then spend £25 on food and £25 on books, so I'd move
£25 each from my food and discretionary categories back into the
"money to withdraw" category.  I stopped doing that because I kept
losing track of cash (which I still do), and decided to allocate money
when I withdrew it: so I wouldn't withdraw £50 and spend it on food
and books, I'd withdraw £25 for food and £25 for books.  The idea was
that all money in my wallet should have a purpose, making me less
likely to lose track of it.  Well, that turned out to be much more
work, and since I barely use cash these days, I'll go back to the old
system and risk forgetting the occasional thing.


## Home

I was living in central London, now I'm not.

I've been in my new flat in Rickmansworth for a month now.  It's
pretty nice, the commute isn't so bad (though getting a seat in the
mornings is tricky).  I'm keeping an eye on the increased cost of
travel, though so far it looks like it'll be cheaper to *not* buy an
annual season ticket, by several hundred pounds.  I'm going to work
out how much I'm spending a month on average in March, and maybe buy a
ticket then if I'm going into London enough, for non-work purposes, to
make it worth it.

I did have fibre, now I have worse fibre.

At my old flat I had symmetric gigabit fibre from Hyperoptic.  It was
great, waiting for downloads was almost a thing of the past.  Now I
have 350Mb/s down and a tenth of that up, for more money (thanks,
Virgin Media)... but it's the best I can get in the new flat and it's
still pretty good.  Another downgrade is that Hyperoptic provided
IPv6, Virgin Media don't.


## Open source

It's been a very slow year.

I released a new super-major version of [dejafu][], which did a lot of
refactoring to make it possible to implement some cool features:

- The ability to run tests using the `ST` monad once more.
- Setup and teardown actions, with the post-setup state shared amongst
  test runs.
- Invariants over mutable state, which are checked everywhere where
  they could potentially be violated (and in no more places).

Those may not sound cool, but they are.  Trust me.

[dejafu]: https://hackage.haskell.org/package/dejafu


## Reading

This year I've read 38 books, which is pretty good but could be
better.  I picked up the pace towards the end of the year and was
around 1 book a week for a while.

I also discovered that the [bookdb][] sqlite file was corrupt, and in
fixing it lost all the changes since mid July, so I had to guess and
re-enter a bunch of last-read dates based on weeknote entries.  That
was a pain.

Here's a list of all the books I read, grouped by author:

- BAXTER, Stephen
  - [Raft]([The Fires of Heaven]: https://en.wikipedia.org/wiki/The_Fires_of_Heaven)
- CHAMBERS, Robert W.
  - [The King in Yellow](https://en.wikipedia.org/wiki/The_King_in_Yellow)
- DEMARKO, Tom & LISTER, Timothy
  - [Peopleware: Productive Projects and Teams](https://en.wikipedia.org/wiki/Peopleware:_Productive_Projects_and_Teams)
- FEIST, Raymond E.
  - [Magician](https://en.wikipedia.org/wiki/Magician_%28Feist_novel%29)
- GLUKHOVSKY, Dmitry
  - [Metro 2033](https://en.wikipedia.org/wiki/Metro_2033)
- LE GUIN, Ursula K.
  - [The Lathe of Heaven](https://en.wikipedia.org/wiki/The_Lathe_of_Heaven)
- HENDRIX, Grady
  - [We Sold Our Souls](https://en.wikipedia.org/wiki/We_Sold_Our_Souls)
- ITO, Junji
  - [Frankenstein](https://junjiitomanga.com/frankenstein/)
  - [Gyo](https://en.wikipedia.org/wiki/Gyo)
  - [Tomie](https://en.wikipedia.org/wiki/Tomie)
- JACKSON, Shirley
  - [We Have Always Lived in the Castle](https://en.wikipedia.org/wiki/We_Have_Always_Lived_in_the_Castle)
- JORDAN, Robert
  - [New Spring](https://en.wikipedia.org/wiki/New_Spring)
  - [The Eye of the World](https://en.wikipedia.org/wiki/The_Eye_of_the_World)
  - [The Great Hunt](https://en.wikipedia.org/wiki/The_Great_Hunt)
  - [The Dragon Reborn](https://en.wikipedia.org/wiki/The_Dragon_Reborn)
  - [The Fires of Heaven](https://en.wikipedia.org/wiki/The_Fires_of_Heaven)
  - [Lord of Chaos](https://en.wikipedia.org/wiki/Lord_of_Chaos)
  - [A Crown of Swords](https://en.wikipedia.org/wiki/A_Crown_of_Swords)
  - [The Path of Daggers](https://en.wikipedia.org/wiki/The_Path_of_Daggers)
  - [Winter's Heart](https://en.wikipedia.org/wiki/Winter%27s_Heart)
  - [Crossroads of Twilight](https://en.wikipedia.org/wiki/Crossroads_of_Twilight)
  - [Knife of Dreams](https://en.wikipedia.org/wiki/Knife_of_Dreams)
  - [The Gathering Storm](https://en.wikipedia.org/wiki/The_Gathering_Storm_(novel))
- KOSTOVA, Elizabeth
  - [The Historian](https://en.wikipedia.org/wiki/The_Historian)
- MACHEN, Arthur
  - [The Hill of Dreams](https://en.wikipedia.org/wiki/The_Hill_of_Dreams)
- MARUYAMA, Kugane
  - [Overlord (vol. 2) The Dark Warrior](https://en.wikipedia.org/wiki/Overlord_(novel_series))
  - [Overlord (vol. 3) The Bloody Valkyrie](https://en.wikipedia.org/wiki/Overlord_(novel_series))
- MATHESON, Richard
  - [I Am Legend](https://en.wikipedia.org/wiki/I_Am_Legend_(novel))
- MOORCOCK, Michael
  - [Behold the Man](https://en.wikipedia.org/wiki/Behold_the_Man_(novel))
- SLIVERBERG, Robert
  - [Downward to the Earth](https://en.wikipedia.org/wiki/Downward_to_the_Earth)
- STRUGATSKY, Arkady & Boris
  - [Roadside Picnic](https://en.wikipedia.org/wiki/Roadside_Picnic)
- VANDERMEER, Jeff
  - [The Southern Reach Trilogy: Area X](https://en.wikipedia.org/wiki/Southern_Reach_Trilogy)
- YAZAWA, Ai
  - [Nana (vol. 8)](https://en.wikipedia.org/wiki/Nana_(manga))
  - [Nana (vol. 9)](https://en.wikipedia.org/wiki/Nana_(manga))
  - [Nana (vol. 10)](https://en.wikipedia.org/wiki/Nana_(manga))
  - [Nana (vol. 11)](https://en.wikipedia.org/wiki/Nana_(manga))
  - [Nana (vol. 12)](https://en.wikipedia.org/wiki/Nana_(manga))

I'm currently making my way through two more books: [In the Court of
the Yellow King][], a collection of short stories in the King in
Yellow mythos; and [Towers of Midnight][], the thirteenth (of
fourteen) Wheel of Time book.

[bookdb]: https://bookdb.barrucadu.co.uk/
[In the Court of the Yellow King]: https://www.goodreads.com/book/show/23441192-in-the-court-of-the-yellow-king
[Towers of Midnight]: https://en.wikipedia.org/wiki/Towers_of_Midnight


## Tech

I tend to try out new tech stuff pretty regularly, and this year has
been no exception.  One of the things I did was an incomplete
migration away from Google: I still use Calendar and Photos, but I've
got replacements for Chrome and Mail.  Here are all the things I've
stuck with:

- **Backups:** [duplicity][] and some shell scripts.  Automatic,
  encrypted, and weekly.  I store my backups in [AWS Glacier][], their
  cheap (ish) long-term storage.

- **Continuous deployment:** [Concourse][], which is deploying
  barrucadu.co.uk, memo.barrucadu.co.uk, uzbl.org, and the latest PDF
  of [my incomplete King James Bible][].

- **Email:** [ProtonMail][], because I wanted to move away from Google
  but *really* didn't want to host my own mailserver.  I was concerned
  about spam, because I've heard Google's spam filters are
  particularly good, but I barely get any through to my inbox.  Or to
  my spam folder either, for that matter.  My email address is hardly
  unavailable, it's scattered all across the internet and has been for
  over a decade, is email spam mostly a thing of the past now?

- **Password manager:** [KeePassXC][], which I switched to from
  [LastPass][].  I switched because I decided it was hypocritical of
  me to not trust my unencrypted backups to the cloud, but to trust it
  with something even more sensitive: my passwords!  Yes, yes,
  LastPass does their crypto locally, their servers don't see my
  plaintext passwords... until there's a breach which pushes out an
  update with some malicious code.  The threat models for "someone
  gets my unencrypted cloud backups" and "someone compromises the
  client of my cloud password manager" are the same: someone with a
  great deal of internal access doing a bad thing.

- **Text editor:** it's still [Emacs][].  I tried out [Spacemacs][],
  because everyone seems to love its configuration system and my Emacs
  config was getting pretty unwieldy.  Unexpectedly, I hated the
  Spacemacs configuration system, but I quite liked the [Evil][]
  integration, so I rewrote my Emacs configuration from scratch to be
  less awkward and to use Evil.

- **VPS provider:** [Hetzner][], which I switched to from [Linode][]
  because they're cheaper but still have a good reputation.

- **Web browser:** [Firefox][], which I moved to as part of my
  migration away from Google.

[Evil]: https://github.com/emacs-evil/evil
[Spacemacs]: https://www.spacemacs.org/
[Emacs]: https://www.gnu.org/software/emacs/
[ProtonMail]: https://protonmail.com/
[Hetzner]: https://www.hetzner.com/
[Linode]: https://www.linode.com/
[KeePassXC]: https://keepassxc.org/
[LastPass]: https://www.lastpass.com/
[Concourse]: https://concourse-ci.org/
[my incomplete King James Bible]: https://github.com/barrucadu/bible/
[duplicity]: http://duplicity.nongnu.org/
[AWS Glacier]: https://aws.amazon.com/glacier/
[Firefox]: https://www.mozilla.org/en-US/firefox/


## Work

A few big things happened at work this year, the main is that I got
promoted to a senior developer in June.  The second is that the
[Elasticsearch][] upgrade project, which started in late 2018 with me
and one other developer migrating from version 2 to 5, finally got us
all the way to ES 6, without search results getting worse.  That
latter part was the hard bit, the actual ES upgrades were tedious but
not too confusing.  Search result quality tanked though, so we had to
put a lot of work into getting that part right.

[Elasticsearch]: https://www.elastic.co/


## Miscellaneous

Earlier this year (though it feels much longer ago), I finished and
submitted my Ph.D corrections, and passed.  I've since been
disappointed by how many services I find which don't let you enter
"Dr" as your honorific.

I got into fermentation, and I've now tried my hand at: [kombucha][]
(but I couldn't make anything tasty), [water kefir][] (which did
work), vinegar (but couldn't get the wine to ferment), and
lactofermentation.  With lactofermentation I've made fermented carrot
sticks, hot sauce (peppers, garlic, and onions: fermented together and
then blended), and sauerkraut.  I want to try sourdough at some point
too.

My [Call of Cthulhu][] game, in which I'm running the [Masks of
Nyarlathotep][] campaign, is still going on.  The first session was in
September 2018!  The players have travelled (in game) from Peru, to
New York, to England, to China, to Egypt, and now to Kenya.  I've told
them that this chapter could be the conclusion of the campaign but, if
they make it through alive, there's still one more place for them to
go.

I got an [Oculus Quest][], a standalone battery-powered VR headset.
It's really cool, I play a lot of [Beat Saber][].  Despite being
stand-alone, the graphics quality is fine.  The main problems I've
found with it are: games which involve moving more than a few meters
are a bit clunky, as they usually have teleportation or
joystick-controlled movement, which means your viewpoint moves without
your feet moving.  That's a bit disconcerting.  The other main problem
is the lack of tactile feedback.  The controllers can buzz, but that's
all the feedback you get.  There are really two aspects to the tactile
feedback: there's knowing when you're touching something (making the
controllers able to convey solidity), and making virtual objects feel
realistic when you interact with them (making the controllers able to
convey resistance).  For example, in [Vader Immortal][] you can hold
your lightsaber with two hands, but there's obviously nothing there in
reality, so it feels really strange moving both hands around as if
they're connected when they're not.  Maybe VR needs more physical
props.

[kombucha]: https://en.wikipedia.org/wiki/Kombucha
[water kefir]: https://en.wikipedia.org/wiki/Tibicos
[Call of Cthulhu]: https://en.wikipedia.org/wiki/Call_of_Cthulhu_%28role-playing_game%29
[Masks of Nyarlathotep]: https://www.yog-sothoth.com/wiki/index.php/Masks_of_Nyarlathotep
[Oculus Quest]: https://en.wikipedia.org/wiki/Oculus_Quest
[Beat Saber]: https://beatsaber.com/
[Vader Immortal]: https://www.oculus.com/vader-immortal/?locale=en_US


## Weekly link roundup

- [Taxonomy of Science Fiction Themes](https://classicsofsciencefiction.com/2019/01/15/taxonomy-of-science-fiction-themes/)
- [Creating a taxonomy of speculative fiction](http://www.ldsphilosopher.com/creating-a-taxonomy-of-speculative-fiction/)
- [How writers signal that a work is science fiction](http://www.ldsphilosopher.com/how-writers-signal-that-a-work-is-science-fiction/)
- [How to craft genuine science fantasy](http://www.ldsphilosopher.com/how-to-craft-genuine-science-fantasy/)
- [What is the Science Fantasy Genre?](https://hunterswritings.com/2016/12/15/what-is-the-science-fantasy-genre/)
- [Is it Science Fiction or Science Fantasy?](http://www.fantasy-magazine.com/non-fiction/is-it-science-fiction-or-science-fantasy/)
- [This Week in Rust 318](https://this-week-in-rust.org/blog/2019/12/24/this-week-in-rust-318/)
- [Issue 191 :: Haskell Weekly](https://haskellweekly.news/issue/191.html)
