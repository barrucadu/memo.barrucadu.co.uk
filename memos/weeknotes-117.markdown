---
title: "Weeknotes: 117"
taxon: weeknotes-2020
date: 2020-12-13
---

## Work

This week I mostly carried on with the cross-domain analytics stuff [I
was thinking about last week][].

It took a bit longer than hoped, as I'd not really worked with
GOV.UK's javascript stuff before, so I had to get to grips with the
module system and how to write tests (and then had to figure out why
my tests were flaky, whether it was a bug in the code or the tests,
and fix it).  And then I had to re-do a bunch of the backend work
because it turns out that [sticking extra params in the OAuth redirect
URI is not cool][]:

>  Often times a developer will think that they need to be able to use
>  a different redirect URL on each authorization request, and will
>  try to change the query string parameters per request. This is not
>  the intended use of the redirect URL, and should not be allowed by
>  the authorization server. The server should reject any
>  authorization requests with redirect URLs that are not an exact
>  match of a registered URL.
>
> If a client wishes to include request-specific data in the redirect
> URL, it can instead use the “state” parameter to store data that
> will be included after the user is redirected. It can either encode
> the data in the state parameter itself, or use the state parameter
> as a session ID to store the state on the server.

But I got there in the end.

We've got another frontend developer joining the team next week, which
will be very handy as we've had a lot of frontend work in recent
weeks.

[I was thinking about last week]: weeknotes-116.html
[sticking extra params in the OAuth redirect URI is not cool]: https://www.oauth.com/oauth2-servers/redirect-uris/redirect-uri-registration/#per-request

## Books

This week I read:

- Volumes 17, 18, and 19 of [Nana][], by Ai Yazawa.

  I gave up on ever receiving my previous order of volume 17 (I
  ordered it in September!), so I cancelled it and bought the volume
  again.  Now I finally have all of Nana which, sadly, isn't the
  complete story, as the creator put it on hiatus back in 2009 after
  volume 21...

[Nana]: https://en.wikipedia.org/wiki/Nana_(manga)

## Time Tracking

I've decided to give tracking my time a go, by starting a [timedot
file][] which I'm manually recording my activities in.  Here's today's
so far (as of about 21:00):

```
2020-12-13
leisure:anime       ........
sleep               8.25h
leisure:tech        .
leisure:systems     ...
leisure:reading     .. ... ...
leisure:social      .......
leisure:ttrpg:play  4h
```

I've divided all human activity[^tt1] under the four headings of
*chores*, *leisure*, *sleep*, and *work*.  Each one of those is
further divided into high-level categories which I think will let me
answer interesting questions.  For example,

[^tt1]: Well, all *my* activity at least.

- For chores: how much time do I spend tracking my finances and
  reconciling transactions?

- For leisure: how much time do I spend *preparing* TTRPG sessions vs
  *playing* them?

- For work: how much time do I spend directly on my team's work, and
  how much time on other things, like line management or support?

I'm trying to keep it fairly easy to use, so I'm not trying to track
every minute of the day.  I'm tracking things in 15-minute intervals.
I will round up if I spend ~10 minutes on something, but if I don't,
it won't get tracked.  I'm also keeping the scope of my tracking
somewhat limited; I'm not tracking things like having a shower,
brushing my teeth, or mindlessly browsing the internet: all those
sorts of activities are just lumped together into untracked time.

I've now been doing this for a few days, so I have a little data built
up:

!["Leisure Breakdown" graph from my "Quantified Self" dashboard.](weeknotes-117/leisure-breakdown.png)

In the graph, "systems" refers to my [personal finance system][],
[self organisation system][], and now my time tracking system.  So as
a *leisure* activity, "systems" is tinkering with those for fun.  I've
been doing a lot of that this week.  There is also an associated
*chore*, which is the time spent doing necessary data entry and
maintenance (if I spend more than a couple of minutes on them, that
is).

And if you're thinking "surely it didn't take 10 hours to read 3
volumes of manga!" you would be right: in my weeknotes I only list the
books I've *finished* that week.  [Malazan continues][].

It's been an interesting experience so far.  I've found myself
becoming a bit more mindful of how I spend my time.  I've also found
myself going to enter some data in the timedot file and frequently
trying to remember what time I started a task, so as a result I've got
quite a bit of unaccounted time, particularly during work hours[^tt2].
That should improve with practice.

[^tt2]: On Friday, for example, I kept working until 6pm because I
  wanted to finish some stuff off, but I somehow only have 7 hours of
  work (including the lunch break) tracked for that day...

[timedot file]: https://hledger.org/timedot.html
[personal finance system]: personal-finance.html
[self organisation system]: self-organisation.html
[Malazan continues]: https://en.wikipedia.org/wiki/The_Bonehunters

## Link Roundup

- [siunitx – A comprehensive (SI) units package](https://ctan.org/pkg/siunitx?lang=en)
- [How to GM an open world campaign](https://www.tribality.com/2020/12/09/how-to-gm-an-open-world-campaign/)
- [ANN: hledger-1.20](https://mail.haskell.org/pipermail/haskell-cafe/2020-December/133098.html)
