---
title: "Weeknotes: 188"
taxon: weeknotes-2022
date: 2022-04-24
---

## Work

This week I got my first significant PR merged: a change to how we
track which individual transactions are used to generate a payout
(money sent to a merchant), so that the [public "payout items" API][]
can be made more efficient.

It's still behind a feature flag, not switched on in production, but
it's definitely nice to get something done mostly independently, and
then merged with minimal changes needed in the review.  And in
implementing this, I learned a bunch about the different sort of
things that make up a payout: transactions yes, but also various types
of fees and other domain concepts, so I feel I've got a much more
solid grip on the fundamentals.

[public "payout items" API]: https://developer.gocardless.com/api-reference/#core-endpoints-payout-items


## Books

This week I read:

- [Memories of Ice][] by Steven Erikson, the third of the [Malazan Book of the Fallen][]

  I think this book is, really, where the main plot of Malazan really
  kicks off.  We meet the Crippled God, and he launches his first
  major assaults on the world: gathering the physically and morally
  crippled under his banner, taking advantage of their vices, and
  allying with the insane Pannion Seer to launch a crusade against
  civilisation.

  And all that is kind of strange because the Crippled God has a
  significant change of heart at the end of the series.  Maybe I just
  missed some foreshadowing, or the conclusive moment of change, on my
  first read-through, but it's hard to see how this hate- and
  pain-filled alien god who wants to corrupt all life becomes good
  when freed of his chains.  It'll be interesting to see if I pick up
  on that change in advance this time.

[Memories of Ice]: https://malazan.fandom.com/wiki/Memories_of_Ice
[Malazan Book of the Fallen]: https://en.wikipedia.org/wiki/Malazan_Book_of_the_Fallen


## Miscellaneous

I've begun on a sourdough starter.  I've been saying "I should really
get into sourdough" for, well, years.  And at last I've finally got on
with it.

I'm using a fairly simple recipe, from a book called *Fresh from
Poland*, to make a rye sourdough starter:

1. Mix 0.5 cups rye flour with 0.5 cups water, cover loosely with a
   kitchen towel and leave at room temperature for 24 hours.
2. Discard half the mixture, mix in another 0.5 cups rye flour and 0.5
   cups water, cover again and leave for another 24 hours.
3. Repeat step 2 for the next 4 days.
4. After that, store in the fridge and feed once a week with 0.5 cups
   rye flour and 0.5 cups water.

I'm on day 3 now.  It's kind of neat to watch.  I was surprised
yesterday to see how much it had expanded over the 24 hour wait: the
airy sour-smelling mixture must have doubled in size.

It should be ready to bake with on Wednesday.  I'm looking forward to
see what sort of bread I get out of it.  I've been baking my own bread
(using a simple no-knead recipe) for years now, but it never expands
that much, and I always end up with a fairly dense loaf.  Hopefully
the vigour my starter has been showing will pass on to the bread it
makes, and I'll actually get a loaf tall enough to make a decent
sandwich out of.

I've never actually had rye sourdough before.  But I like sourdough
and I like rye bread, so surely the combination of both will be double
good.


## Link Roundup

### Roleplaying Games

- [Causal Influence Diagrams](http://www.projectrho.com/rpg/cidiagram.html)
- [Universal, System-Neutral Stats](https://www.prismaticwasteland.com/blog/universal-system-neutral-stats)

### Programming

- [CVE-2022-21449: Psychic Signatures in Java](https://neilmadden.blog/2022/04/19/psychic-signatures-in-java/)
