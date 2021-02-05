---
title: Interview questions I have been told are bad
taxon: general
tags: algorithms, programming
draft: true
---

There is a school of thought which says that the right way to
interview people for programming roles is to ask them brain-teaser
style algorithmic questions.

The problem with such questions is that they disproportionately reward
candidates who are either fresh out of school (so they remember these
puzzles) or who have the free time to study for the interview.  It
penalises regular developers looking to change jobs, and it doesn't
actually test for anything useful on the job.

However, [there is some evidence][] that many people applying to
programming jobs *can't actually progranm*.  So having some
programming component in an interview makes sense.

You want to filter out those who are just plain lying about their
experiences and abilities, but you don't want to fall into the trap of
asking brain-teaser questions which are really only testing that
someone can memorise a solution.

---

This memo contains a list of programming questions I have seen people
say are bad.  I haven't been noting them down until now, so I'll add
new ones as I come across them.

[there is some evidence]: https://blog.codinghorror.com/why-cant-programmers-program/


FizzBuzz
--------

> Write a program that prints the numbers from 1 to 100.  But for
> multiples of three print "Fizz" instead of the number and for the
> multiples of five print "Buzz".  For numbers which are multiples of
> both three and five print "FizzBuzz".

FizzBuzz is a victim of its own success.  It is *the* prototypical
"can you even program" question, so lots of people now know about it
and just learn a solution.

```python
for i in range(1, 101):
    if i % 15 == 0:
        print("FizzBuzz")
    elif i % 5 == 0:
        print("Buzz")
    elif i % 3 == 0:
        print("Fizz")
    else:
        print(i)
```


Invert a binary tree
--------------------

> Write a function which takes as input a binary tree, and swaps the
> left and right children of every node.

This is a problem that [the Homebrew maintainer famously complained
about][], and yes it is a bit confusing if you've never come across
the concept of a "binary tree", or the idea of "inverting" one.  But
unless the interviewer refuses to answer clarifying questions, I don't
think this is unreasonable.

I consider this the FizzBuzz-level problem of recursion and
references, neither of which are particularly obscure.

```python
# assuming our btree value has fields `.left` and `.right`

def invertTree(btree):
    if btree is None:
        return None

    left, right = btree.right, btree.left
    btree.left = invertTree(left)
    btree.right = invertTree(right)
```

[the Homebrew maintainer famously complained about]: https://twitter.com/mxcl/status/608682016205344768


Reverse a string
----------------

> Write a function which takes a string as input and returns its
> reverse.

This is the instance that made me want to write this memo.  I found it
in a Reddit thread where the OP was asking what they were doing wrong:
they had candidates who couldn't even reverse a string!

The amount of backlash against this question---calling it a piece of
trivia, because *why* would someone *ever* reverse a string during
their normal work?---was staggering.

Ok, you may not be reversing strings every day.  But I find it hard to
believe that a competent developer can't solve this even if they don't
know about their language's `reverse` method.

```python
# or more likely: `return str[::-1]`

def reverse(str):
    out = ""
    for i in range(len(str)):
        out += str[-(i+1)]
    return out
```

...
---

It would be good to have at least 5 examples to start with.
