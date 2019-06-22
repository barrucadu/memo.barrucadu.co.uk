---
title: "Weeknotes: 006"
tags: weeknotes
date: 2018-10-28
audience: General
---

## Ph.D

* I was going to fix up my literature review, but then I didn't.

## Work

* [GitHub was down for all of Monday][]: midnight to midnight.  The
  git repositories themselves worked, but pull requests were much
  flakier, and they'd disabled the webhooks while the problem was
  ongoing.  Not the most productive day at work when you can't review
  any code or trigger automatic CI runs.

* As if Monday set the tone, the rest of the week was fairly
  unproductive as well:

  * Wrote up a Trello card to actually do the load-testing work I'd
    planned.
  * Generated some better test data for that.
  * Started having a look at making our [publishing-api][] do a bit
    less work.
  * Spent two days figuring out why the publishing-api was broken in
    our staging environment.

  And that's it!

[GitHub was down for all of Monday]: https://status.github.com/messages/2018-10-28
[publishing-api]: https://github.com/alphagov/publishing-api

## Miscellaneous

* I wrote a memo about [how I processed 100GB of nginx logs][] for the
  load testing I'm doing at work.  Then I discovered that half of that
  memo (finding the busiest minute, all the paths hit in that minute,
  and how many times each path was hit) could be done substantially
  faster with a small shell script:

  ```bash
  for file in cache-{1..3}/lb-access.log.{1..28}; do
    cat $file | \
      grep '"GET ' | \
      grep -v '/government/uploads' | \
      cut -d' ' -f4 | \
      tr -d '[]' | \
      sed 's/\:[0-9][0-9]$//' > $file-tmp
  done

  top_bucket=`sort -m cache-{1..3}/lb-access.log.{1..28}-tmp | \
    uniq -c | \
    sort -rn | \
    head -n1 | \
    cut -d' ' -f2`

  rm cache-{1..3}/lb-access.log.{1..28}-tmp

  cat cache-{1..3}/lb-access.log.{1..28} | \
    grep '"GET ' | \
    grep -v '/government/uploads' | \
    grep $top_bucket | \
    cut -d' ' -f8 | \
    sed 's/\?.*//' | \
    sort | \
    uniq -c | \
    sort -rn
  ```

  It's not a totally fair comparison though, as it doesn't produce all
  the same intermediate files (which could be useful), gives output in
  a different format, and I'm not sure how it could be adapted to
  solve the second problem (find the busiest minute for each path).
  It's also including *all* paths, whereas the Ruby script only
  includes those which are hit more than 2 times.  However this
  doesn't seem to affect the minute chosen, so I've removed it from
  the Ruby too.

