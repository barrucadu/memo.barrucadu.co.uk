---
title: Self Organisation
taxon: self-systems
published: 2018-09-24
modified: 2020-02-09
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

There are three types of state a task can be in: not yet done, being
worked on, and done.  I break those three broad types into a few
different more specific states:

* **Routines**---regular, time-based, tasks.

* **Has Prerequisites**---things I can't do until I do something else
  (which is also on the board, and linked from this thing).

* **Backlog**---things which would be nice to do, but aren't
  particularly important or urgent.

* **Upcoming**---important, but non-urgent, things.

* **This Sprint**---a mixture of tasks from **Backlog** and
  **Upcoming** I've decided to do this sprint (see below).

* **Urgent**---things to do ASAP.  Normally tasks will arrive straight
  here.  They can also come in from **Has Prerequisites**, for
  example, if there's a task which can't be worked on until a
  condition is met, but once that condition is met it becomes urgent.
  Tasks in **Routines** move into **Urgent** a few days before they're
  due.

* **Doing**---things I'm actively doing at the moment (this list is
  very small).

* **Waiting / Blocked**---things where I've done my part, and need to
  wait on something or someone else.

  For example, saving three months expenses.  I've got a budget to
  achieve this, I just need to wait for enough time to pass.

* **Evaluating**---changes which I'm still trying out, like changes to
  my [Personal Finance][] system.

* **Done** - things I've done (there's a new done list every month).

[Personal Finance]: personal-finance.html

Here's a state transition diagram showing the normal workflows:

```graphviz
digraph {
  nodesep=1;

  "Routines"          [peripheries=2];
  "Has Prerequisites" [peripheries=2];
  "Backlog"           [peripheries=2];
  "Upcoming"          [peripheries=2];
  "This Sprint"
  "Urgent"            [peripheries=2];
  "Doing"
  "Waiting / Blocked"
  "Evaluating"
  "Done"

  "Routines"          -> "Urgent"
  "Has Prerequisites" -> "Backlog"
  "Has Prerequisites" -> "Upcoming"
  "Has Prerequisites" -> "Urgent"
  "Backlog"           -> "This Sprint"
  "Upcoming"          -> "This Sprint"
  "This Sprint"       -> "Doing"
  "Urgent"            -> "Doing"
  "Doing"             -> "Waiting / Blocked"
  "Doing"             -> "Evaluating"
  "Doing"             -> "Done"
  "Waiting / Blocked" -> "Doing"
  "Waiting / Blocked" -> "Done"
  "Evaluating"        -> "Done"
}
```

States in which new tasks arrive have a double border.  There are also
flows which don't really fit into the idealised model:

- Tasks might jump straight from one of the to-do lists to **Done**
  without going through **Doing** first.
- A task in **Has Prerequisites** might move into **Doing** at while a
  prerequisite is still in **Doing**.

Tasks can be deleted at any point.

### Sprints

I've decided to take a concept from software development planning and
use "sprints" to prioritise tasks.  Every fortnight I move some tasks
from **Backlog** and **Upcoming** into **This Sprint**, and when
picking up a new task I look at **This Sprint** first.

If I get through all the sprint tasks, great; if not, no big deal,
they can either remain for the following sprint, or move back into a
different list.


## Tags

Every task has at least one tag.  The tags are:

* **Career**
* **Finance**
* **Home**
* **Kitchen**
* **RPG**
* **Memo**
* **Miscellaneous**
* **Programming & Tech**
* **Self**

I'm thinking of tweaking these.


## Routines

I have a bunch of regular tasks which I collected together into a few
different routines:

* **Weekly**---household maintenance (cleaning, laundry, etc) and
  writing [weeknotes][].

* **Fortnightly**---sprint planning and preparing for my RPG.

* **Monthly**---more intense household maintenance (cleaning the oven,
  emptying the hoover, etc), budgeting, and backing up computers.

* **Quarterly**---updating my CV and website.

* **Biannual**---testing the harddrive failure alert in my home
  server.

* **Annual**---reviewing my financial habits.

Each routine is a single card on the board with a checklist of tasks
to complete and a deadline (end of last Sunday in the time period it's
for).

I expect these to change as I repeat them: the weekly and monthly
routines have already been tweaked a bit, but the quarterly routine
has only happened once so far, and the biannual and annual routines
haven't happened at all yet.

[weeknotes]: taxon/weeknotes.html
