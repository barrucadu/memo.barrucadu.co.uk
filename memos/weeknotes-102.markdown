---
title: "Weeknotes: 102"
taxon: weeknotes-2020
date: 2020-08-30 22:00:00
---

## Work

I took the week off work.  It was nice to relax, and I got through a
lot of stuff on my to-do list.


## Books

This week I read:

- Volume 13 of [Nana][], by Ai Yazawa.

  In which the two Nanas make up somewhat, but rifts continue to open
  in the social web, driving people apart.  This series has become so
  depressing, but I continue to read it...

- [The Body Politic][], by Jean-Jacques Rousseau.

  This was a good read, I expected it to be pretty dry and hard to get
  through---like some of the books in the Penguin Little Black
  Classics series---but it was really approachable.  I see why this
  became popular.  Though, Rousseau does seem *wildly* optimistic
  about democracy, in ways which the past few centuries have proven
  false.  For example, he says:

  > the public vote almost never raises to the foremost positions any
  > other than enlightened and capable men, who fill them with honour.

  That may be the case if all the electors *value* enlightened,
  capable, and honourable men; but history has taught us that that is
  not really the case.  The Nazi Party was elected after all.  They
  abused the system, true, but a political system needs to consider
  how it might be exploited, or there'd be no need for law at all: we
  could just elect enlightened and honourable judges and do everything
  by case law.


- Volume 1 of [The Book of the New Sun][], by Gene Wolfe.

  This was good, my second Dying Earth book, and I definitely want to
  look further into this genre now.  It's a neat premise to have
  humanity so far after their fall that science is basically magic and
  society is a weird mix of medieval practices (like a guild of
  torturers) and fantastic technology (like interstellar travel).

  It's also good to read these books which had such an influence on
  the early days of roleplaying games.  Vancian magic, for example,
  seems like a really cool way to me of making magic seem more
  magical; and yet it got removed from D&D, largely I suspect because
  barely any players were familiar with its origins, and so it just
  seemed like some weird and awkward rules with no benefit.

It is week 35, and I have read 68 books.  The gap narrows.

[Nana]: https://en.wikipedia.org/wiki/Nana_(manga)
[The Body Politic]: https://www.goodreads.com/book/show/29378569-the-body-politic
[The Book of the New Sun]: https://en.wikipedia.org/wiki/The_Book_of_the_New_Sun


## Miscellaneous

This week I've got through a lot of things on my to-do list: after 27
months and 903 completed cards the remaining ones all fit on one
screen without scrolling for the first time.

This week I've:

- Gone through almost all of my bookmarks (just a few hundred
  bookmarked as "to-read-later" remaining to examine), deleted most of
  them, and added the rest to my new [bookmarks search engine][].
  I've even gone through my huge youtube "likes" list for things that
  should really be bookmarks.

- Written a bookmarks search engine!  It's [on GitHub][].  I'm using
  the same deployment and security patterns as [bookdb][]: there's a
  read-only public version and a read-write version running on my home
  server; the local one periodically uploads its database to the
  public one; and continuous deployment is done through
  [barrucadu.dev][].

- Written up my [slow cooker chilli recipe][].

- Dockerised my deployments of [pleroma][]---on [ap.barrucadu.co.uk][]
  and [social.lainon.life][]---and set up weekly database backups and
  also automatic deployment of new stable Pleroma releases.  That's
  been on my to-do list for a long time.

  I also dockerised my local deployment of "finder", the manga scraper
  / browser I wrote.

  I'm finding "NixOS config which generates a docker-compose file and
  systemd unit" to be a nice way to handle things.  My backup scripts
  just need to run as a user in the `docker` group so they can run
  `docker cp` and `docker exec`, and continuous deployment can be done
  by giving Concourse permissions to SSH in and restart the unit
  (which pulls the image).

- Downloaded the archives for a couple of podcasts I've started to
  follow: [Voluminous - The Letters of H. P. Lovecraft][] and [The
  Good Friends of Jackson Elias][].

- And finally, this payday, met my goal of having £10,000 + 3 months
  expenses put aside as an emergency fund.  I've got a couple of
  smaller finance goals to still meet this year, then I'm going to
  reevaluate how much cash I'm saving and how much I'm investing (as
  hoarding cash has little point).

[bookmarks search engine]: https://bookmarks.barrucadu.co.uk/search
[on GitHub]: https://github.com/barrucadu/bookmarks
[bookdb]: https://bookdb.barrucadu.co.uk/search
[barrucadu.dev]: https://www.barrucadu.dev/
[slow cooker chilli recipe]: recipe-chilli-slow-cooker.html
[pleroma]: https://pleroma.social/
[ap.barrucadu.co.uk]: https://ap.barrucadu.co.uk
[social.lainon.life]: https://social.lainon.life
[Voluminous - The Letters of H. P. Lovecraft]: https://www.hplhs.org/voluminous.php
[The Good Friends of Jackson Elias]: https://blasphemoustomes.com/

## Link Roundup

- [Releasing Pleroma 2.1.0](https://pleroma.social/blog/2020/08/28/releasing-pleroma-2-1-0/)

I've decided to stop including the "This Week in Rust", "Haskell
Weekly", and "NixOS Weekly" links in this section as I'm not sure when
I last actually read one of them fully.  Also the "NixOS Weekly" is
more like "NixOS Monthly" at best, they should really rename that.
