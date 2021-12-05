---
title: "Weeknotes: 168"
taxon: weeknotes-2021
date: 2021-12-05
---

## Work

As of this week, the Brexit Checker is no more!  It wasn't my team
that retired it, but we do have a bunch of code relating to it, which
can now be deleted.

Speaking of removing things, I've also done some more tearing down of
our defunct prototypes this week too: updating documentation,
archiving github repos, deleting Concourse pipelines, and so on.  Next
week I'll delete the remaining DNS records, and then we're done!

Next week we're having a "firebreak": a week-long break from regular
team work (well, we're splitting it over the next two weeks), to give
time to work on other things which we don't usually get time to focus
on.


## Books

This week I read:

Nothing again!

## Gaming

[Minecraft 1.18 came out this week][], bringing with it all the cool
new world generation.

[Minecraft 1.18 came out this week]: https://minecraft.fandom.com/wiki/Java_Edition_1.18


## Systems

This week I've made a couple of large changes to [my systems][]: the
procedures I use to implement my "external brain" and manage my life.

### Time Tracking

Firstly, I completely stopped tracking my time.  I started this [about
a year ago][] and, while it was kind of interesting seeing where I
spend my time, how much of the average workday is meetings, what
proportion of my time is leisure time, and so on, I found myself very
rarely actually analysing (or even just glancing at) the data I was
working to produce.  And, problematically, it never really became a
habit.  I always had to *think* about tracking my time and, since I
didn't want to go down to the level of counting individual minutes, I
found myself putting off or batching small tasks together, which made
those small tasks feel bigger and more cumbersome.

Even worse, since I had a goal of having under 2 hours of untracked
time a day, and yet I only tracked time I was *actually doing things*,
there was a pressure to only relax by doing the specific activities
I'd given categories to: reading a book, going for a walk, working on
a project, watching anime, and so on.  It's good to do those things,
but sometimes it's nice to just laze around for an afternoon, and I
was discouraging that.

So, on Friday, I stopped.

At first it felt a bit weird, but that passed very quickly.  I feel
like a weight which I was no longer conscious of has been lifted.
This weekend I've found myself doing a greater variety of activities
than usual, I suspect because there's no longer an overhead to
switching activities or doing very short activities.

On the whole, I don't recommend time tracking the way I tried it.

### Personal Finances

Secondly, I threw out a cornerstone of my personal finances: I got rid
of my emergency fund.

I make myself financially resilient in a few ways:

- I keep 3 to 4 months expenses in cash in my bank account.
- I keep a £5,000 emergency fund in Premium Bonds.
- I also keep a £2,500 moving fund in Premium Bonds.

Having a few months expenses saved up is the best first step you can
take (after getting rid of any high-interest debt, that is) to make
yourself financially stable.  This lets you break the cycle of living
paycheque to paycheque.  I've adjusted how much I have saved in this
category over the years, and now I have 4 months for most types of
expenses.  Since I'm paid on the last working day of the month, and
expenses will usually have come out before then, this means over the
month my bank account dwindles down from 4 months expenses saved to 3,
and then shoots back up to 4.

Honestly, this is probably more than I need.  My job is very stable
and has a long (3 month) notice period, so I'm not going to suddenly
lose it.  But this number gives me peace of mind.

After breaking the cycle of living paycheque to paycheque, a good next
step is saving up for uncommon or unexpected expenses.  Money for
uncommon expenses (like my annual ProtonMail fee) I just save in a
bank account.  So, it's only *unexpected expenses* (like needing to
move) that the money in Premium Bonds is for.  Once, I didn't have a
separate moving fund: I just had a £10,000 emergency fund, but I
changed that in 2020.

This week I've made some changes:

- I still have 3 to 4 months expenses in cash in my bank account.
- I've completely removed the £5,000 emergency fund.
- I've shrunk the £2,500 moving fund to £1,000.

I realised that I'm very unlikely to need to use my emergency fund: if
an emergency comes up, I'm more likely to pay for it with my credit
card or by reallocating money from another budget category, than I am
to wait the 3+ days it takes to withdraw from my Premium Bonds.  In
fact, I've only used my emergency fund once, when I unexpectedly
needed to replace the NVMe drive in my desktop computer, and I could
have just taken the money from (say) my rent budget instead.

The moving fund is a slightly different story: I realised it was just
too much.  I picked £2500 because that's about how much I spent in
total when I moved to my current flat in 2019: but I only spent that
much because I bought a lot of new furniture.  I have that furniture
now, I'm not going to replace it when I next move.  But on the other
hand, hiring movers will be more expensive now that I have more stuff
to move: it cost me £400 last time, so allocating more than double
that feels safe.

Now, having said all that, the money sitting around in Premium Bonds
isn't exactly *harming me*, is it?  Well, it probably is!  I've won
£25 in the Premium Bonds since January 2020, so that's a return of
0.3%.  Pretty bad.  On the other hand, my S&S ISA has had an
annualised return of 15%, so if the £6500 I've now freed up had been
invested for the last two years, it would now be worth £8500.  Stocks
and shares can, of course, go down as well as up (which is why you
don't store an emergency fund in them): but in the long term (5+
years) they tend to go up.

I'm planning to update my [personal finance memo][] over the next
month or so, as there have also been a few other changes since I last
did: e.g., I'm now tracking on my dashboard my FIRE progress.

[my systems]: taxon/self-systems.html
[about a year ago]: weeknotes-117.html#time-tracking
[personal finance memo]: personal-finance.html


## Miscellaneous

It's [Advent of Code][] season again, and once again I'm [attempting it in Haskell][].

[Advent of Code]: https://adventofcode.com/
[attempting it in Haskell]: https://github.com/barrucadu/aoc


## Link Roundup

- [This shouldn't have happened: A vulnerability postmortem](https://googleprojectzero.blogspot.com/2021/12/this-shouldnt-have-happened.html)
- [What developers find surprising about Postgres transactions](https://blog.lawrencejones.dev/isolation-levels/)
