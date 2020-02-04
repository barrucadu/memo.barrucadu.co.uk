---
title: Memo Organisation
tags: meta
date: 2020-02-04
important: yes
---

Welcome to my memos.  This isn't just a normal blog: some memos are
written for me, some are written for others.  So that you can find
what you're looking for, it's useful to know how they're organised and
how to subscribe for updates.


Taxonomy
--------

Memos are grouped into a *taxonomy*, a hierarchical category
structure.  The current top-level taxons are:

- **[General](taxon/general.html):** memos of general interest.
- **[Weeknotes](taxon/weeknotes.html):** a summary of my weeks, published every Sunday.
- **[Research](taxon/research.html):** memos about research, either by me or by others.
- **[Tech Docs](taxon/techdocs.html):** technical documentation on stuff I use or run.
- **[Self](taxon/self.html):** information which is useful in the course of being me.

A taxon may have subtaxa, which I won't list here.

A taxon page gives you:

- A link to an atom feed of all the memos in that taxon and its subtaxa
- A list of memos in that taxon
- A list of memos in its subtaxa

Currently there aren't feeds for just the memos in that taxon
(excluding memos in any subtaxa).  If that would be useful, let me
know.


Tagging
-------

Memos are also associated with a tags.  A memo can have any number of
tags, and tags aren't hierarchical.

Unlike the taxa, there isn't really a fixed list of tags: I'll
introduce a new one when I feel like it, whereas a new taxon only
comes about when I spot a pattern in the existing memos.  The full
list of tags can be seen in the sidebar on list pages.

A tag page gives you:

- A link to an atom feed of all the memos tagged to it
- A list of memos tagged to it


Feeds
-----

There are three sorts of atom feeds:

- The feed for all memos, at `/feed.xml`
- The feed for all memos in a taxon and its subtaxa, at `/taxon/<name>.xml`
- The feed for all memos in a tag, at `/tag/<name>.xml`
