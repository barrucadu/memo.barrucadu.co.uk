---
title: C is not Turing-complete
tags: c, programming, semantics
date: 2017-02-01
audience: General
---

A friend told me that C isn't actually Turing-complete due to the
semantics of pointers, so I decided to dig through the (C11) spec to
find evidence for this claim. The two key bits are 6.2.6.1.4 and
6.5.9.5:

> Values stored in non-bit-field objects of any other object type
> consist of `n × CHAR_BIT` bits, where `n` is the size of an object
> of that type, in bytes. The value may be copied into an object of
> type `unsigned char [n]` (e.g., by `memcpy`); the resulting set of
> bytes is called the object representation of the value. Values
> stored in bit-fields consist of `m` bits, where `m` is the size
> specified for the bit-field. The object representation is the set of
> `m` bits the bit-field comprises in the addressable storage unit
> holding it. Two values (other than NaNs) with the same object
> representation compare equal, but values that compare equal may have
> different object representations.

The important bit is the use of the definite article in the first
sentence, "where `n` is **the** size of an object of that type", this
means that all types have a size which is known statically.

> Two pointers compare equal if and only if both are null pointers,
> both are pointers to the same object (including a pointer to an
> object and a subobject at its beginning) or function, both are
> pointers to one past the last element of the same array object, or
> one is a pointer to one past the end of one array object and the
> other is a pointer to the start of a different array object that
> happens to immediately follow the first array object in the address
> space.

Pointers to distinct objects of the same type[^heaps] compare
unequal. As pointers are fixed in size, this means that there's only a
finite number of them. You can take a pointer to any object
[^address-of], therefore there are a finite number of objects that can
exist at any one time!

However, C is slightly more interesting than a finite-state
machine. We have one more mechanism to store values: the return value
of a function! Fortunately, the C spec doesn't impose a maximum stack
depth[^recursion], and so we can in principle implement a pushdown
automata.

Just an interesting bit of information about C, because it's so common
to see statements like "because C is Turing-complete...". Of course,
on a real computer, nothing is Turing-complete, but C doesn't even
manage it in theory.

[^heaps]: Interestingly, you could have a distinct heap for every
  type, with overlapping pointer values. And this is totally fine
  according to the spec! This doesn't help you, however, because the
  number of types is finite: they're specified in the text of the
  program, which is necessarily finite.

[^address-of]: "The unary `&` operator yields the address of its
  operand.", first sentence of 6.5.3.2.3.

[^recursion]: "Recursive function calls shall be permitted, both
  directly and indirectly through any chain of other functions.",
  6.5.2.2.11, nothing else is said on the matter.

### Addendum: Virtual Memory

In a discussion about this on Twitter, the possibility of doing some
sort of virtual memory shenanigans to make a pointer see different
things depending on its context of use came up. I believe that this is
prohibited by the semantics of object lifetimes (6.2.4.2):

> The lifetime of an object is the portion of program execution during
> which storage is guaranteed to be reserved for it. An object exists,
> has a constant address, and retains its last-stored value throughout
> its lifetime. If an object is referred to outside of its lifetime,
> the behavior is undefined. The value of a pointer becomes
> indeterminate when the object it points to (or just past) reaches
> the end of its lifetime.

The lifetime for heap-allocated objects is from the allocation until
the deallocation (7.22.3.1):

> The lifetime of an allocated object extends from the allocation
> until the deallocation. Each such allocation shall yield a pointer
> to an object disjoint from any other object.

### Addendum 2: Non-Object Information

I had a fun discussion on IRC, where someone argued that the
definition of pointer equality does not mention the object
representation, therefore the fixed object representation size is
irrelevant! Therefore, pointers could have extra information somehow
which is not part of the object representation.

It took a while to resolve, but I believe the final sentence of the
object representation quote and the first clause of the pointer
equality quote, together with the fact that pointers are values,
resolves this:

1. Pointers are values.
2. > Two values (other than NaNs) with the same object representation
   compare equal, but values that compare equal may have different
   object representations.
3. Points (1) and (2) mean that pointers with the same object
   representation compare equal.
4. > Two pointers compare equal if and only if...
5. The "only if" in (4) means that if two pointers compare equal, then
   the rest of the rules apply.
6. Points (3) and (5) mean that two pointers with the same object
   representation compare equal, and therefore point to the same
   object (or are both null pointers, etc).

This means that there cannot be any further information that what is
stored in the object representation.

Interestingly, I believe this forbids something I initially thought to
be the case: I say in a footnote that different types could have
different heaps. They *could*, but that doesn't let you use the same
object representation for pointers of different types!
