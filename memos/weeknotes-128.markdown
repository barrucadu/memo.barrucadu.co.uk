---
title: "Weeknotes: 128"
taxon: weeknotes-2021
date: 2021-02-28
---

## Work

This week I continued with the implementation of [the RFC][], making
all the changes needed to switch from a single session cookie set by
[finder-frontend][], the app which serves the [Transition Checker][],
to a session cookie managed by Fastly, our CDN, and passed to our apps
in a custom HTTP header.

We're using a custom header because it means we can cache based on
just that *one* cookie value, rather than all of the cookies.  Since
the full `Set-Cookie` header typically contains a bunch of other
things, if we cached based on it then we'd effectively cache nothing.

I got this idea from [Fastly's best practices for cookies][].

So, we've had to make changes to:

- our Fastly config, to pluck out the cookie value and deal with the
  custom headers,
- the [collections][] app, which serves the [Transition landing
  page][],
- the [finder-frontend][] app, which serves the Transition Checker,
- and [our cookies page][], to list the new one.

Now we've got some common code between [collections][] and
[finder-frontend][], and it'll only spread to more of our frontend
apps.  It'd be good to extract that out to a gem or something.

I've prepared a bunch of PRs to remove the old cookie and simplify
some logic, but I'm off next week.

[the RFC]: https://github.com/alphagov/govuk-rfcs/pull/134
[finder-frontend]: https://github.com/alphagov/finder-frontend
[Transition Checker]: https://www.gov.uk/transition-check/questions
[Fastly's best practices for cookies]: https://developer.fastly.com/reference/http-headers/Cookie/#best-practices
[collections]: https://github.com/alphagov/collections
[Transition landing page]: https://www.gov.uk/transition
[our cookies page]: https://www.gov.uk/help/cookie-details


## Books

This week I read:

- [The Kobold Guide to Magic][] by Ray Vallese *et al.*

  I quite enjoyed this one.  There's a good mix of topics, giving good
  coverage to more "magical-feeling" magic (like Gandalf in Lord of
  the Rings - what *are* his limits?) and more "technological-feeling"
  magic, like the rigid spell lists of D&D or the spell-construction
  rules of Ars Magica.  There's gender-based magic, lost ancient
  magic, traditional Irish folkloric magic, magical cabals, secret
  societies, and so on.

  The "Why I Hate Teleport Spells" essay was good.  It's about the
  problems caused by long-range teleportation (hundreds of miles), and
  how you can fix that by either switching to short-range
  teleportation (tens of miles) or a magical waypoint system:

  - The party can just teleport past the Big Bad's defences.

  - Slow overland travel gives opportunities for additional adventure
    hooks.

  - The sense of scale goes away, everything feels closer together,
    and so it feels less epic to cross huge distances.

  - The GM can't easily pose dilemmas where the party have to choose
    between multiple objectives because they can't do all of them in
    some time limit.

[The Kobold Guide to Magic]: https://koboldpress.com/kpstore/product/kobold-guide-to-magic/


## Gaming

I put an impassable obstacle in front of my Call of Cthulhu group.
Naturally, they overcame it, and one of them even said "that was a good
puzzle!"

I got my own back though, they then spent a while talking to a crazy
man who claimed to have magical powers, but was insulted by their
doubt when they asked him to demonstrate.  Eventually he relented, and
agreed.

One of the PCs cautiously approached the stone circle, watching out
for some sort of magical force pushing them back.  They raised their
foot, began to move it across the boundary... and one of the man's pet
dingoes came over and stood in front of them, blocking their way.
Mighty magic indeed.

So, they've now made it out of Australia.  Next game will be a session
or two of [Troika][], for which I've written a small adventure.  And
after that, England.

[Troika]: https://www.troikarpg.com/


## RPG Blog

[![It's called Look What the Shoggoth Dragged In](weeknotes-128/lookwhattheshoggothdraggedin.png)][blog]

I did end up starting that [RPG blog][blog].

I'm planning to post once a month, it'll be a mixture of mechanics
musings, GM advice, reviews, and short adventures.  Next month's post
will either be first impressions of Troika, or on fudging dice.  I'll
write up my Troika adventure after I finish running it.

[blog]: https://www.lookwhattheshoggothdraggedin.com/


## Link Roundup

### Software Engineering

- [Why is it so hard to see code from 5 minutes ago?](https://web.eecs.utk.edu/~azh/blog/yestercode.html)
- [You need to be able to run your system](http://catern.com/run.html)

### Roleplaying Games

- Questing Beast has started a (hopefully continuing) series of Q&A videos:
  - [Ask Questing Beast! Ep. 1](https://www.youtube.com/watch?v=wX_-qUbx1Lc)
  - [Ask Questing Beast Ep. 2 - Seth Skorkowsky & Dungeon Craft](https://www.youtube.com/watch?v=zLRnLhDp3hE)
- [Advanced Gamemastery: The Goblin Ampersand](https://www.youtube.com/watch?v=IOWKUNQEf-Y)
- [How to Draw Mountains That POP: Fantasy Mapmaking Tutorial for DnD](https://www.youtube.com/watch?v=aaCYc99Ub30)
- [Risks](http://walkingmind.evilhat.com/2018/01/17/risks/)
- [Going From New School to Old School in One Rule Tweak: The Case of Starting HP](http://monstersandmanuals.blogspot.com/2021/02/going-from-new-school-to-old-school-in.html)

### Miscellaneous

- [Five Geek Social Fallacies](https://plausiblydeniable.com/five-geek-social-fallacies/)
