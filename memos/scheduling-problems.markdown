---
title: Solving Scheduling Problems with Integer Linear Programming
tags: gov.uk, maths, programming
date: 2019-01-11
---

[Integer Linear Programming][ILP] (ILP) is, according to Wikipedia, a
kind of mathematical optimisation problem where you're trying to find
a set of integral variable-assignments maximising an objective
function subject to some constraints, where both the constraints and
objective function are expressed as linear functions.  But you don't
need to understand the theory to make use of ILP in your day-to-day
life!

You can express a bunch of interesting problems in terms of ILP, and
there are solvers which do a pretty good job of finding good solutions
quickly.  One of those interesting problems is scheduling, and there's
[a nice write-up of how PyCon uses an ILP solver to generate
schedules][pycon].

Another problem is rota generation, which is after all just a sort of
scheduling.  I have implemented [a rota generator for GOV.UK's
technical support][rota], and this memo is about how it works.


Rotas, mathematically
---------------------

What is a rota?

Well, there are a bunch of time slots \\(\\mathcal T\\), roles
\\(\\mathcal R\\), and people \\(\\mathcal P\\).  We can represent the
assignments as a 3D binary matrix:

```raw
\[
\begin{split}
A_{tpr} =
\begin{cases}
    1,&amp;\text{ if, in time }t\text{, person }p\text{ is scheduled in role }r\\
    0,&amp;\text{otherwise}
\end{cases}
\end{split}
\]
```

Next we need some constraints on what a valid rota looks like.

### In every time slot, each role is assigned to exactly one person

For every pair of slots and roles, the sum of the assignments should
be 1:

```raw
\[
\forall t \in \mathcal T \text{, }
\forall r \in \mathcal R \text{, }
\sum_{p \in \mathcal P} A_{tpr} = 1
\]
```

### Nobody is assigned multiple roles in the same time slot

