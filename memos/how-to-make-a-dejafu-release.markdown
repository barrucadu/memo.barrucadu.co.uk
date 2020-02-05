---
title: "How to: make a Deja Fu release"
taxon: techdocs-runbooks
published: 2020-02-05
---

1. Figure out what the next version number is.  See the [PVP][] page
   if unsure.

2. Update version numbers in the relevant cabal files:

   - Update the `version` field
   - Update the `tag` in the ``source-repository`` block

3. Fill in all `@since unreleased` Haddock comments with the relevant
   version number.

4. Update version numbers in the tables in the README and the "Getting
   Started" page.

5. Ensure the relevant CHANGELOG files have all the entries they
   should.

6. Add the release information to the relevant CHANGELOG files:

   - Change the `unreleased` title to the version number
   - Add the current date

       **If it's early in the year (like January or February), make
       sure you don't put down the wrong year.**

   - Add the git tag name
   - Add the Hackage URL
   - Add the contributors list

7. Commit.

8. Push to GitHub and wait for Travis to confirm everything is OK.  If
   it's not OK, fix what is broken before continuing.

9. Merge the PR.

10. Tag the merge commit.  Tags are in the form
    `<package>-<version>`, and the message is the changelog entry.

11. Push tags to GitHub.

The [pre-deploy script][] checks some of these steps, but it's no
substitute for human review.

When the merge commit successfully builds on `master` the updated
packages will be pushed to Hackage by Travis.

[PVP]: https://pvp.haskell.org/
[pre-deploy script]: https://github.com/barrucadu/dejafu/blob/master/.travis/predeploy


Tips
----

- If a release would have a combination of breaking and non-breaking
  changes, if possible make two releases: the non-breaking ones first,
  and then a major release with the breaking ones.

  This makes it possible for users who don't want the breaking changes
  to still benefit from the non-breaking improvements.

- If you need to manually upload a release to hackage (rather than
  going through CI), check you have no changes to the local files (for
  example, temporarily changing the GHC options, or adding `trace`
  calls, for debugging reasons).

  `stack upload` files on the disk, not the files in version control,
  so your unwanted changes will be published!
