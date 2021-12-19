---
title: Self Organisation
taxon: self-systems
published: 2018-09-24
modified: 2021-12-19
---

I'm good at remembering facts and details, but not so good at
remembering tasks and experiences.  I'd forget to do the laundry every
weekend if I didn't have it written down: so I wrote it down.

I've developed a system to organise myself and make sure I get around
to doing the things I need to do.  Like my [personal finance][]
system, this system has evolved over the years based on what's made
noticeable improvements to my life, and this memo describes what I
currently put into practice, and not some aspirational system I can
only hope to achieve

[personal finance]: personal-finance.html


Trello for to-do lists
----------------------

I've worked at a few different programming jobs now, and I've noticed
programmers on small agile teams tend to adopt a process like this:

- There's a Trello board with various lists: some are lists for work
  not yet started, some are for work in progress, and one is for work
  which is done.

- We regularly review the lists: to make sure work is progressing, to
  make sure we don't have too much in progress at once, and to decide
  what to pick up next.

- Once every week or two, there's a more in-depth review in which new
  work gets prioritised, and old work might be changed or removed.

I think this works really well.  So I use this system to manage my
life as well.

### Trello

![A screenshot of my "To Do" Trello board](self-organisation/todo.png)

Everything I need to do, which isn't captured elsewhere (like in my
email inbox, or in a GitHub issue), goes on the [Trello][] board.  And
if it's a particularly important email or GitHub issue I want to make
sure I don't forget about, and I can't deal with it straight away,
I'll make a card for it anyway.

I used to use [org-mode][] for this, but I've found I personally am
more productive with Trello.  [org-mode][] is very powerful, and so I
felt I needed to tinker with it to come up with a *perfect* system,
which in practice just meant I spent more time fiddling with *how I
tracked things* than *actually doing things*.  Trello is much more
limited.

It's also nice to have the board visualisation, so I can see the state
of everything at a glance.

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
  "Nice To Have"
  "Priority"
  "Near Future"
  "Doing"
  "Waiting / Blocked"
  "Done"

  "Normal tasks"    -> "Has Prerequisites" [style=dashed];
  "Normal tasks"    -> "Nice To Have"      [style=dashed];
  "Normal tasks"    -> "Priority"          [style=dashed];
  "Urgent tasks"    -> "Doing"             [style=dashed];
  "Recurring tasks" -> "Routines"          [style=dashed];

  "Routines"          -> "Doing"
  "Has Prerequisites" -> "Nice To Have"
  "Has Prerequisites" -> "Priority"
  "Nice To Have"      -> "Near Future"
  "Priority"          -> "Near Future"
  "Near Future"       -> "Doing"
  "Doing"             -> "Waiting / Blocked"
  "Doing"             -> "Done"
  "Waiting / Blocked" -> "Doing"
  "Waiting / Blocked" -> "Done"
}
```

Each task is in one of these states:

- **Routines**---regular, time-based, tasks.

- **Has Prerequisites**---things I can't do until I do something else.

- **Nice To Have**---things which would be nice to do, but aren't
  particularly important or urgent.

- **Priority**---important, but non-urgent, things.

- **Near Future**---tasks regularly taken from **Nice To Have** and
  **Priority** which I've decided to get done soon.

- **Doing**---things I'm actively doing at the moment (this list is
  very small).

- **Waiting / Blocked**---things where I've done my part, and need to
  wait on something or someone else.

- **Done**---things I've done.

Each of these is a list on my Trello board.

### The "Near Future" state

I used to pick up tasks from **Nice To Have** and **Priority** as I
felt like it.  But one day I realised that some of the **Priority**
tasks had been there for over a year.  They were important, but I was
putting them off, and still feeling good about myself because I was
getting through lots of unimportant tasks instead.

This is standard procrastination behaviour.

So I decided to have a fortnightly "sprint planning" session where I
would prioritise a small number of tasks, ensuring that nothing got
neglected too much.  I moved these into a **This Sprint** list, which
I aimed to get through in that fortnight.

But, actually, I still found myself slipping a lot.  The separate list
of short-term priorities definitely helped out, but some things hung
around in there for a while, or got moved back into a different list.

So I renamed it to **Near Future**.  It does the same thing as **This
Sprint** did, but it's more honest.


Calendars for routines
----------------------

I track routines as recurring events in [Google Calendar][], another
integral component of my self-organisation system.

Those routines which have multiple things to do (like my chores) have
a corresponding card in the **Routines** list on my Trello board.
When the time to do the routine arrives I move a copy of the template
card to **Doing** and work through its checklist.  Those which just
have a single task, like "Near Future prioritisation", just have a
calendar entry.

Routines which I've got cards for are:

- **Weekly chores**---household maintenance (cleaning, laundry, etc)
  and checking my [ledger][personal finance] is up to date.

- **Prepare game**---preparation for my regular RPG sessions
  (currently [Ars Magica][] and [Traveller][]).

- **Monthly chores**---more intense household maintenance (cleaning
  the oven, emptying the hoover, etc), updating computers, and
  reviewing the lists.

- **Quarterly chores**---updating my CV and website, and checking my
  credit report.

- **Annual chores**---reviewing my habits and preparing for the next
  year.

Routines on my calendar which I don't have cards for are:

- **Near Future prioritisation**---every Sunday, review and move cards
  into and out of the **Near Future** list.

- **Write up session notes**---after my RPG sessions, write up notes
  from the game I prepared and ran.

- **Weeknotes**---every Sunday evening, write my [weeknotes][].

I find having the Trello cards, rather than just putting the steps to
be done in the calendar event, helps.  I like being able to look at
the calendar and see when everything needs to be done; but I prefer
the Trello card interface for text and checkboxes.  It's nice having
everything in its place: temporal data on a calendar, procedural data
in a card.

[Google Calendar]: https://calendar.google.com/
[Ars Magica]: campaign-notes-2021-11-ars-magica.html
[Traveller]: campaign-notes-2021-10-traveller.html
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
labelled with the day number.  I tend to cook large portions of meals
so I can freeze some of it for later, and I note down meals for future
days as my freezer fills up.  This has all but eliminated getting to
meal time and realising I have nothing in, which has cut down on
takeaways and helped to optimise my food budget.
