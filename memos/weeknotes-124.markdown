---
title: "Weeknotes: 124"
taxon: weeknotes-2021
date: 2021-01-31
---

**This deployed a day late as my Concourse instance fell over.**

## Work

### Shifting gears

This week we've changed focus away from building an authentication
solution towards *personalisation*, a very nebulous term which seems
to mean different things to different people.  The Transition Checker
will be going away at some point[^brexit], so we need to branch out
and integrate with something else on GOV.UK to avoid losing our
current cohort of users.

[^brexit]: Now that Transition is, after all, *done*.

So to that end I've [opened an RFC][] to discuss what it'll look like
to have a GOV.UK-wide login session.  There are a few challenges with
our current architecture which make this tricky:

- GOV.UK heavily relies on caching.  If we start passing around
  session cookies naively, we'd be sending every request by a
  logged-in user to our origin servers, even for pages which don't end
  up using the cookie.

- We need to be careful we don't introduce bugs like caching a page
  which includes some personalised information (eg, "Hi barrucadu" in
  the header) and then serving that cached copy to other users.

- This session cookie needs to be secure and tamper-proof, which
  suggests signing it; but then we need to share the signing key
  amongst all our frontend microservices.

- Which microservice should serve the login and logout pages and do
  the actual cookie manipulation?  It doesn't really make sense to
  leave that in the Transition Checker when this is rolled out to all
  of GOV.UK.

[opened an RFC]: https://github.com/alphagov/govuk-rfcs/pull/134

### Prototypes? (again)

Last week I mused whether our apps were still prototypes, as they're
running in production and we're iterating them.  This week I'm a bit
closer to an answer, which I think is "yes, they are".

There's been some more discussions on what exactly the division of
work between GOV.UK and Digital Identity will be and, while there are
still big unknowns, I think the future is beginning to clear up.


## Books

This week I read:

- [The Complete Kobold Guide to Game Design][] by Janna Silverstein *et al*.

  This was generally quite good, but parts of it did feel pretty
  D&D-focussed, which is a bit of a shame.  I suppose it makes sense,
  if you're trying to break into producing RPG content then you'll
  likely target the most popular system.  But as I was coming at this
  from the perspective of a non-D&D GM who wanted to learn some tips
  for designing adventures and planning sessions, that wasn't very
  helpful.

[The Complete Kobold Guide to Game Design]: https://koboldpress.com/kpstore/product/complete-kobold-guide-to-game-design-2nd-edition/

## Link Roundup

- [Designing a Ruby Serverless Runtime](https://daniel-azuma.com/blog/2021/01/20/designing-a-ruby-serverless-runtime)
- [How we made Typerighter, the Guardian’s style guide checker](https://www.theguardian.com/info/2021/jan/26/how-we-made-typerighter-the-guardians-style-guide-checker)
- [Migrating our Rails application to AWS Fargate](https://medium.com/code-wild/migrating-our-rails-application-to-aws-fargate-be671541b5df)
- [What Is GitOps and Why It Might Be The Next Big Thing for DevOps](https://thenewstack.io/what-is-gitops-and-why-it-might-be-the-next-big-thing-for-devops/)
- [Driving Cultural Change Through Software Choices](https://skamille.medium.com/driving-cultural-change-through-software-choices-bf69d2db6539)
- [Improving how we deploy GitHub](https://github.blog/2021-01-25-improving-how-we-deploy-github/)
- [“Why are my tests so slow?” A list of likely suspects, anti-patterns, and unresolved personal trauma.](https://charity.wtf/2020/12/31/why-are-my-tests-so-slow-a-list-of-likely-suspects-anti-patterns-and-unresolved-personal-trauma/)
