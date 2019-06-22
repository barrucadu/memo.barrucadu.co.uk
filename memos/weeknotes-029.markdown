---
title: "Weeknotes: 029"
tags: weeknotes
date: 2019-04-07 21:30:00
audience: General
---

## Work

- This week we rolled out the upgrade to Elasticsearch 5 to production
  and, to make it even better, we did that in the middle of some
  [network connectivity problems][] which were breaking the
  Elasticsearch 2-powered bits of the site.  This came after we
  finished analysing the results of the top 10,000 search terms drawn
  from a 6-month period, and didn't find any changes significant
  enough to cause concern.

  I'm told this migration will result in savings of £35,000 a
  year[^35k] but, oddly, the letter announcing my immediate £35k raise
  doesn't seem to have come through.

- I found out what's going on next quarter.  I'll be on the
  "Bravigation" team, or the "Brexit Navigation" team, or the "Making
  Brexit Content Easier To Find" team (depending on how formal you're
  being), which covers a few different search-related tasks.  One of
  those tasks is upgrading to Elasticsearch 6, which hopefully won't
  take the full quarter this time.  I believe they also want to look
  into using newer Elasticsearch features, now that we're not on quite
  so ancient a version.

[network connectivity problems]: https://status.publishing.service.gov.uk/incidents/s0fj6yqdz6wp

[^35k]: I believe a big chunk of this number is based on an estimate
    of developer-time required for future upgrades, as new
    Elasticsearch versions come out frequently.  We weren't spending
    £35,000 extra on VMs (I hope).

## Miscellaneous

- A set up [Pleroma][], an [ActivityPub][] server, so that I could
  have the CI job which builds memo.barrucadu.co.uk [send a
  notification][].  The script to send the notification is in [the
  memos git repository][].

- I switched my CI from [Jenkins][] to [Concourse][].  I [wrote a
  memo][] which talks about how I set it up and gives some motivation.
  If you're reading this memo, it's working.

- I read [Roadside Picnic][], a book about the aftermath of aliens
  visiting Earth, not noticing humans at all, and leaving behind a
  bunch of junk.  It was enjoyable.

[Pleroma]: https://pleroma.social/
[ActivityPub]: https://www.w3.org/TR/activitypub/
[send a notification]: https://ap.barrucadu.co.uk/users/memo
[the memos git repository]: https://github.com/barrucadu/memo.barrucadu.co.uk/blob/master/post-pleroma-status
[Jenkins]: https://jenkins.io/
[Concourse]: https://concourse-ci.org/
[wrote a memo]: concourseci-nixos.html
[Roadside Picnic]: https://en.wikipedia.org/wiki/Roadside_Picnic

## Link Roundup

- [New studies confirm existence of galaxies with almost no dark matter](https://news.yale.edu/2019/03/29/new-studies-confirm-existence-galaxies-almost-no-dark-matter)
- [Dubstep artist Skrillex could protect against mosquito bites](https://www.bbc.co.uk/news/newsbeat-47770982)
- [This Week in Rust 280](https://this-week-in-rust.org/blog/2019/04/02/this-week-in-rust-280/)
- [Issue 153 :: Haskell Weekly](https://haskellweekly.news/issues/153.html)
- [Speeding up GROUP BY in PostgreSQL](https://www.cybertec-postgresql.com/en/speeding-up-group-by-in-postgresql/)
- [On Being A Senior Engineer](https://www.kitchensoap.com/2012/10/25/on-being-a-senior-engineer/)
- [93% of Paint Splatters are Valid Perl Programs](http://colinm.org/sigbovik/)