For every pair of slots and people, the sum of the assignments should
be 0 (if they're not assigned anything) or 1 (if they are):

```raw
\[
\forall t \in \mathcal T \text{, }
\forall p \in \mathcal P \text{, }
\sum_{r \in \mathcal R} A_{tpr} \in \{0, 1\}
\]
```

### Nobody is assigned a role in a slot they are on leave for

We might give our people time off (how generous!), so there's no point
in generating a rota where someone gets scheduled during their time
off.

Given a function \\(leave : \\mathcal P \\mapsto 2^{\\mathcal T}\\),
which gives the set of slots someone is on leave, then: for every pair
of slots and people, all roles should be unassigned if the slot is in
\\(leave(p)\\):

```raw
\[
\forall p \in \mathcal P \text{, }
\forall t \in leave(p) \text{, }
\forall r \in \mathcal R \text{, }
A_{tpr} = 0
\]
```

### Nobody works too many shifts

We might also have a maximum number of shifts any one person can be
assigned to in a rota.

Given such a limit \\(M\\), then: for every person, the sum of the
assignments across *all* slots should be less than or equal to
\\(M\\):

```raw
\[
\forall p \in \mathcal P \text{, }
\sum_{t \in \mathcal T}
\sum_{r \in \mathcal R}
A_{tpr} \leqslant M
\]
```

### Assignments are fairly distributed

If all we wanted was constraints, then we could use a [SAT][] solver,
and it would probably do a better job than an ILP solver as a SAT
solver is *built* for solving boolean constraints!  But there's one
thing which is more easily expressible to an ILP solver than a SAT
solver: objective functions to optimise.

Given our above constraints, we will get *a* rota, but it might not be
very fair.  One person might be scheduled ten times, and another not
at all.  We can encourage the solver to be more fair by providing it
with an objective which results in more people being assigned.

First we'll need an auxiliary variable to check whether someone has
been assigned at all:

```raw
\[
\begin{split}
X_p =
\begin{cases}
    1,&amp;\text{ if person }p\text{ has any assignments}\\
    0,&amp;\text{otherwise}
\end{cases}
\end{split}
\]
```

We can use two new constraints to set the value of these \\(X\\)
variables:

```raw
\[
\forall t \in \mathcal T \text{, }
\forall p \in \mathcal P \text{, }
\forall r \in \mathcal R \text{, }
X_p \geqslant A_{tpr}
\]

\[
\forall p \in \mathcal P \text{, }
X_p \leqslant \sum_{t \in \mathcal T} \sum_{r \in \mathcal R} A_{tpr}
\]
```

As both \\(A_{tpr}\\) and \\(X_p\\) are binary variables, this means
\\(X_p\\) will be 1 if (first constraint) and only if (second
constraint) person \\(p\\) has any assignments at all.

We then give an objective to the solver:

```raw
\[
\textbf{maximise }
\sum_{p \in \mathcal P} X_p
\]
```

The only way to increase the value of the sum is by assigning roles to
more people, so that is what the solver will do.


The PuLP library
-----------------

[PuLP][] is a Python library for interfacing with ILP solvers.  It
provides a somewhat nicer interface than directly dealing with the
matrices and vectors on which ILP solvers operate, letting us express
constraints as equations much like I have here.

Here's how to express the above with PuLP:

```python
import pulp

# Parameters
slots  = 0
people = []
roles  = []
leave  = {}
max_assignments_per_person = 0

# Create the 'problem'
problem = pulp.LpProblem("rota generator", sense=pulp.LpMaximize)

# Create variables
assignments = pulp.LpVariable.dicts("A", ((slot, person, role) for slot in range(slots) for person in people for role in roles), cat="Binary")
is_assigned = pulp.LpVariable.dicts("X", people, cat="Binary")

# Add constraints
for slot in range(slots):
    for role in roles:
        # In every time slot, each role is assigned to exactly one person
        problem += pulp.lpSum(assignments[slot, person, role] for person in people) == 1

    for person in people:
        # Nobody is assigned multiple roles in the same time slot
        problem += pulp.lpSum(assignments[slot, person, role] for role in roles) <= 1

for person, bad_slots in leave.items():
    for slot in bad_slots:
        for role in roles:
            # Nobody is assigned a role in a slot they are on leave for
            problem += assignments[slot, person, role] == 0

for person in people:
    # Nobody works too many shifts
    problem += pulp.lpSum(assignments[slot, person, role] for slot in range(slots) for role in roles) <= max_assignments_per_person

# Constrain 'is_assigned' auxiliary variable
for slot in range(slots):
    for person in people:
        for role in roles:
            # If
            problem += is_assigned[person] >= assignments[slot, person, role]

for person in people:
    # Only if
    problem += is_assigned[person] <= pulp.lpSum(assignments[slot, person, role] for slot in range(slots) for role in roles)

# Add objective
problem += pulp.lpSum(is_assigned[person] for person in people)

# Solve with the Coin/Cbc solver
problem.solve(pulp.solvers.COIN_CMD())

# Print the solution!
for slot in range(slots):
    print(f"Slot {slot}:")
    for role in roles:
        for person in people:
            if pulp.value(assignments[slot, person, role]) == 1:
                print(f"    {role}: {person}")
```

The quantifiers have become `for...in` loops and the summations have
become calls to `pulp.lpSum` with a generator expression iterating
over the values of interest, but other than that it's fairly
straightforward.

With the parameters:

```python
slots  = 5
people = ["Spongebob", "Squidward", "Mr. Crabs", "Pearl"]
roles  = ["Fry Cook", "Cashier", "Money Fondler"]
leave  = {"Mr. Crabs": [0,2,3,4]}
max_assignments_per_person = 5
```

We get the output:

```
Slot 0:
    Fry Cook: Pearl
    Cashier: Squidward
    Money Fondler: Spongebob
Slot 1:
    Fry Cook: Spongebob
    Cashier: Mr. Crabs
    Money Fondler: Pearl
Slot 2:
    Fry Cook: Spongebob
    Cashier: Squidward
    Money Fondler: Pearl
Slot 3:
    Fry Cook: Spongebob
    Cashier: Pearl
    Money Fondler: Squidward
Slot 4:
    Fry Cook: Squidward
    Cashier: Spongebob
    Money Fondler: Pearl
```

If you play around with this you might notice two things:

1. The rota you get is always the same.

2. If there is no rota which meets the constraints, you get rubbish
   out!

This is due to how [Cbc][] works.  If you try [GLPK][], a different
solver, you'll still get a deterministic rota, but if there isn't one
meeting the constraints you'll (probably) get back an empty rota.
Solving ILP in the general case is NP-complete, so solvers use
heuristics.  Both Cbc and GLPK are deterministic, but they differ in
heuristics.

You can check the `problem.status` to see if it's solved or not:

```python
if problem.status != pulp.constants.LpStatusOptimal:
    raise Exception("Unable to solve problem.")
```

Another way to make the solver go wrong is by having a wide range of
values in your problem.  I'm not sure why this can cause a problem,
but it does.

### Randomisation

A simple way to introduce randomisation is to add give the solver a
randomly generated objective to maximise.  For example, we can assign
a score to every possible allocation, and try to maximise the overall
score:

```python
import random

randomise = pulp.lpSum(random.randint(0, 1) * assignments[slot, person, role] for slot in range(slots) for person in people for role in roles)
```

As we want the actual objective function to take priority, scale it
up:

```python
# Add objective
problem += pulp.lpSum(is_assigned[person] for person in people) * 100 + randomise
```

Now if we run the tool multiple times, we get different rotas:

```
$ python3 rota.py
Slot 0:
    Fry Cook: Spongebob
    Cashier: Squidward
    Money Fondler: Pearl
Slot 1:
    Fry Cook: Pearl
    Cashier: Spongebob
    Money Fondler: Mr. Crabs
Slot 2:
    Fry Cook: Spongebob
    Cashier: Squidward
    Money Fondler: Pearl
Slot 3:
    Fry Cook: Squidward
    Cashier: Spongebob
    Money Fondler: Pearl
Slot 4:
    Fry Cook: Squidward
    Cashier: Pearl
    Money Fondler: Spongebob

$ python3 rota.py
Slot 0:
    Fry Cook: Spongebob
    Cashier: Squidward
    Money Fondler: Pearl
Slot 1:
    Fry Cook: Spongebob
    Cashier: Squidward
    Money Fondler: Mr. Crabs
Slot 2:
    Fry Cook: Spongebob
    Cashier: Squidward
    Money Fondler: Pearl
Slot 3:
    Fry Cook: Pearl
    Cashier: Squidward
    Money Fondler: Spongebob
Slot 4:
    Fry Cook: Squidward
    Cashier: Spongebob
    Money Fondler: Pearl
```

The downside to this approach is that we might accidentally generate a
random objective which is really hard to maximise, making the solver
do a lot of work when all we really want is an arbitrary solution.


Modelling the GOV.UK support rota with ILP
------------------------------------------

The GOV.UK support rota is a bit more complex than the example above.
A typical rota runs for 12 weeks, with 1 week being 1 slot, in the
above parlance.  There are two types of roles, and constraints about
who can occupy which roles:

- **In-hours support roles:**
  - *Primary in-hours*, must have been secondary in-hours at least
    three times.
  - *Secondary in-hours*, must have been shadow at least two times.
  - *Shadow*, must not have shadowed twice before.  This role is
    optional.
- **Out-of-hours support roles:**
  - *Primary on-call*, no special requirements.
  - *Secondary on-call*, must have been primary on-call at least three
    times[^asym].

[^asym]: There's an asymmetry there: the primary in-hours needs to be
  experienced, but the opposite is the case for on-call roles.  This
  is intentional!  If the primary on-call were more experienced, they
  would resolve every issue themselves and the less experienced one
  would never get to learn anything.

There are separate pools for each type: there are some people who can
do in-hours support, some people who can do out-of-hours support, and
some people who can do both.

To ensure individuals and teams aren't over-burdened with support
roles, there are some constraints about when people can be scheduled:

- Someone can't be on in-hours support in two adjacent weeks.
- Two people on in-hours support in the same week (or adjacent weeks)
  can't be on the same team.

And there is also a limit on the number of in-hours and out-of-hours
roles someone can do across the entire rota.

The objective function is a bit more complex too:

- As above, we want to maximise the number of people on the rota.
- We want to maximise the number of weeks when the secondary in-hours
  has done it fewer than three times.
- We want to maximise the number of weeks when the primary
  out-of-hours has done it fewer than three times.
- We want to maximise the number of weeks with a shadow.

### Primary in-hours must have been secondary in-hours at least three times

I won't go through all of the constraints, as they're mostly more of
the same, but this is an example of a particularly interesting
constraint, as it's pretty hard to implement.

The logic here is simple, but the language of ILP is very limited: you
can't directly express `if...then`-style constraints between
variables.  Now, this is fine if we want to limit the primary in-hours
role to people who have been secondary in-hours at least three times
*before this rota period*, as we can statically determine that:

```raw
\[
\forall t \in \mathcal T \text{, }
\forall p \in \mathcal P \text{, }
\text{if }p\text{ has been secondary}\lt 3\text{ times before the start of this rota, }
A_{tp,\text{primary}} = 0
\]
```

But that's too restrictive.  If someone has been secondary in-hours
two times before the start of the rota, and is secondary in-hours in
one week, they should be able to be primary in-hours in subsequent
weeks.

To work around this we'll need some auxiliary variables.

Firstly, let's record how many times someone has been a secondary at
the start of each slot:

```raw
\[
\begin{split}
S_{tp} =
\begin{cases}
    \text{the number of times person }p\text{ has been a secondary before the start of this rota},&amp;\text{ if }t = 0\\
    S_{t-1,p} + A_{t-1,p,\text{secondary}},&amp;\text{otherwise}
\end{cases}
\end{split}
\]
```

Unlike previous variables we've seen, this is not a binary variable.
But it is still an integral variable.  Translating the above into ILP
constraints is straightforward:

```raw
\[
\forall p \in \mathcal P \text{, }
S_{0,p} = \text{the number of times person }p\text{ (etc)}
\]
\[
\forall t \geqslant 1 \in \mathcal T \text{, }
\forall p \in \mathcal P \text{, }
S_{tp} = S_{t-1,p} + A_{t-1,p,\text{secondary}}
\]
```

Now we can use [a trick I found to encode conditionals in ILP][trick].
The trick is to introduce an auxiliary variable, \\(D \\in
\\{0,1\\}\\), and use constraints to ensure that \\(D = 0\\) when the
condition goes one way, and \\(D = 1\\) when it goes the other.

Here is how we encode `if X > k then Y >= 0 else Y <= 0`, where `k` is
constant:

```raw
\[
\begin{align}
0     &amp;\lt X - k + m \times D     \\
0     &amp;\leqslant Y + m \times D   \\
X - k &amp;\leqslant m \times (1 - D) \\
Y     &amp;\leqslant m \times (1 - D)
\end{align}
\]
```

Here \\(X\\) and \\(Y\\) are the ILP variables from our conditional,
\\(D\\) is the auxiliary variable we introduced, and \\(m\\) is some
large constant, way bigger than the possible maximum values of \\(X\\)
or \\(Y\\).  Let's walk through this, firstly here's the case where
\\(D = 0\\):

```raw
\[
\begin{align}
0     &amp;\lt X - k   \\
0     &amp;\leqslant Y \\
X - k &amp;\leqslant m \\
Y     &amp;\leqslant m
\end{align}
\]
```

Because \\(m\\) is a large constant, the bottom two constraints are
trivially true, so they can be removed.  With a little rearranging, we have:

```raw
\[
\begin{align}
k     &amp;\lt X       \\
0     &amp;\leqslant Y \\
\end{align}
\]
```

So if \\(D = 0\\), \\(X\\) is strictly greater than \\(k\\) (the
condition is true), and \\(Y \\geqslant 0\\).  That's the true branch
sorted!

Now let's look at the \\(D = 1\\) branch:

```raw
\[
\begin{align}
0     &amp;\lt X - k + m   \\
0     &amp;\leqslant Y + m \\
X - k &amp;\leqslant 0     \\
Y     &amp;\leqslant 0
\end{align}
\]
```

Because \\(m\\) is a large constant, this time we can get rid of the
first two constraints.  With a little rearranging, we get:

```raw
\[
\begin{align}
X &amp;\leqslant k \\
Y &amp;\leqslant 0
\end{align}
\]
```

So if \\(D = 1\\), \\(X\\) is not strictly greater than \\(k\\) and
\\(Y\\) is at most zero.  Remember, the real "\\(Y\\)" we're using is
an \\(A_{tpr}\\) value, which is a binary value, so the overall effect
is to specify that it must be zero.  Adding a constraint \\(Y
\\geqslant 0\\) would do the same job.

Each conditional needs a fresh \\(D\\) variable.  So adding these
conditionals in results in a lot of extra variables and constraints:

```raw
\[
\begin{alignat*}{4}
&amp;\forall t \in \mathcal T \text{, } \forall p \in \mathcal P \text{, } &amp; 0 &amp;\lt S_{tp} - 2 + 999 \times D_{tp} \\
&amp;\forall t \in \mathcal T \text{, } \forall p \in \mathcal P \text{, } &amp;0 &amp;\leqslant A_{tp,\text{primary}} + 999 \times D_{tp} \\
&amp;\forall t \in \mathcal T \text{, } \forall p \in \mathcal P \text{, } &amp;S_{tp} - 2 &amp;\leqslant 999 \times (1 - D_{tp}) \\
&amp;\forall t \in \mathcal T \text{, } \forall p \in \mathcal P \text{, } &amp;A_{tp,\text{primary}} &amp;\leqslant 999 \times (1 - D_{tp})
\end{alignat*}
\]
```

Here 2 has been substituted for \\(k\\), as someone needs to have been
a secondary at least three times to be a primary; and 999 has been
substituted for \\(m\\), which is larger than the number of secondary
shifts someone could actually have done.

### Two people on in-hours support in the same week can’t be on the same team

Let's cover one more type of constraint: not over-burdening teams by
taking all of their members away to be on support at once.  This one
is pretty simple, but does require a bit more information about the
people, specifically, what team they're on.

Given a function \\(team : \\mathcal P \\mapsto 2^{\\mathcal P}\\),
which gives the set of people on the same team as another, then: for
every pair of slots and people, there should be no overlap in the
in-hours assignments if the two people are on the same team:

```raw
\[
\forall t \in \mathcal T \text{, }
\forall p_1 \in \mathcal P \text{, }
\forall p_2 \neq p_1 \in team(p_1) \text{, } \\
\forall r_1 \in \{\text{primary}, \text{secondary}, \text{shadow}\} \text{, } \\
\forall r_2 \in \{\text{primary}, \text{secondary}, \text{shadow}\} \text{, } \\
A_{t,p_1,r_1} + A_{t,p_2,r_2} \leqslant 1
\]
```


The Incredible Rota Machine
---------------------------

My GOV.UK rota generator [is on GitHub][rota], and also on Heroku as
[The Incredible Rota Machine][heroku].

I've timed it on my laptop by running it repeatedly overnight, and
found that the time to generate a rota varies between about 10s and
15m, but the median is about 30s.  I expect it'll be slower on Heroku,
though.

It's already paying off, I saved the person who usually puts together
the rota an hour and a half!  A new rota is needed every quarter, and
it took me three and a half days to make, so it'll pay for itself in a
mere four and a half years!

It was a fun project, and a neat thing to do in firebreak---the
one-week "do whatever you want as long as it's useful" gap we have
between quarters---but probably not worth it if you're looking to save
a bit of time.

![xkcd 1205, "Don't forget the time you spend finding the chart to look up what you save. And the time spent reading this reminder about the time spent. And the time trying to figure out if either of those actually make sense. Remember, every second counts toward your life total, including these right now."](xkcd-1205.png)


[ILP]: https://en.wikipedia.org/wiki/Integer_programming
[pycon]: https://conference-scheduler.readthedocs.io/en/latest/background/mathematical_model.html
[rota]: https://github.com/barrucadu/govuk-2ndline-rota-generator
[SAT]: https://en.wikipedia.org/wiki/SAT
[PuLP]: https://pythonhosted.org/PuLP/
[Cbc]: https://projects.coin-or.org/Cbc
[GLPK]: https://www.gnu.org/software/glpk/
[trick]: http://www.yzuda.org/Useful_Links/optimization/if-then-else-02.html
[heroku]: https://govuk-2ndline-rota-generator.herokuapp.com/
