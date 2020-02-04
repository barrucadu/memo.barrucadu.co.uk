---
title: A GOV.UK Incident
tags: gov.uk, tech
date: 2018-08-10
---

In August 2018 [GOV.UK][] had an incident where people who had
subscribed to content changes on the site received duplicate emails
--- one user got as many as 7 for the same thing!  There's a subtle
technical reason behind this incident, so I'm writing about it and our
incident management process here.  At some point there will also be an
official blog post on the [Inside GOV.UK blog][].


Incident management at GOV.UK
-----------------------------

When something breaks at GOV.UK, we first have to ask "is this an
incident?"  Nobody really wants to ask that because if the answer is
"yes" the incident management process begins, but a good rule of thumb
is that if you have to ask it probably is.

When we've decided that something is an incident, the incident
management process begins:

1. Pick one dev to be "incident lead" and one to be "comms lead"
2. Incident lead begins working on fixing it, which may include
   pulling in other devs for help; comms lead continues with:
   - Categorise the incident (roughly "big", "medium", or "small")
   - Start recording what's going on in an incident report
   - Send an email to the incident mailing list with the draft report

As work on resolving the incident continues, the comms lead keeps the
draft report updated, and sends periodic emails to the mailing list to
reassure people that, yes, it is still being worked on.

Eventually the incident is resolved, the report gets fleshed out more,
and we have a meeting to discuss the incident, including both the
people who were directly involved, and people a bit more detached.


### Incident categorisation

We use a slightly fuzzy incident categorisation system:

- A **P1** incident is an outage of a critical service, with no
  workaround possible.  For example, if travel advice emails weren't
  being sent, or if publishers couldn't edit content.

- A **P2** incident is something major broken, but with work-arounds
  available.  For example, search is down (you can use Google), or
  publishers need to jump through some additional hoops to publish
  content.

- A **P3** incident is everything else: something isn't working
  properly, but it's still largely usable.

Security incidents are either a **P1** or a **P2**, whichever seems
the most appropriate.

We decided this was a **P3** incident, because nothing actually
*broke* as such.  It was certainly annoying for users, and the Foreign
and Commonwealth Office got involved because this also resulted in
duplicate travel advice emails, but at least the emails were still
being sent.


The incident
------------

So, onto the incident.  This will involve diving into code a bit.

- **The symptoms:** people were getting duplicate emails.
- **The cause:** not immediately apparent.

Because there wasn't an immediately obvious solution, and it had been
happening for a few hours by the time the investigation began, this
was an incident.  I wasn't directly involved at this stage, but I was
sat behind the people who were, so I overheard a lot.  I'll keep using
"we" instead of "the incident lead and comms" though.

Because we only found out about this from support tickets, we only
knew about duplicate travel advice emails, so we began looking there.

Travel advice on GOV.UK is published by the
[travel-advice-publisher][], which talks to the [email-alert-api][],
which talks to [GOV.UK Notify][], which is what actually sends the
emails via some Amazon thing.

GOV.UK Notify is, despite the name, not managed by the GOV.UK team,
but by another team here in the Government Digital Service.  We can
log in to GOV.UK Notify to see which emails we told it to send, which
is a quick way to confirm if the problem is at our end or their end.
Not too surprisingly, it was a problem on our end.

Next we began looking into the email-alert-api.  At some point during
this initial investigation, we got another support ticket for
duplicate emails which weren't travel advice.  Non-urgent emails
(basically everything but travel advice) makes it into the
email-alert-api by a different route (through the
[email-alert-service][], which listens to a message bus which the
[publishing-api][] writes to when there is some new content), so the
fact that both of these were failing made us fairly confident that the
problem is in how the email-alert-api is generating emails.

### The email-alert-api

The email-alert-api receives notifications of content changes, matches
those against subscribers in the database, and generates emails from
these.  We quickly found that there were duplicate emails in the
database for the same content change, so we started looking at the
code which generates the emails, the `ImmediateEmailGenerationWorker`:

```ruby
class ImmediateEmailGenerationWorker
  include Sidekiq::Worker

  sidekiq_options queue: :email_generation_immediate

  LOCK_NAME = "immediate_email_generation_worker".freeze

  attr_reader :content_changes

  def perform
    @content_changes = {}

    ensure_only_running_once do
      subscribers.find_in_batches do |group|
        subscription_contents = grouped_subscription_contents(group.pluck(:id))
        update_content_change_cache(subscription_contents)
        import_and_associate_emails(group, subscription_contents)
      end
    end
  end

  # ...
```

This is a worker process run by [sidekiq][], a popular job-scheduling
library for Ruby.  There are three email-alert-api boxes, so multiple
of these workers can run at the same time.  If multiple workers ran
the email generation logic at the same time, duplicate emails would be
sent; but how could that happen?

