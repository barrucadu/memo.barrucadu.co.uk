---
title: Why I dislike mocking
tags: programming
date: 2018-05-09
audience: Programmers.
epistemic_status: A rant.
---

Mocking is a technique in writing tests where some component external
to the thing you are testing is replaced with a fake implementation
with constrained behaviour.

I do not like mocking, and think it often does more harm than good
unless you are very careful about what your test is actually testing.


## An example

Let's say your program involves loading some data from disk, and you
use a library to do this loading.  Let's say that there are a few ways
in which a file can be invalid, and these are each signalled by the
library raising a different exception.

Your code might look like this:

```ruby
def calculate_thing
  ExternalLibrary::Reader.new("data_file").frobnicate
rescue ExternalLibrary::MalformedData, ExternalLibrary::UnsupportedExtension
  nil
end
```

And your test might look like this:

```ruby
def calculate_thing_handles_file_errors
  errors = %w(ExternalLibrary::MalformedData ExternalLibrary::UnsupportedExtension)
  errors.each do |err|
    ExternalLibrary::Reader.any_instance.stubs(:frobnicate).raises(err.constantize)
    assert_nil calculate_thing
  end
end
```

This looks good: you're catching exceptions in your program, and your
test is throwing those and checking that they are handled.  But what
is this *really* testing?

The test is obviously correct, which isn't necessarily a bad thing as
it guards against the code changing, but does it *really* test that
you handle errors from the external library?  I don't think so.  If a
new version of `ExternalLibrary` comes along and adds a third
exception type, this test will not help you.

This test guards against the exception list in the code being changed,
but does *not* check that all errors from the external library are
handled.


## The problem with mocking

The main problem with mocking is that it is very easy to write a
reasonable test, and then to derive more confidence from it than you
should.

Whenever you artificially change the behaviour of something, you need
to be very clear about what your test is actually testing.  It is much
better to avoid the change if possible, possibly at the price of a
more complex (but more realistic) test.

There's a lesser problem that it's easy to write a mock which doesn't
exercise all the behaviour your program expects (imagine
`calculate_thing` handled the two exceptions differently, but your
mock only threw one of them, for example).  This problem can be
overcome with branch coverage.
