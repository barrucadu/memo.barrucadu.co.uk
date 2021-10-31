---
title: "Weeknotes: 163"
taxon: weeknotes-2021
date: 2021-10-31
---

## Work

At long last, we launched the thing.

This week we switched over our production auth service to Digital
Identity, migrated over the users, and everything seems to be working
fine.

Migrating the users involved all of the OIDC subject identifiers
changing, which was a bit of a risk, but we worked around that by
preserving a user's old subject identifier as a custom claim available
in the userinfo, and having some logic on our end to check for old
identifiers and update our database as users log in.  And that seems
to be working just fine.

So now it's full steam ahead on bringing email notifications into the
account!


## Books

This week I've been reading the [Space Trilogy][] by C. S. Lewis.
Each story is about twice the length of the previous one, so I'm
thankful he only wrote three of them.  I'm two stories in so far and
they're pretty good, I'm looking forward to the next one.

Surprisingly (to me at least), he wrote this years before Narnia.

[Space Trilogy]: https://en.wikipedia.org/wiki/The_Space_Trilogy


## RPG Blog

This week I wrote a post on [my first rumour table][], which I made
for my Traveller campaign.

[my first rumour table]: https://www.lookwhattheshoggothdraggedin.com/post/my-first-rumour-table.html


## Miscellaneous

This week I've spent a bunch of time playing [Rise to Ruins][] and
[Audiosurf 2][].  I've had these games for years, I'm still pretty bad
at them, but there's just something about them which keeps me coming
back every few months or so.

[Runescape][] and [Guild Wars 2][] used to be my regular computer
games, but I think I've finally lost interest in MMOs.

[Rise to Ruins]: https://store.steampowered.com/app/328080/Rise_to_Ruins/
[Audiosurf 2]: https://store.steampowered.com/app/235800/Audiosurf_2/
[Runescape]: https://play.runescape.com/
[Guild Wars 2]: https://www.guildwars2.com/en-gb/


## Link Roundup

### Roleplaying Games

- [The Only Two Enemies You'll Ever Need](https://knightattheopera.blogspot.com/2021/09/the-only-two-enemies-youll-ever-need.html)