* I started rewriting the venerable [LambdaMOO][] in [Rust][]
  ([there's a repository on GitHub][]).  I've got my Rust code
  compiling to a shared library, which the LambdaMOO C is using, and
  am gradually moving functions over.  This approach is more work
  overall than just rewriting in one big bang, but it has a lower
  up-front investment and gives me a working code-base at every step
  of the way.  I've not touched Rust in ages, so there was a lot of
  re-learning to do before I could really get started.

  I've now ported:

  * [The memory allocator][]
  * [The hash function used for byte arrays][]
  * [Part of the input handling][]

  The memory allocator is a useful first step, because without that I
  can't port any functions which need to allocate.  Of course, Rust is
  a memory-safe language, so the code is very clear:

  ```rust
  /// Allocate memory, with space for a int immediately before the
  /// returned pointer IFF the `memory_type` is float (12), string (5),
  /// or list (7).
  ///
  /// TODO: Phase this out in favour of `Rc<RefCell<_>>` as things are
  /// ported to Rust.
  ///
  /// TODO: Handle failed malloc in Rust when `panic` is ported.
  #[no_mangle]
  pub extern "C" fn almost_mymalloc(size: libc::size_t, memory_type: u32) -> *mut libc::c_void {
      let offset = refcount_offset(memory_type);
      let actual_size = if size == 0 { 1 } else { size } + offset;

      unsafe {
          let mut mem = libc::malloc(actual_size) as *mut u8;

          if mem.is_null() {
              return mem as *mut libc::c_void;
          }

          if offset > 0 {
              mem = mem.offset(offset as isize);
              *((mem as *mut i32).offset(-1)) = 1
          }

          mem as *mut libc::c_void
      }
  }
  ```

  Or not.  Needing to maintain the same interface as the C allocator
  results in it being a bit nasty.

  Next I'm going to tackle handling MOO values in Rust.  Most of the C
  functions operate on MOO values, so until I can handle those there's
  not much more I can rewrite.

  The old C code is totally without tests, includes stuff deprecated
  since 1995, and has optimisations for the DEC Alpha's 31-bit
  pointers; so it's a bit slow going as I untangle everything.

* I read Dune for the first time since... I'm not sure exactly.  I
  don't have a read date for it in [bookdb][], which means it was
  probably before 2012-05.  I've now started on Dune Messiah.

* My [Call of Cthulhu][] game resumed this week, after a one month
  break.  I wrote a summary of the previous session to help jog the
  players' memories:

  > You all responded to a newspaper advert looking for participants
  > in an expedition to find an unknown pyramid in Peru, organised by
  > one Augustus Larkin.
  >
  > In Lima, Peru, you met Augustus Larkin, a sickly looking white man
  > with a British accent, who you noticed is possibly suffering
  > opioid withdrawal symptoms; Luis de Mendoza, a Hispanic-looking
  > man, who is Larkin's silent and imposing assistant; and Jesse
  > Hughes, an African-American folklorist.  "Jesse Hughes" is
  > actually an alias he has given Larkin, his real identity is
  > Jackson Elias, a not-unknown author who investigates and writes
  > about real-world cults.
  >
  > Over dinner, Larkin gave you an overview of the expedition and
  > what he hopes to find.  Afterwards, Jackson Elias revealed that he
  > has doubts: he's in Peru to investigate an ancient death cult
  > behind the legend of the "kharisiri", fat-sucking vampires.
  > Mendoza has a fearsome reputation, and Larkin is acting strangely;
  > Jackson Elias thinks that they, the pyramid, and this expedition
  > are all connected to the cult somehow.
  >
  > You, and Jackson Elias, are staying in the Hotel Maury; Larkin and
  > Mendoza are staying in the Hotel Espana.  The expedition leaves
  > the morning of the day after tomorrow to Puno, and from there into
  > the mountains: so you have one evening and one full day in Lima.
  >
  > The following morning you went with Jackson Elias to meet with
  > Professor Memesio Sanchez, a respected archaeologist and historian
  > at the local university. Professor Sanchez has offered numerous
  > times to help Larkin's expedition, but been rebuffed or ignored
  > every time.  He thinks that Larkin plans to steal the pyramid's
  > historical treasures and take them abroad, which the law currently
  > does not prevent.  He and his assistant, the undergraduate
  > Trinidad Rizo, have been conducting research into the possible
  > location of the pyramid, based on documents in the university
  > archives.
  >
  > Rizo was taking an unusually long time to arrive at the meeting,
  > so you---not including Jackson Elias and Professor Sanchez---went
  > to the store room to investigate.  There you found signs of a
  > struggle, and Rizo's dead body.  Boxes had been knocked off
  > shelves, and she was partly buried.  You found the skin stretched
  > tightly over her bones, as if the fat had been removed from her
  > body, and a large circular wound in her chest.
  >
  > It is now around noon.
  >
  > Dr. Crane, you were examining the body.
  >
  > Lady Ashdown, you had found footprints leaving the room.
  >
  > What are the rest of you doing?

[how I processed 100GB of nginx logs]: processing-100gb-nginx-logs.html
[LambdaMOO]: https://en.wikipedia.org/wiki/LambdaMOO
[Rust]: https://www.rust-lang.org/
[there's a repository on GitHub]: https://github.com/barrucadu/lambdamoo
[The memory allocator]: https://github.com/barrucadu/lambdamoo/blob/master/rust-source/src/memory.rs
[The hash function used for byte arrays]: https://github.com/barrucadu/lambdamoo/blob/master/rust-source/src/crypto.rs
[Part of the input handling]: https://github.com/barrucadu/lambdamoo/blob/master/rust-source/src/parse_cmd.rs
[bookdb]: http://barrucadu.co.uk/bookdb
[Call of Cthulhu]: https://en.wikipedia.org/wiki/Call_of_Cthulhu_(role-playing_game)

## Link Roundup

* [Gatling 3.0.0 is here!](https://gatling.io/2018/10/23/gatling-3-0-0-is-here/)
* [Gitless](https://gitless.com/)
* [Guinea Pigs eating Sprouts!](https://www.youtube.com/watch?v=oiGxVSMBedY)
* [How Big Is An Enum?](https://www.embedded.fm/blog/2016/6/28/how-big-is-an-enum)
* [How to change symlinks atomically](http://blog.moertel.com/posts/2005-08-22-how-to-change-symlinks-atomically.html)
* [Issue 130 :: Haskell Weekly](https://haskellweekly.news/issues/130.html)
* [LambdaMOO Takes a New Direction](https://www.cc.gatech.edu/classes/AY2001/cs6470_fall/LTAND.html)
* [This Week in Rust 257](https://this-week-in-rust.org/blog/2018/10/23/this-week-in-rust-257/)
* [sizeof(char) is 1](https://drj11.wordpress.com/2007/04/08/sizeofchar-is-1/)
