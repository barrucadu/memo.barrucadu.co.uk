---
title: "Weeknotes: 004"
taxon: weeknotes-2018
date: 2018-10-14
---

## Personal

* On Saturday I went to an escape room with some friends.  We did the
  the "Project Delta" room at [Archimedes Inspiration][].  It was fun,
  there was a strong focus on narrative, and I liked how almost all of
  the puzzles were based on deduction (no awkward manual dexterity
  "puzzles", for instance).  I think they exaggerated the difficulty a
  bit though.  After the spiel at the beginning about it being an
  escape room for people who have played hundreds of them and who are
  looking for a real challenge, I was expecting us to run out of time
  and fail---but we got in the top 25% by time.

[Archimedes Inspiration]: https://aiescape.com/

## Ph.D

* I did some of the corrections for chapter 7, which is about
  [CoCo][], a tool to discover properties about concurrent data
  structures.  Just one more thing to go (clarifying some
  terminology), and then I'll be done with the corrections to my
  actual contributions.  I've got one thing to do in my literature
  review, but then the end will be in sight: I'll just need to fix up
  the introduction and conclusions.

[CoCo]: https://github.com/barrucadu/coco

## Work

* I drew a bunch of architecture diagrams:

  * One for our [documentation][] about the architecture of
    [transition][]:

    ![Architecture of the transition application](weeknotes-004/transition-architecture.png)

  * One for a talk I gave about how we handle files uploaded by
    publishers, comparing it to how we handle content:

    ![Workflow of assets vs content](weeknotes-004/assets-vs-documents.png)

  * Another for the same talk, about the internal workflow in the
    [asset-manager][] itself:

    ![Internal flow of assets in the asset-manager](weeknotes-004/asset-workflow.png)

* On Wednesday I started looking into our postgres backup system,
  [WAL-E][].  We actually have two backup systems, one which takes a
  full backup as a SQL dump every day, and WAL-E which takes a full
  backup every day and incremental backups throughout the day.  We
  want to switch to using only WAL-E, and remove the old system[^aws].
  But we can't do that until a few outstanding issues have been
  solved.  It took a little while to work out exactly what was wrong,
  and we also had our weekly sprint planning and retrospective, so I
  didn't have much chance to make significant progress.

* WAL-E work continued on Thursday and Friday.  I found a number of
  different problems:

  * The replicas didn't recover after the primary restored a backup.
    [The solution][wal1] was to make it possible to also restore the
    backup to the replicas, after which point the normal postgres
    replication keeps up.

  * One of our staging machines was failing to push backups to S3, as
    the permissions on its user were incorrect.  The solution was to
    redeploy our [Terraform][] configuration.

  * Restoring our backups is a bit finnicky, because we encrypt them.
    I wrote [some documentation][wal2].

  * One of our staging machines (and both of our production machines!)
    can't restore the backup at all, as they're missing some
    permissions.  We're currently working out the best way to modify
    our Terraform to grant the necessary permissions.

  When the final issue is done we'll test our production backups (by
  restoring them to our staging environment) and, if that works, I
  think we can have confidence in our WAL-E backups and turn off the
  old system.

* I picked up a change to our "[getting married abroad][]"
  [smart-answer][].  Unlike most of GOV.UK, making a change to the
  content of a smart-answer requires a developer to deploy the change.
  Content designers submit pull requests, we do some necessary
  fiddling, and make it live.

* I fixed a piece of tech debt I'd left around.  A while ago I made a
  change, it caused problems, and the change got reverted.
  Unfortunately this change added a field to a database table, and the
  pull request was simply reverted, with no migration to remove the
  field.  This field has been sitting around harmlessly but
  confusingly in our production database since then.  I got rid of it
  with a slightly weird [conditional migration][].

[^aws]: And when we migrate everything to AWS, which is possibly
    happening this quarter, we'll be getting rid of WAL-E too, as
    Amazon will be handling our database backups.  This makes me
    wonder exactly how much benefit there is in getting WAL-E
    working...

[documentation]: https://docs.publishing.service.gov.uk/manual/transition-architecture.html
[transition]: https://github.com/alphagov/transition/
[asset-manager]: https://github.com/alphagov/asset-manager/
[WAL-E]: https://github.com/wal-e/wal-e
[wal1]: https://github.com/alphagov/govuk-puppet/pull/8196
[Terraform]: https://www.terraform.io/
[wal2]: https://github.com/alphagov/govuk-developer-docs/pull/1276
[getting married abroad]: https://www.gov.uk/marriage-abroad
[smart-answer]: https://github.com/alphagov/smart-answers/
[conditional migration]: https://github.com/alphagov/whitehall/pull/4417

## Miscellaneous

* I upgraded all of my machines to [NixOS 18.09][], which worked
  perfectly.  Good job, NixOS team!

* I played Minecraft for the first time in a long while, and made a
  server for some friends, with a bunch of mods.  For a long time I've
  found it hard to enjoy vanilla Minecraft, as there isn't really any
  challenge to the game once you've set up a self-sustaining base;
  after that everything you want is just a matter of time.  Mods add
  enough depth to offset the tedium for me.

* Some new tea I ordered arrived.  This is a welcome change from the
  Earl Grey I've been drinking for the past week and a half.  I use an
  online tea shop called [What-Cha][], which generally has a pretty
  good selection, and all of my orders so far have included a small
  sample of something else.

[NixOS 18.09]: https://nixos.org/nixos/manual/release-notes.html#sec-release-18.09
[What-Cha]: https://what-cha.com/

## Link Roundup

* [12 Factor CLI Apps](https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46)
* [Disk Usage - PostgreSQL wiki](https://wiki.postgresql.org/wiki/Disk_Usage)
* [Issue 128 :: Haskell Weekly](https://haskellweekly.news/issues/128.html)
* [My Git Branching Strategy – Graph Gardening](https://spin.atomicobject.com/2018/10/10/git-branching-strategy/)
* [Protobuffers Are Wrong](https://reasonablypolymorphic.com/blog/protos-are-wrong/index.html)
* [S2 Geometry](https://s2geometry.io/)
* [The Illustrated TLS Connection: Every Byte Explained](https://tls.ulfheim.net/)
* [This Week in Rust 255](https://this-week-in-rust.org/blog/2018/10/09/this-week-in-rust-255/)
* [[Minecraft] Let's build a Japanese castle [How to build a Japanese castle]](https://www.youtube.com/watch?v=kAugKJSgFKw)
* [【マインクラフト】図書館を建築してみる【図書館の作り方】](https://www.youtube.com/watch?v=CK237oiJtIU)---another Minecraft video.
