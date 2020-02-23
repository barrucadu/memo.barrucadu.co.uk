---
title: "Weeknotes: 075"
taxon: weeknotes-2020
date: 2020-02-23
audience: General
---

## Work

I was only at work for three days this week, so I worked on getting
[the RFC implementation in whitehall][] done and deployed---which
[revealed an issue with Welsh HTML attachments][].  Translations in
whitehall have all sorts of quirks.  But now, if you go to a page with
attachments[^rfc_eg], details of those attachments are in the content
item!  And what's more, I republished all of the pre-existing
whitehall content, so the metadata would show up for old documents as
well.

There are a few more things to do, but the whitehall implementation
was the biggest task.  I don't know if any more will get done while
I'm on leave (as this is pretty low-priority work), but I tried to
make sure the remaining tasks were well explained.

The rest of the time, when I wasn't doing RFC work, I was making sure
all the stuff which largely resided in my head (eg, how the machine
learning automation worked) made sense to other people and had
documentation.

[^rfc_eg]: Like the [latest (at the time of writing) statistics publication](https://www.gov.uk/api/content/government/statistics/public-sector-finances-uk-january-2020).

[the RFC implementation in whitehall]: https://github.com/alphagov/whitehall/pull/5353
[revealed an issue with Welsh HTML attachments]: https://github.com/alphagov/whitehall/pull/5376
[latest (at the time of writing) statistics publication]:

## Miscellaneous

### barrucadu.dev

I decided to set up a new, more powerful, server to run my dev stuff,
rather than running it all on [dunwich][], which isn't the most
powerful of machines when it's trying to concurrently do CI/CD stuff,
run game servers, and be a general-purpose shell sever.

This week I've set up a new server, [dreamlands][][^names], with:

- **Git hosting:** using [Gitea][] (previously I was using [Gitolite][]).
- **CI/CD:** using [Concourse][].
- **Docker registry:** with the standard registry image.

[^names]: **Machine naming convention:** local machines are beings
  (gods, people, etc) in the Cthulhu Mythos, remote machines are
  places.  Dunwich shows up in [The Dunwich Horror][], the dreamlands
  show up in a bunch of stories, such as [The Dream-Quest of Unknown
  Kadath][].

I've made all the Concourse pipelines public, and have [a little
frontend][] showing job statuses, with Concourse information getting
to the frontend via [a little Haskell-powered API][].

As usual, [NixOS config is online][], and so is [everything else][].

I also took the opportunity to set up something I'd been meaning to
for a while, a regular build/test of [dejafu][] whenever a new
[Stackage][] snapshot comes out:

- Statuses: [https://www.barrucadu.dev/?project=dejafu](https://www.barrucadu.dev/?project=dejafu)
- Pipeline: [https://cd.barrucadu.dev/teams/main/pipelines/dejafu](https://cd.barrucadu.dev/teams/main/pipelines/dejafu)
- Test case: [https://github.com/barrucadu/barrucadu.dev/blob/e8eb3ed056c5da82c72ef188d3636cd172545419/pipelines/dejafu.jsonnet#L65-L77](https://github.com/barrucadu/barrucadu.dev/blob/e8eb3ed056c5da82c72ef188d3636cd172545419/pipelines/dejafu.jsonnet#L65-L77)

[dunwich]: https://memo.barrucadu.co.uk/machines.html#dunwich
[dreamlands]: https://memo.barrucadu.co.uk/machines.html#dreamlands
[The Dunwich Horror]: http://www.hplovecraft.com/writings/texts/fiction/dh.aspx
[The Dream-Quest of Unknown Kadath]: http://www.hplovecraft.com/writings/texts/fiction/dq.aspx
[Gitea]: https://gitea.io/
[Gitolite]: https://gitolite.com/gitolite/index.html
[Concourse]: https://concourse-ci.org/
[a little frontend]: https://www.barrucadu.dev/
[a little Haskell-powered API]: https://github.com/barrucadu/barrucadu.dev/tree/master/event-api-server
[NixOS config is online]: https://github.com/barrucadu/nixfiles/tree/master/hosts/dreamlands
[everything else]: https://github.com/barrucadu/barrucadu.dev
[dejafu]: https://github.com/barrucadu/dejafu
[Stackage]: https://www.stackage.org/

### Books

I finished reading The Two Towers, and started on The Return of the
King.  I'm still working through The Unicorn Project.

## Link Roundup

- [Random libraries and benchmarks](https://alexey.kuleshevi.ch/blog/2019/12/21/random-benchmarks/)
- [Elixir and Postgres: A Rarely Mentioned Problem](https://blog.soykaf.com/post/postgresql-elixir-troubles/)
- [Maker <-> Puzzler](https://phildini.dev/maker-puzzler)
- [This 7,000-year-old well is the oldest wooden structure ever discovered, archeologists say](https://www.ctvnews.ca/sci-tech/this-7-000-year-old-well-is-the-oldest-wooden-structure-ever-discovered-archeologists-say-1.4815023)
- [This Week in Rust 326](https://this-week-in-rust.org/blog/2020/02/18/this-week-in-rust-326/)
- [Issue 199 :: Haskell Weekly](https://haskellweekly.news/issue/199.html)
- [Why the fuck are we templating yaml?](https://leebriggs.co.uk/blog/2019/02/07/why-are-we-templating-yaml.html)
- [GHC Proposal: Delimited continuation primops](https://github.com/ghc-proposals/ghc-proposals/pull/313)
- [Church vs Curry Types](https://lispcast.com/church-vs-curry-types/)
- [What would Dijkstra do? Proving the associativity of min](https://byorgey.wordpress.com/2020/02/23/what-would-dijkstra-do-proving-the-associativity-of-min/)
