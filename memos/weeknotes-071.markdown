---
title: "Weeknotes: 071"
tags: weeknotes
date: 2020-01-26
audience: General
---

## Work

### Fixing scary search stuff

I found a worrisome, you might even say *scary*, comment in search-api
about a clever work-around to avoid hitting Elasticsearch's search
queue limit: which is 1000.

Naturally my reaction was "what? you can make a request to search-api
which makes it send *a thousand* queries to elasticsearch!?"  That
sounds fantastically inefficient, and a great way to DoS us.  So I
decided to dig deeper.

The comment was to do with fetching examples for aggregates.  You can
use aggregate examples to get sample documents for things which you're
aggregating over.  [Click here to see it in action][]: that search is
getting 5 organisations and, for each, getting 5 example documents.

The way these examples work is by first making a query to
Elasticsearch to do the normal search and get the aggregate buckets
(list of organisations, in this case), and then making additional
queries to get the examples.  I tried to rewrite the code to make all
that happen in a single Elasticsearch query, but unfortunately our
aggregate examples are too featureful: I couldn't figure out an
equivalent Elasticsearch query, and suspect that one doesn't exist.

So what did I change?

Previously, no matter how many buckets you requested, search-api would
fetch examples for all of them.  There are 1097 organisations, so
previously search-api would have fetched examples for *all 1097 of
them*, figured out which 5 to return in the response, and then thrown
away the unneeded 1092 sets of examples.  That's a bit wasteful.

