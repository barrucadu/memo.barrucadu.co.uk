---
title: "Weeknotes: 070"
taxon: weeknotes-2020
date: 2020-01-19
---

## Work

### Blogs

A post I wrote [about upgrading to Elasticsearch 6][] finally got
published this week, though it's a bit delayed.  We've been working on
a lot since then!

[about upgrading to Elasticsearch 6]: https://technology.blog.gov.uk/2020/01/10/upgrading-gov-uk-search-to-help-users-find-micropigs-and-important-information-faster/

### Finders

It turns out that disabling an option in the frontend isn't enough to
disable it in the backend.  A couple of weeks ago I [made a change][]
so that you couldn't sort by "most viewed" if you'd entered a search
query.  At least, you couldn't select the "most viewed" *option*:
turns out that direct links to the search page still worked.  So I did
a little work to [properly kill off sorting by "most viewed"][].

I made another change to finder pages this week---which so far I seem
to have got right in one go---[removing the keyword tags from a search
page][].  If you go to [a search page with some filters applied][] (on
desktop, the mobile search UI is a bit different) you get a list of
the selected filters, and can click each one to remove it.  That also
used to be the case for keywords too.  So on that search I linked to,
you'd get a button each for `i`, `have`, `a`, `pet`, `frog`.  We found
it just confused people, so now it's gone.

[made a change]: https://github.com/alphagov/finder-frontend/pull/1835
[properly kill off sorting by "most viewed"]: https://github.com/alphagov/finder-frontend/pull/1858
[removing the keyword tags from a search page]: https://github.com/alphagov/finder-frontend/pull/1863
[a search page with some filters applied]: https://www.gov.uk/search/all?keywords=i+have+a+pet+frog&level_one_taxon=d6c2de5d-ef90-45d1-82d4-5f2438369eea&content_purpose_supergroup%5B%5D=guidance_and_regulation&organisations%5B%5D=animal-and-plant-health-agency&public_timestamp%5Bto%5D=2025&order=relevance

### Machine learning

After a lot of work, I finally merged [the PR][PR1] which automates
our search ranking machine learning stuff through Amazon SageMaker.
And then immediately hit an issue with memory usage when it first ran
in production, and [had to fix that][PR2].  And then another issue
with not pinning dependency versions, and [had to fix that][PR3].  So
there have been a few bumps on the road, but it's now there and
working.

Before we switch the actual SageMaker-powered reranking in production,
we want to add some more monitoring and alerting, so we're working on
boring stuff like that now.  But at least we're past the big hump:
we've got a machine learning training and deployment pipeline set up
in AWS, and we could switch it on in production right now if we wanted
to.

[PR1]: https://github.com/alphagov/search-api/pull/1871
[PR2]: https://github.com/alphagov/search-api/pull/1903
[PR3]: https://github.com/alphagov/search-api/pull/1917

## Miscellaneous

### Books

Not much to report.  I'm still working my way through [The Rise and
Fall of the Third Reich][] on my commute, and I've started re-reading
The Lord of the Rings (I hardly think I need to link to the wiki
article of *that*) before bed.

[The Rise and Fall of the Third Reich]: https://en.wikipedia.org/wiki/The_Rise_and_Fall_of_the_Third_Reich

### Bread

I baked a few loaves of bread this week, using a recipe in [My
Bread][].  They turned out pretty well, but my cast iron pan is
definitely not the right shape to bake sandwich bread in.  So I've
ordered a few loaf tins from Amazon to try out.  It would be good if I
could make all my sandwich bread.

[My Bread]: https://www.amazon.com/My-Bread-Revolutionary-No-Work-No-Knead/dp/0393066304

### Call of Cthulhu

I resumed [my Call of Cthulhu game][], which had been on hold over the
festive period.  It's hard to believe that this is the second New Year
the game has seen: it started in September 2018.

This is the first session I used background music in, and I think it
worked pretty well.  I used a Discord music bot, [Groovy][], to play
tracks from Youtube.  The only downside was that it would disconnect
if music was paused for too long, so we'd occasionally get the Discord
disconnect/reconnect jingles.  Maybe I can find a silent video for it
to "play" when I've not got any particular background music to put on.

[my Call of Cthulhu game]: masks-of-nyarlathotep.html
[Groovy]: https://groovy.bot/

### SAT and SMT solvers

I started writing [a little SAT solver][] based on the paper
["Abstract DPLL and Abstract DPLL Modulo Theories"][], and it works
pretty well!  At least on some problems.  Once I got it working I
turned it into an SMT solver, though currently it only supports the
theory of equality with uninterpreted functions (EUF).  In hindsight,
that was perhaps a mistake.  As I've now got to the point where I want
to make the solver faster, but that means I have to implement
optimisations which work with EUF as well as SAT, while only having a
basic knowledge of each.

There are really two paths forward:

1. I can stare at [the DPLL(T) paper][] until I understand backjumping
   (non-chronological backtracking) when you're considering EUF (or
   any theory, really).
2. Or I can switch to a less efficient core algorithm which will let
   me use regular SAT backjumping, though will ultimately be worse
   than option (1).

I'm not sure yet which to go for.

[a little SAT solver]: https://github.com/barrucadu/sat/
["Abstract DPLL and Abstract DPLL Modulo Theories"]: https://www.cs.upc.edu/~roberto/papers/lpar04.pdf
[the DPLL(T) paper]: https://link.springer.com/content/pdf/10.1007/978-3-540-27813-9_14.pdf

## Link Roundup

- [Making GOV.UK more than a website](https://gds.blog.gov.uk/2019/12/19/making-gov-uk-more-than-a-website/)
- [The Ultimate Retaliation: Pranking My Roommate With Targeted Facebook Ads](https://ghostinfluence.com/the-ultimate-retaliation-pranking-my-roommate-with-targeted-facebook-ads/)
- [Hypermodeling Hyperproperties](https://www.hillelwayne.com/post/hyperproperties/)
- [Synthesizing Loop-Free Programs with Rust and Z3](https://fitzgeraldnick.com/2020/01/13/synthesizing-loop-free-programs.html)
- [CrossHair](https://github.com/pschanely/CrossHair)
- [This Week in Rust 321](https://this-week-in-rust.org/blog/2020/01/14/this-week-in-rust-321/)
- [Issue 194 :: Haskell Weekly](https://haskellweekly.news/issue/194.html)
