---
title: "Weeknotes: 049"
taxon: weeknotes-2019
date: 2019-08-25
---

## Work

- I did some investigation into how we boost popular pages in search
  results.  Strangely, the formula is `1 / (10 + rank)`, so the most
  popular page gets a score of `1 / 11`, the second most popular page
  gets a score of `1 / 12`, and so on.  How much more popular page `n`
  is than page `(n+1)` doesn't play into the scoring at all.

  We have some indication that popularity boosting isn't quite doing
  what we want with ES6.  The range of scores ES6 assigns to results
  is so different to the range of scores ES5 assigns that it's not too
  surprising that these popularity boosts might need tweaking.

- I started prototyping a way to expose the ES [ranking evaluation
  API][] in search-api, so we can give search-api a list of relevance
  judgements and have it say how good the search performs.  This is
  far preferable to copying the query out of search-api and querying
  Elasticsearch directly.

  However, a danger with using the ranking evaluation API to guide
  improvements in our search query is that we're optimising for
  results we know are relevant, and so might unknowingly penalise
  results we *don't* know are relevant.  If we make our relevance
  judgements based on the first page of results, there might be a
  super-relevant result on page 2, but that doesn't make it into the
  data we use for scoring queries.  The same sort of problem shows up
  in the machine learning community, and a common approach there is to
  have separate training and testing data, so that might be something
  to look at.

- Some more query tweaking (which hasn't gone live yet, I need to
  think about how best to test it):

  - I decided to try to replicate [the old scoring behaviour of
    `should` queries in ES5 and below][], and came up with this
    delightful bit of code:

    ```ruby
    def should_coord_query(queries)
      if queries.size == 1
        queries.first
      else
        {
          function_score: {
            query: { bool: { should: queries } },
            score_mode: "sum",
            boost_mode: "multiply",
            functions: queries.map do |q|
              {
                filter: q,
                weight: 1.0 / queries.size
              }
            end
          }
        }
      end
    end
    ```

    Good news is that it works, and does seem to improve matters quite
    a bit.  Bad news is that it checks every result against each query
    twice.

  - I also spotted a "problem" in our search query.  Here are the
    subqueries we use:

    ```ruby
    match_phrase("title", PHRASE_MATCH_TITLE_BOOST)
    match_phrase("acronym", PHRASE_MATCH_ACRONYM_BOOST)
    match_phrase("description", PHRASE_MATCH_DESCRIPTION_BOOST)
    match_phrase("indexable_content", PHRASE_MATCH_INDEXABLE_CONTENT_BOOST)
    match_all_terms(%w(title acronym description indexable_content), MATCH_ALL_MULTI_BOOST)
    match_any_terms(%w(title acronym description indexable_content), MATCH_ANY_MULTI_BOOST)
    minimum_should_match("all_searchable_text", MATCH_MINIMUM_BOOST)
    ```

    We do phrase matching against some fields, and then a fuzzier
    "just look for all the keywords" match against a collection of
    fields.  Seems reasonable, right?

    Actually not really.  Phrase matching is very strict.  For
    example, "brexit business" won't `match_phrase` the title of the
    business readiness finder, which is "Find Brexit guidance for your
    business", because there are words between "brexit" and
    "business".  So really, those four `match_phrase` subqueries will
    almost never match, so we miss out on the field-specific boost
    factors.

    I've changed those into `match_all_terms` and also tweaked the
    boost factors, and it looks *much* better.

  I'd like to put both of these changes out and A/B test them against
  the current search query, because all the searches I've manually
  done have looked pretty good.  Maybe that will happen this coming
  week.

[ranking evaluation API]: https://www.elastic.co/guide/en/elasticsearch/reference/current/search-rank-eval.html
[the old scoring behaviour of `should` queries in ES5 and below]: weeknotes-046.html

## Miscellaneous

- I sorted out a short-term tenancy agreement with my current
  landlord, so I won't need to move until mid-December.  This is good,
  as I no longer have to rush to find somewhere.

## Link Roundup

- [Jonathan on Twitter: "Alright, here we go. A thread on Government Security Classifications...](https://twitter.com/jonodrew/status/1163015964381892608)
- [Implications of pure and constant functions](https://lwn.net/Articles/285332/)---It's sad that GCC defines "pure" totally incorrectly.
  Consider this code:

  ```c
  int one = strlen(some_str_pointer);
  some_str_pointer[0] = '\0';
  int two = strlen(some_str_pointer);
  assert(one == two); /* this will fail if the str was initially nonempty */
  ```

  `strlen` is defined as a pure function, even though it depends on
  its environment!  I definitely see the utility in an annotation
  meaning "this function doesn't have write effects (but may have read
  effects)", but they shouldn't have called it "pure".[^pure]

- [Write Fuzzable Code](https://blog.regehr.org/archives/1687)
- [Skeleton Lake: Genetic Surprise Deepens Riddle Of The Dead](http://blogs.discovermagazine.com/deadthings/2019/08/20/skeleton-lake/)
- [Issue 173 :: Haskell Weekly](https://haskellweekly.news/issues/173.html)
- [This Week in Rust 300](https://this-week-in-rust.org/blog/2019/08/20/this-week-in-rust-300/)
- [Some obscure C features](https://multun.net/obscure-c-features.html)
- [A grimoire of functions](http://fredrikj.net/blog/2019/05/a-grimoire-of-functions/)

[^pure]: I tried to write this as a margin note but couldn't get the
    code block to work.
