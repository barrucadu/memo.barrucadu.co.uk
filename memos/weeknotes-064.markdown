---
title: "Weeknotes: 064"
taxon: weeknotes-2019
date: 2019-12-08
---

## Moving

I was off work this week to move, which turned out to be a week-long
affair:

- **Monday:** I had a removals company move all my stuff.  While that
  was happening, some men arrived to replace the fridge/freezer in the
  new flat.

- **Tuesday:** I had an IKEA delivery, someone round to set up the
  internet, and the letting agency's maintenance guy to finish off
  some tasks which didn't get done previously.  I spent the rest of
  the day putting furniture together.  And then the maintenance guy
  came over again in the evening as there was one more thing he
  forgot.

- **Wednesday:** I had a large Morrisons delivery ("starting from
  scratch" with food is pretty expensive).  I then went back to the
  old flat to clean it and to return the keys.  Back in the new flat I
  put the rest of the furniture together (other than the dining table
  and bookcase, which were too big for me to do alone) and started
  tearing up and disposing of the huge amounts of cardboard I now
  have.

- **Thursday:** I called up a handyman to put together my dining table
  and bookcase, and to put my whiteboards on the walls.  But he
  arrived half an hour late (the office gave him the wrong address),
  didn't know what I needed doing (the office hadn't shared any of my
  explanation with him) and, when I explained, said it would need two
  people and he disappeared for 15 minutes to fetch someone else.
  Given that bad first impression I didn't really trust this company
  with my walls, so I just had the two of them put the furniture
  together...

- **Friday:** I went to the post office to collect an ethernet cable,
  which turned out to be far too long, so I could get internet in the
  second bedroom, which I've turned into an office.  I then spent the
  rest of the day waiting for a FedEx delivery which was supposed to
  come by 6pm (and had also been scheduled to arrive on Thursday by
  6pm) but which didn't show up.  After it was obvious the FedEx
  delivery wasn't coming, I went to find the local Tesco superstore
  and buy some fresh ingredients.  I then cooked for the first time,
  having been living off takeaways so far.

- **Saturday:** New curtains arrived, 4 days ahead of schedule
  (there's a lesson there for FedEx), I put those up and spent the
  rest of the day relaxing.

So now everything is just about done.

## Miscellaneous

- [Advent of Code][] started last Sunday, and once again I'm taking
  part and [putting my solutions online][].  Last year I planned to
  write up my solutions to some of the more interesting puzzles, but
  never got around to it.  Maybe this year I will.

- I figured out how to serve custom CNAME records with [Pi-hole][].
  As it uses [dnsmasq][] (well, a dnsmasq-derived thing), you can
  stick an extra config file in `/etc/dnsmasq.d`.  For example, adding
  some CNAME records to point to `nyarlathotep`, which is the hostname
  of a DHCP-managed machine:

  ```
  pi@raspberrypi:/etc/dnsmasq.d $ cat 99-cnames.conf
  cname=bookdb.nyarlathotep,nyarlathotep
  cname=flood.nyarlathotep,nyarlathotep
  cname=grafana.nyarlathotep,nyarlathotep
  cname=finder.nyarlathotep,nyarlathotep
  ```

  This is neat because it means I can get subdomains on my LAN without
  giving them public DNS records, which is what I was doing
  previously.

[Advent of Code]: https://adventofcode.com/
[putting my solutions online]: https://github.com/barrucadu/aoc/tree/master/2019
[Pi-hole]: https://pi-hole.net/
[dnsmasq]: http://www.thekelleys.org.uk/dnsmasq/doc.html

## Link Roundup

- [Issue 188 :: Haskell Weekly](https://haskellweekly.news/issue/188.html)
- [This Week in Rust 315](https://this-week-in-rust.org/blog/2019/12/03/this-week-in-rust-315/)
- [Professor X Sends Thoughts and Prayers, Killing Thousands](https://thehardtimes.net/harddrive/professor-x-sends-thoughts-and-prayers-killing-thousands/)
