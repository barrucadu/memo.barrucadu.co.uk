---
title: "Weeknotes: 040"
taxon: weeknotes-2019
published: 2019-06-23
---

## Work

- We're doing some work to retire ["advanced search" finders][], which
  are now unnecessary in the brave new world of [supergroup
  finders][], so we can delete a lot of code and then make a bunch of
  simplifications to [finder-frontend][].  But to avoid confusing
  people, we're making the supergroup finders look like the "advanced
  search" finders if you arrive from a [topic page][].  So visually
  nothing will change, but internally stuff will.

  I've only done [a small bit][] of this, most has been done by others
  on the team.  We're nearly there now, maybe it'll get done this
  week.

- When we switched to the [finder-based site search][], we
  accidentally broke some metadata.  It used to be the case that if
  your search results included content published by a previous
  government, it would say that next to the result.  [I fixed that][],
  and you can see it in some of the results when you [search for
  "every child matters"][].

- We had a chat with Amazon about how GOV.UK uses Elasticsearch, and
  made a small architectural change to our cluster off the back of
  that (changing from r4.xlarge instances to r5.xlarge).  We also
  [made the data sync work][], [fixed an issue with loading popularity
  data][], and switched the [licence-finder][] to [use ES6 in
  production][].  We found a problem with the queries being sent to
  ES6, but once that is solved we should be able to start the A/B
  test.

  You can query the ES6 cluster right now [by using the public search
  API][], but it's not returning all the results yet because of the
  query problem.

["advanced search" finders]: https://www.gov.uk/search/advanced?group=services&topic=%2Feducation
[supergroup finders]: https://www.gov.uk/search/services?parent=&keywords=&level_one_taxon=c58fdadd-7743-46d6-9629-90bb3ccc4ef0&level_two_taxon=&order=most-viewed
[finder-frontend]: https://github.com/alphagov/finder-frontend
[topic page]: https://www.gov.uk/education
[a small bit]: https://github.com/alphagov/finder-frontend/pull/1188
[finder-based site search]: https://www.gov.uk/search/all
[I fixed that]: https://github.com/alphagov/finder-frontend/pull/1198
[search for "every child matters"]: https://www.gov.uk/search/all?parent=&keywords=every+child+matters&level_one_taxon=&manual=&public_timestamp%5Bfrom%5D=&public_timestamp%5Bto%5D=&order=relevance
[made the data sync work]: https://github.com/alphagov/govuk-puppet/pull/9284
[fixed an issue with loading popularity data]: https://github.com/alphagov/search-api/pull/1593
[licence-finder]: https://github.com/alphagov/licence-finder
[use ES6 in production]: https://github.com/alphagov/govuk-puppet/pull/9294
[by using the public search API]: https://www.gov.uk/api/search.json?q=micropig&cluster=B

## Miscellaneous

- I spotted an odd pattern in GitHub URLs when browsing a directory
  tree at a particular branch.  Here's a path on GitHub broken down
  into its components:

    ```
              repository                         directory
              vvvvvvvvvvvv                       vvvvvvvvvvvvvvvvvvvvvvv
    /alphagov/govuk-puppet/tree/msw/disable-xray/environments/production
     ^^^^^^^^                   ^^^^^^^^^^^^^^^^
     user / org                 branch
    ```

    Imagine you're parsing this:

    - User / org names can't contain slashes, so that's simple enough.
    - Repository names also can't contain slashes.
    - The next bit says what sort of thing it is, in this case it's
      "tree" meaning we're browsing a tree.
    - Now it gets tricky: next are the branch and directory names, but
      those can both contain slashes and there's nothing between them.

    How do we handle this?  And what if it's not unique?  What if
    there's a directory `/environments/production` in the
    `msw/disable-xray` branch *and also* a
    `/disable-xray/environments/production` directory in the `msw`
    branch?

    Well it turns out that git just doesn't let you create branches
    which have this problem:

    ```
    $ git init
    $ git checkout -b foo
    Switched to a new branch 'foo'
    $ touch file; git add .; git commit -m "make a new branch"
    [foo (root-commit) 85508af] make a new branch
     1 file changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 file
    $ git checkout -b foo/bar
    fatal: cannot lock ref 'refs/heads/foo/bar': 'refs/heads/foo' exists; cannot create 'refs/heads/foo/bar'
    ```

    Pushes are similarly blocked, so you can't get around it by
    pushing the `foo` branch, deleting it, and then doing the same
    with the `foo/bar` branch.

    Making branches with slashes in the name actually create multiple
    levels of directories on the filesystem feels a
    bit... unsatisfying.  But I guess it means if you've got a string
    `$branch/$path` and a snapshot of the repository, it has an
    unambiguous meaning and you can work it out without needing to
    backtrack.

- I finally fell out of love with static site generators, and wrote
  some scripts to generate static sites.  I wrote a memo: [I replaced
  a static site generator with a script to generate static sites][].

- I started writing a Python script to find a new place to live.  It
  scraped listings from Rightmove, had some metrics to discard
  incorrectly tagged listings (eg, even when you exclude studios, a
  lot of the "1 bedroom flat" listings say something like "a lovely
  studio apartment" in the description), and I was going to add a
  filter to only keep properties which have Hyperoptic (based on me
  scraping a list of 30,000 or so postcodes from [the coverage
  map][]).

  But that all felt like a lot of work, so I asked on the GDS slack
  how people had found their flats.  Naturally, two other devs linked
  me to *their* flat-finding scripts...

- I watched HBO's [Chernobyl][], which was really good.  After the end
  of the final episode, there's a 10-minute segment showing actual
  historic photos and videos, and giving information about the fates
  of the real people the characters were based on.  It's definitely
  worth watching.

[I replaced a static site generator with a script to generate static sites]: static-site-generators.html
[the coverage map]: https://hyperoptic.com/map/?residential
[Chernobyl]: https://www.hbo.com/chernobyl

## Link Roundup

- [terraform-provider-dominos: the Terraform plugin for the Dominos Pizza provider.](https://ndmckinley.github.io/terraform-provider-dominos/)
- [Page Layout: Illustrated Books and the Rule of Thirds](http://theworldsgreatestbook.com/page-layout-rule-of-thirds/)
- [Research Design Patterns](http://pgbovine.net/research-design-patterns.htm)
- [Going Critical](https://meltingasphalt.com/interactive/going-critical/)
- [Using Formal Methods at Work](https://www.hillelwayne.com/post/using-formal-methods/)
- [Google Cloud Networking Incident #19009](https://status.cloud.google.com/incident/cloud-networking/19009)
- [The One PR Per Day Rule](http://neilmitchell.blogspot.com/2019/06/the-one-pr-per-day-rule.html)
- [Issue 164 :: Haskell Weekly](https://haskellweekly.news/issues/164.html)
- [This Week in Rust 291](https://this-week-in-rust.org/blog/2019/06/18/this-week-in-rust-291/)
- [Introducing time.cloudflare.com](https://blog.cloudflare.com/secure-time/)
