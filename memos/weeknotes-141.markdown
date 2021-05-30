---
title: "Weeknotes: 141"
taxon: weeknotes-2021
date: 2021-05-30
---

## Work

I took Friday off this week ([privilege day][]), and it's a bank
holiday on Monday, so I have a four-day weekend.  I could get used to
working four days on, four days off.

This week I got a few things done, which was nice.

I made a small performance improvements to our [account-api][] by
[caching the OpenID Connect discovery response][] (and I have another
caching change in review), which made our 90th percentile latency
immediately drop, which was nice to see on a chart.  When the second
caching change has been made, it might be time to revise our latency
SLO and set ourselves a harder target.

I also noticed a few cases where we have apps signing users in by
redirecting via `https://www.gov.uk/sign-in`, when they could instead
construct the OAuth URL directly: removing one user-facing redirect.
I think we should probably adopt a policy along the lines of
"`/sign-in` is just for the global sign-in link in the header,
redirects should use OAuth URLs directly."

I also got account-api consuming messages from our RabbitMQ cluster,
so it can do things (like update a user's saved pages) in response to
publishing updates.

Right before ending work on Thursday, I updated my work Macbook to Big
Sur.  Let's hope everything just works on Tuesday.

[privilege day]: https://en.wikipedia.org/wiki/Privilege_day
[account-api]: https://github.com/alphagov/account-api/
[caching the OpenID Connect discovery response]: https://github.com/alphagov/account-api/pull/78

## Books

This week I read:

- [Dancers at the End of Time][] by Michael Moorcock.

  This is a trilogy set millions of years in the future, when the
  Earth has a small population of humans living in a post-scarcity
  paradise.  Once humans travelled the universe and bent nature to
  their will, now they remain on Earth, using poorly-understood
  technologies from the past to give them god-like control over their
  environment.  It's a decadent society, and the book starts with the
  main character trying to understanding the meaning of virtue, which
  he found in an ancient dictionary.

  The story follows this native of the End of Time, who is obsessed
  with the 19th century and regarded as the planet's foremost expert
  (despite almost all of his knowledge being twisted or outright
  wrong), and an unwilling time traveller from 1896.

[Dancers at the End of Time]: https://en.wikipedia.org/wiki/The_Dancers_at_the_End_of_Time#The_Dancers_at_the_End_of_Time


## Freenode Drama

Unfortunately, [the Freenode drama][] has continued, with rasengan
proving that he has no business running an IRC network.  rasengan
locked over 700 channels which mentioned [Libera.Chat][] in their
topic, including some pretty big channels like [#haskell][],
[#emacs][], and [various Wikimedia channels][].  [NixOS has moved to
Libera.Chat][]. [FOSDEM has moved to Libera.Chat][].  Even the FSF is
[considering leaving Freenode][].

I'm not a big IRC user these days, but since every Freenode channel I
was in got locked at the same time, the decision to disconnect was a
pretty easy one.  You can now only find me on Libera.Chat, with the
usual username.

According to the last stats I saw, earlier in the week, the number of
connections to Freenode had dropped by about 25% in a matter of days,
almost all of which had moved to Libera.Chat.

rasengan may be overlord of Freenode, but people are rapidly fleeing
his realm.

[the Freenode drama]: weeknotes-140.html#freenode-drama
[Libera.Chat]: https://libera.chat/
[#haskell]: https://old.reddit.com/r/haskell/comments/nl74hc/freenode_has_unilaterally_taken_over_haskell/
[#emacs]: https://www.emacswiki.org/emacs/EmacsChannel
[various Wikimedia channels]: https://meta.wikimedia.org/wiki/IRC/Migrating_to_Libera_Chat
[NixOS has moved to Libera.Chat]: https://nixos.wiki/wiki/Get_In_Touch
[FOSDEM has moved to Libera.Chat]: https://fosdem.org/2021/news/2021-05-26-libera/
[considering leaving Freenode]: https://www.fsf.org/events/community-meeting-on-the-future-of-our-irc-presence


## Miscellaneous

Following on from a reddit discussion about how in Haskell [it's not a
no-op to unmask an interruptible operation][], I [wrote a memo][]
about how you can find that issue with [dejafu][].

[it's not a no-op to unmask an interruptible operation]: https://old.reddit.com/r/haskell/comments/nntfui/its_not_a_noop_to_unmask_an_interruptible/
[wrote a memo]: restore-interruptible.html
[dejafu]: http://hackage.haskell.org/package/dejafu


## Link Roundup

### Roleplaying games

- [Bunkers & Dragons: Machine Guns for D&D](https://deadtreenoshelter.blogspot.com/2021/05/bunkers-dragons-machine-guns-for-d.html)
- [Ask Questing Beast 7: Mike Pondsmith and Sean McCoy](https://www.youtube.com/watch?v=ER8U7snhrq0)

### Software engineering

- [small things that make apis a little bit better](https://edmz.org/personal/2021/05/27/small_things_that_make_apis_a_little_bit_better.html)
- [Should we rebrand REST?](https://kieranpotts.com/rebranding-rest/)
