---
title: "Weeknotes: 080"
taxon: weeknotes-2020
date: 2020-03-29
---

## Work

This week I've made a few small tweaks to search to help people
looking for coronavirus content:

- If you're on a search page filtered by a topical event [like this
  one][], it says in smaller text above the title what topical event
  you're looking at.  This is useful because we don't have a facet for
  topical events, so there was previously no indication that you were
  seeing a filtered list of results (other than the querystring).

- A lot of people are searching for terms which are only tangentially
  related to coronavirus, like "dog walking".  So to help pull
  coronavirus results up onto the first page, they're [now slightly
  boosted][].

- We've also been brainstorming ways to help, like adding more
  synonyms (eg, "covid19" and "coronavirus"), automatically fixing
  some common spelling mistakes (like "vunerable"), and adding a
  feature to our ranking model for "is this content coronavirus
  related?" and seeing what that does.

I also did some work on finishing off [showing "parts" of multi-part
content directly in search results][], as we think we could use that
to expose HTML attachments [on pages like this][] directly in search,
making it clearer what's on a page and reducing the number of clicks
needed to get to it.  There's a bit more to do there, as currently we
don't index HTML attachments in search, but once that's sorted we can
A/B test it and see how it performs.

Boringly, it was also end-of-year review time.  I got it done, but
it's a bit hard to prioritise mundane stuff like that when there's
coronavirus and brexit going on.

[like this one]: https://www.gov.uk/search/news-and-communications?topical_events%5B%5D=coronavirus-covid-19-uk-government-response
[now slightly boosted]: https://github.com/alphagov/search-api/pull/2035
[showing "parts" of multi-part content directly in search results]: https://github.com/alphagov/finder-frontend/pull/1877
[on pages like this]: https://www.gov.uk/government/publications/guidance-to-employers-and-businesses-about-covid-19


## The Plague

Another week, another intensification of the prevention measures.
Going outside is now only allowed for daily exercise, shopping, and a
few other reasons.

On the bright side, the supermarkets are filling up with supplies
again, and they're pretty quiet now.  But I've not managed to buy
flour in over a week, so I'll run out of bread soon.

Other than that, it's not so bad.


## Miscellaneous

### Books

Still reading The Nyarlathotep Cycle[^reading], but I've read a few
more stories:

- The Dweller in Darkness, by August Derleth
- The Titan in the Crypt, by J. G. Warner
- Fane of the Black Pharaoh, by Robert Bloch
- Curse of the Black Pharaoh, by Lin Carter

[^reading]: I seem to be reading less at night lately, I need to fix that.

The Dweller in Darkness was my first August Derleth story, and I quite
liked it.  It's got heavy similarities with The Whisperer in Darkness,
but that's ok, as it takes the story in a different direction.  I
don't think I like his conception of the mythos along more traditional
good-vs-evil lines, though.

### Games

Another week of Apocalypse World.  I think I'm getting the hang of the
system more now, though I'm still struggling to handle task
difficulties.  For example, the players were in a junkyard on the
outskirts of a town which hates their guts, searching through the
rubbish for a plane engine.  I wanted them to find the engine, because
they came to this plan based on what their characters knew, so: stuff
I'd told them.  It would suck a lot to go into danger, narrate how
they dig through the rubbish heaps, and for me to say "sorry, there
isn't one there, even though I strongly hinted that there would be."

I also felt it would be a bit unsatisfying to say "lo and behold,
there one is!" without any drama happening at all.  If this were Call
of Cthulhu, I could have called for a **Spot Hidden** roll, and
handled the result like this:

- **Hard success:** you find the engine and are able to get away
  undetected.
- **Regular success:** you find the engine but, as you're loading it
  up into your car, you get discovered.  Your enemies will give chase!
- **Failure:** you find the engine but, as you're digging it out of
  the rubbish, you get discovered.  Do you run back to the car and
  leave, or stand and fight so that one of you can finish retrieving
  it?

Fortunately, one of the players introduced drama by deciding to wander
into the town to ask some questions, and only escaped by successfully
bluffing that he had guards with him.  Then he ran back to the
junkyard, where they'd just found and dug out the engine, and they
didn't waste any time sticking around.  But if that hadn't happened,
I'm not sure what I would have done other than say "well done, you
found it".

### Internet

I've been working from home this week so, naturally, my internet
connection has been terribly unreliable.  I've been having minutes,
sometimes even hours, of total packet loss.  The mornings and evenings
have mostly been fine, but it all falls apart in the afternoons.  It's
pretty hard to work remotely if your connection is so unstable you
can't load a web page or send an email!

So I've been tethering to my phone a lot, but I've used up half of its
data allowance already... and it resets just before the end of
*April*.

I've got a Virgin Media engineer coming around tomorrow afternoon to
have a look.  I really hope he can fix it there and then, rather than
doing some triage and realising that the problem is elsewhere in the
network.


## Link Roundup

- [The 5 Types of Ethical Dilemmas](http://goblinpunch.blogspot.com/2015/07/the-5-types-of-ethical-dilemmas.html)
- [New grad vs senior dev](https://ericlippert.com/2020/03/27/new-grad-vs-senior-dev/)
- [The problem with adding functions to compact regions](http://www.well-typed.com/blog/2020/03/functions-in-compact-regions/)
- [Fate Roleplaying Game SRD](https://fate-srd.com/)
- [#03 - NixOS Weekly](https://weekly.nixos.org/2020/03-nixos-weekly-2020-03.html)
- [Issue 203 :: Haskell Weekly](https://haskellweekly.news/issue/203.html)
- [Issue 204 :: Haskell Weekly](https://haskellweekly.news/issue/204.html)
- [This Week in Rust 330](https://this-week-in-rust.org/blog/2020/03/17/this-week-in-rust-330/)
- [This Week in Rust 331](https://this-week-in-rust.org/blog/2020/03/24/this-week-in-rust-331/)
