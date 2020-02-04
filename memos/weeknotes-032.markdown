---
title: "Weeknotes: 032"
taxon: weeknotes-2019
date: 2019-04-28
---

## Work

- I made two changes to [organisation pages][], which are rendered by
  [collections][], an app which I hadn't touched much previously.
  Recently the team changed how publications are displayed on org
  pages, adding the new "Services", "Guidance and regulation", "News
  and communications" (etc) headings, which draw content from
  "supergroups".  A supergroup is a collection of related document
  types, where we have some evidence that users understand the theme
  of the group.  Document types, on the other hand, aren't really
  something users should need to know about to find what they want.

  - I made the "Services" and "Guidance and regulation" supergroups
    [sort content by popularity][], rather than by recency.

  - I [removed some metadata from "Services"][], because knowing when
    the service page was published on GOV.UK isn't useful in the
    slightest.

- I [have a fix][] for an issue with the [new site search][] where, if
  you [search for something with a quote in it][], the little "x" to
  remove the keyword doesn't work.  I don't touch frontend stuff much,
  so this was a bit of a learning experience.  I was really surprised
  to discover that javascript doesn't have a built-in way to decode
  HTML entities in a string (without rendering the string to the page
  as raw HTML first).

- I have another fix for [an issue with synchronising our
  Elasticsearch data from production to staging][].  The problem is
  that:

  - Elasticsearch needs to be able to *write* to an S3 bucket, even if
    it's only ever used to *restore* snapshots.
  - Sometimes Elasticsearch likes to write a metadata file to the S3
    bucket when it does a restore.
  - Elasticsearch (at least, the AWS managed one) can't be configured
    to grant ownership of the file it writes to the owner of the
    bucket.
  - S3 doesn't have a way to impose a default access policy on new
    files.

  So sometimes our staging Elasticsearch will restore a snapshot and
  write a file to the production S3 bucket, which renders the
  production Elasticsearch unable to take new snapshots because
  there's a file in the bucket it can't read.  This isn't a serious
  problem, because we use separate (non-shared) buckets for backups,
  but it does mean our data sync keeps breaking.

  The AWS-suggested solution is to have a lambda which is triggered by
  an S3 notification, which then fixes the permissions.  Which feels
  like a hacky work-around to me.

[organisation pages]: https://www.gov.uk/government/organisations/hm-revenue-customs
[collections]: https://github.com/alphagov/collections
[supergroup finders]: https://www.gov.uk/search/services?organisations%5B%5D=hm-revenue-customs&parent=hm-revenue-customs
[sort content by popularity]: https://github.com/alphagov/collections/pull/1095
[removed some metadata from "Services"]: https://github.com/alphagov/collections/pull/1096
[new site search]: https://www.gov.uk/search/all
[search for something with a quote in it]: https://www.gov.uk/search/all?parent=&keywords=%22brexit%22&level_one_taxon=&manual=&public_timestamp%5Bfrom%5D=&public_timestamp%5Bto%5D=&order=relevance
[have a fix]: https://github.com/alphagov/finder-frontend/pull/1067
[an issue with synchronising our Elasticsearch data from production to staging]: https://github.com/alphagov/govuk-aws/pull/902

## Miscellaneous

