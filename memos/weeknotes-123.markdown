---
title: "Weeknotes: 123"
taxon: weeknotes-2021
date: 2021-01-24 21:00:00
---

## Work

### Leavers and joiners

This week one of the devs who has been on the team from the beginning
left (though not far away, only to another team on GOV.UK), and a
replacement will be joining on Monday.

That's sad, but it does give us another opportunity to test and
iterate [our on-boarding documentation][].  One of the other devs on
the team has really taken charge of this process, helping to onboard a
bunch of frontend devs, and has recently been working with our tech
writer to get it all written up, which is great.

[our on-boarding documentation]: https://team-manual.account.publishing.service.gov.uk/new-starter/

### Secret management

I wrote up some [documentation on secrets][], and was kind of
surprised by how many we have already.  It would be nice to remove
some of these, for example maybe we could replace the special shared
OAuth tokens---they're essentially just shared passwords---with a
mechanism to automatically negotiate a temporary credential, which
would also have the advantage that leaking it becomes less of a
concern.  But then we need the secret which gives access to the secret
generator.  Hmm.

Another problem with our secrets is that they're set in environment
variables, which of course don't have any sort of auditability: the
process can just read them willy-nilly.  The [GOV.UK PaaS][] doesn't
have any sort of secrets management built in yet, but it's on their
roadmap.  Maybe we can live with the current situation until then.

On another note, [I removed detect-secrets from our repositories][],
as it was just a pain.  We gave it a good go, but I think we're now
all firmly of the opinion that it's better to just not have the need
to touch production secrets when doing local development.

[documentation on secrets]: https://team-manual.account.publishing.service.gov.uk/support/rotate-secrets/
[GOV.UK PaaS]: https://www.cloud.service.gov.uk/
[I removed detect-secrets from our repositories]: https://github.com/alphagov/govuk-account-manager-prototype/pull/613

### Prototypes?

Our apps still have "prototype" in the name.  But are they?  We've
learned a lot about the domain since starting.  There are some
implementation choices we made which are starting to bite us.  Is it
time to throw our current code away and start again, producing the
first version of some non-prototype apps?

Well, maybe.  It depends on who is building the *real* authentication
solution for the cross-government account system.

If it's us, then we'll need non-prototypes at some point.  If it's the
Digital Identity programme, they'll build the thing and we'll just be
implementing a frontend on top.

On the assumption that it will be us, I've been looking into using
[ORY Hydra][] as our OAuth/OIDC tool[^hydra].  Currently we use
[doorkeeper][] and [doorkeeper-openid_connect][], which work, but
doorkeeper-openid_connect is looking for maintainers, and we'd ideally
not end up implementing bits of the prototols---why use libraries if
we still need to do it ourselves?

[^hydra]: Though we'll also need to look at more options, and possibly
  do some spikes, to ensure we make the "best" choice.

[ORY Hydra]: https://www.ory.sh/hydra/
[doorkeeper]: https://github.com/doorkeeper-gem/doorkeeper
[doorkeeper-openid_connect]: https://github.com/doorkeeper-gem/doorkeeper-openid_connect

### Better tests

I learned a couple of handy things about testing this week:

- [SimpleCov can show you branch coverage as well as line coverage](https://github.com/alphagov/govuk-account-manager-prototype/pull/640)
- [Bullet is a handy gem for finding ActiveRecord query issues](https://github.com/alphagov/govuk-account-manager-prototype/pull/616)


## Books

This week I read:

- Volume 3 of [Black Wings of Cthulhu][] edited by S. T. Joshi, an
  anthology of modern Lovecraftian stories.

  Another good collection of stories.  I particularly liked:

  - *Houdini Fish* by Jonathan Thomas, and *Further Beyond* by Brian
    Stableford

    These both build on [From Beyond][], with Houdini Fish being a
    retelling of the same premise but in a different context, and
    Further Beyond being a direct sequel.

  - *The Man with the Horn* by Jason V. Brock

    Same sort of idea as [The Music of Erich Zann][], but this time we
    get to take a peek through the window and learn a bit more about
    the musician himself.

  - *Waller* by Donald Tyson

    I think this was my favourite in the collection.  It's about a man
    with terminal liver cancer, who falls through a wall (literally)
    into another world, where people like him are hunted for the "life
    seeds" which grow within them, because it is what the gods demand.

  - *The Megalith Plague* by Donn Webb

    In which a man in a rural Texas village finds a buried book which
    has instructions on the *true* way to worship god, and apparently
    god wants a lot of stone circles.

[Black Wings of Cthulhu]: https://www.goodreads.com/book/show/23602717-black-wings-of-cthulhu
[From Beyond]: https://hplovecraft.com/writings/texts/fiction/fb.aspx
[The Music of Erich Zann]: https://hplovecraft.com/writings/texts/fiction/mez.aspx


## Gaming

Another good session in my Pulp Cthulhu game this weekend.  In which
the characters saw a terrible vision of the future, and then promptly
repressed the memory, keeping only a faint impression that "somewhere
in China" is relevant to their current predicament.

Unfortunately for them, China is pretty big.

Having one of the players handle writing up the session recap is a
game-changer, I wish I'd started doing this years ago.  My GM notes
for this campaign are so brief compared to the previous one.


## Time Tracking

I'm still keeping up with my time tracking, tweaking it as I go.

I decided to add a `chores:self` category, which so far covers my
morning routine: showering, getting dressed, and making a pot of tea.
I decided that if I'm aiming to have under 2 hours of untracked time a
day, losing a 45-minute chunk every morning wasn't a good start.  I
should probably also track meal times in that, though I eat pretty
quickly.

I'm also considering adding a `leisure:misc` for slacking-off
mindless-browing-the-internet time and the like.  I originally planned
to not track that, but maybe it would be nice to be able to
distinguish time lost due to measurement errors or gaps, and time
spent doing nothing useful.

## Link Roundup

- [The Hypertext Transfer Protocol Status Code 308 (Permanent Redirect)](https://tools.ietf.org/html/rfc7538)
- [Deciphering Ruby Code Metrics](https://codeclimate.com/blog/deciphering-ruby-code-metrics/)
- [Vulgar: fantasy language generator](https://www.vulgarlang.com/)
- [User power, not power users: htop and its design philosophy](https://hisham.hm/2020/12/18/user-power-not-power-users-htop-and-its-design-philosophy/)
- [Game Design Perspective: Stardew Valley](https://www.pixelatedplaygrounds.com/sidequests/game-design-perspective-stardew-valley)
