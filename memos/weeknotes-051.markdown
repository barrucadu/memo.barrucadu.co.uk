---
title: "Weeknotes: 051"
taxon: weeknotes-2019
date: 2019-09-08
---

## Work

- I finally finished my long support shift on Tuesday.

- On Friday I put live an A/B test for [the new (new) search query][],
  which performed pretty well for the handful of queries we manually
  checked.  But ultimately the only way to know if it's good or not is
  to put it in front of a lot of users and see what the aggregate
  metrics say.  We also want to be careful about making search worse
  at the moment, as people are probably relying on GOV.UK a bit more
  currently than they normally would, so only 1% of traffic is getting
  the new query.

- I made the first step towards [bringing back search spelling
  suggestions][].  This is a feature which did exist, but got lost
  when we changed how search worked a while back.  There are two bits
  of work in bringing this back: the backend work to fetch spelling
  suggestions from search-api (which this PR achieves), and some
  frontend / design work to figure out how to present suggestions to
  the user.  Our search interface is pretty cluttered on mobile, so
  the design bit is going to be the hard part.  You can see it in
  action by going to [/search/all.json?keywords=funance][] and looking
  at the `suggestions` key.

  Possible future work here is making it smarter than just correcting
  a single word at a time.  For example, if you search for "drving
  loicence" it suggests "drving licence", and if you search for that
  it suggests "driving licence".  It would be better to go straight to
  the final suggestion, without needing the intermediate search.

- I did some investigation into how we handle provisioning new
  machines, as we get a burst of errors whenever we switch on a new
  search machine.  Ultimately it turns out that our health checks,
  which determine if a machine can be added to a load balancer's
  active pool, [aren't very good for search][]; they only check the
  machine is running, not that the app is running.

- I started looking into how to better handle searches with quoted
  fragments.  These four queries all give different results if you
  search for them in Google:

  1. `"marzipan shoes"` (least results)
  2. `"marzipan" shoes`
  3. `marzipan "shoes"`
  4. `marzipan shoes` (most results)

  The behaviour seems to be that quoted fragments are exactly matched
  against the content (and are required), whereas the unquoted
  fragments are fuzzily matched (and aren't required).  In contrast,
  GOV.UK search treats cases 2, 3, and 4 all the same: we only do
  something different if the entire query is quoted.  I don't like
  that, so I'm working on a way to make it more Google-y, as I suspect
  that is what other people expect too.

[the new (new) search query]: https://github.com/alphagov/search-api/pull/1669
[bringing back search spelling suggestions]: https://github.com/alphagov/finder-frontend/pull/1481
[/search/all.json?keywords=funance]: https://www.gov.uk/search/all.json?keywords=funance
[aren't very good for search]: https://github.com/alphagov/govuk-aws/pull/1096

## Miscellaneous

- I read [Downward to the Earth][] (by Robert Silverberg)[^700].  It
  was about colonialism and about what makes humanity different to
  animals, set on an alien world which was once humanity's possession,
  but was returned to its native inhabitants.  It was really good.

- I've played a lot of [Rise to Ruins][] this week.  It's difficult,
  but I'm gradually getting better I think.

[^700]: Which is my newest book, and the 700th entry in [bookdb][].

[Downward to the Earth]: https://en.wikipedia.org/wiki/Downward_to_the_Earth
[bookdb]: https://www.barrucadu.co.uk/bookdb/
[Rise to Ruins]: https://risetoruins.com/

## Link Roundup

- [Green Threads Explained in 200 Lines of Rust](https://cfsamson.gitbook.io/green-threads-explained-in-200-lines-of-rust/)
- [First there was SkyKnit. Now there’s HAT3000](https://aiweirdness.com/post/187489831262/first-there-was-skyknit-now-theres-hat3000)
- [John Carmack on Inlined Code](http://number-none.com/blow/john_carmack_on_inlined_code.html)
- [Issue 175 :: Haskell Weekly](https://haskellweekly.news/issues/175.html)
- [NixOS Weekly #12 - Mobile NixOS, import-from-derivation, one-page introduction, runtime type-checker, a job](https://weekly.nixos.org/2019/12-mobile-nixos-import-from-derivation-one-page-introduction-runtime-type-checker-a-job.html)
- [This Week in Rust 302](https://this-week-in-rust.org/blog/2019/09/03/this-week-in-rust-302/)
