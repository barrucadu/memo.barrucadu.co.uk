---
title: "Weeknotes: 058"
taxon: weeknotes-2019
date: 2019-10-27
---

## Work

- Not that much this week, again; though it's because I was covering
  support on Tuesday, and then off sick on Wednesday and Thursday.

- I changed the metric we use to evaluate search performance from DCG
  to nDCG, and [wrote a long commit message about why][], which got me
  wondering what my most well-explained commit was.  I came up with
  this script to rank my commits by proportion of commit message to
  commit diff:

  ```bash
  for hash in $(git log --format='%H' --no-merges --author=mike@barrucadu.co.uk); do
    msg_len=$(git show --format='%B' --no-patch $hash | wc -c)
    full_len=$(git show --format='%B' $hash | wc -c)
    echo -e "$(echo "($full_len - $msg_len) / $msg_len" | bc -l)\t$(git show --oneline --no-patch $hash)"
  done | sort -h
  ```

  Smaller numbers mean more explanation than diff.  My most
  well-explained commit in search-api is:

  ```
  commit f9410c9a7c4c8c4664125103d225eb83ddfba967
  Author: Michael Walker <mike@barrucadu.co.uk>
  Date:   Fri Apr 5 12:04:09 2019 +0100

      Bump limit of default sidekiq queue to 8

      We've occasionally seen a build up of sidekiq jobs (in both search-api
      and rummager).  I experimented by bumping the limit on the "default"
      queue to 8 via the app console during one such spike: the jobs cleared
      much faster than in rummager (which still had the limit of 4), and the
      Elasticsearch search latency increased by maybe a couple of
      milliseconds - it's hard to say because any increase is small enough
      to be obscured by the natural variability of the metric.

      These limits were added to solve a problem, but that problem occurred
      with an almost totally different search architecture, so I think it's
      worth experimenting with the limits a bit.  They could perhaps be
      increased further, but let's see how this change performs for now.

  diff --git a/config/sidekiq.yml b/config/sidekiq.yml
  index 46a23a0b..1706eef3 100644
  --- a/config/sidekiq.yml
  +++ b/config/sidekiq.yml
  @@ -12,4 +12,4 @@ production:
     - bulk
   :limits:
     bulk: 4
  -  default: 4
  +  default: 8
  ```

  My least well-explained commits all seem to be refactoring commits,
  and that trend holds across a few different repositories (including
  non-work ones).

[wrote a long commit message about why]: https://github.com/alphagov/search-api/commit/111b06f262808b8ace9d819b3a244452165b389c

## Miscellaneous

- I got a letter from HMRC saying I'd paid £2037 too much tax last
  year, so as soon as I claimed that back I bought an [Oculus Quest][]
  and some games: [Beat Saber][], [I Expect You To Die][], and
  [Moss][].  It arrived on Saturday morning, and I've spent a lot of
  this weekend in VR.  Unlike other VR headsets, the Quest is entirely
  self-contained and doesn't need external sensors or a connection to
  a computer (though next month it is getting the ability to play PC
  VR games if connected by a cable).  I'm really impressed with how
  well it works, though some things---like browsing the web in
  VR---are a bit clunky, due to the limited number of buttons on the
  controllers.  But for gaming it's great.

- I read a few books this week:
  - [The Fires of Heaven][] (by Robert Jordan), the fifth book in the
    Wheel of Time series.
  - The Dark Warrior and The Bloody Valkyrie, volumes 2 and 3 of
    [Overlord][] (by Kugane Maruyama).

- I had an idea for how to make a searchable local academic database:
  for each paper, write a little metadata (bibliographic data + a list
  of references) and use [tesseract][] to extract the contents of the
  PDF as text.  Plug all that into Elasticsearch, and you've got your
  own academic database.  [I had a go][], and it seems like it would
  work pretty well.

[The Fires of Heaven]: https://en.wikipedia.org/wiki/The_Fires_of_Heaven
[Overlord]: https://en.wikipedia.org/wiki/Overlord_(novel_series)
[tesseract]: https://github.com/tesseract-ocr
[I had a go]: https://twitter.com/barrucadu/status/1186764623330119680
[Oculus Quest]: https://www.oculus.com/quest/
[Beat Saber]: https://beatsaber.com/
[I Expect You To Die]: https://iexpectyoutodie.schellgames.com/
[Moss]: https://www.polyarcgames.com/moss

## Link Roundup

- [What Type Soundness Theorem Do You Really Want to Prove?](https://blog.sigplan.org/2019/10/17/what-type-soundness-theorem-do-you-really-want-to-prove/)
- [What About the Natural Numbers? by José Manuel Calderón Trilla [PWLConf 2019]](https://www.youtube.com/watch?v=jFk1qpr1ytk)
- [This Week in Rust 309](https://this-week-in-rust.org/blog/2019/10/22/this-week-in-rust-309/)
- [Rats taught to drive tiny cars to lower their stress levels](https://www.bbc.co.uk/news/world-us-canada-50167812)
- [Simon Marlow, Simon Peyton Jones, and Satnam Singh win Most Influential ICFP Paper Award](https://engineering.fb.com/security/simon-marlow/)
- [Issue 182 :: Haskell Weekly](https://haskellweekly.news/issue/182.html)
