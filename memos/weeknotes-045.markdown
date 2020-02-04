---
title: "Weeknotes: 045"
taxon: weeknotes-2019
date: 2019-07-28 19:30:00
---

## Work

- We had an incident to do with emails not being sent out this week,
  and in the process of fixing that we noticed that email
  subscriptions weren't being validated[^mom], so there were a bunch
  of junk subscription filters.  These were mostly created by bots (we
  think), so they hadn't actually signed up - just hit the page which
  created the filter in the database.  So I paired with an apprentice
  developer to [write a rake task][] to clear out filters with no
  subscribers.

- We ran a short A/B test for Elasticsearch 6, and it looked slightly
  worse than Elasticsearch 5 in terms of how many times people refined
  their search and which position result they clicked.  So we switched
  it off, and then I switched it back on again on Friday with a lower
  proportion of traffic going to ES6.  We're going to leave it for a
  week this time and see what it looks like.

- The search synonym for "Brexit" and "EU Exit" is [going to be
  removed][].  Regular content is being updated to use "Brexit"
  (because that's what everyone says), so "EU Exit" will only remain
  in places like official titles of publications and legislation.
  Those feel like distinct enough use-cases that the synonym will be
  dropped.  Unfortunately changing synonyms requires reindexing all
  the content, which prevents updates from getting into search while
  that runs.  So actually deploying the change has been delayed until
  next week, as there's been a lot of publishing activity over the
  past week (for some reason).

- I started thinking about how to load production data into
  [govuk-docker][], like we can with the development VM (which
  govuk-docker is supposed to be obsoleting).  I've now got a script
  which works for Elasticsearch, but it requires some changes to
  govuk-docker I'll need to put up for review.

  Developing this lead to me discovering an interesting problem where
  copying 15GB from the host (OSX) to the container would reliably
  hang after 6.4GB if I used `docker cp`.  But when I instead mounted
  the host directory into the container as a volume, and used `cp`
  inside the container, it worked flawlessly.  `docker cp` is
  definitely doing something weird.

[^mom]: For example, you could sign up to email alerts for the
    Ministry of Magic, despite no such organisation existing (I
    promise).

[write a rake task]: https://github.com/alphagov/email-alert-api/pull/912
[going to be removed]: https://github.com/alphagov/search-api/pull/1636
[govuk-docker]: https://github.com/alphagov/govuk-docker/

## Miscellaneous

- I've been thinking of switching away from gmail to some other email
  provider, and [ProtonMail][] seems a good candidate.  I'll probably
  write up a memo about how it went afterwards.

- I've decided to start making offline copies of blog posts and other
  online content I like, due to my older bookmarks having a tendency
  to 404.  My current approach is to copy all the text out of the page
  and add formatting back with Markdown.  I'm also storing a small
  amount of metadata for each page: title, original URL, original
  publication date, modification date (if given), and archive date.
  I'm manually adding the Markdown in at the moment, which works well
  enough for very wordy articles without much formatting or linking,
  but wouldn't really work for content where that's not the case.
  I'll need to think about how to handle that.

[ProtonMail]: https://protonmail.com/

## Link Roundup

- [Learning to code at GDS](https://gds.blog.gov.uk/2019/07/18/learning-to-code-at-gds/)
- [Think in Math. Write in Code.](https://justinmeiners.github.io/think-in-math/)
- [Pluralistic ignorance](https://en.wikipedia.org/wiki/Pluralistic_ignorance)
- [Tarot for Hackers](https://christine.website/blog/tarot-for-hackers-2019-07-24)
- [To Walk on the Path](https://write.as/mya249cn84nosg9r)
- [Issue 169 :: Haskell Weekly](https://haskellweekly.news/issues/169.html)
- [This Week in Rust 296](https://this-week-in-rust.org/blog/2019/07/23/this-week-in-rust-296/)
- [Migrating away from an (entrenched) gmail.com email address](https://lobste.rs/s/urxqti/migrating_away_from_entrenched_gmail_com)
- [Parable of the Gong](http://www.principiadiscordia.com/bip/8.php) (click "Next page" to see the other half)
- [Photographers, Instagrammers: Stop Being So D*mn Selfish and Disrespectful](https://petapixel.com/2019/07/22/photographers-instagrammers-stop-being-so-dmn-selfish-and-disrespectful/)
