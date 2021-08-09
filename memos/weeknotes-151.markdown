---
title: "Weeknotes: 151"
taxon: weeknotes-2021
date: 2021-08-09
---

This came a day late as I was away visiting friends this weekend.

## Work

This week I [continued looking at Fastly's Compute@Edge stuff][].

I also looked into [edge-side includes (ESI)][] as another option (and
possibly less of a change to how we currently do things) but I think I
need to ask someone at Fastly some questions about how it all works:
eg, if the "main request" sets some response headers, can I feed those
into the "ESI request" as request headers (such as if it sets a
cookie), or does the "ESI request" just get the request headers from
the user?  [The Fastly ESI docs][] are pretty bare-bones.

And I implemented [a way of sticking flash messages in our session
cookie][], so we can have the user do something with one frontend app,
and redirect them to another frontend app which shows a message (which
then disappears on the next page load).  The motivating example is
email subscriptions, which involves a minimum of two frontend apps:

1. The user browses to a page (say, rendered by
   [government-frontend][]) and clicks a button to get email
   notifications.  That button sends the user to the email sign-up
   journey in [email-alert-frontend][]; where,
2. The user either logs in (we haven't implemented this bit yet) or
   continues without logging in; then,
3. The user confirms that they want the subscription, and gets
   redirected back to the page they came from; and,
4. The user sees a confirmation banner at the top of the page (we
   haven't implemented this yet either).

In step 3, we'll set a flash message from email-alert-frontend which
will make government-frontend render the confirmation banner.  And
because it's set up so that the flash gets cleared after each request,
if the user refreshes the page or navigates elsewhere, the message
goes away.  This is a pretty common pattern in Rails apps, but it
requires a little more care to make it work when you have multiple
frontend apps which don't share the Rails session cookie.

[continued looking at Fastly's Compute@Edge stuff]: weeknotes-150.html#work
[edge-side includes (ESI)]: https://en.wikipedia.org/wiki/Edge_Side_Includes
[The Fastly ESI docs]: https://developer.fastly.com/reference/vcl/statements/esi/
[a way of sticking flash messages in our session cookie]: https://github.com/alphagov/govuk_personalisation/pull/9
[government-frontend]: https://github.com/alphagov/government-frontend/
[email-alert-frontend]: https://github.com/alphagov/email-alert-frontend

## Books

This week I read:

- [The Rise and Fall of the Third Reich][] by William L. Shirer

  I started reading this [in Janaury last year][] on my commute, and
  then the commute stopped.  So I put the book aside and only returned
  to it recently.  I very much enjoyed reading it (though, of course,
  much of the subject matter is abhorrent), even though there are
  [some significant criticisms][].  I might pick up a more scholarly
  history of the Third Reich in the future.

- [Little Nuns][] by [Diva][]

  On just about the opposite end of the spectrum from *Rise and Fall*,
  this little artbook of nuns and ducks which I'd kickstarted arrived
  last week, and I had a little break from history to look through the
  pictures.

[The Rise and Fall of the Third Reich]: https://en.wikipedia.org/wiki/The_Rise_and_Fall_of_the_Third_Reich
[in Janaury last year]: weeknotes-068.html#miscellaneous
[some significant criticisms]: https://en.wikipedia.org/wiki/The_Rise_and_Fall_of_the_Third_Reich#Criticism
[Little Nuns]: https://www.kickstarter.com/projects/diva01/litttle-nuns
[Diva]: https://twitter.com/hyxpk


## Miscellaneous

This weekend I went to a friend's house, along with a couple of other
friends.  It's the largest (and longest) social gathering I've been to
since the plague started.  I thought it might feel a little weird to
begin with, but it didn't (at least to me); we'd all done rapid
lateral flow tests the day beforehand, so we knew the risk of
infection was low, and so it was just like any other meetup.

Having to wear a mask for a couple of hours on public transit wasn't
fun though.


## Link Roundup

### Miscellaneous

- [If all stories were written like science fiction stories](https://archive.is/9HERI)
