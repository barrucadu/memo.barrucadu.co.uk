---
title: Self Organisation
taxon: self-systems
published: 2018-09-24
modified: 2020-09-11
---

My memory is good for *facts* but poor for *tasks* and *experiences*.
I can recall obscure details about a programming project months or
years after-the-fact with a little thought, but would forget to do the
laundry every weekend if I didn't have it written down, and I
certainly won't remember promising to do something.

I've given up on improving my recall, and instead have developed a
system to organise myself and make sure I get around to doing things
I've said I would.  Much like my [personal finance][] system, this
system have evolved over the years based on what's made noticeable
improvements to my life.

My ideas may not work as-is for you, but I hope they'll prompt you to
think about how you organise yourself, and what you can do to improve.

[personal finance]: personal-finance.html


"Scrumban" for to-do lists
--------------------------

I've worked at a few different programming jobs now, and I've noticed
programmers on small agile teams have a tendency to adopt a style of
development I've heard called "scrumban":

- Like scrum, there are fixed-length sprints, but like kanban work
  gets added to the backlog at any time.  The sprint cadence is mostly
  to review the pending work and prune the backlog, it's not a target
  to get everything done by.

- Like scrum, there is a product manager who is ultimately in charge
  of the backlog, and a delivery manager (or scrum master) who leads
  the ceremonies.

- Like kanban, work is delivered continuously, but like scrum there is
  usually an end-of-sprint show-and-tell.

- Like kanban, we use a kanban board with a WIP limit.

So scrumban is mostly kanban, but the backlog has an owner who
regularly reviews it.  I view scrumban as close to the minimal amount
of process needed to work in an effective development team: there's
regular product oversight of the work (the sprint cadence), and
everyone knows what everyone else is working on (the daily standup).

I use a form of scrumban to keep on top of my to-do list.  I am the
"product manager" for my life, making sure I only do relevant things,
I suppose I'm also the "delivery manager" for my life, ensuring I get
things done and resolve blockers, but so far I've not felt the need to
have a daily standup of just me.

So, onto how I implement this.

### Trello

![A screenshot of my "To Do" Trello board](self-organisation/todo.png)

Everything I need to do, which isn't captured elsewhere (like in my
email inbox, or in a GitHub issue), goes on the [Trello][] board.  And
if it's a particularly important email or GitHub issue I want to make
sure I don't forget about, and I can't deal with it straight away,
I'll make a card for it anyway.

I've found Trello works better for me for this than [org-mode][] did:
the latter is very powerful, which makes it hard to use consistently;
Trello is much more limited, so consistency is easy.  It's also nice
to have the board visualisation, so I can see at a glance how much
stuff I have to do.

The rest of my process is now more complex than it was when I first
started, but even just having "To Do", "Doing", "Waiting / Blocked",
and "Done" lists was a game-changer.  I *would* have got my Ph.D
corrections done without Trello (because I had to), but it would have
been much more difficult.

[Trello]: https://trello.com/
[org-mode]: https://orgmode.org/

### Task states

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

Each task I need to do is in one of these states:

- **Routines**---a backlog of regular, time-based, tasks (see
  [routines](self-organisation.html#routiens) section).

- **Has Prerequisites**---a backlog of things I can't do until I do
  something else.

- **Backlog**---a backlog of things which would be nice to do, but
  aren't particularly important or urgent.

- **Upcoming**---a backlog of important, but non-urgent, things.

- **This Sprint**---a to-do list of tasks from **Backlog** and
  **Upcoming** which I've decided to get done this sprint.

- **Doing**---things I'm actively doing at the moment (this list is
  very small).

- **Waiting / Blocked**---things where I've done my part, and need to
  wait on something or someone else.

- **Done** - things I've done.

Each of these is a list on my Trello board.

### Sprints

I used to not have the **This Sprint** list, and would just pick up
tasks from **Backlog** and **Upcoming** based on whatever I felt like
doing.  But one day I realised that some of the **Upcoming** tasks had
been there for over a year.  They were important, but I was putting
them off, and still feeling good about myself because I was getting
through lots of unimportant tasks instead.

This is standard procrastination behaviour.

So I decided to have a fortnightly "sprint planning" session where I
would prioritise a small number of tasks, ensuring that nothing got
neglected too much.

I'm not terribly strict on myself: if I get through all the sprint
tasks, great; if not, no big deal, they can either remain for the
following sprint, or move back into a different list.  On the whole
this change has helped me get through things.


Calendars for routines
----------------------

I manage routines using [Google Calendar][], another integral
component of my self-organisation system.

Routines are recurring calendar events, for example I've got an event
every Saturday morning called "weekly chores", and every another
Sunday evening called "weeknotes".

The routines which have multiple things to do (like my chores) have a
corresponding card in the **Routines** list on my Trello board, which
has a deadline.  When the time to do the routine arrives I make a copy
of the card in **Doing**, update the deadline of the template card,
and work through the checklist.

Those routines which just have a single task, like "sprint planning",
just have a calendar entry.

Routines which I've got cards for are:

- **Weekly chores**---household maintenance (cleaning, laundry, etc)
  and checking my [ledger][personal finance] is up to date.

- **Prepare game**---preparation for my [fortnightly Call of Cthulhu
  game][].

- **Monthly chores**---more intense household maintenance (cleaning
  the oven, emptying the hoover, etc), updating computers, and
  reviewing the lists.

- **Quarterly chores**---updating my CV and website and checking my
  credit report.

- **Annual chores**---reviewing my habits and preparing for the next
  year.

Routines on my calendar which I don't have cards for are:

- **Sprint planning** and **Mid-sprint review**---alternating Sundays,
  populate and review the **This Sprint** list.

- **Write up session notes**---every other Sunday evening, write up
  notes from the game I prepared and ran.

- **Weeknotes**---every Sunday evening, write my [weeknotes][].

I find having the Trello cards, rather than just putting the steps to
be done in the calendar event, helps.  I'm quite visual with this sort
of data, I like being able to look at the calendar and see when
everything needs to be done; but I prefer the Trello card interface
for text and checkboxes.  It's nice having everything in its place:
temporal data on a calendar, procedural data in a card.

[Google Calendar]: https://calendar.google.com/
[fortnightly Call of Cthulhu game]: campaign-notes-2020-05-call-of-cthulhu.html
[weeknotes]: taxon/weeknotes.html


Going analogue for household organisation
------------------------------------------

The final component of my self-organisation system is a whiteboard and
some pens.

I primarily use this to note down my shopping list, as it's much
easier to grab a pen and scribble something down than to open Trello
and add a comment to a card.

I also use the whiteboard for meal planning.  I have a simple 5-week
calendar on the board, with rows labelled "Monday" to "Sunday" and
columns labelled "1" to "5", and the first cell of each column
labelled with the day number (the "week 1" column may not start with
the "Monday" cell).  I tend to cook large portions of meals so I can
freeze some of it for later, and I note down meals for future days as
my freezer fills up.  This has all but eliminated getting to the
evening and realising I have nothing in, which has cut down on
takeaways and helped to optimise my food budget.
