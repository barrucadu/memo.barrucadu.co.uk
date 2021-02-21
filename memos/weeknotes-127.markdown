---
title: "Weeknotes: 127"
taxon: weeknotes-2021
date: 2021-02-21
---

## Work

Implementation of [the RFC][] has begun.  I'm aiming for a gradual
switch from the current way things work to the new way they should
work.  It's more awkward to do it this way, but means we're
maintaining backwards compatibility every step of the way.  So if
something goes wrong, we can revert the last change we made to the
affected microservice, rather than needing to unpick a tangled mess
across multiple services.

Well, that's the idea.

And it turns out that the first such step, changing the way we pass
some state from the [Transition Checker][] to the [Account Manager][]
resulted in a net *reduction* in complexity and in lines of code, and
is much more standard practice than what we were doing.  If we'd
thought to do it this way from the beginning, we'd have avoided some
of the problems we hit along the way.

As the saying goes, weeks of programming can save you hours of
planning.

[the RFC]: https://github.com/alphagov/govuk-rfcs/pull/134
[Transition Checker]: https://www.gov.uk/transition-check/questions
[Account Manager]: https://www.account.publishing.service.gov.uk/

## Books

This week I read:

- [The Hydrogen Sonata][] by Iain M. Banks, the tenth and last of the [Culture series][].

  This was great, I enjoyed it a lot more than [I did Surface
  Detail][].  Though I found myself wondering at times why <span
  class="spoiler">Banstegeyn was putting so much effort into keeping
  the secret, when if anything his methods were the ones threatening
  confidence in the subliming</span>.  And also it was a bit weird to
  refer to non-hyperspace as "the Real", when previously that term had
  only been used to mean "the non-simulated world".

  I find myself running low on book series to read.  I only have the
  two [sequels of Neuromancer][] and part two of [The Book of the New
  Sun][] to go.  I'll have to pick up something new.

- [The Great Indoors][] by Emily Anthes.

  This is all about how architecture affects our health, moods, and
  behaviours, and the growing field of evidence-based building design.
  It's pretty interesting, it covers things from the microbes you
  might find living in your shower head, to the sort of buildings we
  could have on Mars one day.  Fitting, given [recent events][].

[The Hydrogen Sonata]: https://en.wikipedia.org/wiki/The_Hydrogen_Sonata
[Culture series]: https://en.wikipedia.org/wiki/Culture_series
[I did Surface Detail]: weeknotes-122.html
[sequels of Neuromancer]: https://en.wikipedia.org/wiki/Sprawl_trilogy
[The Book of the New Sun]: https://en.wikipedia.org/wiki/The_Book_of_the_New_Sun
[The Great Indoors]: http://emilyanthes.com/thegreatindoors/
[recent events]: https://en.wikipedia.org/wiki/Mars_2020

## Miscellaneous

Setting up my new RPG blog is going well.  I've published two posts,
but want to have two in draft and five more outlined before
publicising it anywhere.  I figure once a month is a good minimum
posting frequency, so that would give me content for the next 7 months
in varying stages of completion.

## Link Roundup

- [Free SVG and PNG icons for your games or apps](https://game-icons.net/)
- [Using Tanglegrams for Planning RPG Sessions](https://thebardicinquiry.wordpress.com/2021/02/15/using-tanglegrams-for-sandbox-play/)
- [Advanced Gamemastery: Mysteries in RPGs](https://www.youtube.com/watch?v=FgVM8-vbhZA)
- [Running D&D: Engaging Your Players](https://www.youtube.com/watch?v=_iWeZ-i19dk)
