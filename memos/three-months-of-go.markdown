---
title: Three Months of Go (from a Haskeller's perspective)
tags: haskell, go, programming
date: 2016-08-25
---

This summer I've been interning at [Pusher][], and have been writing a
lot of Go. It's been a bit of a change coming from a Haskell
background, so I decided to write up my thoughts now, at the end.

## The Good

### Incredibly easy to pick up

There's not a lot to Go, it's quite a small language. I had never
written a line of it before June, and now I've written about 30,000.
It's very easy to get started and become productive.

Haskell, on the other hand, is notorious for being hard to learn
(*cough* monad tutorials *cough*). People often find it really hard to
take the step from evaluating pure mathematical expressions to writing
actual programs. I experienced no such disconnect in Go.

### Garbage collector keeps getting better and better

Pusher previously tried to use Haskell for the project I was working
on, but eventually had to give up due to unpredictable latency caused
by garbage collection pauses. GHC's garbage collector is
[designed for throughput, not latency][ghcgc]. It is a generational
copying collector, which means that pause times are proportional to
the amount of live data in the heap. To make matters worse, it's also
stop-the-world.

[Go's garbage collector][gogc] is a concurrent mark-sweep with very
short stop-the-world pauses, and it just seems to
[keep getting better][perf17]. This is definitely a good thing for a
garbage collected language. We did have some issues with unacceptable
latencies, but were able to work them all out. No such luck with the
Haskell project.

### Style wars are a thing of the past

Say what you like about `gofmt`, but it makes arguments over code
style almost impossible. Just run it on save, and your code will
always be consistently formatted.

I do find it a little strange that `gofmt` has been completely
accepted, whereas Python's significant whitespace (which is there for
exactly the same reason: enforcing readable code) has been much more
contentious across the programming community.

## The Neutral

### Code generation seems to be the accepted solution to a lot of problems

I am not a huge fan of code generation (and I say this as
[the author of a code generation tool][pblog]). I think it can do
good, but it can also obscure what's actually going on. In every
discussion on Go generics, someone will come along and say you can add
generics with code generation: that's true, but at the cost of
introducing additional, nonstandard, syntax.

I suspect the strong culture of code generation is largely because it
lets you work around the flaws of the language.

### Strict, not lazy, evaluation

Strict evaluation is typically better for performance than lazy
evaluation (thunks cause allocation, so you're gambling that
[the computation saved offsets the memory cost][svl]), but it does
make things less composable. There have been a couple of times where
I've gone to split up a function, only to realise that doing so would
require allocating a data structure in memory which before was not
needed.

I could trust the compiler to inline things for me, and so optimise
away the additional allocations, but in a lazy language you just don't
have that issue at all.

### The standard library is not so great

If you know me in person, it might seem a little odd that I
specifically comment on this. Normally I am all for languages having a
small, really well-written, stdlib and everything else provided
through libraries. I am picking on Go here a bit because the standard
library seems to get a lot of praise, but I was unimpressed.

Parts of it are good, a lot of it is mediocre, and some of it is
downright bad (like the [go/ast][] package documentation). It seems a
lot of Go's use is in webdev, so perhaps those bits of the stdlib
(which I haven't touched at all) are consistently good.


## The Bad

I also agree with this Quora answer by Tikhon Jelvis to
[do you feel that golang is ugly?][quora], so have a look at that once
you've read this section.

### A culture of "backwards compatibility at all costs"

In Go, you import packages by URL. If the URL points to, say, GitHub,
then `go get` downloads HEAD of master and uses that. There is no way
to specify a version, unless you have separate URLs for each version
of your library.

This is just insane.

Go has a very strong culture of backwards compatibility, which I think
is largely due to this. Even if you have a flaw in the API of your
library, you can't actually *fix* it because that would break all of
your reverse-dependencies, unless they do vendoring, or pin to a
specific commit.

Coming from the Haskell world, where the attitude is far more towards
correctness than compatibility, this was probably the biggest culture
shock for me. Things break backwards compatibility in Haskell, and the
users just update their code because they *know* the library author
did it for a reason. In Go, it just doesn't happen *at all*.

### The type system is really weak

A common mantra in Haskell is "make illegal states unrepresentable,"
which is great. If you've never come across it before it means to
*choose your types such that an illegal value is a static error*. Want
to avoid nulls? Use an option type. Want to ensure a list has at least
one element? Use a nonempty list type. Use proper enums, not just
ints. etc etc

In Go you just can't do that, the type system isn't strong enough. So
a lot of things which are (or can be) a *compile-time* error in
Haskell are a *runtime* error in Go, which is just worse.

Let's pick on some specifics:

- **No generics**

    Want to write a tree where every element is statically
    *guaranteed* to be the same type? Well, have fun implementing a
    "uinttree", an "inttree", a "stringtree", and so on. You can't
    just implement a generic tree.

    But Go *does* have generics, for the built-in types. Arrays,
    channels, maps, and slices all have generic type parameters. So it
    seems that the Go developers want generics, but they don't want to
    bother implementing it properly, so it remains a special case for
    a few things in the compiler.

- **No sum types**

    The way in Go to handle possibly-failing functions is to have
    multiple return values: an actual result, and an error. If the
    error is `nil`, then the actual result is sensible; otherwise the
    actual result is meaningless.

    This means you can forget to check the error and use a bogus
    result and, because there are no compiler warnings (another wtf),
    you will know nothing of this until things fail at runtime.

    With a sum type, like `Either error result`, that just can't
    happen.

- **No separation of pure code from effectful code**

    It is very nice to know, just by looking at the type of a
    function, that it *cannot* perform any side-effects. Go's type
    system doesn't do that.

### The tooling is bad

Haskell gets a lot of criticism for bad tooling, but I think it's
worlds ahead of Go in some cases.

- **Godoc makes it really difficult to write good documentation**

    Godoc groups bindings by type, and then sorts alphabetically. Code
    is not written like that, code is written with related functions
    in proximity to each other. The source order is *almost always*
    better than how godoc sorts things.

    Also, [godoc doesn't even support lists][godoc]:

    > Previous proposals similar to this have been rejected on grounds
    > that it's a slippery slope from this to Markdown or worse.

    I think that comment is particularly discouraging. Because the
    developers don't like Markdown (and similar languages), they
    refuse to add even the most basic of formatting to godoc.

- **There is nothing like GHC's heap profiling**

    Go has a snapshot-based memory profiler. You can take a snapshot
    at a point in time, and see which functions and types are taking
    up the heap space. However, there is [nothing like this][ghchp].

    Being able to see not only a snapshot, but also how things have
    changed over time, is incredibly useful for spotting memory leaks.
    If all you have is a snapshot, all you can really say is "well,
    the number of allocated `Foo`s looks a bit high, is that right?"
    With a graph you can say "the number of allocated `Foo`s is
    increasing when it shouldn't be."

- **There is (was?) nothing like ThreadScope**

    [ThreadScope][] is a tool for profiling performance of concurrent
    Haskell programs. It shows which Haskell threads are running on
    which OS threads, when garbage collection happens, and a bunch of
    other information.

    If things are slower than expected, it's great: you can see
    *exactly* how things are executing. Go doesn't *currently* have
    anything like it, although towards the end of Dave Cheney's
    **Seven ways to profile Go applications** talk at [GolangUK][], he
    did whip out something which looked rather like ThreadScope
    (sadly, a video isn't up at the time of writing, that I can see).

### Zero values are almost never what you want

Go avoids the issue of uninitialised memory by having "zero values".
If you declare a variable of type `int`, but don't give it a value, it
gets the value 0. Simple.

Except that that's almost never what you want.

What is a sensible default value for a type? Well, it depends on what
you're using it for! Sometimes there isn't a sensible default, and not
initialising a value should be an error. You can't define a zero value
for your own types, so you're kind of stuck.

Zero values caused so many problems over the summer, because
everything would *appear* to be fine, then it suddenly breaks because
the zero value wasn't sensible for its context of use. Perhaps it's an
unrelated change that causes things to break (like a struct getting an
extra field).

I would much rather:

1. Drop the syntax for declaring a variable without giving it a value.
2. Make it an error to not initialise a struct field.

### Lots of boilerplate

The cause of the lots of code generation, I feel.

- Because you have to check error values, if you want to perform a
  sequence of possibly-erroring computations, where the successful
  result of one feeds into the next, there is a lot of typing. In
  Haskell, you'd just use the `Either` monad.

- If you want to sort a slice, because there are no generics, you need
  to wrap the slice in another type and implement three methods on
  that type. So that's four lines of code to sort a slice of uints,
  four lines to sort a slice of uint8s, four lines to sort a slice of
  uint16s, and so on. In Haskell, you'd just use the generic `sort`.

## My Overall Feelings

I do have one [non-Pusher Go project][logdb] that I plan to keep
developing, as it's a fun project. I picked Go for it because my
initial motivation was to eventually integrate it with what I was
doing at work, but that ended up not happening.

Other than that, I will probably never choose to use Go for anything
ever again, unless I'm being paid for it. Go is just too different to
how I think: when I approach a programming problem, I first think
about the types and abstractions that will be useful; I think about
statically enforcing behaviour; and I don't worry about the cost of
intermediary data structures, because that price is almost never paid
in full.

[Pusher]:      https://pusher.com/
[pblog]:       https://blog.pusher.com/go-interface-fuzzer/
[svl]:         https://www.barrucadu.co.uk/posts/2016-02-12-strict-vs-lazy.html
[ghcgc]:       https://blog.pusher.com/latency-working-set-ghc-gc-pick-two/
[gogc]:        https://blog.golang.org/go15gc
[perf17]:      https://golang.org/doc/go1.7#performance
[go/ast]:      https://golang.org/pkg/go/ast/
[quora]:       https://www.quora.com/Do-you-feel-that-golang-is-ugly
[godoc]:       https://github.com/golang/go/issues/7873
[ghchp]:       https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/profiling.html#profiling-memory-usage
[ThreadScope]: https://wiki.haskell.org/ThreadScope
[GolangUK]:    http://golanguk.com/
[logdb]:       https://github.com/barrucadu/logdb
