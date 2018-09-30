---
title: "Weeknotes: 002"
tags: weeknotes
date: 2018-09-30
audience: General
---

## Personal

* I went to the [London Haskell][] meetup, where there was a talk
  about term rewriting systems.  It was quite introductory, and I
  think I probably wouldn't have gone if there had been an abstract
  available beforehand.

* I ran the first session of my [Call of Cthulhu][] campaign
  yesterday.  We got through character creation, some session 0 stuff,
  and ended the session on a good cliffhanger.  The next session
  unfortunately isn't going to be until the 27th, due to scheduling
  constraints.  Usually it will be fortnightly.

[London Haskell]: https://www.meetup.com/London-Haskell/
[Call of Cthulhu]: https://en.wikipedia.org/wiki/Call_of_Cthulhu_(role-playing_game)

## Ph.D

* I mostly took this week off, waiting for feedback on the draft
  semantics I sent to [SPJ][], my examiner.  Today he got back to me
  with some specific points to address but, on the whole, my new
  semantics are much better than the old.

[SPJ]: https://www.microsoft.com/en-us/research/people/simonpj/

## Work

* We finished setting up [AWS X-Ray][], a tool for tracing network
  requests in distributed systems, and got it deployed to our
  integration environment.

  ![AWS X-Ray service graph for GOV.UK's integration environment][]

  This is a graph of network requests based on the last 6 hours of
  traffic, today at 22:30ish on a Sunday.  This traffic is probably
  all coming from [smokey][], a part of our monitoring system which
  continuously makes requests to the site.

* On Wednesday, I began a shift on support.  Two people are "on-call"
  from 09:30 to 17:30 to solve any issues which arise with the site,
  and two other people are on-call overnight.  These shifts last a
  week.  This means I got to experience several new things which I'm
  not usually exposed to.  Here are some of the highlights:

    * Three virtual machines in our production environment became
      unresponsive, and couldn't be rebooted from the management
      console.  Fortunately they weren't important, but a bit
      concerning nontheless.  They came back by themselves with no
      human intervention.  Mysterious.

    * Some bad SSH configuration was deployed to our integration
      environment which resulted in nothing being able to connect to
      anything else, which broke just about everything.  Reliability
      Engineering were in the office bit late that day.

    * A had to manually restart some of [data.gov.uk][]'s
      "harvesters".  A harvester is a thing which goes out to a source
      of data, and fetches all the data sets.  Sometimes they get
      stuck, for reasons unknown.

    * I dealt with significantly more Welsh than I am used to.

      !["cofrestru" or "mewngofnodi"?][]

    * Relatedly, I had to fix a bug where something assumed all
      content was available in English.

    * I deployed a fix for an issue where [brexit-related statutory
      instruments][] couldn't be searched properly.  The bug had
      actually been fixed a week or so previously, but the fix had
      never been deployed by the author---whoops.  This isn't the
      first time a bug fix has been forgotten about.

    * An exciting new bug surfaced where publishers get a cryptic
      error message along the lines of "lock state version cannot be
      updated while edition is in the published state", which also
      happened during the last batch of brexit-related publications.
      Seems it wasn't a one-off, and we're not really sure what the
      problem is.  I have a theory, but haven't succeeded in finding
      much evidence for it yet.

    * About 16:30 on a Friday is the perfect time for a production
      cache server to develop issues, isn't it?  After a little over
      an hour of fairly fruitless debugging, I restarted it and we
      went home.

[AWS X-Ray]: https://aws.amazon.com/xray/
[AWS X-Ray service graph for GOV.UK's integration environment]: /weeknotes-002/x-ray.png
[smokey]: https://github.com/alphagov/smokey
[data.gov.uk]: https://data.gov.uk/
["cofrestru" or "mewngofnodi"?]: /weeknotes-002/welsh.png
[brexit-related statutory instruments]: https://www.gov.uk/eu-withdrawal-act-2018-statutory-instruments

## Miscellaneous

* I wrote a memo about [Self Organisation][], under a new
  "[systems][]" tag, which m going to use for memos about the way I do
  things.

* I forgot to mention this last week: I added Atom feeds for each tag.
  For example, [here is the feed for "weeknotes"][].

* I discovered that Google Calendar can be very creepy.  I had my
  calendar configured to not show me invitations I'd not responded to.
  But it seems that that setting doesn't apply to people you are
  sharing your calendar with, so I got a message from a friend with a
  screenshot of some very sketchy-looking invitations on my calendar,
  which I'd never seen before.  Leaving aside the fact that anyone can
  apparently send me spam calendar invitations, showing *other people*
  more on my calendar than *I* can see is very weird.  I now have that
  setting disabled, and I've deleted the invitations.

[Self Organisation]: /self-organisation.html
[systems]: /tag/systems.html
[here is the feed for "weeknotes"]: /tag/weeknotes.xml
