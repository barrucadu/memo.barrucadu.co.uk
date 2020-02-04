---
title: How to Break an API
taxon: research-summary
tags: esec, fse
date: 2017-11-30
---

By [Christopher Bogart][a1], [Christian Kästner][a2], [James Herbsleb][a3], and [Ferdian Thung][a4].<br>
In *Foundations of Software Engineering* (FSE). 2016.<br>
[Paper][m1] / [Conference][m2] / [Project][m3]

I've recently discovered the world of empirical studies of software
engineering practices, and like what I see.  The few papers I've read
seem to confirm the conventional wisdom of what "everybody knows", but
it's nice to see these thoughts backed up by data.

This study looks at three different ecosystems with different
approaches to API breakage: the very stable [Eclipse Marketplace][1],
the consistent snapshot approach of [CRAN][2], and the semantic
versioning approach of [npm][3].  An ecosystem is more than a
collection of packages, it's also a group of people, with cultural
norms about stability and change.

> How, when, and by whom changes are performed in an ecosystem with
> interdependent packages is subject to (often implicit) negotiation
> among diverse participants within the ecosystem.  Each participant
> has their own priorities, habits and rhythms, often guided by
> community-specific values and policies, or even enforced or
> encouraged by tools.  Ecosystems differ in, for example, to what
> degree they require consistency among packages, how they handle
> versioning, and whether there are central gatekeepers.  Policies and
> tools are in part designed explicitly, but in part emerge from
> ad-hoc decisions or from values shared by community members.  As a
> result, community practices may assign burdens of work in ways that
> create unanticipated conflicts or bottlenecks.

The paper looks at the issue of API breakage from the perspective of
both library authors (those doing the breaking) and library users
(those who need to modify their code).  The results come from a case
study of 28 open source developers across the three ecosystems.  This
doesn't seem like a lot, but that's inevitable for survey papers.

Firstly we get an overview of the policies of each ecosystem.  They're
very different:

> A core value of the Eclipse community is backward compatibility.
> This value is evident in many policies, such as "API Prime
> Directive: When evolving the Component API from release to release,
> do not break existing Clients".

> CRAN pursues snapshot consistency in which the newest version of
> every package should be compatible with the newest version of every
> other package in the repository.  Older versions are "archived":
> available in the repository, but harder to install.  [...]  A core
> value of the R/CRAN community is to make it easy for end users to
> install and update packages.

> A core value of the Node.js/npm community is to make it easy and
> fast for developers to publish and use packages.  In addition, the
> community is open to rapid change.  [...]  The focus on convenience
> for developers (instead of end users) was apparent in our
> interviews.

Stability.  Snapshot consistency.  Ease of development.  Nobody will
use a library that breaks its API every week, but there is clearly a
sliding scale of how much breakage is tolerated.

This paper was interesting to me because I'm most familiar with the
[Hackage][4] and [Stackage][5] models, and it didn't take long for me
to see parallels between the Haskell world and other ecosystems.
Hackage is more like npm, with the [PVP][6] in Haskell serving the
role of [semver][7] in npm; and Stackage is more like CRAN.  The
project website has some analysis of Hackage and Stackage, which I
think lends credence to this:

> Stackage stands out as particularly valuing of compatibility; this
> is not too surprising since it was formed over as an alternative to
> Hackage with the specific goal to identify mutually compatible
> versions of packages to use together.

The reasons for library authors to consider a breaking API change
mostly line up with what I would have expected:

- Technical debt
- Efficiency
- Bugs

Funnily enough, fixing bugs isn't always a good thing for the users:

> Throughout our interviews, we heard many examples of how bug fixes
> effectively broke downstream packages, and the difficulty of knowing
> in advance which fixes would cause such problems.  For example, R7
> told us about reimplementing a standard string processing function,
> and finding that it broke the code of some downstream users that
> depended on bugs that his tests had not caught.  R9 commented on the
> opportunity cost of not fixing a bug in deference to downstream
> users' workarounds for it: "If the [downstream package] is
> implemented on the workaround for your bug, and then your fix
> actually breaks the workaround, then you sort of have to have a
> fallback... [pause] It gets nasty."

