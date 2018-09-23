---
title: "Weeknotes: 001"
tags: weeknotes
date: 2018-09-23
audience: General
---

I've decided to give writing [weeknotes][] a try.  I've tried, and
failed, to keep a diary multiple times, so we'll see how this goes.
Maybe if I keep this up, the notes will be useful for whenever I go to
update my [now page][].

[weeknotes]: https://weeknot.es/
[now page]: https://www.barrucadu.co.uk/now.html

A lot of what I do is either recorded in a git repository somewhere or
on my personal Trello board (I'm planning to write a memo about how I
use Trello for self organisation at some point), so when I started on
this memo I whipped up this shell function:

```bash
# Recent git history, across repositories
function git-history() {
  local since=$1
  for d in *; do
    if [[ -e $d/.git ]]; then
      pushd $d;
      local repo=`printf '%-16s' "$d"`
      git log --since=$since --pretty=format:"${repo:0:16} %ai (%h):  %s" --author='Michael Walker' --all
      popd
    fi
  done
}
```

With this I can run `git-history "last week"` in my `~/projects`
directory and get a list of all the commits I've made, in the
repositories I have locally checked out, in the last week.

I'm not really sure what format to do these in, so for now I'll go for
bullet points grouped by different aspects of my life.

## Personal

* I wanted to check out this federated social networking stuff, so I
  set up [Pleroma][] (like [Mastodon][] but not---they talk to each
  other), and am now available as [barrucadu@social.lainon.life][].
  It seems neat so far.

* I've been planning a [Call of Cthulhu][] campaign I'll be running
  for some friends, starting next weekend.  This will only be the
  second time I've DMed a game, so I've decided to use a published
  campaign.  Re-reading the rulebook, and reading the campaign book,
  has been fun.

[Pleroma]: https://pleroma.social/
[Mastodon]: https://mastodon.social/about
[barrucadu@social.lainon.life]: https://social.lainon.life/users/barrucadu
[Call of Cthulhu]: https://en.wikipedia.org/wiki/Call_of_Cthulhu_(role-playing_game)

## Ph.D

* I finished the corrections for chapter 5 of my thesis, which is the
  longest chapter with the main contributions in.  This involved
  totally rewriting one section, which I'd been putting off for months
  and took me a fortnight.  Today I sent it off to my external
  examiner, [Simon PJ][], to ask if this is the sort of thing he was
  expecting.

[Simon PJ]: https://www.microsoft.com/en-us/research/people/simonpj/

## Work

* I've mostly been working on [transition][], the tool we use to move
  government websites from one domain to another (like onto
  [GOV.UK][]), re-jigging how it generates traffic metrics and making
  it pull our CDN log files from Amazon S3.

* On Tuesday afternoon there was an all-staff offsite event filled
  with talks.  It was mostly boring, but there was a really
  interesting talk at the end by some people from the Coast Guard
  about producing a system for different emergency services to share
  information about ongoing emergencies.  I'd assumed this was a
  long-solved problem; no, it was only solved in 2014 or so (I forget
  the exact year).

[transition]: https://github.com/alphagov/transition
[GOV.UK]: https://www.gov.uk/

## Miscellaneous

* I did some maintenance on [dejafu][] and [irc-client][], updating
  things for newer dependencies and pulling in some fixes.  It's a bit
  sad how much development has slowed down (basically stopped), but
  with Ph.D work ongoing, I haven't tended to do much intellectually
  demanding stuff during my reduced free time.

* I did some thinking about the "Target Audience" field on my memos.
  Previously this was just free text, and I used it really
  inconsistently.  I've now changed it to [three categories][].

* Also on the topic of memos, I removed the "Attention Conservation
  Notice" field, because I was using it similarly inconsistently.

* After using [f.lux][] and [redshift][] for years, I finally decided
  to switch them off.  I don't think the dimming, reddening, screen
  has ever prompted me to go to bed or helped me get to sleep---it
  just makes things harder to read.

* I watched [Jim Fisher][]'s "[Don't say 'simply'][]" talk from [Write
  the Docs 2018][].  Even though I already knew his philosophy, it was
  a good talk and I liked the examples.

[dejafu]: https://github.com/barrucadu/dejafu
[irc-client]: https://github.com/barrucadu/irc-client
[three categories]: https://memo.barrucadu.co.uk/read-me-first.html
[f.lux]: https://justgetflux.com/
[redshift]: http://jonls.dk/redshift/
[Jim Fisher]: https://jameshfisher.com/
[Don't say 'simply']: https://jameshfisher.com/2018/09/13/dont-say-simply-writethedocs-prague.html
[Write the Docs 2018]: http://www.writethedocs.org/conf/prague/2018/
