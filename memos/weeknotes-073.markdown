---
title: "Weeknotes: 073"
taxon: weeknotes-2020
date: 2020-02-09 19:00:00
---

## Work

### Machine learning stuff

On Monday morning, I flipped the switch to start serving our ML search
ranking model from [Amazon SageMaker][], which also means we're
training and deploying a new model every day.  We're still evaluating
it, but it looks pretty comparable to what we had running previously.
It's a bit hard to say at the moment, because the deadline for self
assessment was at the end of January, so recent search traffic has
been heavily skewed towards searching for that sort of thing.

I also made some changes to make it easier to train and deploy a model
using a branch of the scripts, but now I need to write up some
documentation on how to actually do that, as it's all in my head
currently.

I'm also planning to write a memo on using Learning to Rank with
SageMaker, because that was pretty tricky to figure out.

[Amazon SageMaker]: https://aws.amazon.com/sagemaker/

### Documentation

Speaking of documentation, I went through [all the search docs][] and
then [all the *other* search docs][] making sure they were up-to-date,
consistent, and actually helpful.

We regularly review our dev docs, each source file starts with a
header like this:

```yaml
---
owner_slack: "#govuk-searchandnav"
title: How to debug underperforming search
section: Monitoring
layout: manual_layout
parent: "/manual.html"
last_reviewed_on: 2020-02-04
review_in: 3 months
---
```

The `owner_slack` channel gets notified when `last_reviewed_on +
review_in` is the current date or older.  However, when reviewing
documentation like that, people often just make sure that the
*current* content is still correct, and if so, bump the
`last_reviewed_on` date.  Something we *don't* often do is review
groups of documentation for consistency or missing information.

It's possible that the problem could be addressed by some process
change.  A lot of documentation is assigned to the in-hours support
team (well, their slack channel), and they usually have other stuff
going on to put much effort into reviewing docs.  Maybe splitting up
the load amongst other teams more, and having pages about similar
topics all get reviewed at once, would help.

[all the search docs]: https://github.com/alphagov/govuk-developer-docs/pull/2281
[all the *other* search docs]: https://github.com/alphagov/govuk-developer-docs/pull/2282

### RFC

[The RFC][] got accepted, and I've been working through the
implementation.  I've got steps 1 to 4 done.  Now I'm getting to the
steps which require changes to [Whitehall][] and [Content
Publisher][].  As Content Publisher is under active development, I
think the time has come to have a chat with some developers on its
team.

[The RFC]: https://github.com/alphagov/govuk-rfcs/blob/master/rfc-116-store-attachment-data-in-content-items.md
[Whitehall]: https://github.com/alphagov/whitehall
[Content Publisher]: https://github.com/alphagov/content-publisher

### Splunk for rookies

I attended a two-hour "[Splunk][] for rookies" workshop in the office,
given by a visiting Splunk employee (splunker?).

First thoughts: the Splunk query language is *far* nicer than the
[Kibana][] query language; I was able to actually figure out stuff for
myself without needing to read documentation first.  I can also see
why people like this over Grafana, where you're writing queries in the
language of the underlying data store.

Second thoughts: they really emphasise how the data you give to Splunk
is analysed at query time, rather than being indexed into a database
or anything like that.  But given that you tell Splunk what the format
of your data is (eg, an Apache access log), isn't that needlessly
slow?  The splunker presented it as a universal good, solving all
sorts of problems with databases, but of course neglected to mention
how it compared to the *advantages* of databases.  There are reasons
we don't use flat files, parsed on demand, for everything.

[Splunk]: https://www.splunk.com/
[Kibana]: https://www.elastic.co/kibana

## Miscellaneous

### Apocalypse World

I've decided that my new game, to fill the void left by Call of
Cthulhu, will be [Apocalypse World][].  The first game will be next
week: Saturday the 15th.

I've not played Apocalypse World before, and now I'm running it, so
this'll be interesting.

[Apocalypse World]: http://apocalypse-world.com/

### memo.barrucadu.co.uk

I made a few improvements to memo.barrucadu.co.uk:

- [Implementing a dark mode](https://github.com/barrucadu/memo.barrucadu.co.uk/commit/639def0dffa91f6161c53cb79b7adda5b389bb80)
- [Making some mobile improvements](https://github.com/barrucadu/memo.barrucadu.co.uk/commit/0a028cc1a853301ebb7a973c0bf519d79deef7a1)
- [Grouping memos into a taxonomy](https://github.com/barrucadu/memo.barrucadu.co.uk/commit/1b0447aacb63f17468c165cc5e67e8d1fc580051)

There are still some things to do, particularly on the mobile
friendliness front: font size in `<pre>` tags is *really* small, for
reasons I've not yet figured out, and I need to make margin notes
appear in the main body of text.  I also need to either pick a new
syntax highlighting theme for dark mode, or find a theme which works
for both.  The current colours mostly work, but there are a few syntax
elements which are hard to read.

I'm planning to introduce dark mode and mobile improvements to
www.barrrucadu.co.uk as well.

I had a go at making bookdb.barrucadu.co.uk more mobile
friendly... but quickly gave up.

## Link Roundup

- [Old CSS, new CSS ](https://eev.ee/blog/2020/02/01/old-css-new-css/)
- [How To Add CSS Dark Mode To A Website](https://kevq.uk/how-to-add-css-dark-mode-to-a-website/)
- [How I Work From Anywhere in the World](https://jezenthomas.com/how-i-work-from-anywhere-in-the-world/)
- [What makes a good runbook?](https://www.transposit.com/blog/2019.11.14-what-makes-a-good-runbook/)
- [What to do when you don’t trust your data anymore](https://laskowskilab.faculty.ucdavis.edu/2020/01/29/retractions/)
- [Building an Effective Test Pipeline in a Service Oriented World](https://medium.com/airbnb-engineering/building-an-effective-test-pipeline-in-a-service-oriented-world-6968c513c6bd)
- [Creating Sigils](https://urbit.org/blog/creating-sigils/)
- [Structural typing and first-class case expressions](https://ice1000.org/2019/07-14-FirstClassCases.html)
- [My productivity app for the past 12 years has been a single .txt file](https://jeffhuang.com/productivity_text_file/)
- [Issue 197 :: Haskell Weekly](https://haskellweekly.news/issue/197.html)
- [#02 - NixOS Weekly](https://weekly.nixos.org/2020/02-nixos-weekly-2020-02.html)
- [This Week in Rust 324](https://this-week-in-rust.org/blog/2020/02/04/this-week-in-rust-324/)
- [The TTY demystified](http://www.linusakesson.net/programming/tty/)
- [Linux PTY - what powers docker attach functionality](https://iximiuz.com/en/posts/linux-pty-what-powers-docker-attach-functionality/)
- [Lessons learned from writing ShellCheck, GitHub’s now most starred Haskell project](https://www.vidarholen.net/contents/blog/?p=859)
