---
title: "Weeknotes: 074"
taxon: weeknotes-2020
date: 2020-02-16
audience: General
---

## Work

### A/B testing

We've not run any A/B tests since GOV.UK changed to require you to opt
in to analytics cookies, due to worries about whether we even *can*
A/B test people without their consent.  This has been a bit of a
bother, so I made our A/B testing framework [only bucket you if you'd
opted in to cookies][].  Which then promptly [broke our smoke
tests][], because they weren't consenting to cookies, whoops.

[only bucket you if you'd opted in to cookies]: https://github.com/alphagov/govuk-cdn-config/pull/247
[broke our smoke tests]: https://github.com/alphagov/smokey/pull/647

### Documentation

My documentation spree continued this week, though it was mostly
process improvements than actual writing:

- I reviewed all the docs which were assigned to our 2ndline support
  team, and reassigned almost all of them to other teams.  This is a
  nice change, because reviewing docs is the lowest priority thing
  2ndline do, so they tend to build up.  And when you see 50+ pages
  needing review, it puts you off even more.  Spreading the load is
  part of solving the problem.  The next part is making people care
  more about doing reviews, but I've not figured out how to achieve
  that yet.

- I reviewed all of our "how to" docs and made sure that they were
  actually how-tos (and if not reclassified them as "learn" docs), and
  that they had an action-oriented title.

I also found some coverage issues in our docs:

- There are lots of dev VM related docs which are *almost* irrelevant
  (and can be deleted when everyone is using [govuk-docker][]) and
  some postgres docs which are only relevant to our old cloud
  environment (and can be deleted when the last few apps make it
  across to AWS).

- There aren't actually many docs on govuk-docker at all, that's
  probably a gap which needs filling judging from the frequency of
  questions on slack.

Finally, I did manage to do a bit of writing, [documenting how we can
use SageMaker to A/B test different ranking models][].

[govuk-docker]: https://github.com/alphagov/govuk-docker
[documenting how we can use SageMaker to A/B test different ranking models]: https://github.com/alphagov/search-api/pull/1979

### Reshuffle

I've been on call this week, and it's been the reshuffle this week!
Rumours had it being a big one, but then it didn't quite go as planned
(or as feared?).  So thankfully I didn't get any calls on Thursday
evening.  But I'm still on call until 09:30 on Wednesday, so who knows
what could happen.

I did fix one reshuffle-related bug, someone noticed that the "View
all announcements" links on [ministerial role pages][] was trying to
filter using the `people` facet, and not the `roles` facet.  So
nothing was being found, because there isn't a person called (eg)
`prime-minister`.  Changing whitehall is always worrying, but it ended
up [only being a small fix][].

[ministerial role pages]: https://www.gov.uk/government/ministers/prime-minister
[only being a small fix]: https://github.com/alphagov/whitehall/pull/5357

### RFC

I've been working on implementing [the RFC][], and have got to the
point where [whitehall can publish attachment metadata!][]
Unfortunately, I got that implemented just before a reshuffle-related
deploy freeze was announced, but I should be able to merge that on
Monday.

Next I need to make [content-publisher][] send the same metadata, then
I can start phasing out the old way.  I had a quick look at
content-publisher, and it feels... kind of whitehally.  Hopefully
we're not just replacing one whitehall with another.

[the RFC]: https://github.com/alphagov/govuk-rfcs/blob/master/rfc-116-store-attachment-data-in-content-items.md
[whitehall can publish attachment metadata!]: https://github.com/alphagov/whitehall/pull/5353
[content-publisher]: https://github.com/alphagov/content-publisher

### Miscellaneous

I'm on leave for two weeks from Thursday next week.  I don't have any
plans, I just had some leave to use up before April.  I'm looking
forward to waking up at noon and not having to do anything.

## Miscellaneous

### Books

I read [The Phoenix Project][], which was an enjoyable enough read, in
a way, but not quite the revelatory experience the hype had lead me to
expect.  The story was pretty contrived, and the main character was
basically infallible and guided by a mysterious mentor who just so
happened to have almost unlimited influence with the company execs.
The IT Ops team are portrayed as poor victims of circumstance, their
only failing being not having enough awareness of what work is going
on.  Once they get a handle on that, they whip those silly developers
into shape, cause the security guy to have a mental breakdown (who
somehow later comes back as an evangelist for the guy who caused it),
and totally transform the build and deploy pipelines, including
migrating from a on-premise datacentre with hand-managed VMs to an
auto-provisioned AWS environment in a couple of weeks.  It's very much
a story about how IT Ops are superheroes, and how everything wrong
with IT is caused by someone else.

I've started reading [The Unicorn Project][] which is the same story
(or maybe a variant on it in a parallel universe) told from the
perspective of the devs.  Maybe it will be better, though the
mysterious mentor has shown up again: apparently he runs a bar now
(well, has run a bar for years)---in addition to being a devops
expert, a business genuis, and vastly wealthy---and it *just so
happens* to be the bar at which all the angry devs have been meeting
to moan about work.

[The Phoenix Project]: https://www.goodreads.com/book/show/17255186-the-phoenix-project
[The Unicorn Project]: https://www.goodreads.com/book/show/44333183-the-unicorn-project

### Games

I played a game of [Blades in the Dark][] this weekend[^apoc], and it
was pretty good.  The setting is a Victorian-era city in a world where
ghosts, demons, and the like roam the Earth.  You play as a gang of
criminals in the city of Doskvol, which is a large and important city
protected from the horrible nightmarish beings in the wasteland by a
wall of lightning powered by demon blood.

[^apoc]: We couldn't start [Apocalypse World][] because a few people
  were away.

In a four-hour session we got through character creation and a short
heist.  My character almost died, but I survived in the end.  I think
I'd be up for playing it again some time.

[Blades in the Dark]: https://www.evilhat.com/home/blades-in-the-dark/
[Apocalypse World]: http://apocalypse-world.com/

## Link Roundup

- [Compiling Haskell to JavaScript, not in the way you'd expect](http://oleg.fi/gists/posts/2020-02-09-compiling-haskell-to-javascript.html)
- [pipe: use exclusive waits when reading or writing](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0ddad21d3e99c743a3aa473121dc5561679e26bb)
- [The Wall of Technical Debt](http://verraes.net/2020/01/wall-of-technical-debt/)
- [LetsBeRealAboutDependencies](https://wiki.alopex.li/LetsBeRealAboutDependencies)
- [Fizz Buzz in Tensorflow](https://joelgrus.com/2016/05/23/fizz-buzz-in-tensorflow/)
- [Haskell in Production: Riskbook](https://serokell.io/blog/haskell-in-industry-riskbook)
- [A Bridge To Nowhere](http://thecodelesscode.com/case/154)
- [Upcoming stackage LTS 15 snapshot with ghc-8.8.2](https://www.stackage.org/blog/2020/02/upcoming-lts-15-ghc-8-8-2)
- [The Myth of the Barter Economy](https://www.theatlantic.com/business/archive/2016/02/barter-society-myth/471051/)
- [This Week in Rust 325](https://this-week-in-rust.org/blog/2020/02/11/this-week-in-rust-325/)
- [Issue 198 :: Haskell Weekly](https://haskellweekly.news/issue/198.html)
