---
title: "Weeknotes: 027"
tags: weeknotes
date: 2019-03-24
audience: General
---

## Open Source

- I made [a new release of dejafu][] which restores the ability to
  execute concurrent programs using `ST` rather than `IO`, like
  dejafu-0.x could.  For example:

  ```haskell
  import Control.Concurrent.Classy (MonadConc(..), fork)
  import Control.Exception         (SomeException)
  import Control.Monad.Catch.Pure  (runCatchT)
  import Control.Monad.ST          (runST)
  import Data.Set                  (Set)

  import Test.DejaFu.Conc     (Condition, runConcurrent, roundRobinSched)
  import Test.DejaFu.SCT      (resultsSet)
  import Test.DejaFu.Settings (defaultMemType, defaultWay)

  example :: MonadConc m => m Int
  example = do
    v <- newEmptyMVar
    fork $ putMVar v 1
    fork $ putMVar v 2
    readMVar v

  -- get all results
  results :: Either SomeException (Set (Either Condition Int))
  results = runST $ runCatchT $ resultsSet defaultWay defaultMemType example

  -- get a single result, using a round-robin scheduler
  single :: Either SomeException (Either Condition Int)
  single = case runST $ runCatchT $ runConcurrent roundRobinSched defaultMemType () example of
    Right (result, _, _) -> Right result
    Left e -> Left e

  -- throw errors
  single' :: Int
  single' = case single of
    Right (Right result) -> result
    Right (Left _) -> error "your program deadlocked or something"
    Left _ -> error "an internal error occurred in dejafu"

  > results
  Right (fromList [Right 1,Right 2])

  > single
  Right (Right 2)

  > single'
  2
  ```

  I'll probably write a memo going into more detail, but the gist is
  that I changed from using a "metacircular evaluator"-like approach
  (implementing some `MonadConc` actions in terms of `MonadConc`) to a
  "tagged final" approach (introducing a special-purpose `MonadDejaFu`
  typeclass for the needed operations).

[a new release of dejafu]: http://hackage.haskell.org/package/dejafu-2.1.0.0

## Work

- This week we planned to start the roll-out of Elasticsearch 5 to
  production, so naturally we discovered a bunch of significant
  problems:

  - Best bets were broken.  A "best bet" is a search result we (or
    someone in a department) thinks should rank really highly for a
    particular search term.  They conceptually work by doing a query
    to find all the best bets which match the user's query then, in
    the query which finds *all* the search results, some constraints
    are added to include all of the best bets and give them a really
    high score.  This is actually all implemented in the same query,
    but I find it easier to think about in stages like this.

    What was actually happening is that *all* best bets were matching
    every query, so at the top of every search were thousands of
    mostly irrelevant results.

    This turned out to be a problem introduced when [I changed the
    index schemas to only use a single mapping type][].  After that
    change, best bets were being matched like this:

    ```json
    { "query":
      { "bool":
        { "must": { "match": { "document_type": "best_bet" } }
        , "should":
          [ { "match": { "exact_query":   "<the query goes here>" } },
          , { "match": { "stemmed_query": "<the query goes here>" } },
          ]
        }
      }
    }
    ```

    The behaviour of `must` is that a document will be returned only
    if the inner query is true.  The behaviour of `should` is that a
    document will be returned only if at least one of the inner
    queries are true.

    What I didn't realise is that the behaviour of a `must` in
    combination with a `should` is that documents matching the `must`
    will be returned even if they don't match *any* of the `should`
    queries, and the `should` is only used for ranking.  Whoops.

    It turned out [I'd introduced the same problem in a few places.][]

    This definitely highlights a weakness in the testsuite.  Best bets
    are tested, but I guess there are no tests that if you have
    multiple best bets, only the ones which match the query are
    returned.

  - Result ordering was weird.  The default text similarity metric
    changed between Elasticsearch 2 and Elasticsearch 5, so we
    expected (and observed) some difference in result ordering, but at
    some point things became far worse.  I tracked it down to a change
    made to our index definitions; but the change followed the
    Elasticsearch migration guide, so we don't really know why it
    didn't work out.

    [I switched back to the (deprecated) old-style text similarity and
    reverted the index definition change.][] But these fixes will have
    to be revisited when we move to Elasticsearch 6, which is likely
    to be next quarter.

  - Locking the indices didn't work.  AWS managed Elasticsearch has
    the behaviour that it will automatically lock your indices based
    on the health of your cluster.  For example, if you've run out of
    disk space, it will lock the indices to prevent further writes.
    This is handled by a process which runs every few minutes.

    Unfortunately, if your cluster is healthy, it will automatically
    *unlock* your indices.  Even if you locked them manually.  After
    some pretty fruitless debugging, and a live chat with AWS support,
    [we have a solution][], but it's not a perfect solution as it
    gives rise to a race condition to do with switching between
    indices.  We've decided that the race is unlikely to be important,
    and so have accepted this for now.

  - Reindexing is broken in a way we don't understand yet.
    Occasionally there is a need to reindex all of the documents in
    Elasticsearch (if the schema changes, for instance), so it's
    essential this works.  The way we reindex is like so:

    1. Lock the old index
    2. Create the new index
    3. Reindex the old into the new
    4. Compare the old and new
    5. Switch to the new index if the comparison doesn't find any
       differences.

    This process was broken because of the locking issue, but even
    taking that into account, things don't seem right.  I found that
    many thousands of documents seem to get slightly mangled in the
    reindexing process, with fields being inconsistently dropped in
    the new index (some documents would be missing a field, other
    documents would have the same field).  I'm hoping this is somehow
    due to the locking problem and will just work when I try it
    tomorrow.

  If the reindexing issue can be solved, we plan to switch over our
  production apps to use Ealsticsearch 5 late next week.  Originally
  we weren't planning to do anything on Thursday or Friday, but then
  the date of Brexit changed.

[I changed the index schemas to only use a single mapping type]: /weeknotes-023.html
[I'd introduced the same problem in a few places.]: https://github.com/alphagov/search-api/pull/15
[I switched back to the (deprecated) old-style text similarity and reverted the index definition change.]: https://github.com/alphagov/search-api/pull/23
[we have a solution]: https://github.com/alphagov/search-api/pull/24

## Miscellaneous

- I switched my VPS from [Linode][] to [Hetzner Cloud][], because I
  realised I could more than double the resources for only a small
  extra cost ($20/month to €19.08/month).  Using NixOS made it really
  easy to [copy and tweak][] the configuration for my Linode, giving
  me an almost identical system with only a few minutes effort.

  The biggest pain has been finding all the git repositories which
  were configured to use my Linode as the upstream.

- I found some code I wrote a couple of years ago to learn about text
  justification and [pushed it to GitHub][].  The `README.png` file is
  its output.

[Linode]: https://www.linode.com/
[Hetzner Cloud]: https://www.hetzner.com/cloud
[copy and tweak]: https://github.com/barrucadu/nixfiles/commit/528f0f22a7c8380d7f2597e53196e46654bd3a3b
[pushed it to GitHub]: https://github.com/barrucadu/justify

## Link Roundup

- [This Week in Rust 278](https://this-week-in-rust.org/blog/2019/03/19/this-week-in-rust-278/)
- [Issue 151 :: Haskell Weekly](https://haskellweekly.news/issues/151.html)
- [Endlessh: an SSH Tarpit](https://nullprogram.com/blog/2019/03/22/)
- [How we made Haskell search strings as fast as Rust](https://tech.channable.com/posts/2019-03-13-how-we-made-haskell-search-strings-as-fast-as-rust.html)