This puts me in mind of Microsoft, who are famous for never breaking
backwards compatibility and just introducing new APIs when they have a
better way of doing something.  I wouldn't want to maintain their
behemoth of a codebase!

Library authors don't like to break things for their users, but for
CRAN package authors this is perhaps a greater concern than usual:

> Two interviewees (E1 and R4) specifically mentioned concern for
> downstream users' scientific research (R4: "We're improving the
> method, but results might change, so that's also worrying --- it
> makes it hard to do reproducible research").

But some library authors don't care so much:

> Only a few developers were not particularly worried about breaking
> changes. Some (E6, N1, N5) had strong ties to their users and felt
> they could help them individually (N5: "We try to avoid breaking
> their code --- but it's easy to update their code").  Interviewee N6
> expressed an "out of sight, out of mind" attitude: "Unfortunately,
> if someone suffers and then silently does not know how to reach me
> or contact me or something, yeah that's bad but that suffering
> person is sort of [the tree] in the woods that falls and doesn't
> make a sound."

It's perhaps worth mentioning at this point that the "N" people are
npm users.  The attitude of N6 would be fairly typical of Hackage
users too, I feel.

Now the paper crosses over to the other side, and looks at library
users and how they react to dependency changes.  It's the same people
as in the first survey, so these are library users who are also
library authors.  I wonder if a survey of people who are primarily
application authors would be different here.  There are three
approaches to learning about new library releases:

- Actively monitoring dependencies.  Most people don't do this.
- Having a general social awareness of the field, such as by following
  people on Twitter.
- Reactively waiting for notifications.  Most people do this.

A common strategy to handling the constant barrage of library updates
is to be more careful about what you depend on.

> Interviewee E5 represents a common view: "I only depend on things
> that are really worthwhile.  Because basically everything that you
> depend on is going to give you pain every so often. And that's
> inevitable."

Developers use a number of factors to decide if a dependency is worth
it:

- How much they trust the authors
- How actively developed it is
- The size of its user base
- What the authors' historic approach to breakage has been

The paper now mentions as surprising something which I completely
expected:

> Interestingly, there was almost no mention of traditional
> encapsulation strategies to isolate the impact of changes to
> upstream modules, contra to our expectations and typical
> software-engineering teaching.  Only N6 mentioned developing an
> abstraction layer between his package and an upstream dependency

I don't think I've seen a project introduce a layer of abstraction
between a dependency and its use, except in cases where one of
multiple dependencies will be used (like using one out of several
database libraries, but providing a consistent interface).  Maybe this
would be a good idea sometimes, but I feel like in most situations
it's just adding extra complexity and maintenance burden for little
benefit.

The paper wraps up with some discussion of the tension between
policies, values, and practice:

> For example there is a tension in Eclipse between the policy and
> practice of semantic versioning.  Eclipse has a long-standing
> versioning policy similar to semantic versioning and the platform's
> stability is reflected in the fact that many packages have not
> changed their major version number in over 10 years.  However, even
> for the few cases of breaking changes that are clearly documented in
> the release notes, such as removing deprecated functions, major
> versions are often not increased, because, as E8 told us, updating a
> major version number can ripple version updates to downstream
> packages, and can entail significant work for the downstream
> projects.

This is something I struggle with as a library user in Haskell: if I
change the version bounds on one of my dependencies, how exactly does
that translate into a version change for me?  Sometimes it's not so
clear.

So, to conclude:

> How to break an API: In Eclipse, you don't.  In R/CRAN, you reach
> out to affected downstream developers.  In Node.js/npm, you increase
> the major version number.

[a1]: http://chris.bogarthome.net/
[a2]: https://www.cs.cmu.edu/~ckaestne/
[a3]: http://herbsleb.org/
[a4]: https://sites.google.com/site/ferdianthung/
[m1]: https://dl.acm.org/citation.cfm?id=2950325
[m2]: http://www.cs.ucdavis.edu/fse2016/
[m3]: http://breakingapis.org/
[1]: https://marketplace.eclipse.org/
[2]: https://cran.r-project.org/
[3]: https://www.npmjs.com/
[4]: https://hackage.haskell.org/
[5]: https://www.stackage.org/
[6]: https://pvp.haskell.org/
[7]: https://semver.org/
