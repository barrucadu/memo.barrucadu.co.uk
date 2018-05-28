---
title: A New Kind of Imageboard
tags: culture, tech
date: 2018-05-28
audience: Imageboard dwellers & cyber-anthropologists.
epistemic_status: Totally unsubstantiated opinions, but I've been immersed in this culture for a while.
notice: This is part feature list / part response to Clay Shirky's "A Group Is Its Own Worst Enemy" essay.  Will I ever implement this and test these ideas out?  Who knows!
---

I've been using imageboards for a long time, and I accept that they
have problems.  Total anonymity brings out the worst in people: any
contentious issue at all becomes a hot button issue, where civility of
discussion rapidly degrades.  It doesn't help that many of the more
vocal imageboard users are trolls, incels, or other similar groups.
Politics and religion, even exercise and relationships, can cause huge
arguments.  The simple solution is to say "anonymity has failed, let's
just use accounts with persistent handles and a reputation system like
everyone else".

But I don't like that solution.  Accounts raise the barrier to entry,
which helps to curb drive-by trolling, but not significantly.  People
even act terribly when their account is associated with their real
name and employer, as we have seen time and time again on Facebook and
Twitter.

Another problem with imageboards is stagnation.  They're pretty much
all the same.  They have different appearences and different boards,
but that's it.  Some do depart from the standard feature-set:
liveboards, where you can see a post as it is typed, and have a more
rapid-fire discussion, are a great innovation.  Part-way between
real-time and asynchronous communication, I think they are the future
of imageboards.

Live posting is a big change, both technically and culturally, but
liveboards are still clearly the same sort of thing as imageboards.  I
think we can go further.

This memo is an exploration of ideas I have for something which is
recognisably "imageboard-like", but which comes with some new stuff
which I hope will have a culturally significant effect.  At the same
time, I'll discuss ["A Group Is Its Own Worst Enemy"][shirky], as my
ideas are part-motivated by the problems raised in that.

[shirky]: http://www.shirky.com/writings/herecomeseverybody/group_enemy.html

## A group is its own worst enemy

I recommend reading [the original article][shirky] by Clay Shirky, but
I'll present a summary here, which will be useful to bear in mind in
later sections.

There are three things we have to accept about online communities:

1. You cannot completely separate technical and social issues.  See
   ["LambdaMOO Takes a New Direction"][ltand] for one failed attempt
   at this.

