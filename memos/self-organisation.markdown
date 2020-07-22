---
title: Self Organisation
taxon: self-systems
published: 2018-09-24
modified: 2020-07-22
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

```graphviz
digraph {
  nodesep=1;

  "Normal tasks"    [shape=plain,style=dashed]
  "Urgent tasks"    [shape=plain,style=dashed]
  "Recurring tasks" [shape=plain,style=dashed]

  "Routines"
  "Has Prerequisites"
  "Backlog"
  "Upcoming"
  "This Sprint"
  "Doing"
  "Waiting / Blocked"
  "Done"

  "Normal tasks"    -> "Has Prerequisites" [style=dashed];
  "Normal tasks"    -> "Backlog"           [style=dashed];
  "Normal tasks"    -> "Upcoming"          [style=dashed];
  "Urgent tasks"    -> "Doing"             [style=dashed];
  "Recurring tasks" -> "Routines"          [style=dashed];

  "Routines"          -> "Doing"
  "Has Prerequisites" -> "Backlog"
  "Has Prerequisites" -> "Upcoming"
  "Backlog"           -> "This Sprint"
  "Upcoming"          -> "This Sprint"
  "This Sprint"       -> "Doing"
  "Doing"             -> "Waiting / Blocked"
  "Doing"             -> "Done"
  "Waiting / Blocked" -> "Doing"
  "Waiting / Blocked" -> "Done"
}
```

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

* **Doing**---things I'm actively doing at the moment (this list is
  very small).  Urgent tasks come straight here.

* **Waiting / Blocked**---things where I've done my part, and need to
  wait on something or someone else.

* **Done** - things I've done (there's a new done list every month).

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
* **Memo**
* **Miscellaneous**
* **Programming & Tech**
* **Self**
* a few tags for games I'm in


## Routines

I have a bunch of regular tasks which I collected together into a few
different routines:

* **Weekly**---household maintenance (cleaning, laundry, etc) and
  writing [weeknotes][].

* **Monthly**---more intense household maintenance (cleaning the oven,
  emptying the hoover, etc), updating computers, reviewing the tasks,
  etc.

* **Quarterly**---updating my CV and website.

* **Annual**---reviewing my financial habits.

Each routine is a single card on the board with a checklist of tasks
to complete and a deadline (end of last Sunday in the time period it's
for).

[weeknotes]: taxon/weeknotes.html
