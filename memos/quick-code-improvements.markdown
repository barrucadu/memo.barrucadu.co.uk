---
title: Quick Code Improvements
date: 2021-03-05
taxon: general
tags: programming
---

Here are 21 small improvements you can make to your code or the
tooling around it, taken from the [Code Quality Challenge][] in
February 2021.  If you find yourself with 20 minutes spare, pick one
and see how far you can get.

[Code Quality Challenge]: https://www.codequalitychallenge.com/

1. **Improve your README**

    For example, document the philosophy behind your project and how
    it fits into the larger ecosystem; give a comparison to similar
    projects; give usage examples; explain how it's developed and
    tested; how it's deployed (if it's a program); and your approach
    to outside contributions.

2. **Nuke TODO comments**

    Grep for `TODO` and: if out of date, delete; if still relevant,
    fix or turn into an issue; and if you're unsure, find someone who
    *is* sure.

3. **Get rid of a warning**

    Whether it's in the code proper or just in the tests, fix at least
    one.

4. **Delete some unused code**

    Tools like [unused][] or test coverage metrics can help you track
    down dead code.

5. **Trim your (git) branches**

    Run `git remote prune origin` to delete any tracking branches
    which have since been merged or deleted.  If you have any old
    branches of your own, get rid of them with `git push origin
    --delete <branch>`.

6. **Extract a compound conditional**

    Look for complex conditionals of multiple terms and see if they
    can be extracted into a function or a variable whose name clearly
    expresses what is being checked.

7. **Slim down an overgrown class**

    Look at your largest classes (or modules if you're using a
    class-less language) and see if there are any bits of code which
    can be refactored.  Extract a new class (or module), delete a
    stray comment, improve a name, tighten the visibility of a method
    (or function, type, etc), split apart a long method, and so on.

8. **Help new starters get up to speed**

    The actual challenge was to **create a setup script**, but you
    might have a different approach to solving this problem.  So
    create a setup script, or a Dockerfile, add instructions to your
    README, or however you do it.

9. **Run your tests with no network connection**

    Tests which rely on an external service are slow and brittle, so
    try to get your tests passing without any such dependencies.

10. **Investigate your slowest tests**

    Find your 10 slowest tests or so and have a look through them.
    Are any duplicates?  Can any be replaced by a faster variant?  Are
    they actually useful?

11. **Improve one name**

    Find one poorly-named thing and make it better.  Any thing.

12. **Audit your dependencies**

    Are they still needed?  Is everything up to date?  Can a runtime
    dependency be turned into a build or test dependency?

13. **Audit your PRs and issues**

    Have any been hanging around for a while?  If so, are they still
    relevant?  If you're not sure, ask the reporter if they can
    confirm, and close the issue if they don't get back to you in a
    week or so.

14. **Investigate long parameter lists**

    Long parameter lists, particularly if they occur in multiple
    methods (or functions), might indicate that there's a useful type
    you're missing, or that some of the parameters should be instance
    data.  Some parameters, like booleans, may indicate that you've
    got one method doing the work of several, and it should be split
    up.

15. **Automate something repetitive**

    Find something you do repeatedly and automate it.  For example,
    write shell aliases for some commands you run a lot.

16. **Audit your database schema**

    You might look for inconsistent column names, missing indices, or
    missing null or foreign key constraints.

17. **RTFM**

    Look at the docs for something you use a lot---whether that's a
    development tool (like your text editor), or a backing service
    (like a database), or a framework, or something else---and see if
    there's anything which you can apply.

18. **Investigate high-churn files**

    Files which change a lot can point to a good refactoring
    opportunity.  With git you can see the number of commits each file
    has with:

    ```bash
    git log --all -M -C --name-only --format='format:'  \
        | sort \
        | grep -v '^$' \
        | uniq -c \
        | sort -n \
        | awk 'BEGIN {print "count\tfile"} {print $1 "\t" $2}'
    ```

19. **Create or update your snippets**

    If your text editor has support for snippets, make sure you have
    some for any code patterns you type a lot.

20. **Begin plugging a knowledge gap**

    There's probably something you know you don't know.  Start doing
    something about it: spend 20 minutes researching it and start to
    chip away at your lack of knowledge.

21. **Extract a method**

    Look at your larger methods (or functions), are there any groups
    of functionality which could be pulled out into smaller units of
    code with their own clear names?

[unused]: https://unused.codes/
