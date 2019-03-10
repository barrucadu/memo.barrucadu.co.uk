---
title: "Weeknotes: 025"
tags: weeknotes
date: 2019-03-10
audience: General
---

## Work

- This week I went on support on Wednesday.  Before then I did some
  smallish tasks relating to upgrading elasticsearch: updating our
  data sync process[^data_sync] to work with an AWS managed
  elasticsearch 5; and wrote a plan for how we do the final steps of
  switching off the elasticsearch 2 service and removing the stuff
  we've put in place to support two search services running in
  parallel.

- On Wednesday morning the GOV.UK frontend apps migrated to AWS.  This
  has been in the works for a while, and has so far made for a busy
  few days.  Everything has mostly worked, but there have been a few
  issues:

  - Some of our apps in AWS were running a fairly old version, and
    needed to be re-deployed to the correct versions.
  - Problems with redirects and hostnames, now that we have a few new
    not-publicly-routable hosts.
  - On Thursday morning we restored (rather than took) a backup of our
    [router][] database, which meant anything published on the 6th
    existed in the content API, but couldn't be accessed.
  - We had a bunch of assets from old deploys in our old hosting
    provider, which didn't exist in AWS.  Some people were hotlinking
    these (which we say you shouldn't do, but they do).
  - The secret key used to generate [JSON web tokens][] was
    inconsistent between the two environments, so links to manage your
    email subscription preferences didn't work.
  - The robots.txt was configured to block everything.

  So it's been pretty hectic at times, but on the other hand this is a
  good way to test a *lot* of assumptions our code makes, and to make
  things more robust for the future.

  I've also "solved" a huge number of support tickets now, because
  I've been the one replying to them saying "Yes, we had a problem,
  but it's fixed now."

- Other than AWS migration issues, the biggest proportion of support
  work is [data.gov.uk][] related.  Of the 17 open tickets currently,
  12 of them are about data.gov.uk.  I think we do seem to be solving
  entire classes of problems and reducing the support burden,
  gradually, but there's still a way to go.

[^data_sync]: The process which copies production data to our staging
  and integration environments nightly, so we have realistic test
  data.

[router]: https://github.com/alphagov/router
[JSON web tokens]: https://jwt.io/
[data.gov.uk]: https://data.gov.uk/

## Miscellaneous

- I read [We Sold Our Souls][], about a metal band who... sold their
  souls.  Terry, one member of the band, made a deal to be a famous
  musician, and rather than sell his own soul he used the souls of his
  bandmates.  The book follows Kris, one of the band members, who
  figures out (decades later) that something is up, and goes to
  confront Terry.

  It was an enjoyable read, I got through it in one sitting, but a key
  component of the story just doesn't make sense.  The last album Kris
  wrote before her soul was sold, Troglodyte, turns out to be
  prophetic, and guides her in circumventing Terry's eyes and ears
  (which are everywhere).  It's made pretty clear that the devils (for
  lack of a better term) feel threatened in some way by Troglodyte,
  and that's why they want Kris caught.

  But as Troglodyte was written before her soul was sold, is it just a
  coincidence that it prophesies a way to confront Terry?  Why would a
  normal person have the gift of prophecy?  It would make more sense
  if she wrote the album after she lost her soul, but another key part
  of the story is that soulless people can't be truly creative or
  inspired, so that wouldn't have worked either.

  Good book, as long as you don't think about it.

- I gave [Spacemacs][] a go, which is Emacs set up to work nicely with
  [evil][], the extensible Vi layer for Emacs.  It also has a
  different configuration system than regular emacs, based on
  self-contained community-contributed chunks of configuration called
  "layers".  I was mostly interested in the layers system, because my
  Emacs config has a lot of cruft.

  One thing I immediately discovered is that there's loads of
  "Spacemacs for Vi users" blog posts and guides, but almost no
  "Spacemacs for Emacs users".  In fact, one such guide I found
  recommended that an Emacs user learn Spacemacs by making Vi their
  main editor for a month or two first!  I didn't much like the idea
  of using a strictly inferior editor[^holy_war], so I decided to
  struggle on with my limited knowledge of Vi commands: `dd`, `:wq`,
  `i`, and `esc`.

  To my surprise, I didn't like the "layers" configuration model but
  *did* like the evil integration.  Layers felt like too much
  conceptual abstraction.  Also it wouldn't let me use `C-c` as a
  leader key, which I've been doing in my regular Emacs config for
  ages now, and I didn't want to give up that muscle memory.  There's
  probably a way to unbind what was bound to `C-c` but it wasn't
  immediately obvious and I didn't know what to look for.

  So I spent a little time on Friday and Saturday going through my
  Emacs config: removing things I didn't use, adding evil integration,
  looking for new things.  Sometimes it's nice to go over the
  configuration of a tool you use every day and make sure it's still
  set up in the way you like.

[^holy_war]: Emacs is "Vi complete" but Vi is not "Emacs complete":
  [evil][] is just a regular emacs package, whereas [vile][] (Vi Like
  Emacs) is a totally new editor.

[We Sold Our Souls]: https://en.wikipedia.org/wiki/We_Sold_Our_Souls
[Spacemacs]: http://spacemacs.org/
[evil]: https://github.com/emacs-evil/evil
[vile]: https://invisible-island.net/vile/vile.html

## Link Roundup

- [This Week in Rust 276](https://this-week-in-rust.org/blog/2019/03/05/this-week-in-rust-276/)
- [Issue 149 :: Haskell Weekly](https://haskellweekly.news/issues/149.html)
