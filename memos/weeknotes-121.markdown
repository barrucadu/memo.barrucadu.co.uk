---
title: "Weeknotes: 121"
taxon: weeknotes-2021
date: 2021-01-10 21:00:00
---

## Work

This week didn't start out great, with me sleeping through my alarm
and waking up at about 1pm.  I decided to retroactively take Monday
off.

The transition from holiday to work is rough.

Other than that, it was business as usual.  A few people are still
off, so the team's a little quiet, but there's enough to keep
ourselves occupied.

One tricky problem came up: we deployed the [NCSC password
blacklist][], to prevent people from signing up with, or changing to,
the top breached passwords.  For existing users, we can check if they
have a breached password on sign in, but what about users who don't
sign in regularly?  Well, we just have to check every password (about
~44,000 which meet our minimum length restriction) against every user.
Because we're using good password hashing---a pepper, a random salt,
and an expensive hash function---this is going to take a while.  Oh
well.

[NCSC password blacklist]: https://www.ncsc.gov.uk/blog-post/passwords-passwords-everywhere

## Books

This week I read:

- [Toll the Hounds][] by Steven Erikson, the eighth of the [Malazan Book of the Fallen][].

  A very climactic book, with some major characters and plot points
  being dealt with, with finality.  Malazan started out as a GURPS
  campaign, and Steven Erikson once said:

  > Believe it or not, the clash of two major characters in Toll the
  > Hounds was decided on a single roll of the die.  If it had gone
  > the other... well, I shudder to think.

  I think I know which clash he meant, and the results of that clash
  will have a major impact on the remaining books, it going the other
  way would be a pretty dramatic change.  But that's what's fun about
  RPGs, right?  Rolling the dice and having events develop in
  unexpected ways.  The way things turned out seems a huge positive,
  with the other way being very bad; but Malazan is a story *based on*
  a game, not the story *of* the game, so I'm sure if things had gone
  the other way, the books would still have been good.

[Toll the Hounds]: https://en.wikipedia.org/wiki/Toll_the_Hounds
[Malazan Book of the Fallen]: https://en.wikipedia.org/wiki/Malazan_Book_of_the_Fallen

## Gaming

I finally read about the [Threefold Model][], a predecessor of
[GNS][], and I definitely prefer it as a model of player goals.

GNS is the most widely known such model, but it's really confusing.
GNS breaks player motivations down into three types:

- **Gamists** focus on competition and game goals, leading to ideas
  like D&D-style levelling systems, hit points, and encounter balance.
  Computer RPGs are generally very gamist.

- **Narrativists** focus on the story, but specifically in taking a
  step outside the story and focussing on moral and ethical questions,
  rather than simply on genre tropes.  There's a strong emphasis on
  "playing to find out what happens" and removing the traditional GM /
  player split in narrative authority.

- **Simulationists** focus on simulating some experience.  For
  example, simulating a world by having detailed rules for the
  "physics", or simulating a story by codifying genre tropes as rules
  (like PbtA games do).

My major problems with GNS are:

1. It is written as if gamism and narrativism are *the* ways to play a
   game (with narrativism being *the best* way), and that
   simulationism is something some people think they like, but they're
   just mistaken.  GNS adherents can be very pretentious.

2. Simulationism groups two *very* different types of game---realistic
   gritty world-simulations and unrealistic genre-simulations---under
   the same umbrella, because they're both "simulating", even though
   one doesn't care about the story at all and the other is all about
   the story.

3. Nobody really agrees on what each category means, because the
   original essay is kind of vague.  As said, simulationism is
   particularly bad; but gamism and narrativism are also pretty
   confusing.

I've generally described myself as a "simulationist" gamer---which is
already unfortunate because GNS seems to look down on us---but one who
wants to simulate worlds, rather than think about the story.  But
because PbtA games, which are basically the opposite of what I want,
are also considered "simulationist" games, the word itself is almost
completely unhelpful in describing what sort of games I like to play.


It's like the GNS authors thought "surely nobody *actually* wants to
play as if the game world were a real place, because that's just
tedious."

Enter the Threefold Model.  It's much better.  It breaks player
motivations down into:

- **Dramatists** focus on the story.

- **Gamists** focus on fair challenges and computer-game-like
  elements.

- **Simulationists** focus on resolving in-game events
  "realistically", as if the game world were a real place.

So Threefold-Dramatism covers GNS-Narrativism and the genre-simulating
aspect of GNS-Simulationism; Threefold-Gamism is the same as
GNS-Gamism; and Threefold-Simulationism is actually a narrow enough
category to be useful for describing things.

Since GNS came later, and reads as if narrativism is really the best
way to play RPGs, I suspect that it came out of the Dramatist
community wanting to separate people who view "the story" in different
ways---people who want to play a game with a good story vs people who
want to explicitly play with the story---but without introducing a
fourth category.  And I think that was a mistake.

[Threefold Model]: http://www.darkshire.net/%7Ejhkim/rpg/theory/threefold/faq_v1.html
[GNS]: http://www.indie-rpgs.com/articles/3/

## Miscellaneous

I backed the [Little Nuns kickstarter][], for an artbook of [these
nuns with ducks][].

[Little Nuns kickstarter]: https://www.kickstarter.com/projects/diva01/litttle-nuns
[these nuns with ducks]: https://twitter.com/hyxpk/

## Link Roundup

- [Steam's login method is kinda interesting](https://owlspace.xyz/cybersec/steam-login/)
- [A First Look at Info Table Profiling](https://well-typed.com/blog/2021/01/first-look-at-hi-profiling-mode/)