[Now it doesn't do that.][]

[Click here to see it in action]: https://www.gov.uk/api/search.json?count=0&facet_organisations=5,examples:5,example_scope:global
[Now it doesn't do that.]: https://github.com/alphagov/search-api/pull/1924

### Ignoring broken SSL stuff

One of the components of the GOV.UK stack is the [link-checker-api][],
which tells you if a link is broken and how it's broken.  This is used
by publishing apps to check links in content, and by
[local-links-manager][] to report which local authority websites have
changed their stuff and broken GOV.UK (they do that a lot).

To give you some idea of scale, there are currently about 20,500
broken or missing local authority links.  It's pretty much impossible
to keep on top of.

But we had reason to suspect that link-checker-api was being a bit
overzealous.  One of the more common classes of error was about SSL
certificates, but the links usually worked fine when opened in a
browser.  So what was going on?

There was a lot of reading of cryptic OpenSSL output.

```
$ openssl s_client -servername www.wokingham.gov.uk -connect www.wokingham.gov.uk:443
CONNECTED(00000003)
depth=0 OU = Domain Control Validated, OU = Issued through Wokingham Borough Council E-PKI Manager, OU = COMODO SSL Unified Communications, CN = *.wokingham.gov.uk
verify error:num=20:unable to get local issuer certificate
verify return:1
depth=0 OU = Domain Control Validated, OU = Issued through Wokingham Borough Council E-PKI Manager, OU = COMODO SSL Unified Communications, CN = *.wokingham.gov.uk
verify error:num=21:unable to verify the first certificate
verify return:1
---
Certificate chain
 0 s:OU = Domain Control Validated, OU = Issued through Wokingham Borough Council E-PKI Manager, OU = COMODO SSL Unified Communications, CN = *.wokingham.gov.uk
   i:C = GB, ST = Greater Manchester, L = Salford, O = COMODO CA Limited, CN = COMODO RSA Domain Validation Secure Server CA
---
Server certificate
-----BEGIN CERTIFICATE-----
MIIHKjCCBhKgAwIBAgIQXKP8A1NtSSoihHROd9dJfjANBgkqhkiG9w0BAQsFADCB
kDELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxNjA0BgNV
BAMTLUNPTU9ETyBSU0EgRG9tYWluIFZhbGlkYXRpb24gU2VjdXJlIFNlcnZlciBD
QTAeFw0xODEyMDYwMDAwMDBaFw0yMDEyMDUyMzU5NTlaMIGtMSEwHwYDVQQLExhE
b21haW4gQ29udHJvbCBWYWxpZGF0ZWQxPzA9BgNVBAsTNklzc3VlZCB0aHJvdWdo
IFdva2luZ2hhbSBCb3JvdWdoIENvdW5jaWwgRS1QS0kgTWFuYWdlcjEqMCgGA1UE
CxMhQ09NT0RPIFNTTCBVbmlmaWVkIENvbW11bmljYXRpb25zMRswGQYDVQQDDBIq
Lndva2luZ2hhbS5nb3YudWswggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
AQDYoet0dWbzJn9SHFBU0PVkJsojM0UgRuz7dXZi+FbuaGg/9UPGK4pKoECWww7G
dJ8g8CtMniotRGEyeOr3ctzJeFWEadN6Dct3yhDBr/NnAZjxWeTOT9e/ncnY+i1H
w1aVpuvU3Y+YpXMCx3p46Q1I0T/g7uBO2eYIa4hdI2DLKi1Comg5nae1ssyHLV4U
KgQkx1In0Z7AKFCDKDj8jogUXvW6L5hfioYSTfO32T+915PkpPspU0cBe0K5yU/O
8yxGCnKuadrLKYZo0hxoGNKF+KxkCi96buwhUaM/zg1Tn01J2+yvYCITEfNLGxQ0
XfZwI7dh9WCPUrYoOqoBnn5BAgMBAAGjggNfMIIDWzAfBgNVHSMEGDAWgBSQr2o6
lFoL2JDqElZz30O0Oija5zAdBgNVHQ4EFgQUOxiPksZGcw+Wwvwv20vtX8YIoy4w
DgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUH
AwEGCCsGAQUFBwMCME8GA1UdIARIMEYwOgYLKwYBBAGyMQECAgcwKzApBggrBgEF
BQcCARYdaHR0cHM6Ly9zZWN1cmUuY29tb2RvLmNvbS9DUFMwCAYGZ4EMAQIBMFQG
A1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0NPTU9ET1JT
QURvbWFpblZhbGlkYXRpb25TZWN1cmVTZXJ2ZXJDQS5jcmwwgYUGCCsGAQUFBwEB
BHkwdzBPBggrBgEFBQcwAoZDaHR0cDovL2NydC5jb21vZG9jYS5jb20vQ09NT0RP
UlNBRG9tYWluVmFsaWRhdGlvblNlY3VyZVNlcnZlckNBLmNydDAkBggrBgEFBQcw
AYYYaHR0cDovL29jc3AuY29tb2RvY2EuY29tMCoGA1UdEQQjMCGCEioud29raW5n
aGFtLmdvdi51a4ILb3B0YWxpcy5vcmcwggF/BgorBgEEAdZ5AgQCBIIBbwSCAWsB
aQB2ALvZ37wfinG1k5Qjl6qSe0c4V5UKq1LoGpCWZDaOHtGFAAABZ4PemmYAAAQD
AEcwRQIhANLghMHaEmuVQ6eI5+uZ+R26U5fxWDOEu12ooV6w3fdtAiB3ajcmerZh
oxn+UCnjG4m819PHqsT83Nbo3iJIjaBjIwB2AF6nc/nfVsDntTZIfdBJ4DJ6kZoM
hKESEoQYdZaBcUVYAAABZ4Pemq8AAAQDAEcwRQIgY6dp4+d62PhwPI7bi6HPGzRp
+G71oyVB9jgVB9pRmD0CIQDxl9I8TDLcdleY3LoBMIQi9OjOxf9QqwJemA+zsVeP
qwB3APCVpFnyANGCQBAtL5OIjq1L/h1H45nh0DSmsKiqjrJzAAABZ4PemrEAAAQD
AEgwRgIhAKeH/M53jLw0ytFMP8C771+FTlFxSvttH0Jmsp9hVgaZAiEA+IxpP5kj
T5d+HQi2LJ2wqE7pB8EXMMSLgY0GXT/lqr0wDQYJKoZIhvcNAQELBQADggEBAAoJ
fWxQNnjYpBLCR1FGsfdiEerUnY3nbBt+7PyNXPhujratodFIzHc3e5B1JHcxSlt8
4uD0FDDqDc0Ou2cQFHq7neyXy4BmXxjSGWkY1RF/3gtRfRV/c5E5/4sulu5EVTXI
0kTz1fQO58/po0dFWXtsIdJo/0AcW2U/EkZWhmozHFNxCbugd65B/Gh6IxQbbNO6
odet5v5d9A3BfqesngIEUeDwdYQeozek7ZvG7Qf9ijJTuKmNlnoyLmLkZVAjhTUY
kv7y7zDSQf7oV1715AzVGtUoDsG0Kl1CRKDVvaxn9GlEWG6UUWWcMi7v7u43hpz7
TLx77cAn16IlH0EDndw=
-----END CERTIFICATE-----
subject=OU = Domain Control Validated, OU = Issued through Wokingham Borough Council E-PKI Manager, OU = COMODO SSL Unified Communications, CN = *.wokingham.gov.uk

issuer=C = GB, ST = Greater Manchester, L = Salford, O = COMODO CA Limited, CN = COMODO RSA Domain Validation Secure Server CA

(...)
```

But eventually I had the answer.  When you get an SSL certificate,
it's usually not signed by the root certificate of the CA directly,
it's signed by an intermediate certificate.  That intermediate
certificate itself may be signed by another intermediate certificate,
and so on.  Eventually you'll get to a cerfificate which *has* been
signed by the root.

To verify that a certificate is correct, you need the full chain of
intermediate ones.  A lot of local authority websites (and a lot of
websites in general) are incorrectly configured, and *don't* send the
intermediate certificates.  So link-checker-api was unable to verify
the certificate, and complained.

Browsers cache certificates, so if you visit a website which *does*
serve the missing intermediate certificate, then the broken website
will start to work.  I experienced this while debugging, when one
website failed to load in Firefox, and then all of a sudden started to
work after I'd been browsing other sites.

As we're not in the business of monitoring others' websites for
configuration issues, and what we really care about is if the link is
*broken*, [I downgraded SSL problems to a warning][].  In one fell
swoop I "fixed" 999 broken links.

[link-checker-api]: https://github.com/alphagov/link-checker-api
[local-links-manager]: https://github.com/alphagov/local-links-manager
[I downgraded SSL problems to a warning]: https://github.com/alphagov/link-checker-api/pull/331

### Requesting comments

At the beginning of the month I [opened an RFC][] about storing
attachment metadata in content items, not just the rendered HTML.
Originally I had quite a tightly-scoped RFC with a narrow use-case in
mind, but it turned out that this would be *really useful* for the
team working to get rid of [whitehall][].  So the RFC has grown a fair
bit, has had a lot of input, and I've had to push back the deadline.

But it seems like all the major issues have been discussed now, so
hopefully there won't be too much change in this final week.

[opened an RFC]: https://github.com/alphagov/govuk-rfcs/pull/116
[whitehall]: https://github.com/alphagov/whitehall

## Miscellaneous

### Giving BookDB some long-overdue attention

[BookDB][] is probably my longest-lived piece of software at this
point.  It's been rewritten a few times, but the current incarnation
is pretty old.  The deployment approach never really evolved as I
learned how ops stuff "should" be done.  Here's how it worked until
Sunday:

- I'd clone the bookdb git repo on my VPS
- Compile it
- Stop the systemd unit
- Copy the binary to the right place
- Start the systemd unit

It would occasionally break because it would dynamically link against
libraries which got deleted by the NixOS garbage collector, because I
never bothered to write up a proper Nix package for it.  So I'd have
to recompile it, and then it would break in exactly the same way a
month or so later.  There was no automatic deployment.  The systemd
unit ran it as my user.  There was a config file not in version
control.  Really, it wasn't in a good state.

So this weekend I gave it some attention:

- I made it use postgres, rather than sqlite ([60b8909][])
- Put all the configuration in environment variables ([bb272df][])
- Finally ripped out the last remnants of my homebrew web framework
  and switched to a standard one ([0774a4a][])
- Wrote a Dockerfile ([764cc93][]) and changed the systemd unit to use
  docker-compose ([0444703][], [26de36f][])
- Wrote a Concourse pipeline for continuous deployment ([e4e5000][])

And now BookDB is less of a special snowflake.

[BookDB]: https://bookdb.barrucadu.co.uk/list
[60b8909]: https://github.com/barrucadu/bookdb/commit/60b89098b93ac9deb01b7285d4023392ad810251
[bb272df]: https://github.com/barrucadu/bookdb/commit/bb272df638da78acbebd66ae750af754a127d07e
[0774a4a]: https://github.com/barrucadu/bookdb/commit/0774a4a3b4e3c392cd7d00362c8296ce68d548ea
[764cc93]: https://github.com/barrucadu/bookdb/commit/764cc93b4fe2e0fc5e8092c69acb076fc5f5117c
[0444703]: https://github.com/barrucadu/nixfiles/commit/044470335e607044f35e62bcf79e0126f1c54ff1
[26de36f]: https://github.com/barrucadu/nixfiles/commit/26de36fb241dfa73feff059d56a2c8db53dfcbfd
[e4e5000]: https://github.com/barrucadu/concoursefiles/commit/e4e5000ff826df44d69acb1554d53868ef34df5e

### Migrating away from Google Apps: from Docs to Notion

Last year I decided to migrate away from Google Apps, having
successfully migrated away from Google Search[^ddg].  [I switched to
ProtonMail][] in August, which left Calendar, Docs, and Photos.  I
don't use the rest of the suite.

[^ddg]: I use Duck Duck Go for all searches by default now, and only
  turn to Google when DDG fails to find what I'm looking for, which
  isn't that frequent.

[ProtonMail announced that they were making a calendar][], so I
thought I'd just wait for that, and then stopping using Docs and
Photos would be easy because I barely use those at all.  However, I've
found that I use Docs more than I thought I did.  I often use it for
writing up notes before my Call of Cthulhu sessions:

![Excerpt of a Google Doc used for Call of Cthulhu session planning.](weeknotes-071/docs.png)

So I decided to find a replacement for Docs.

In a thread about campaign management software on [/r/rpg][], I found
[Notion][].  It's kind of like an integrated wiki / project management
/ database system.  It's got a lot of functionality, but doesn't feel
overwhelming, and lets you make templates for common tasks.  I whipped
up a Masks of Nyarlathotep page:

![Screenshot of a Notion page with Masks of Nyarlathotep information.](weeknotes-071/notion.png)

I've not filled in all of those subpages, only the overview, music,
pre- and post-session checklists, and the most recent set of Kenya
session notes.  The rest is there to get some idea of what it would be
like if I'd started using it to plan the campaign from the beginning.

So far I've only thought about how I *could* use Notion to plan a
session; I've not actually done it yet.  I'll be able to report on
that in the next weeknote instalment.

[I switched to ProtonMail]: weeknotes-046.html
[ProtonMail announced that they were making a calendar]: https://protonmail.com/blog/protoncalendar-beta-announcement/
[/r/rpg]: https://old.reddit.com/r/rpg
[Notion]: https://www.notion.so

### Planning and Prioritisation

I've been using Trello, with great success, as a to-do list since
June 2018.  My "Life (Done)" board has amassed 588 tickets, and there
are currently 37 on the "Life" board due to move over at the end of
the month.  Some of the tickets are repeating things like "Weekly
Routine" or "Monthly Routine", but most of them are unique.  I think
it's fair to say that I've significantly improved my ability to both
remember tasks and complete them since starting this.  My Trello board
is one of the three tabs I have permanently open in Firefox: along
with Google Calendar and ProtonMail.

Unfortunately, my "To Do" and "Some day / Maybe" lists have amassed a
lot of cruft.  Some tickets have been there for a year or more.  So
I'm wondering about a way to address that.  I don't want to prioritise
all the tickets and work through them in priority order, because I
think they're genuinely unorderable.  I'm sure there's a partial order
there, but not a total one.  Similarly, I don't want to work through
them in chronological order, because some tickets *are* more important
than others!

So I've been wondering about better ways of organising them.  There
are a few options:

- **Aggressive pruning:** if a ticket sticks around for more than some
  predetermined period of time, like three months, just get rid of it.

- **Plan tasks in sprints:** I could have two lists, "backlog" and
  "this sprint", and every week (or fortnight, whatever) move a set of
  tickets over from the backlog.  I'd then only pick up tasks from the
  "this sprint" list.  As new tasks come in they'd be put in the
  backlog, if they're not urgent, or "this sprint", if they are.

- **Assign tasks into very rough priority groups:** one approach to
  prioritising tasks is called the [Eisenhower Matrix][], where tasks
  are grouped into one of four categories depending on their
  importance and urgency:

  - *Important and urgent:* do now
  - *Important, but not urgent:* plan when to do
  - *Not important, but urgent:* delegate
  - *Neither important nor urgent:* eliminate

  Sadly, I don't have someone to delegate my personal tasks to, so I'd
  have three categories:

  - *Urgent:* do now
  - *Important:* plan when to do
  - *Neither urgent nor important:* eliminate

  I'm not too sure about eliminating tasks either, as I feel like I
  have a lot of tasks which are neither important nor urgent, but are
  kind of nice-to-haves.  For example, writing up my muffin recipe
  (which has been on the list since January last year), which I may do
  at some point when I've got some free time.

My current "To Do" and "Some day / Maybe" lists are *supposed* to be
like the rough priority group approach, with "To Do" being things
which should be worked on soon, and "Some day / Maybe" being things
which can be worked on when there's nothing more important.  But it's
not working.  I'm leaning towards a combination of the three approaches,
giving something like this:

- *Urgent:* do now
- *This Sprint:* aim to do this sprint, urgent tasks permitting
- *Upcoming:* important tasks, to be brought into sprints
- *Backlog:* neither important nor urgent, to be done if there's some
  free time, and things deleted from this when they get too old

Now I just need to decide what appropriate sprint and pruning
frequencies would be.

[Eisenhower Matrix]: https://www.developgoodhabits.com/eisenhower-matrix/

## Link Roundup

- [How is computer programming different today than 20 years ago?](https://medium.com/swlh/how-is-computer-programming-different-today-than-20-years-ago-9d0154d1b6ce)
- [The Amazing Psychology of Japanese Train Stations](https://www.citylab.com/transportation/2018/05/the-amazing-psychology-of-japanese-train-stations/560822/)
- [The Edge of Emulation](https://byuu.org/articles/edge-of-emulation)
- [Trade-offs under pressure: heuristics and observations of teams resolving internet service outages (Part 1)](https://blog.acolyer.org/2020/01/22/trade-offs-under-pressure-part-1/)
- [Trade-offs under pressure: heuristics and observations of teams resolving internet service outages (Part II)](https://blog.acolyer.org/2020/01/24/trade-offs-under-pressure-part-2/)
- [This Week in Rust 322](https://this-week-in-rust.org/blog/2020/01/21/this-week-in-rust-322/)
- [pledge() and unveil() in SerenityOS](https://awesomekling.github.io/pledge-and-unveil-in-SerenityOS/)
- [Gödel’s Ontological Argument](https://plato.stanford.edu/entries/ontological-arguments/#GodOntArg)
- [Forget About Setting Goals. Focus on This Instead.](https://jamesclear.com/goals-systems)
- [Issue 195 :: Haskell Weekly](https://haskellweekly.news/issue/195.html)
- [Dhall for Kubernetes](https://christine.website/blog/dhall-kubernetes-2020-01-25)
- [Haskell Problems For a New Decade](http://www.stephendiehl.com/posts/decade.html)
- [How To Run Your Life Inside of Notion](https://superorganizers.substack.com/p/how-to-run-your-life-inside-of-notion)