2. Members are different than users.  Some group of users (the "core
   group") will arise that cares more than average about the integrity
   and success of the group as a whole.

3. The core group has rights that trump individual rights in some
   situations.

And there are four things we have to design for:

1. A notion of identity, because knowing who said what is the minimum
   requirement to have a conversation.  The simplest is a persistent
   handle.

2. A notion of members in good standing, so good deeds can be
   recognised.  The simplest is, again, a persistent handle.

3. Barriers to participation, to protect the group from drive-by
   harassment and damage.

4. A way to spare the group from scale, as it's harder to have a good
   conversation in a large group.

[ltand]: https://www.cc.gatech.edu/classes/AY2001/cs6470_fall/LTAND.html

## A plan for the future of imageboards

I'll drill into this more deeply in the subsections that follow, but
here's the high-level overview:

- The basic model is a liveboard.
- With limited opening hours.
- Moderation is by voting, by eligible online posters.
- A mail system: users have any number of named mailboxes, you can
  mail the author of a post or a particular mailbox, and respond to
  such messages.
- Mail is just liveposting but with a restricted set of users.
- No enforced visible identity: you can't know that two posts are by
  the same person (or would send mail to the same person).

I'm taking care to preserve anonymity to some degree, as I think it's
an important part of imageboard culture.  An imageboard which ties
every post to a named user is *too much* of a change: at that point
you just have a weird forum.

Let's go through these in order.

### Limited opening hours

This currently exists in some liveboards, and is typically called a
"curfew" (though that's not quite the right word).  The idea is that
the board is only "open" for some period of time, not only can you not
post outside of the opening hours, you can't even browse.

It works *extremely* well for fostering discussion when the community
is small, because everyone makes an effort to show up at the same
time.  Even if there are only ten people, all liveposting at once
feels a lot busier than people being spread around the clock.

This is often combined with automatic deletion of posts when the board
closes.  Posts only exist within their one session.

### Poster identity

Shirky goes quite far, and says that weak pseudonymity doesn't work
well, as people need to connect the current conversation to prior
conversations.  I don't fully agree with that: I think connecting to
prior conversations is important for a more meaningful discussion, but
I don't think allowing users to change their handles easily is much of
a problem.

One model I have seen work well, albeit in a small community where all
of these problems are simpler, is that most users voluntarily assume a
consistent handle.  But the handle is not part of the software, it's
just a thing expressed through choice of images.

People occasionally change handle, but not frequently.  When someone
does, one of three things happen:

- They explicitly connect their new handle to their previous handle,
  by making a post.

- They do not connect their handles, but people figure it out anyway,
  because of how they write and what they post about.

- They do not connect their handles, and their posting style is not
  distinctive enough for people to confidently connect the two
  handles.

So two out of three outcomes result in the community knowing that the
poster has just changed their handle.  Would managing accounts and
handles in software change this?  I don't think so: in the third case,
where the user wants to use a new handle unconnected to their old one,
they would just create a new account.

Furthermore, there is a social cost to changing your handle: unless
the whole community is on at the same time, people will be asking for
weeks afterwards "Is X gone?  Or did they just change their name?"
This tends to discourage frequent changes, but still permits them for
users who like to change and don't mind the hassle.

So, in summary, I agree with Shirky that consistent handles are needed
for interactions which last longer than a single conversation, but I
don't think they need to be part of the software.

### Moderation

Imageboards attract trouble, and a persistent problem is that there
are never enough moderators.  [I have written before about imageboard
staffing](/imageboards.html), and the system is quite heavyweight.
Here's a summary:

Administrators
  ~ They can do everything.  Some examples of admin-only powers are:
  creating and deleting users, creating and deleting boards, modifying
  user permissions.

Moderators
  ~ The bulk of your typical imageboard's staff.  On their boards,
  they can do basically anything: delete, move, and edit posts and
  images; ban users; spoiler and unspoiler images; bumplock threads;
  sticky threads; and so on.

Janitors
  ~ They can delete posts.

Making someone a moderator is a significant investment of trust.
Moderators are explicitly created by the administrator, and have
little oversight.  If a moderator does something bad on their board,
you'd better hope you have good backups.

Janitors were introduced as a low-trust stopgap, but they can't do
much.  If someone is spamming, and only janitors are online, they
cannot really deal with the spammer, only clean up after them.

What we want is a large group of people who can handle an ongoing
attack in the absence of any staff.  Who better to form this group
than the core users?  The core users are the most invested users: the
ones who show up to every session, who report bad posts, and who try
to steer discussion away from bad actors.

But we don't want someone who infiltrates this trusted core group to
be able to cause problems if they turn bad.  So we'll restrict the
power of any one individual, by making decisions by a simple majority
vote of online members.  Specifically, I think this group should be
able to:

- Elect new members to the group.
- Issue a temporary ban to the author of a post.
- Hide an individual post.
- Hide all posts by a banned user.

On the technical side, this could work using passwords.  When a user
is elected to the group, they get issued a unique password.  They can
gain their powers by entering the password on the website.  They can
also reset their password.

When a vote is triggered, all users who have signed in during the
current session are eligible voters.  The vote passes if a majority
vote yes.

### Mail

When a user shows up for the first time, they get a randomly generated
mailbox name.  This could be stored in a cookie, with the option to
explicitly enter it so that users don't lose their mail if they clear
their cookies (or use another computer).

When a user makes a post, the post keeps a record of the user's
mailbox.  Other users can send a message to the poster's mailbox.
However, the mailbox name is *not* shown (all you know is that you're
sending a message to the author of that post), so mailbox names can't
be used to link posts together.

A user can also choose to tell other users their mailbox name, in
which case those users can directly message them.  Such messages can
be sent to multiple mailboxes at the same time.  In this case, we'll
probably want the ability to password-protect a mailbox, so we can
allow private communication without also granting read access.

We'll probably also want the ability for a user to monitor multiple
mailboxes; but one must be the "primary" mailbox, which gets
associated with their posts.

I'm envisioning mail to be just like regular posts, where all
recipients can see as you type.  So mail threads are effectively
one-thread private liveboards.  It should also be possible to add a
new recipient to a thread.  By keeping these threads invite-only, I
think it avoids the moderation nightmare that is 8chan, where any user
can create their own (public) board.

Perhaps mail should be accessible at all times, so the curfew is not a
barrier to these more private discussions.

### A few more thoughts

If we take the private group mail to its logical extreme, then the
point of the public posting space is to be, more or less, a lobby in
which the whole group gets together, and to act as a place for new
members to arrive; discussion in this lobby will be fairly superficial
and friendly, with more serious discussion happening in cultivated
groups.  This gives rise to an interesting question:

*Are multiple boards, or even multiple threads, necessary at all?*

I suspect not.  In which case, we need to be careful with the growing
number of posts in the single "thread" (and in each mail group).  I
think an expiry mechanic would work nicely here: posts can either
expire at a fixed time (such as the end of a session), or when the
thread contains a given number of posts.

I think this would be a very interesting community!

- A single public thread, only open for a few hours a day at fixed
  times;
- With a mail system, accessible even when the lobby is closed;
- Where posts gradually expire as time goes on.

This feels more like a chatroom than an imageboard!

## Open problems

So how does this proposal do with respect to Shirky's design
requirements?

1. A notion of identity.

    As discussed, I don't think this needs a solution in the software,
    and anything which the software does implement can be easily
    overcome.  The mail system is the closest thing there is to
    identity, and I am explicitly allowing the same individual to have
    as many mailboxes as they want.

2. A notion of members in good standing.

    I'm going to explicitly recognise this group, by promoting them to
    moderators.  This group will then grow itself, without the need
    for staff intervention.  Is there a need for people to be able to
    cast out members?  Perhaps, I don't know.  Hopefully this will be
    a rare occurrence, but definitely staff should be able to do it.

3. Barriers to participation.

    This is sort of solved.  The core group chooses new members by
    voting, which is certainly a barrier: you need half of the ones
    who are online at any given time to agree you're also of good
    standing.  The curfew system imposes another barrier, which
    somewhat discourages drive-by attacks, but does nothing to deter
    those willing to wait.

4. A way to spare the group from scale.

    This still needs thought.  There are two types of scale problems:
    bad actors overwhelming the staff, which we have somewhat solved
    with the idea of the core group; but also good actors diluting
    discussion.  How do we solve this?  The mail system will help,
    especially with group discussions, but I don't think it's a
    complete solution.

We also need to think about users not on a traditional computer: the
posters who use tablets and phones.  I have heard (but couldn't find
an original source) that moot said that if he was starting 4chan
today, he would focus on the mobile experience.  That's where the
users are today.  Using imageboards on a phone is definitely a pain
currently, so there are some interface wins to be made.  Does a mobile
interface also suggest new functionality?  I'm not sure.  Being able
to upload photos or videos straight from the camera, and audio
straight from the microphone, would certainly be neat.
