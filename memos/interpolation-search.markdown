---
title: Interpolation Search
tags: algorithms, programming, python
date: 2019-05-15
audience: General
---

In which I rediscover something [first described in 1957][is], and
learn a little [Hypothesis][] along the way.

[is]: https://en.wikipedia.org/wiki/Interpolation_search
[Hypothesis]: https://hypothesis.readthedocs.io/en/latest/


## Binary search

This is binary search, implemented in Python:

```python
def binary_search(haystack, needle):
    lo = 0
    hi = len(haystack) - 1
    found = None
    iterations = 0
    while lo <= hi and found is None:
        iterations += 1
        mid = lo + (hi - lo) // 2

        if haystack[mid] == needle:
            found = mid
        elif haystack[mid] > needle:
            hi = mid - 1
        else:
            lo = mid + 1

    return (found, iterations)
```

It returns both the index of the found element and the number of
iterations, for reasons which will become apparent in section 3.

How do we know it's right?  Well, let's test it.  I decided to do this
with [Hypothesis][], a property-based testing tool.  Here's a property
that an element in the list is found by `binary_search`:

```python
from hypothesis import given
from hypothesis.strategies import lists, integers

@given(
    haystack=lists(integers(), min_size=1),
    index=integers()
)
def test_needle_in_haystack(haystack, index):
    haystack.sort()

    needle = haystack[index % len(haystack)]
    found_index, _ = binary_search(haystack, needle)

    assert found_index >= 0
    assert found_index < len(haystack)
    assert haystack[found_index] == needle
```

Given a sorted nonempty list of integers, and an index into that list,
the element at that position should be found by `binary_search`.

We should also test the other case, elements *not* in the list
shouldn't have an index returned:

```python
@given(
    haystack=lists(integers()),
    needle=integers()
)
def test_needle_might_be_in_haystack(haystack, needle):
    haystack.sort()

    found_index, _ = binary_search(haystack, needle)

    if needle in haystack:
        assert found_index >= 0
        assert found_index < len(haystack)
        assert haystack[found_index] == needle
    else:
        assert found_index is None
```


## Interpolation search

Binary search is pretty good, but I found myself wondering one day
while doing [Advent of Code][] if we could do better by not splitting
the search space in the middle, but biasing our split by assuming the
data is distributed linearly.  After all, if you look in a dictionary
for "binary" you don't start by opening it to "M".

[Advent of Code]: https://adventofcode.com/

This is [interpolation search][is], it's like binary search, but
different:

```python
def interpolation_search(haystack, needle):
    lo = 0
    hi = len(haystack) - 1
    found = None
    iterations = 0
    while lo <= hi and found is None:
        iterations += 1
        if needle < haystack[lo] or needle > haystack[hi]:
            # a new special case
            break
        elif haystack[lo] == haystack[hi]:
            # a new special case
            if needle == haystack[lo]:
                found = lo
            else:
                break
        else:
            # a more complex calculation
            mid = lo + int((((hi - lo) / (haystack[hi] - haystack[lo])) * (needle - haystack[lo])))

            if haystack[mid] == needle:
                found = mid
            elif haystack[mid] > needle:
                hi = mid - 1
            else:
                lo = mid + 1

    return (found, iterations)
```

It's a bit more complex, we've got two new special cases: one for if
the needle is not in the haystack at all, and one for if all the
elements in the haystack are equal.  We've also got a more complex
`mid` calculation, trying to figure out where in the haystack the
needle will appear.

We can use Hypothesis to compare our two search functions against each
other:

```python
@given(
    haystack=lists(integers()),
    needle=integers()
)
def test_interpolation_equiv_binary(haystack, needle):
    haystack.sort()

    found_index_b, _ = binary_search(haystack, needle)
    found_index_i, _ = interpolation_search(haystack, needle)

    if found_index_b is None:
        assert found_index_i is None
    else:
        assert found_index_i is not None
        assert haystack[found_index_b] == haystack[found_index_i]
```

This is a common trick with property-based testing (and lots of types
of testing, really): implement a simpler version of your thing and
test that the more complex "real" implementation behaves the same as
the simpler "test" implementation.

I intentionally didn't do this:

```python
@given(
    haystack=lists(integers()),
    needle=integers()
)
def test_interpolation_equal_binary(haystack, needle):
    haystack.sort()

    found_index_b, _ = binary_search(haystack, needle)
    found_index_i, _ = interpolation_search(haystack, needle)

    assert found_index_b == found_index_i
```