- I added some [schema.org][] microdata to memos, the memo listing,
  and my website.  Probably not useful, but it wasn't too tricky.  I
  found the schema.org vocabulary simultaneously really rich and also
  very limited.  For example, you can link a `CreativeWork` to a
  `Person`, like so:

  ```html
  <span itemprop="author" itemscope itemtype="http://schema.org/Person" style="display: none">
    <meta itemprop="name" content="Michael Walker">
    <meta itemprop="email" context="mike@barrucadu.co.uk">
    <link itemprop="url" href="https://www.barrucadu.co.uk">
  </span>
  ```

  ...but you can't link a `Person` to a `CreativeWork`.  The closest I
  could come up with is:

  ```html
  <li itemscope itemprop="knowsAbout" itemtype="https://schema.org/Thesis">
    <meta itemprop="author" content="https://www.barrucadu.co.uk">
    <meta itemprop="datePublished" content="2018">
    <meta itemprop="sourceOrganization" content="University of York">
    <meta itemprop="inSupportOf" content="Ph.D">
    <a itemprop="url" rel="author" class="title" href="/publications/thesis.pdf">
      <span itemprop="headline name">Revealing Behaviours of Concurrent Functional Programs by Systematic Testing</span>
    </a>
    <br/>
    <span class="description">
      University of York. Ph.D thesis. 2018.
      [<a itemprop="sameAs" rel="alternate" href="/publications/thesis.bib">bib</a>]
    </span>
  </li>
  ```

  Which feels a bit suboptimal.  I more than "know about" my thesis, I
  wrote it!  Another strange thing is that you can link a `Person` to
  an `Occupation` (the `hasOccupation` relationship), and a `Person`
  to an `Organization` (the `worksFor` relationship), but you can't
  link an `Occupation` to an `Organization` or an `Organization` to an
  `Occupation`.  So I ended up doing this:

  ```html
  <section itemscope itemprop="worksFor" itemtype="https://schema.org/EmployeeRole" class="experience">
    <meta itemprop="roleName" content="Software Engineer">
    <meta itemprop="startDate" content="2018-04">
    <header itemscope itemprop="worksFor" itemtype="https://schema.org/Organization">
      <a href="https://www.gov.uk/government/organisations/government-digital-service">
        <img itemprop="logo" src="/logos/gds.png" alt="Government Digital Service (GDS)">
      </a>
      <div>
        <h1>
          <a itemprop="url" href="https://www.gov.uk/government/organisations/government-digital-service">
            <span itemprop="name">Government Digital Service (GDS)</span>
          </a>
        </h1>
        <h2>Software Engineer</h2>
        <p class="when">Apr 2018&ndash;present</p>
      </div>
      <ul>
        <li><a href="https://github.com/alphagov">alphagov</a> <i class="fa fa-github"></i>
      </ul>
    </header>
    <p>I've worked on a variety of evidence-driven improvements to
      the <a href="https://www.gov.uk">GOV.UK</a> publishing stack,
      both performance improvements and also resolving long-standing
      technical debt.  Mostly Ruby and Rails 5 / Sinatra, some Python
      2.  Also gave regular support to teams which did not merit a
      full-time developer.  Most of my work for GOV.UK is open
      source.</p>
  </section>
  ```

  So, rich in some ways, and strangely impoverished in others.  It's
  also kind of a pain adding all this markup by hand, so I'm once
  again wondering about making a machine-readable CV and having
  scripts to generate the LaTeX and HTML from that.

- I discovered a neat thing about zsh's "global aliases" (*the* killer
  feature of zsh in my opinion), you can make an alias that executes
  code.  For example, here is a demo of using [`fzf`][] to [select two
  files which are then `cat`ed][].  I already use global aliases
  pretty heavily to [simplify typing out common pipelines][], maybe
  these `$()`-style aliases will also become a significant part of my
  workflow.

[schema.org]: https://schema.org/
[`fzf`]: https://github.com/junegunn/fzf
[select two files which are then `cat`ed]: https://asciinema.org/a/243030
[simplify typing out common pipelines]: https://github.com/barrucadu/dotfiles/blob/c004c3c3b93222be64e7c559d06aab5d48267a35/zsh/.zsh/11-aliases#L15-L24

## Link Roundup

- [This Week in Rust 283](https://this-week-in-rust.org/blog/2019/04/23/this-week-in-rust-283/)
- [Issue 156 :: Haskell Weekly](https://haskellweekly.news/issues/156.html)
- [[Haskell-cafe] [ANNOUNCE] GHC 8.8.1-alpha1 is now available](https://mail.haskell.org/pipermail/haskell-cafe/2019-April/131029.html)
- [The inception bar: a new phishing method](https://jameshfisher.com/2019/04/27/the-inception-bar-a-new-phishing-method/)
- [Verifying Popcount](https://blog.regehr.org/archives/1667)
- [When pigs fly: optimising bytecode interpreters](https://badootech.badoo.com/when-pigs-fly-optimising-bytecode-interpreters-f64fb6bfa20f)
