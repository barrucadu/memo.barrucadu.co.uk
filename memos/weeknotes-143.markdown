---
title: "Weeknotes: 143"
taxon: weeknotes-2021
date: 2021-06-13
---

## Work

This week I mostly worked on getting us towards having a generic way
of linking GOV.UK email notifications to an account, for two reasons:

1. Features like the Transition Checker conceptually have one email
   topic associated with them---the topic corresponding to your
   results---but in practice that means there's a topic for every
   possible combination of results (sort of), all of which have a
   distinct name.
   
   So if the Transition Checker wanted to change a user's email
   notifications (because they changed their results), it would have
   to do this:
   
   1. Call email-alert-api with the *old* results to get the old topic name
   2. Call email-alert-api with the *new* results to get the new topic name
   3. Call email-alert-api to get the user's subscriptions, and pick out the one corresponding to the old topic
   4. Call email-alert-api to cancel the old subscription
   5. Call email-alert-api to create the new subscription
   
   That's a bunch of steps!  By having a slightly higher level
   abstraction, a named "email subscription" which can correspond to
   an arbitrary topic, we can push all the complication into
   account-api.
   
   So the Transition Checker instead does this:
   
   1. Call account-api with the agreed subscription name and the new results
   
   And behind the scenes account-api will:
   
   1. Check its database to see if there's a previous subscription ID
   2. Call email-alert-api to cancel the previous subscription if so
   3. Call email-alert-api to set up the new subscription
   4. Store the new subscription ID in its database
   
   Having a database removes the need to do the "look up all the
   user's subscriptions and search through for one matching the old
   results" step.

   *We actually already have this, and have done for months*, but it's
   implemented in our account-manager prototype and only works for the
   Transition Checker.  I've been moving the functionality into
   account-api, making it more generic, and preparing to migrate the
   data across (with no downtime).

2. We don't want to fully integrate email notifications with accounts
   yet, so for now we only want subscriptions which were created
   through the account to do things like update the address when the
   user confirms a new one.
   
   Notifications are likely to integrate more fully with accounts at
   some point (because notifications *are* a kind of account, and so
   it's weird to have two accounts on one site), but not yet.

## The Plague

This week my age group became eligible to [book a coronavirus
vaccination][].  Unfortunately, I discovered that my NHS records
are... missing?  The booking tool told me that it couldn't find my
vaccination records and to contact my GP.

Even more unfortunately, my GP was the University of York one who I
registered with in 2010.  I only tried to see them once, some years
later, and the receptionist told me that they didn't know who I was
and that I should go home, re-register online, wait for them to
process that, then come back in to book an appointment.  I didn't
bother.

I'm not surprised in the slightest that they've lost my records.

So now I've registered with a local GP (which I've been meaning to do
for a while anyway), and have emailed the previous one asking them to
sort out my records.  I'll give it a few more days, and ring 119 on
Wednesday if I still can't book online by then.

Having no records seems likely to cause future problems too, so I'd
really like to get this sorted out properly.

[book a coronavirus vaccination]: https://www.nhs.uk/conditions/coronavirus-covid-19/coronavirus-vaccination/book-coronavirus-vaccination/


## Books

This week I read: nothing!


## Link Roundup

### Roleplaying Games

- [Game Design 101 - Guns in D&D](https://www.youtube.com/watch?v=0Mr0PjFkJC4)
- [Splitting the Party - Playing RPGs](https://www.youtube.com/watch?v=CVEnzu4z0Uw)
- [Building DnD Traps That Players Love](https://www.youtube.com/watch?v=RY_IRqx5dtI)
- [8 Puzzles for D&D Better Than Options from Tasha's Cauldron of Everything](https://www.youtube.com/watch?v=zt9lYvERgeI)
- [10 MORE Puzzles for D&D and TTRPGs part 2](https://www.youtube.com/watch?v=32xqHvITEB0)
- [](https://www.youtube.com/watch?v=wXZXSYjlnGE)

### Software Engineering

- [Reasons why bugs might feel "impossible"](https://jvns.ca/blog/2021/06/08/reasons-why-bugs-might-feel-impossible/)
- [Incident report: GOV.UK outage on 8 June 2021](https://insidegovuk.blog.gov.uk/2021/06/11/incident-report-gov-uk-outage-on-8-june-2021/)
- [Summary of June 8 outage](https://www.fastly.com/blog/summary-of-june-8-outage)

### Miscellaneous

- [Post Office Trial: speech to University of Law](https://www.postofficetrial.com/2021/06/marshall-spells-it-out-speech-to.html)