Because the functions can differ if the needle is present in the
haystack multiple times (eg, looking for `0` in `[0,0,1]`), and that's
fine.


## Is it faster?

Given our fancy midpoint calculation, the interpolation search *must*
be better than (ie, do no more iterations than) binary search, right?

```python
@given(
    haystack=lists(integers(), min_size=1),
    index=integers()
)
def test_interpolation_beats_binary(haystack, index):
    haystack.sort()
    needle = haystack[index % len(haystack)]

    _, iterations_b = binary_search(haystack, needle)
    _, iterations_i = interpolation_search(haystack, needle)

    assert iterations_i <= iterations_b
```

Wrong.

```
==================================== FAILURES ===================================
________________________ test_interpolation_beats_binary ________________________

    @given(
>       haystack=lists(integers(), min_size=1),
        index=integers()
    )
    def test_interpolation_beats_binary(haystack, index):

interpolation-search.py:101:
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

haystack = [0, 1, 3], index = 64

    @given(
        haystack=lists(integers(), min_size=1),
        index=integers()
    )
    def test_interpolation_beats_binary(haystack, index):
        haystack.sort()
        needle = haystack[index % len(haystack)]

        _, iterations_b = binary_search(haystack, needle)
        _, iterations_i = interpolation_search(haystack, needle)

>       assert iterations_i <= iterations_b
E       assert 2 <= 1

interpolation-search.py:111: AssertionError
---------------------------------- Hypothesis -----------------------------------
Falsifying example: test_interpolation_beats_binary(haystack=[0, 1, 3], index=64)
====================== 1 failed, 3 passed in 0.34 seconds =======================
```

We have a counterexample where binary search wins: with the list `[0,
1, 3]` and the index 64 (which gives a `needle` of 1), binary search
finds it in 1 iteration but interpolation search takes 2.

Let's step through that example:

<table>
  <thead>
    <tr class="header">
      <th style="text-align: right; vertical-align: top;" rowspan="2" class="table-column-group-end">iteration</th>
      <th style="text-align: right;" colspan="4" class="table-column-group-end">binary search</th>
      <th style="text-align: right;" colspan="4">interpolation search</th>
    </tr>
    <tr class="header">
      <th style="text-align: right;">lo</th>
      <th style="text-align: right;">hi</th>
      <th style="text-align: right;">mid</th>
      <th style="text-align: right;" class="table-column-group-end">found</th>
      <th style="text-align: right;">lo</th>
      <th style="text-align: right;">hi</th>
      <th style="text-align: right;">mid</th>
      <th style="text-align: right;">found</th>
    </tr>
  </thead>
  <tbody>
    <tr class="odd">
      <td style="text-align: right;" class="table-column-group-end">0</td>
      <td style="text-align: right;">0</td>
      <td style="text-align: right;">2</td>
      <td style="text-align: right;"></td>
      <td style="text-align: right;" class="table-column-group-end">False</td>
      <td style="text-align: right;">0</td>
      <td style="text-align: right;">2</td>
      <td style="text-align: right;"></td>
      <td style="text-align: right;">False</td>
    </tr>
    <tr class="even">
      <td style="text-align: right;" class="table-column-group-end">1</td>
      <td style="text-align: right;">0</td>
      <td style="text-align: right;">2</td>
      <td style="text-align: right;">1</td>
      <td style="text-align: right;" class="table-column-group-end">True</td>
      <td style="text-align: right;">0</td>
      <td style="text-align: right;">2</td>
      <td style="text-align: right;">0</td>
      <td style="text-align: right;">False</td>
    </tr>
    <tr class="odd">
      <td style="text-align: right;" class="table-column-group-end">2</td>
      <td style="text-align: right;"></td>
      <td style="text-align: right;"></td>
      <td style="text-align: right;"></td>
      <td style="text-align: right;" class="table-column-group-end"></td>
      <td style="text-align: right;">0</td>
      <td style="text-align: right;">1</td>
      <td style="text-align: right;">1</td>
      <td style="text-align: right;">True</td>
    </tr>
  </tbody>
</table>

In iteration 1, the binary search picks the middle element, which is
the right answer.  But the interpolation search doesn't.  It's thrown
off by the assumption we've made in the `mid` calculation: that the
values will be linearly distributed.  If they're not, the biasing of
the interpolation search towards one end of the search space will work
against us.

Sadly, my idle thought about a biased search hasn't revolutionised
computer science.  Better luck next time.
