---
title: "Weeknotes: 144"
taxon: weeknotes-2021
date: 2021-06-20
---

## Work

This week I finished off working on the email subscription stuff [I
mentioned last week][], so we now have a general mechanism to have
email subscriptions which are based on something we know about the
user, that we can change when we what we know changed, and these
subscriptions will follow the user if they their change email address.

Next I just need to migrate the Transition Checker-specific email
subscription data and get rid of the old endpoints.

I also did a general code quality review, looking for missing cases in
our API tests, setting up a couple of smoke tests for logging in
(which is hard to test at the app level, as that involves GOV.UK, a
separate auth service, and some CDN configuration), and reviewing our
database validations.

Finally, I did some work towards moving the account "dashboard" page
out of the account manager prototype and onto GOV.UK.  That's still
ongoing.

[I mentioned last week]: weeknotes-143.html#work


## The Plague

[Last week][] I discovered I couldn't book a coronavirus vaccination
due to missing medical records.  Well, this week, I still haven't
heard back from my old GP.  But I reached out to my new GP and they
were able to book an appointment for me, despite 119 saying I'd need
to get my records sorted out first.

Welcome to the UK public sector: really fragmented, and the people in
the middle only have vague knowledge of what's going on at the
periphery.

But at least I have an appointment now.  If it's 8 to 11 weeks between
jabs, I should get the second one in late August or early September.

[Last week]: weeknotes-143.html#the-plague


## Books

This week I read:

- [Babel-17][] by Samuel R. Delany.

  This was, I think, the first time I've been disappointed by [the SF
  Masterworks series][].  Ok, maybe "disappointed" is a bit strong:
  the book was still a fun read; but the big plot twist <span
  class="spoiler">that the mysterious acts of sabotage were caused by
  innocent people who learned Babel-17, as the language was designed
  to corrupt the mind,</span> is kind of ridiculous.

[Babel-17]: https://en.wikipedia.org/wiki/Babel-17
[the SF Masterworks series]: https://en.wikipedia.org/wiki/SF_Masterworks


## Gaming

### Pulp(?) Cthulhu

[Last time][] we finished off the current chapter of our Pulp Cthulhu
campaign, and it was *really* pulpy: there was *a zeppelin*, the
zeppelin was *attacked by flying monsters* and *exploded*, one of the
players summoned *a god* who *destroyed the flying monsters with
spears of lightning*.  It was exciting.  It was fast-paced.  It was
chaos.

But... I don't think most of the game sessions are like that.  Most of
the time it feels like we're playing normal Call of Cthulhu with some
more powerful player characters.

So I'm wondering about how to make it a bit faster-paced and a bit
more pulpy going forward.

[Last time]: weeknotes-142.html#gaming

### Godbound

This week I ran a one-shot of [Godbound][], a high-powered fantasy
system where the player characters are demigods.  The scenario I wrote
was that they had been granted divine power by God so that they could
defeat the evil wizard Zargothrax and prevent his ambitions of
becoming a new Dark Lord.

This was with my usual Call of Cthulhu group, plus a couple of new
players.  I prepared a very linear scenario, which started out with a
really easy challenge (which the players could actually have totally
ignored, and one suggested doing just that) to get them thinking about
how their character's powers can be used, and then progresses through
a series of challenges in a predetermined order until the final
battle.  It's pretty on rails, but that's fine for the occasional
one-shot so long as it doesn't become actual *railroading*, which is
definitely not the case here.

We'll be finishing off the scenario in a fortnight.

### What next?

I've also had some thoughts about what to do *after* Call of Cthulhu
(if such a thing can even be imagined: there's likely close to a year
left in the campaign).  I think I'd be up for running a [Traveller][]
campaign, full of sci-fi space adventures, so I'll have to write some
[campaign pitches][].

[Godbound]: https://www.drivethrurpg.com/product/185959/Godbound-A-Game-of-Divine-Heroes-Free-Edition
[Traveller]: https://www.mongoosepublishing.com/
[campaign pitches]: https://www.youtube.com/watch?v=MtH1SP1grxo


## Link Roundup

### Roleplaying Games

- [Trilemma Adventures](https://trilemma.com/)
- [Spell Lists Are Not Magical](https://www.prismaticwasteland.com/blog/spell-lists-are-not-magical)
- [Random GM Tip – The Grok Threshold (Running a Published Setting)](https://thealexandrian.net/wordpress/39775/roleplaying-games/random-gm-tip-the-grok-threshold-running-a-published-setting)
- A three-part series on some of the pleasures of the OSR and what makes it different to story games:
  - [Secrecy and Discovery](https://maziriansgarden.blogspot.com/2019/04/pleasures-of-osr-secrecy-and-discovery.html)
  - [Emergent Story and Open Worlds](https://maziriansgarden.blogspot.com/2019/04/pleasures-of-osr-emergent-story-and.html)
  - [Overcoming Challenges](https://maziriansgarden.blogspot.com/2020/06/pleasures-of-osr-overcoming-challenges.html)
- [Injury and the Abstract Combat Round](http://maziriansgarden.blogspot.com/2021/04/injury-and-abstract-combat-round.html)
