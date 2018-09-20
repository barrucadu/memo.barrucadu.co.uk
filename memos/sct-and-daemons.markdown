---
title: Systematic Concurrency Testing and Daemon Threads
tags: concurrency, programming, research
date: 2016-05-13
audience: Narrow
---

Systematically testing concurrent programs is hard because, for
anything nontrivial, there are a *lot* of potential executions. There
are a few approaches to solving this problem, one of which is
*partial-order reduction*, which forms the basis of dejafu's testing
today (and is available by itself in the [dpor][] library). This is
the approach, in outline:

1. Run your concurrent program, recording an execution trace.
2. Look back through the trace for pairs of actions which *might* give
   a different result if done in the other order. These are called
   *dependent actions*.
3. For each pair of dependent actions, attempt to schedule the latter
   before the former by inserting a context switch.

It works pretty well. The space of potential schedules is cut down by
a *huge* proportion. In papers presenting specific partial-order
algorithms, the authors will typically give a little example like so:

> We assume a core concurrent language consisting of reads and writes
> to shared variables. In this context, two reads are independent, but
> two writes, or a read and a write, are dependent if to the same
> variable.

So here's a little example, we have two threads, `T0` and `T1`, which
are executing concurrently:

~~~
T0:  read x        T1:  read x
                        write x 1
~~~

Initially `x = 0`. If we take the result of this program to be the
value of `x` that `T0` reads, then there are clearly two possible
results, and here are possible traces which could lead to them:

~~~
T0:  read x           T1: read x
T1:  read x           T1: write x 1
T1:  write x 1        T0: read x
result = 0            result = 1
~~~

If we run this program under a non-preemptive scheduler starting with
`T0`, it'll run `T0` until it terminates, then run `T1`, giving the
left trace above. The algorithm will then note the dependency between
`T1: write x 1` and `T0: read x`, and so schedule `T1` before `T0`,
giving the right trace above. This will then give rise to a third
execution:

~~~
T1:  read x
T0:  read x
T1:  write x 1
result = 0
~~~

But it doesn't change the result. You might think an obvious
optimisation is to apply the context switch before as many independent
actions as possible, which would then not give a new unique schedule
to try. Unfortunately this isn't sound in general because what if the
write is conditional on the read? The execution trace only contains
*visible* actions, if-statements and the like are not shown.

I have made an assumption when I ran that program, can you see what it
is?

- - -

**[pause for dramatic effect]**

- - -

I am assuming that the program only terminates after every thread
terminates! If the program instead terminates when `T0` terminates, we
would get this trace:

~~~
T0: read x
result = 0
~~~

There is no dependency between reads, so `T1` would never be
scheduled. In this context, `T1` is a *daemon thread*. Daemon threads
do not block program termination, they are killed by the runtime after
all non-daemon threads terminate. In Haskell, all threads other than
the main thread are demon threads. Variants of this problem have
cropped up in a few places in dejafu and bitten me. I couldn't find
anything written about this online, so I decided to document it for
posterity.

There are two solutions:

1. Make your dependency function *smarter*, by having a special case:
   two actions are dependent if one of them is the last action in the
   trace. This handles daemon threads, and also cases where the
   program did not terminate gracefully but was aborted by the testing
   framework: for instance, if you bound the length of an execution,
   you still want to explore different schedules within that bound.

2. Add a special "stop" action to the end of the main thread, which is
   dependent with everything. This does *not* handle the case where
   execution is aborted by the test framework, only when execution
   terminates gracefully.

The dpor library implements a variant of case 1, to accommodate
length-bounding. I'm not convinced it's a great solution, as it leads
to a lot of additional schedules being explored which are then quickly
aborted, but I'm not sure of a better approach yet. The dejafu library
implements case 2, because having a special "stop" action also gives
you a convenient place to clean up everything associated with a
thread.

So that's it: daemon threads do work within the context of
partial-order reduction, but you need to make sure you're explicitly
handling the termination of the main thread.

[dpor]: http://hackage.haskell.org/package/dpor
