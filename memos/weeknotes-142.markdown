---
title: "Weeknotes: 142"
taxon: weeknotes-2021
date: 2021-06-06
---

## Work

This week I made another caching change to reduce latency, got rid of
an unnecessary redirect, did some more work on saving pages, and then
switched to ripping out a few prototype features and implementing
"real" replacements (which'll be the focus of next week too):

- Moving the "dashboard" page from our prototype account manager onto
  GOV.UK.  This is good because it's ultimately where the
  functionality will need to be, and it means we're one step closer to
  being able to switch off the prototype.

- Moving the [Transition Checker][]'s email management from the
  account manager to the account-api and making it more generic, so
  that we can have similar account-bound email subscriptions elsewhere
  on GOV.UK.  This is good because currently this is really
  special-case code which we don't want to have to keep supporting
  indefinitely.

Maybe in the future we'll have a greater connection between GOV.UK
email subscriptions and GOV.UK accounts: for example, being able to
log in with a password (rather than a magic link) to manage your
subscriptions, or having your subscriptions follow you if you change
the email address of your account.

[Transition Checker]: https://www.gov.uk/transition-check/questions


## Books

This week I read:

- [Mona Lisa Overdrive][] by William Gibson, the third of the [Sprawl trilogy][].

  Another confusing one, but I found this easier to follow than I did
  [Count Zero][].  We get a few new characters and several returning
  ones, including Molly from Neuromancer, and Angela and Bobby from
  Count Zero.  There's a neat [Borges][] reference, with a super high
  density storage system which can contain an entire simulated world
  being called "an aleph": named, of course, after [the story of the
  same name][].

- [Hellstar Remina][] by Junji Ito.

  Oh boy, this was a strange one.  The story is mad: a new planet
  comes through a wormhole, and the scientist who discovers it names
  it after his daughter (Remina), and then that new planet starts
  eating the other planets and heading towards Earth!  So far weird
  but not *too* weird.  The particularly bonkers bit is that everyone
  on Earth decides that this planet is connected to the girl it was
  named after, and decides that if they kill her and her father the
  new planet will leave Earth alone.  The story is nuts.  There's also
  a subplot about two characters with very similar names which just
  felt really contrived (and I wonder if it works better with kanji).

  Not Junji Ito's finest work.

- Volume 13 of [Overlord][] by Kugane Maruyama.

  I had mixed feelings reading this.  The story was enjoyable, but the
  translation felt pretty lacking in parts.  There were a couple of
  times when I thought I'd missed out a page because everything seemed
  to suddenly change, but actually there'd just been a big shift in
  tone or context half-way through a paragraph in a way which doesn't
  usually happen in English prose.  And there was one character who
  was referred to by his forename by one set of characters and his
  surname by another set of characters, and his full name wasn't
  mentioned until afterwards, so at a few times I found myself
  wondering if a new character had suddenly appeared in the scene.
  That character had been introduced in the previous volume, but that
  was published last year, and so it would have been nice to mention
  his full name sooner in this volume

[Mona Lisa Overdrive]: https://en.wikipedia.org/wiki/Mona_Lisa_Overdrive
[Sprawl trilogy]: https://en.wikipedia.org/wiki/Sprawl_trilogy
[Count Zero]: weeknotes-129.html
[Borges]: https://en.wikipedia.org/wiki/Jorge_Luis_Borges
[the story of the same name]: http://www.phinnweb.org/links/literature/borges/aleph.html
[Hellstar Remina]: https://junjiitomanga.fandom.com/wiki/Hellstar_Remina
[Overlord]: https://en.wikipedia.org/wiki/Overlord_(novel_series)


## Gaming

This week marked the end of the England chapter of [my Call of Cthulhu
campaign][].  The party disrupted a giant cult ritual in rural Essex.
A police zeppelin was involved.  The zeppelin was ripped open by giant
flying monsters.  It subsequently blew up.  Very pulpy.

Next time we'll be having a one-shot of [Godbound][], so I can have
some fun running a throw-away high-level fantasy adventure.

[my Call of Cthulhu campaign]: campaign-notes-2020-05-call-of-cthulhu.html
[Godbound]: https://www.drivethrurpg.com/product/185959/Godbound-A-Game-of-Divine-Heroes-Free-Edition


## RPG Blog

This week I published [a review of Izirion's Enchiridion of the West
Marches][], a sourcebook for [West Marches][] style play I kickstarted
earlier this year.

[a review of Izirion's Enchiridion of the West Marches]: https://www.lookwhattheshoggothdraggedin.com/post/izirions-enchiridion.html
[West Marches]: http://arsludi.lamemage.com/index.php/78/grand-experiments-west-marches/


## Link Roundup

### Software Engineering

- [Cross-Branch Testing](https://buttondown.email/hillelwayne/archive/cross-branch-testing/)
- [How to Test](https://matklad.github.io//2021/05/31/how-to-test.html)
