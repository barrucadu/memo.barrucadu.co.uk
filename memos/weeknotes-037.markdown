---
title: "Weeknotes: 037"
taxon: weeknotes-2019
date: 2019-06-02
---

## Work

- Monday was a bank holiday, and I took Tuesday off for "privilege
  day"---an extra day off Civil Servants get either before or after
  the Spring bank holiday for the Queen's birthday.

- I mostly did Elasticsearch upgrade stuff: making our index
  definitions compatible with 6[^es0], investigating and fixing query
  incompatibilities[^es1], setting up ES6 on one of our CI agents so
  we can test things against it, and working with another couple of
  developers to provision the ES6 cluster.  I've been trying to put
  off doing this stuff myself, so others will learn how it works, but
  there's only so much other stuff to do...

- Thursday had the last of a three-session "Learning to code at GDS"
  thing which introduced people to basic HTML, CSS, and Ruby.  I've
  been one of the teachers.  The students enjoyed it, and we're hoping
  that it can be a more formal thing next quarter, rather than just
  something we run during our lunch hours.

[^es0]: Two pull requests:
    [Switch from string to text / keyword](https://github.com/alphagov/search-api/pull/1553) and
    [Remove use of include_in_all](https://github.com/alphagov/search-api/pull/1557).

[^es1]: One pull request:
    [Use 'like' instead of 'docs' in more_like_this query](https://github.com/alphagov/search-api/pull/1561),
    some investigation, and a small list of future issues to fix.

## Miscellaneous

- I saw [Detective Pikachu][] on Monday, it was pretty good.  I heard
  from someone at work who had seen it without knowing anything about
  Pokemon that it did a good job of introducing the setting.

- I watched [Good Omens][] on Saturday, that was really good.  It
  managed to modernise the story a bit while also remaining faithful
  to the source material.  Definitely worth watching if you've enjoyed
  the book.

[Detective Pikachu]: https://www.imdb.com/title/tt5884052/
[Good Omens]: https://www.imdb.com/title/tt1869454/

## Link Roundup

- [Writing Custom Optimization Passes](https://reasonablypolymorphic.com/blog/writing-custom-optimizations/index.html)
- [Faking Fundeps with Typechecker Plugins](https://reasonablypolymorphic.com/blog/faking-fundeps/index.html)
- [Marklish: What English sounds like if you don't understand it](https://www.eiman.tv/blog/posts/marklish/index.html)
- [This Week in Rust 288](https://this-week-in-rust.org/blog/2019/05/28/this-week-in-rust-288/)
- [Why The "Multiply and Floor" RNG Method Is Biased](https://pthree.org/2018/06/13/why-the-multiply-and-floor-rng-method-is-biased/)
- [Building a stateless API proxy](https://blog.thea.codes/building-a-stateless-api-proxy/)
- [Google to restrict modern ad blocking Chrome extensions to enterprise users](https://9to5google.com/2019/05/29/chrome-ad-blocking-enterprise-manifest-v3/)
- [Cloudflare Repositories FTW](https://blog.cloudflare.com/cloudflare-repositories-ftw/)
- [Jevons paradox](https://en.wikipedia.org/wiki/Jevons_paradox)
- [Issue 161 :: Haskell Weekly](https://haskellweekly.news/issues/161.html)
