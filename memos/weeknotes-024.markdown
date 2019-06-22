---
title: "Weeknotes: 024"
tags: weeknotes
date: 2019-03-03
audience: General
---

## Work

- Finished off the work to change our Elasticsearch indices to use
  only a single type, [because Elasticsearch 6 hates types or
  something][].  I also discovered that [`jq`][] is a neat little
  tool.  Here's a script I used to verify that the number of each type
  of document in our Elasticsearch 2 and Elasticsearch 5 indices
  match:

  ```bash
  for index in page-traffic metasearch govuk government detailed; do
    for doctype in aaib_report asylum_support_decision best_bet business_finance_support_scheme \
                   cma_case contact countryside_stewardship_grant dfid_research_output drug_safety_update \
                   edition employment_appeal_tribunal_decision employment_tribunal_decision \
                   european_structural_investment_fund export_health_certificate hmrc_manual \
                   hmrc_manual_section international_development_fund maib_report manual manual_section \
                   medical_safety_alert page-traffic policy raib_report residential_property_tribunal_decision \
                   service_manual_guide service_manual_topic service_standard_report tax_tribunal_decision \
                   utaac_decision statutory_instrument; do
      es2_count=`curl http://localhost:9200/$index/$doctype/_count 2>/dev/null | jq .count`
      es5_count=`curl "http://elasticsearch5/$index/generic-document/_count?q=document_type:$doctype" 2>/dev/null | jq .count`
      if [[ "$es2_count" != "$es5_count" ]]; then
        echo "$index : $doctype"
        echo "    es2: $es2_count"
        echo "    es5: $es5_count"
        echo
      fi
    done
  done
  ```

  The `| jq .count` bit extracts the `count` field of the top-level
  object from stdin.  This is better than my previous approach of
  pretty-printing the json with `json_pp` and then using `sed`.

- Fixed some flakey tests.  Debugging a test which
  nondeterministically fails isn't the most glamorous or exciting
  work, but it sure beats re-running your tests until they pass.

- Provisioned the Elasticsearch 5 cluster in our staging and
  production environments.  We're planning to switch over the
  [licence-finder][] first, ideally early next week, as it only uses
  Elasticsearch in a very small way.  Unlike the main GOV.UK search,
  we're not planning to run two licence-finders in parallel to do a
  zero-downtime switch: it isn't used particularly much, so we can
  tolerate the 20s or so of downtime it will take to switch to the new
  cluster and reindex its data.

[because Elasticsearch 6 hates types or something]: https://www.elastic.co/guide/en/elasticsearch/reference/6.0/removal-of-types.html
[`jq`]: https://stedolan.github.io/jq/
[licence-finder]: http://www.gov.uk/licence-finder

## Miscellaneous

- I rewrote my backup scripts to use [duplicity][] and [wrote about
  them][].

- I've been toying with the idea of a GOV.UK to [Gopher][] bridge ever
  since I learned GOV.UK has an API.  Unfortunately, the GOV.UK API
  gives the page body as rendered HTML, and I didn't want to parse
  HTML.  On Saturday I stumbled across the [html2text][] Python
  library, which turns HTML into Markdown.  After a few hours work, I
  came up with [govuk-gopher][].  It currently supports:

  - Answers ([example](https://www.gov.uk/vehicle-tax-refund))
  - Browse pages ([example](https://www.gov.uk/browse/driving/disability-health-condition))
  - Guides ([example](https://www.gov.uk/sorn-statutory-off-road-notification))
  - HTML publications ([example](https://www.gov.uk/government/publications/civil-service-code/the-civil-service-code))
  - News stories ([example](https://www.gov.uk/government/news/charity-annual-return-2018))
  - Organisation pages ([example](https://www.gov.uk/government/organisations/ministry-of-defence))
  - Taxon pages ([example](https://www.gov.uk/life-circumstances))
  - Transactions ([example](https://www.gov.uk/vehicle-tax))

  That's far from all of them, but it's enough to browse most of the
  "mainstream" (stuff not under `www.gov.uk/government/`) GOV.UK
  content.

  There's a demo [on asciinema][], and the source is [on
  github][govuk-gopher].

- I realised that there are two ways to model a credit card in a
  [plain-text accounting tool][], like [hledger][] which I use.  The
  first way, and the way I use, is to treat the money *spent* on the
  card as a *liability*:

  ```
  2019-02-01 Spending some money on my credit card
      expenses:ducks                                                       £100.00
      liabilities:creditcard
  2019-03-01 Spending some more money on my credit card
      expenses:geese                                                       £100.00
      liabilities:creditcard

  ; $ hledger balance -H creditcard
  ;             £-200.00  liabilities
  ;             £-200.00    creditcard
  ; --------------------
  ;             £-200.00
  ```

  The card has a negative balance (the total amount you've spent).

  The second way is to treat the money *remaining* on the card as an
  *asset*:

  ```
  2019-01-01 Got a new credit card
      assets:creditcard                                                  £10000.00
      liabilities:creditcard
  2019-02-01 Spending some money on my credit card
      expenses:ducks                                                       £100.00
      assets:creditcard
  2019-03-01 Spending some more money on my credit card
      expenses:geese                                                       £100.00
      assets:creditcard

  ; $ hledger balance -H creditcard
  ;             £9800.00  assets
  ;             £9800.00    creditcard
  ;           £-10000.00  liabilities
  ;           £-10000.00    creditcard
  ; --------------------
  ;             £-200.00
  ```

  The card has a positive balance (the total amount remaining), which
  can be added to the liability (from where you took the original
  balance) to see how much you owe.

  In a sense the asset approach is better, because it gives you more
  information: how much balance is remaining.  But in practice I think
  that could encourage you to spend more, so it may not be a good
  thing to know after all.  I'll be sticking with the liability
  approach.

- I read Authority and Acceptance, the latter two books of the
  [Southern Reach trilogy][].  Authority is about the Southern Reach,
  the shadowy government organisation which investigates Area X, and
  its new director; Acceptance switches between the perspectives of
  different characters, in different places and times.  It's hard to
  say more without spoiling anything, so I won't.  They were pretty
  good, I enjoyed the trilogy as a whole.

[duplicity]: http://duplicity.nongnu.org/
[wrote about them]: backups.html
[Gopher]: https://en.wikipedia.org/wiki/Gopher_(protocol)
[html2text]: https://pypi.org/project/html2text/
[govuk-gopher]: https://github.com/barrucadu/govuk-gopher/
[on asciinema]: https://asciinema.org/a/231309
[plain-text accounting tool]: https://plaintextaccounting.org/
[hledger]: https://hledger.org/
[Southern Reach trilogy]: https://en.wikipedia.org/wiki/Southern_Reach_Trilogy

## Link Roundup

- [Resilience Engineering and Error Budgets](http://willgallego.com/2019/02/23/resilience-engineering-and-error-budgets/)
- [Bret Taylor on Twitter: "Here’s a silly Google Maps origin story about how “Satellite” was almost named “Bird Mode”… "](https://twitter.com/btaylor/status/1099370126678253569?s=11)
- [GHC TysWiredIn.hs](http://hackage.haskell.org/package/ghc-8.6.1/docs/src/TysWiredIn.html#doubleDataConName) (see Note [Any types])
- [How much mayhem could I cause as a sentient fish?](https://worldbuilding.stackexchange.com/questions/140058/how-much-mayhem-could-i-cause-as-a-sentient-fish)
- [This Week in Rust 275](https://this-week-in-rust.org/blog/2019/02/26/this-week-in-rust-275/)
- [NixOS Weekly #04 - Static rootless Nix, SRE job, homebrew to Nix migration](https://weekly.nixos.org/2019/04-static-rootless-nix-sre-job-homebrew-to-nix-migration.html)
- [Pirate Site Blocking Rejected By Swiss Supreme Court](https://torrentfreak.com/pirate-site-blocking-rejected-by-swiss-supreme-court/)
- [Putting the Router through its paces](https://gdstechnology.blog.gov.uk/2013/12/13/putting-the-router-through-its-paces/)
- [Issue 148 :: Haskell Weekly](https://haskellweekly.news/issues/148.html)
- [Lazy validation](https://ro-che.info/articles/2019-03-02-lazy-validation-applicative)
