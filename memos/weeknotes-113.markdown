---
title: "Weeknotes: 113"
taxon: weeknotes-2020
date: 2020-11-15 20:00:00
---

## Work

I was off on Monday and Tuesday this week.  It was nice to have a
little break after spending a few weeks working towards a launch and
then fixing post-launch bugs.

For the rest of the week I was working on monitoring and starting to
think about SLIs / SLOs and autoscaling.  Right now we're using very
few of our machine resources, but that's not likely to be the case
forever.  Though I definitely don't want us to fall into the GOV.UK
situation, where there is monitoring and alerting for every metric
conceivable: devs have been fighting a war against useless metrics for
some time.


## Books

This week I read:

- [Matter][] by Iain M. Banks, the eighth of the [Culture series][].

  In which a primitive society unintentionally resurrects a
  world-killing threat.  This one has a smattering of war too.  In the
  appendix is an interview with Iain M. Banks in which he is asked if
  he thinks war is a necessary part of civilisation, as it crops up in
  all the Culture books.  He said no, that it's from "the authorial
  need for narrative tension and conflict."  I agree that a good story
  needs conflict; but it's a bit of a shame that his narrative
  conflict seems to always be war or its effects.

[Matter]: https://en.wikipedia.org/wiki/Matter_(novel)
[Culture series]: https://en.wikipedia.org/wiki/Culture_series


## Games

In this fortnight's instalment of Masks of Nyarlathotep, one of the
gang accidentally ended up participating in a cult ritual and went
indefinitely insane, which I don't think is what they were aiming for.
They also survived a car chase, did some snooping, and impersonated a
Danish princess for the third time.

They're now divided on running away to Australia or staying back in
New York to find some way to deal with the cult, leading to [this
session's theme song][].

[this session's theme song]: https://www.youtube.com/watch?v=xMaE6toi4mk


## Miscellaneous

Last week I slightly broke my memos, by upgrading the dependencies in
the docker image and deleting the old one, only to realise that
[pandoc-sidenote][] and [panflute][] had incompatible version
constraints on [pandoc][].  And I couldn't revert the change to the
Dockerfile and rebuild the old one because it referenced an old
version of TeXlive which was now 404ing.  Ho hum.

Fortunately, it turned out that replicating the bit of pandoc-sidenote
I used as a panflute filter was very easy:

```python
#!/usr/bin/env python3

from panflute import *


counter = 0


def coerceToInline(blocks):
    """Extract inlines from blocks.
    """

    paragraph_break = [LineBreak(), LineBreak()]

    inlines = []
    for block in blocks:
        block = block.walk(lambda e, _: Str("") if type(e) == Note else e)
        if type(block) == Plain:
            inlines.extend(block.content)
        elif type(block) == Para:
            inlines.extend(block.content)
            inlines.extend(paragraph_break)
        elif type(block) == LineBlock:
            for lines in block.content:
                inlines.extend(lines)
                inlines.append(LineBreak())
            inlines.extend(paragraph_break)
        elif type(block) == RawBlock:
            inlines.append(RawInline(block.text, format=block.format))

    return inlines


def sidenote(elem, doc):
    """Turn footnotes into sidenotes
    """

    global counter

    if type(elem) != Note:
        return

    content = coerceToInline(elem.content)
    number = Span(Str(str(counter)), classes=["sidenote-number"])
    sidenote = Span(number, *content, classes=["sidenote"])

    counter += 1

    return Span(number, sidenote)


if __name__ == "__main__":
    run_filter(sidenote)
```

So this week I got it all working again.

[pandoc-sidenote]: https://github.com/jez/pandoc-sidenote
[panflute]: https://github.com/sergiocorreia/panflute
[pandoc]: https://pandoc.org/

## Link Roundup

- [The Language Squint Test](https://www.teamten.com/lawrence/writings/the_language_squint_test.html)
- [Pimp My Microwave - Installing a RGB mechanical keypad on my microwave](https://github.com/dekuNukem/pimp_my_microwave/)
- [The Glatisant: Issue #9](https://questingbeast.substack.com/p/the-glatisant-issue-9)
- [Non-Euclidian Horror: The Writhing Spheres](https://coinsandscrolls.blogspot.com/2020/07/non-euclidian-horror-possibly-gilman.html)
- [Roleplaying in Glorantha: How to get started ](https://elruneblog.blogspot.com/2020/04/roleplaying-in-glorantha-how-to-get.html)
- [Traveller: Part 8 - Worlds & Starports](https://www.youtube.com/watch?v=QKTuaJQi4b4&list=PL25p5gPY6qKVUg6ys5N1oRlsBI7DTByyI)
