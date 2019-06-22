---
title: Self Organisation
tags: life, systems, trello
date: 2018-09-24
audience: Narrow
---

I use [Trello][] to keep track of things I need to do.  Everything I
need to do, which isn't captured elsewhere (like in a github issue),
goes on the Trello board.

I've found Trello works better for me for this than [org-mode][] did:
the latter is very powerful, which makes it hard to use consistently;
Trello is much more limited, so consistency is easy.

[Trello]: https://trello.com/
[org-mode]: https://orgmode.org/


## Task States

I sort my tasks into different lists, depending on what their state
is:

* **Someday / Maybe**---things I might do, but equally might not.

* **Has Prerequisites**---things I can't do until I do something else
  (which is also on the board, and linked from this thing).

* **To Do**---things I intend to do in the reasonably near term.

  Things might move between **To Do** and **Someday / Maybe** based on
  my whims.

* **Routines**---regular, time-based, tasks.

* **Doing**---things I'm actively doing (this list is very small).

* **Waiting / Blocked**---things where I've done my part, and need to
  wait on something or someone else.

  For example, saving three months expenses.  I've got a budget to
  achieve this, I just need to wait for enough time to pass.

* **Evaluating**---life changes which I'm still trying out.

  For example, I'm currently considering using an "[LRU cache][]" for
  my clothes: when I do laundry or buy new clothes, they go on the
  left of my wardrobe, so things I tend not to wear gradually migrate
  to the right; and the idea is to periodically get rid of the clothes
  at the right.  I'll keep that in **Evaluating** until I actually do
  throw out a bunch of clothes.

* **Done** - things I've done (there's a new done list every month).

[LRU cache]: https://en.wikipedia.org/wiki/Cache_replacement_policies#Least_recently_used_(LRU)

Here's a state transition diagram showing the normal workflows:

```graphviz
digraph {
  nodesep=1;

  "Someday / Maybe"   [peripheries=2];
  "Has Prerequisites" [peripheries=2];
  "To Do"             [peripheries=2];
  "Routines"          [peripheries=2];

  "Someday / Maybe"   -> "To Do"
  "Has Prerequisites" -> "To Do"
  "To Do"             -> "Someday / Maybe"
  "To Do"             -> "Doing"
  "Routines"          -> "Doing"
  "Doing"             -> "Done"
  "Doing"             -> "Evaluating"
  "Doing"             -> "Waiting / Blocked"
  "Waiting / Blocked" -> "Doing"
  "Waiting / Blocked" -> "Done"
  "Evaluating"        -> "Done"
}
```

States in which new tasks arrive have a double border.  There are also
less common flows which don't really fit into the pure model:

* *In principle*, every task goes though **Doing**, but in practice
  small things can jump straight from **To Do** to **Done**, as I
  don't slavishly update the board at every step.

* *In principle*, a task in **Has Prerequisites** can't move into **To
  Do** until all of its prerequisites are in **Done**, but in practice
  the task and its last few dependencies might enter **Doing**
  together.

Tasks can be deleted at any point.


## Tags

Every task has at least one tag.  The tags are:

* **Finance**
* **Home**
* **Memo**
* **Programming & Tech**
* **Self**
* **Thesis**
* **Miscellaneous**---only if the task has no other tags.

Fairly self-explanatory.


## Routines

I have a bunch of regular tasks which I collected together into a few
different routines:

* **Weekly**---household maintenance (cleaning, laundry, etc) and
  writing [weeknotes][].

* **Monthly**---more intense household maintenance (cleaning the oven,
  emptying the hoover, etc), budgeting, and backing up computers.

* **Quarterly**---updating my CV and website.

* **Biannual**---testing the harddrive failure alert in my home
  server.

* **Annual**---reviewing my financial habits.

Each routine is a single card on the board with a checklist of tasks
to complete and a deadline (9pm of last Sunday in the time period it's
for).

I expect these to change as I repeat them: the weekly and monthly
routines have already been tweaked a bit, but the quarterly routine
has only happened once so far, and the biannual and annual routines
haven't happened at all yet.

[weeknotes]: tag/weeknotes.html
