---
title: "Weeknotes: 046"
tags: weeknotes
date: 2019-08-04
audience: General
---

## Work

- The highlight is that I came up with [a new formulation for how we
  compute search result relevancy][].  We decided to stop our existing
  A/B test after noticing some really strange results---it looked like
  Elasticsearch 6 was ranking popular pages highly for all sorts of
  queries simply because the query and the page both contained a
  common word like "your".  Our metrics showed that people were
  refining their searches more with ES6, and clicking on results less.
  We also got a support ticket from a department.  Not great.

  At first we thought that this was because we switched [from classic
  similarity to BM25 similarity][], so we just undid that change,
  going back to classic similarity.  Unfortunately, ES6 removed a
  feature which was essential for the classic similarity to work.

  If you have a `bool` query with several clauses, like our old core
  query:

  ```ruby
  {
    bool: {
      should: [
        core_query.match_phrase("title"),
        core_query.match_phrase("acronym"),
        core_query.match_phrase("description"),
        core_query.match_phrase("indexable_content"),
        core_query.match_all_terms(%w(title acronym description indexable_content)),
        core_query.match_any_terms(%w(title acronym description indexable_content)),
        core_query.minimum_should_match("all_searchable_text")
      ],
    }
  }
  ```

  Then in ES5 and below, the score is:

  ```
  sum(clause_scores) * num_matching_clauses / num_clauses
  ```

  Whereas in ES6 and above, it's just `sum(clause_scores)`.  This
  totally threw off our relevancy scores.  The [ES6 changelog][] had
  this to say:

  > As a consequence, use of the TF-IDF similarity is now discouraged
  > as this was an important component of the quality of the scores
  > that this similarity produces. BM25 is recommended instead.

  So we had to stick with BM25, and solve the weird over-weighting of
  common words.

  I'll skip the trail of discovery, and give you the result.  This is
  what the new core query looks like:

  ```ruby
  {
    dis_max: {
      queries: [
        core_query.match_phrase("title", boost: 5),
        core_query.match_phrase("acronym", boost: 5),
        core_query.match_phrase("description", boost: 2),
        core_query.match_phrase("indexable_content"),
        core_query.match_all_terms(%w(title acronym description indexable_content)),
        core_query.match_any_terms(%w(title acronym description indexable_content), boost: 0.2),
        core_query.minimum_should_match("all_searchable_text", boost: 0.2)
      ],
      tie_breaker: 0.7
    }
  }
  ```

  This has the score:

  ```
  max(clause_scores) + 0.7 * (sum(clause_scores) - max(clause_scores))
  ```

  Where the clause scores are as they were before, but multiplied by
  the boost factors.

  The main thoughts I had when coming up with this were:

  - If two clauses match, that's good, but not *twice as good* as one
    clause matching (which was what the `should` gave)
  - Titles, acronyms, and descriptions are the most important fields
    (in that order)
  - If only some of the terms are present, then that's good enough to
    get the document included in the results, but shouldn't influence
    the scores anywhere near as much as the other factors

  We manually inspected the results for a hundred or so popular search
  queries, and there was some weirdness, but on the whole it looked
  much better than what we had before.

  On Friday afternoon we started the A/B test again, this time
  comparing ES5 with the old query against ES6 with the new query.

  Something nice to do in the future would be to sit down and start
  from scratch, thinking about what makes a document relevant to a
  query, rather than tweak what we already have (which is what I did).
  But since ES5 is end-of-life we want to switch to ES6 soon, so a
  good-enough tweaked query is fine for now.

[a new formulation for how we compute search result relevancy]: https://github.com/alphagov/search-api/pull/1648
[from classic similarity to BM25 similarity]: https://www.elastic.co/guide/en/elasticsearch/reference/6.0/index-modules-similarity.html
[ES6 changelog]: https://www.elastic.co/guide/en/elasticsearch/reference/6.0/breaking_60_search_changes.html#_scoring_changes

## Miscellaneous

- I switched to [ProtonMail][], which went pretty smoothly.  But I'm
  unable to import my emails from gmail, as the import/export tool
  keeps crashing with an invalid pointer dereference.  It's a Go
  program, and as I understand it the justification for the verbosity
  and awkwardness of Go is that it makes it easy to write correct
  programs.  I'm not convinced...

  I'm waiting to hear back from support on that, and then I should be
  able to never look at my gmail account again.

- My [Call of Cthulhu game][] reached the thrilling conclusion of
  another chapter.  I just need to get the players to decide whether
  they're going to Australia, Egypt, or Kenya, and then I can start to
  prepare the next big chunk.

[ProtonMail]: https://protonmail.com/
[Call of Cthulhu game]: masks-of-nyarlathotep.html

## Link Roundup

- [We, the undersigned…](https://www.bbc.co.uk/news/extra/SZS0zzeSOh/Petitions)
- [semantic/why-haskell.md](https://github.com/github/semantic/blob/8f15669a99cf5f7ea0fe642f914896b1fed40376/docs/why-haskell.md)
- [Fuzzers & Reducers as Productivity Tools](https://kripken.github.io/blog/binaryen/2019/06/11/fuzz-reduce-productivity.html)
- ['No way to prevent this', Says Only Development Community Where This Regularly Happens](https://medium.com/@nimelrian/no-way-to-prevent-this-says-only-development-community-where-this-regularly-happens-8ef59e6836de)
- [BM25 The Next Generation of Lucene Relevance](https://opensourceconnections.com/blog/2015/10/16/bm25-the-next-generation-of-lucene-relevation/)
- [Title Search: when relevancy is only skin deep](https://opensourceconnections.com/blog/2014/12/08/title-search-when-relevancy-is-only-skin-deep/)
- [Ozymandias (Smash Mouth version)](https://twitter.com/PateraQuetzaI/status/1156300892733243392)
- [This Week in Rust 297](https://this-week-in-rust.org/blog/2019/07/30/this-week-in-rust-297/)
- [Call of Cthulhu: Shadow of the Crystal Palace](https://www.youtube.com/watch?v=0uhqZdJ8swQ)
- [Issue 170 :: Haskell Weekly](https://haskellweekly.news/issues/170.html)
- [NixOS Weekly #11 - Nixery, nixfmt and Cachix releases, NixCon 2019 tickets, a job and first impressions post](https://weekly.nixos.org/2019/11-nixery-nixfmt-and-cachix-releases-nixcon-2019-tickets-a-job-and-first-impressions-post.html)
- [Typing rules for Haskell](https://gitlab.haskell.org/rae/haskell)
