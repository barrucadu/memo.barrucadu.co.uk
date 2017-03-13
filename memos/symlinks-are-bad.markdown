---
title: Symlinks are Bad
tags: tech
date: 2017-03-13
---

So you're about to run `ln -s fileName linkName` are you? Wait!

Ask yourself these three questions:

1. Is the file in fact a directory?
2. Is the file on a different partition to the link?
3. Is there a need to determine the original filename from the link?

If you answered "no" to all three of these questions, **make a hardlink instead!**


Symlinks are bad and almost never what you want
-----------------------------------------------

Too many tools "helpfully" treat symlinks are more than a mere pointer to another file.

For example, if you symlink to a file which contains relative paths, these paths will often be
interpreted relative to the *original* file, rather than the link.

So before you make a symlink, stop and ask yourself "is this *really* what I want?"
