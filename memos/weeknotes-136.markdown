---
title: "Weeknotes: 136"
taxon: weeknotes-2021
date: 2021-04-25
---

## Work

This week the team had a "[firebreak][]", a week of doing whatever you
want so long as it's useful.  I spent the time improving healthchecks
for GOV.UK's apps.

The way our healthchecks used to work had a few problems:

- Our healthchecks always returned a 200 status code, and communicated
  the details (which could be something like `status: critical`) in
  the response body.  So software which expects the status code to be
  meaningful---like an AWS load balancer---assumes our apps are
  healthy even when they're not.

- Because our monitoring system is powered by ancient versions of
  Graphite and Icinga (and configured with an ancient version of
  Puppet), adding new alerts "properly" is difficult, so lots of apps
  co-opt their healthcheck to check other things as well.  Like
  whether the database has any soon-to-expire API tokens: this is
  something which needs monitoring, but it's not a healthcheck.

- Every app had a single `/healthcheck` endpoint, rather than follow
  the current industry good practice of having separate liveness and
  readiness healthchecks.

So I worked through our ~50 apps, implementing separate liveness and
readiness healthchecks, and implementing new alerts for those
not-healthchecks which had proliferated.  I still need to deploy the
monitoring configuration change, and then the AWS load balancer
configuration change.  I hope to get that done on Monday morning, then
I can go through all the apps *again* and delete the old
`/healthcheck` endpoint.

While it wasn't a very exciting piece of work (opening 50 almost
identical PRs doesn't stretch the creative muscles much), it was
satisfying to work through, and to put GOV.UK in a slightly better
place.  Now, if only our monitoring system wasn't so old...

[firebreak]: https://insidegovuk.blog.gov.uk/2018/05/03/firebreaks-on-gov-uk/


## Books

This week I read:

- [Site Reliability Engineering][] and [The Site Reliability Workbook][] ([available for free online][]) by many Googlers.

  There's a lot of great stuff in these books.  I think I preferred
  the Workbook, as it's a bit more practical and has lots of
  non-Google examples.  I'm definitely going to try to apply some of
  these ideas at work, where our processes can be... not so great.

[Site Reliability Engineering]: https://www.google.co.uk/books/edition/_/81UrjwEACAAJ?hl=en
[The Site Reliability Workbook]: https://www.google.co.uk/books/edition/_/fElmDwAAQBAJ?hl=en
[available for free online]: https://sre.google/books/


## Link Roundup

### Software Engineering

- [Why it’s worth it to invest in internal docs](https://increment.com/documentation/why-investing-in-internal-docs-is-worth-it/)
- [Kubernetes and the Erlang VM: orchestration on the large and the small](http://blog.plataformatec.com.br/2019/10/kubernetes-and-the-erlang-vm-orchestration-on-the-large-and-the-small/)
- [Testing in Production, the safe way](https://copyconstruct.medium.com/testing-in-production-the-safe-way-18ca102d0ef1)

### Miscellaneous

- [The Logarithm of a Sum](https://cdsmithus.medium.com/the-logarithm-of-a-sum-69dd76199790)
