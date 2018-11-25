---
title: "Weeknotes: 010"
tags: weeknotes
date: 2018-11-25
audience: General
---

## Ph.D

- Nothing to report, I didn't much fancy trying to do work on a
  computer which was crashing and rebooting every hour.

## Work

- This week my team shifted focus to investigating if we can use our
  "finders" (for example, the [AAIB][], [MAIB][], and [RAIB][] report
  finders) to search through arbitrary documents.  Currently our
  finders are set up to search through a specific type of document,
  determined by the finder, and the type of the document determines
  the metadata which you can filter by.  We instead wanted to find out
  if we could tag arbitrary documents with some given metadata, and
  then build a finder to search through all documents with those
  metadata fields.

  We quickly found that we could build a finder for this metadata if
  documents were tagged with it, but how to tag documents was another
  matter entirely.  We didn't really want to change every single
  publishing app.  The two applications which consume metadata are
  [rummager][] and the [email-alert-api][].  Tagging documents would
  be a fairly simple matter if all of our publishing apps talked to
  those via the [publishing-api][], as we could build something to sit
  in front of the publishing-api and add the needed tags.  But, due to
  hysterical raisins, our [whitehall][] app talks to rummager
  directly, and our [specialist-publisher][] and
  [travel-advice-publisher][] apps talk to the email-alert-api
  directly.

  So for now we have something sitting in front of rummager and the
  email-alert-api adding these tags in.  It's a bit unfortunate, as it
  means that the tags are not visible in our content API, but even
  worse the publishing-api is no longer the sole source of truth about
  a document.  We plan to move this all into the publishing-api at
  some point though.

[AAIB]: https://www.gov.uk/aaib-reports
[MAIB]: https://www.gov.uk/maib-reports
[RAIB]: https://www.gov.uk/raib-reports
[rummager]: https://github.com/alphagov/rummager
[email-alert-api]: https://github.com/alphagov/email-alert-api
[publishing-api]: https://github.com/alphagov/publishing-api
[whitehall]: https://github.com/alphagov/whitehall
[specialist-publisher]: https://github.com/alphagov/specialist-publisher
[travel-advice-publisher]: https://github.com/alphagov/travel-advice-publisher

## Miscellaneous

- I made a cottage pie, and it was very nice.  [I wrote up my
  recipe][].  There are no quantities; quantities in recipes are for
  people who lack discernment.

- On Friday I got a bunch of new hardware and built myself a new
  desktop computer and fileserver.  Finally, my hardware woes are
  over.  This is my first major upgrade in about 6 years, in that time
  I've only bought new hard drives and graphics cards.  I got a couple
  of [NVMe M.2 SSDs][] for my desktop, and I had to [look up a video
  on youtube][] to teach me how to plug them in, as I had no idea.

  I'm really impressed with the performance.  I'm used to Windows
  taking upwards of 5 minutes to boot and become fully responsive.  It
  now takes about 50 seconds for a cold boot, including POST.
  Excluding POST, Windows boots, logs in, and starts everything up in
  about 30 seconds.

- In my Call of Cthulhu campaign this week [the players have begun
  investigating][] the gruesome murder of their good friend Jackson
  Elias, after a four-year time skip.

[I wrote up my recipe]: /recipe-cottage-pie.html
[NVMe M.2 SSDs]: https://en.wikipedia.org/wiki/M.2
[look up a video on youtube]: https://www.youtube.com/watch?v=NCIqZjo34rw
[the players have begun investigating]: /masks-of-nyarlathotep.html

## Link Roundup

- [Issue 134 :: Haskell Weekly](https://haskellweekly.news/issues/134.html)
- [My favorite Haskell function](https://github.com/quchen/articles/blob/master/2018-11-22_zipWith_const.md)
- [On Programming Language Design](http://blog.ielliott.io/on-programming-language-design/)
- [Publishing with Apache Kafka at The New York Times](https://www.confluent.io/blog/publishing-apache-kafka-new-york-times/)
- [Symbiosis Ware](http://wiki.c2.com/?SymbiosisWare)
- [This Week in Rust 261](https://this-week-in-rust.org/blog/2018/11/20/this-week-in-rust-261/)
- [foone on Twitter: "my favorite thing about the "floppies on the space station" tweet (besides the all of it) is how the floppies have these silly little home-made-in-ms-word labels on them, or are hand-written.](https://twitter.com/Foone/status/1065024550310600704?s=19)
