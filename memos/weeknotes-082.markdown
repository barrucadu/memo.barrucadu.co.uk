---
title: "Weeknotes: 082"
taxon: weeknotes-2020
date: 2020-04-12
---

## Work

A standard week in Platform Health, which means I worked on a bunch of
different things.  Probably the most interesting was a bug[^me] to do
with attachment replacements.

[^me]: Introduced by me a couple of years ago, as it turns out.

What are attachment replacements?  Well, pages on GOV.UK can have
files attached to them by the publisher, and new versions of a page
can *replace* existing attachments, making the old attachment redirect
to the replacement.  However, there was a problem with how this
mechanism interacted with draft pages.

Pages on GOV.UK can be either *draft* or *live*.  Draft content isn't
accessible to normal people (like you), only live content is.  So it's
very important that attachments don't redirect to their replacement if
that replacement is still a draft!

There's a bit of logic for handling redirections [in asset-manager][]:

```ruby
if asset.replacement.present? && (!asset.replacement.draft? || requested_from_draft_assets_host?)
  set_default_expiry
  redirect_to_replacement_for(asset)
  return
end
```

So, if a publisher creates a new draft of a document, and replaces
some attachments, the live attachments won't redirect until the
document is published and the replacements become live. So far so
good.

But there's a problem with `asset.replacement`.

To avoid long chains of redirects (which many browsers won't follow
after a certain point), whenever an attachment is replaced, anything
transitively replaced by it is updated to refer directly to it.

Say you have two attachments:

```
A1 -> A2
```

Where `->` means "is replaced by".  Assuming `A2` is live, visiting
`A1` redirects you to it.  Good stuff.  But then the publisher makes a
new draft, and replaces `A2`.  We get this situation:

```
A1 -> A3
A2 -> A3
```

Until the document is published, `A3` is a draft.  So neither `A1` nor
`A2` will redirect to it.  That's good, but now the redirect from `A1`
to `A2` is broken!  Oh no!

It turned out to be not too tricky to fix, but did have to be changed
in two apps to be fully fixed: in [asset-manager][] and in
[whitehall][].

Now to wait another few years to discover a bug in how I did it.

[in asset-manager]: https://github.com/alphagov/asset-manager/blob/c1dd51c49fae63d9c4021cc1adc54690dab98cb9/app/controllers/media_controller.rb#L8-L12
[asset-manager]: https://github.com/alphagov/asset-manager/pull/750
[whitehall]: https://github.com/alphagov/whitehall/pull/5530


## The Plague

The shops are still out of flour.


## Miscellaneous

### Books

I read [Uzumaki][], a horror manga by Junji Ito about spirals.  I've
read it before, but not for a long time, so while I remembered the
basics of most of the stories I'd forgotten a lot of the detail.
Junji Ito writes some really good stuff.

I also got a few new books:

- A couple of Call of Cthulhu RPG source books
- [The Witch-Cult in Western Europe][]
- A collection of stories by [W. W. Jacobs][]
- And a collection of American horror stories

[Uzumaki]: https://en.wikipedia.org/wiki/Uzumaki
[The Witch-Cult in Western Europe]: https://en.wikipedia.org/wiki/The_Witch-Cult_in_Western_Europe
[W. W. Jacobs]: https://en.wikipedia.org/wiki/W._W._Jacobs

### Games

It's Apocalypse World week again.  This time I tried to introduce some
more NPCs, as the players said that the lack of them was causing
difficulties: in Apocalypse World you have to pay for your character's
living expenses at the start of a session, and the main way to make
more money is to do jobs for NPCs.  I got to introduce some new NPCs
and flesh out some old ones, and everyone made some money.

Towards the end of the session, I got to reveal a plot twist I've had
in mind (two NPCs turned out to be the same person), which I thought
had been obvious for a while, but a couple of the players hadn't
picked up on it (some had), so it worked pretty well.  Now I need to
think of the next plot twist and get some foreshadowing in.

I also ran a game of [Golden Sky Stories][] for two people who'd not
played it before, and who had limited RPG experience: one had played a
bit of D&D, the other hadn't played any games before but had read a
bunch of rulebooks.  I spent the session thinking "this is going
terribly, they're hating this" but, actually, it seems they quite
enjoyed it, and they want another session.

The session was slightly marred by Steam's voice chat echoing
everything anyone said.  Discord voice chat works fine, so it must be
a software issue.

[Golden Sky Stories]: https://tvtropes.org/pmwiki/pmwiki.php/TabletopGame/GoldenSkyStories

## Link Roundup

- Ben Robbin's "West Marches" blog posts:
  - [Grand Experiments: West Marches](http://arsludi.lamemage.com/index.php/78/grand-experiments-west-marches/)
  - [Grand Experiments: West Marches (part 2), Sharing Info](http://arsludi.lamemage.com/index.php/79/grand-experiments-west-marches-part-2-sharing-info/)
  - [Grand Experiments: West Marches (part 3), Recycling](http://arsludi.lamemage.com/index.php/80/grand-experiments-west-marches-part-3-recycling/)
  - [Grand Experiments: West Marches (part 4), Death & Danger](http://arsludi.lamemage.com/index.php/81/grand-experiments-west-marches-part-4-death-danger/)
  - [West Marches: Running Your Own](http://arsludi.lamemage.com/index.php/94/west-marches-running-your-own/)
  - [West Marches: Secrets & Answers (part 1)](http://arsludi.lamemage.com/index.php/705/west-marches-secrets-answers-part-1/)
  - [West Marches: Layers of History](http://arsludi.lamemage.com/index.php/949/west-marches-layers-of-history/)
- [Issue 205 :: Haskell Weekly](https://haskellweekly.news/issue/205.html)
- [Issue 206 :: Haskell Weekly](https://haskellweekly.news/issue/206.html)
- [This Week in Rust 332](https://this-week-in-rust.org/blog/2020/03/31/this-week-in-rust-332/)
- [This Week in Rust 333](https://this-week-in-rust.org/blog/2020/04/07/this-week-in-rust-333/)
- [Eager vs. Lazy Instantiation: Making an Informed Decision](https://www.tweag.io/posts/2020-04-02-lazy-eager-instantiation.html)
- [Non-Mechanical Difficulty Levels for Monstrous Threats](http://blog.trilemma.com/2014/10/non-mechanical-difficulty-levels-for.html)
- [Treasure Tells A Story](http://arsludi.lamemage.com/index.php/99/treasure-tells-a-story/)
- DWARF support in GHC:
  - [Part 1](http://www.well-typed.com/blog/2020/04/dwarf-1/)
  - [Part 2](http://www.well-typed.com/blog/2020/04/dwarf-2/)
  - [Part 3](http://www.well-typed.com/blog/2020/04/dwarf-3/)
  - [Part 4](http://www.well-typed.com/blog/2020/04/dwarf-4/)
  - [Part 5](http://www.well-typed.com/blog/2020/04/dwarf-5/)
- [Fantasy Heartbreakers](http://www.indie-rpgs.com/articles/9/)