Mutual exclusion is achieved with the `ensure_only_running_once`
method, which uses PostgreSQL [advisory locks][] under the hood:

```ruby
  def ensure_only_running_once
    Subscriber.with_advisory_lock(LOCK_NAME, timeout_seconds: 0) do
      yield
    end
  end
```

All the workers use the same `LOCK_NAME`, so they use the same lock.
The `timeout_seconds: 0` option means that if a worker can't acquire
the lock on its first try, it aborts (rather than blocking and waiting
to grab the lock).  A new `ImmediateEmailGenerationWorker` is enqueued
every minute or so, so content changes are processed promptly even if
most of the workers short-circuit like this.

At this point we were stumped.  That code looked fairly sensible, the
PostgreSQL docs reassured us that this is a reasonable thing to do,
and the problem had never come up before.  Time to look at the recent
deployments of email-alert-api.

Nothing.  At least, nothing remotely relevant.

Ah, but there had been a deployment of [govuk-puppet][] recently,
which switched the email-alert-api over to connecting to its database
through [PgBouncer][], and which coincided almost exactly with the
first duplicate email!

At this point we didn't know why PgBouncer would cause a problem (and
I joined in at this point because I'd been recently working on the
PgBouncer puppet code), but we deployed a reversion while we
investigated further.

### Transaction pooling and PostgreSQL locks

At this point I was reading the PgBouncer docs, and the incident lead
was googling combinations of "postgres", "advisory lock", and
"pgbouncer".  Eventually we stumbled across Rails issue [#32622][],
"Migrations failing due to `ConcurrentMigrationError` while trying to
release an already acquired lock".

After a few comments, the author figured out the problem:

> I finally figured that this is not a rails issue. Rails takes an
> advisory lock to prevent concurrent migrations on the same DB.
>
> There is one crucial detail that I forgot to mention in the issue
> description, it's that we were using PgBouncer in transaction
> pooling mode. Since, in transaction pooling mode, different
> connections can be used for different transactions in the same
> session, it experiences issues with things like Advisory Locks.

Were we using transaction pooling mode?  [Yes we were][pp]!  Why were
we using transaction pooling?  We had hoped to make more efficient use
of the database server's resources.

This is the sort of problem which could only have arisen in a
distributed system: we needed database-level locking because we had
multiple nodes running this code concurrently, and the database-level
locking is necessarily tied to a session; we then introduced a layer
between the database and the applications, which broke session-level
features like this.


Lessons for the future
----------------------

In an incident review, we discuss how we can lessen the risk of a
similar incident happening again in the future.  For this incident,
there are a few things we can take away:

- When deviating from the default configuration of a tool (transaction
  pooling is not the default for PgBouncer), check what the costs are
  and be very confident that nothing will be adversely affected.

- If an application uses something unusual, like an advisory lock,
  document that.

- Our alerting only checks that emails have been *sent*, not that they
  have been sent only once.  Perhaps that can be improved.

- When we send an email, we also send one to a designated google
  group, but that goes through a different codepath to the regular
  emails.  This confused the initial diagnosis work, maybe those
  codepaths should be unified.

- Furthermore, maybe we can impose email uniqueness with database
  constraints.  This might or might not have prevented the duplicate
  emails, it's hard to say.

You might wonder why there's nothing about testing in this list.  The
problem is, we did test it!  We checked that an email could be sent
from our integration and staging environments, and we didn't get any
duplicates.  The problem only manifested on production because there
needed to be enough load on the email system for the worker processes
to overlap.

GOV.UK records traffic in production and plays it back in staging, to
help catch frontend issues.  To catch this issue, we'd also need to
record and replay publishing activity, which is a much harder problem.

[GOV.UK]: https://www.gov.uk
[Inside GOV.UK blog]: https://insidegovuk.blog.gov.uk
[travel-advice-publisher]: https://github.com/alphagov/travel-advice-publisher
[email-alert-api]: https://github.com/alphagov/email-alert-api
[GOV.UK Notify]: https://www.notifications.service.gov.uk/
[email-alert-service]: https://github.com/alphagov/email-alert-service
[publishing-api]: https://github.com/alphagov/publishing-api
[sidekiq]: https://github.com/mperham/sidekiq
[advisory locks]: https://www.postgresql.org/docs/9.6/static/explicit-locking.html#ADVISORY-LOCKS
[govuk-puppet]: https://github.com/alphagov/govuk-puppet
[PgBouncer]: https://pgbouncer.github.io/
[#32622]: https://github.com/rails/rails/issues/32622
[pp]: https://github.com/alphagov/govuk-puppet/blob/65e893e38b76ae2c1a2764df0ffd0d3324b51230/modules/govuk_pgbouncer/manifests/init.pp
