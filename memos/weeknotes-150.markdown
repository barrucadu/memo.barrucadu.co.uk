---
title: "Weeknotes: 150"
taxon: weeknotes-2021
date: 2021-08-01
---

## Work

This week I started looking into [Fastly's Compute@Edge service][], as
a possible means of handling some bits of dynamic content on GOV.UK
(for example, showing the appropriate sign in / sign out link in the
header, without every request needing to hit our origin servers).

Currently we do our CDN configuration [with lots of VCL][], which has
a big downside: Fastly use their own fork of Varnish, so we can't run
or test this VCL locally.  You just have to make your change, deploy
it to staging, and manually check.

But Compute@Edge would let us use Rust or AssemblyScript, which in
principle *can* be run locally, though the situation there isn't so
great either:

- Fastly's Rust crate depends on some hidden code which their runtime
  injects.  So you can run integration tests locally where you use
  their local runtime to run your WASM binary and fire requests at it,
  but unit tests are a bit trickier.
- Their "hello world" AssemblyScript project [crashes][], which is
  very unpromising and makes me wonder what more subtle bugs are
  lurking, if something this blatant slipped through.

The downside of using Compute@Edge for some accounts-related
functionality is that we'd have another layer in our CDN stack.  This
could be pretty confusing, as all the network hops inside Fastly's
network go through cache nodes.

We'd likely stick the Compute@Edge logic between our current VCL and
our origin servers, so we'd end up with something like:

```graphviz
digraph {
  user       -> fedge
  fedge      -> vcl
  vcl        -> fcacheVCL1
  vcl        -> fcacheVCL2
  vcl        -> fcacheVCL3
  vcl        -> fcacheVCL4
  fcacheVCL1 -> cate
  fcacheVCL2 -> mirror1
  fcacheVCL3 -> mirror2
  fcacheVCL4 -> mirror3
  cate       -> fcacheCATE
  fcacheCATE -> origin

  user       [label="User"]
  fedge      [label="Fastly Edge Node"]
  vcl        [label="GOV.UK VCL"]
  fcacheVCL1 [label="Fastly Cache Node"]
  fcacheVCL2 [label="Fastly Cache Node"]
  fcacheVCL3 [label="Fastly Cache Node"]
  fcacheVCL4 [label="Fastly Cache Node"]
  cate       [label="GOV.UK Compute@Edge"]
  fcacheCATE [label="Fastly Cache Node"]
  origin     [label="GOV.UK Origin"]
  mirror1    [label="GOV.UK Mirror #1"]
  mirror2    [label="GOV.UK Mirror #2"]
  mirror3    [label="GOV.UK Mirror #3"]
}
```

...or maybe...

```graphviz
digraph {
  user        -> fedge
  fedge       -> vcl
  vcl         -> fcacheVCL
  fcacheVCL   -> cate
  cate        -> fcacheCATE1
  cate        -> fcacheCATE2
  cate        -> fcacheCATE3
  cate        -> fcacheCATE4
  fcacheCATE1 -> origin
  fcacheCATE2 -> mirror1
  fcacheCATE3 -> mirror2
  fcacheCATE4 -> mirror3

  user        [label="User"]
  fedge       [label="Fastly Edge Node"]
  vcl         [label="GOV.UK VCL"]
  fcacheVCL   [label="Fastly Cache Node"]
  cate        [label="GOV.UK Compute@Edge"]
  fcacheCATE1 [label="Fastly Cache Node"]
  fcacheCATE2 [label="Fastly Cache Node"]
  fcacheCATE3 [label="Fastly Cache Node"]
  fcacheCATE4 [label="Fastly Cache Node"]
  origin      [label="GOV.UK Origin"]
  mirror1     [label="GOV.UK Mirror #1"]
  mirror2     [label="GOV.UK Mirror #2"]
  mirror3     [label="GOV.UK Mirror #3"]
}
```

In either case, it's kind of confusing having two layers of custom CDN
logic.  Now, Rust is a much nicer language than VCL, so perhaps we'd
end up merging the VCL into the Compute@Edge code and doing it all
there, and then we could have fully tested CDN logic, which would be
very nice.

```graphviz
digraph {
  user        -> fedge
  fedge       -> cate
  cate        -> fcacheCATE1
  cate        -> fcacheCATE2
  cate        -> fcacheCATE3
  cate        -> fcacheCATE4
  fcacheCATE1 -> origin
  fcacheCATE2 -> mirror1
  fcacheCATE3 -> mirror2
  fcacheCATE4 -> mirror3

  user        [label="User"]
  fedge       [label="Fastly Edge Node"]
  cate        [label="GOV.UK Compute@Edge"]
  fcacheCATE1 [label="Fastly Cache Node"]
  fcacheCATE2 [label="Fastly Cache Node"]
  fcacheCATE3 [label="Fastly Cache Node"]
  fcacheCATE4 [label="Fastly Cache Node"]
  origin      [label="GOV.UK Origin"]
  mirror1     [label="GOV.UK Mirror #1"]
  mirror2     [label="GOV.UK Mirror #2"]
  mirror3     [label="GOV.UK Mirror #3"]
}
```

But deciding to rewrite how our CDN works is a *little* outside the
scope of the accounts team, so I'd need to build up some support
first.

[Fastly's Compute@Edge service]: https://developer.fastly.com/learning/compute/
[with lots of VCL]: https://github.com/alphagov/govuk-cdn-config
[crashes]: https://github.com/fastly/compute-starter-kit-assemblyscript-default/issues/19


## Books

This week I read:

- [The Stars My Destination][] by Alfred Bester

  It's the future, humanity has colonised the solar system, and a
  great breakthrough has been made: the ability to "jaunte", or
  teleport up to about 1000 miles merely by thinking.  The book starts
  with Gully Foyle, the narrator, running low on air in a derelict
  spaceship, who watches another craft approach, notice his distress
  signal, and leave him behind.

  Most of the book is a Count of Monte Cristo-esque revenge tale, with
  a subplot of some very rich men trying to recover a secret treasure
  which Foyle's ship had been transporting.  It's a good read, and I
  enjoyed it a lot.

  I'm glad that the original title of "Tiger!  Tiger!" got dropped, as
  "The Stars My Destination" is much better.

[The Stars My Destination]: https://en.wikipedia.org/wiki/The_Stars_My_Destination


## Link Roundup

### Roleplaying Games

- [Level One Wonk: Fantasy Economics](https://cannibalhalflinggaming.com/2020/07/22/level-one-wonk-fantasy-economics/)
- [11 ways to be a better roleplayer](https://lookrobot.co.uk/2013/06/20/11-ways-to-be-a-better-roleplayer/)
- [Running Session Zeros](https://slyflourish.com/running_session_zeros.html)
- [Running Episodic Games](https://slyflourish.com/running_episodic_games.html)
- [The 7-3-1 Technique](https://www.gauntlet-rpg.com/blog/the-7-3-1-technique)
- [Starship Geomorphs 2.0](http://travellerrpgblog.blogspot.com/2020/07/starship-geomorphs-20.html)

### History

- [Fireside Friday: March 26, 2021 (On the Nature of Ancient Evidence)](https://acoup.blog/2021/03/26/fireside-friday-march-26-2021-on-the-nature-of-ancient-evidence/)

### Software Engineering

- [Exploring PGO for the Rust compiler](https://blog.rust-lang.org/inside-rust/2020/11/11/exploring-pgo-for-the-rust-compiler.html)
