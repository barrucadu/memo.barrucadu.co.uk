---
title: "Weeknotes: 135"
taxon: weeknotes-2021
date: 2021-04-18
---

## Work

This week we hammered out the details of another experiment we want to
run, and this experiment *won't* need the user to use 2FA.  Our
current experiment does, so I've been thinking about how to handle
that.

### Levels of Authentication

The solution I hit upon was to track a user's "level of
authentication".  Currently we have one level (logged in with a
username, password, and 2FA).  The new experiment will introduce a
second (logged in with just a username and password).  Levels of
authentication form a total order.

Then, for each piece of user data, we need to specify the minimum
level of authentication needed to:

- check if it's present;
- get its value; and
- update it.

The [account-api][] will check that a user is authenticated to the
right level when they try to do something with an attribute, returning
a 403 error and the required level if not.

[account-api]: https://github.com/alphagov/account-api

### Security

How do we store this level of authentication?  We could have the
identity provider associate it with the OAuth access token, and have
an endpoint to query it.  This makes it unspoofable, but adds a
network round-trip to every attribute request.  Not great.

The next best option is to request it *just once*, when the user is
returned to the OAuth callback path after successfully authenticating,
and to store it in the session.  This is much better, except our
sessions were plaintext.

Fortunately, Rails comes with [a message signer/encryptor built in][],
so I didn't need to think too hard about the crypto or (god forbid)
roll my own.

[a message signer/encryptor built in]: https://apidock.com/rails/ActiveSupport/MessageEncryptor

### Authentication

The final piece of the puzzle is to allow a service to pass a desired
level of authentication along in an OAuth auth request, and for the
identity provider to:

- authenticate the user at the desired level if they're not logged in;
  or
- upgrade the user to the desired level if they're logged in at a
  lower one.

The tricky part of this is that if a user has *registered* at the
lower level, and tries to use the [Transition Checker][], they'll have
to set up 2FA.  So it's a little more complex than "if the user hasn't
done 2FA, make them do it".  Not an insurmountable problem, but it
moves this work out of the purely technical realm and means we'll need
to get some design input on how to explain to the user why they need
to now provide their phone number.

When we've got this part done, we can get on with actually
implementing the experiment.

[Transition Checker]: https://www.gov.uk/transition-check/questions


## Books

I didn't finish any books this week either!  Still working through the
Google SRE books and Helliconia.


## Orchestrating Containers

[Last week][] I mused on making a container scheduler, and I spent a
lot of this week [making a start][].  I decided to call it
[Ozymandias][], because I expect people to look upon my works and
despair.

Built on top of [podman][] and [etcd][], it's got to the point where I
can put pod configuration into etcd and run a command on the node to
fetch the config and launch it.  The next logical step is to add a
little daemon which'll monitor for pod configurations being added or
removed, and automatically update the local state.

Implementing even this little has given me a much greater
understanding of the sorts of problems Kubernetes needs to solve, so
maybe I'll have another go at learning that.  I think I'd do better
this time.

[Last week]: weeknotes-134.html
[making a start]: https://github.com/barrucadu/ozymandias
[Ozymandias]: https://en.wikipedia.org/wiki/Ozymandias
[podman]: https://podman.io/
[etcd]: https://etcd.io/


## New Server

I consolidated my two VPSes into a single, slightly bigger, one.  I
set it up in the "[erase your darlings][]" style, so it gets wiped on
boot other than a limited selection of preserved state:

- My home directory
- The compiled NixOS configuration
- Some non-recoverable state:
  - SSH host keys
  - Persistent docker volumes
  - Minecraft server files
  - Log files and Prometheus metrics
- Other recoverable, but nice to keep, state:
  - Static website files
  - HTTPS certs
  - Docker registry contents
  - Syncthing configuration

Not all of this is strictly needed: for example, I could throw away
logs and metrics at boot; regenerate HTTPS certs; redeploy static
websites; and rebuild docker images.  But that would make reboots more
of a pain.  I think what I'm keeping strikes a good balance between
immutability and practicality.

I learned something new about [Concourse][] setting up this server: if
you're running workers in docker, you should make them "ephemeral", or
[you'll have a disk space leak][].

[erase your darlings]: https://grahamc.com/blog/erase-your-darlings
[Concourse]: https://concourse-ci.org/
[you'll have a disk space leak]: https://github.com/barrucadu/nixfiles/pull/12


## RPG Blog

I published a short post about a [Knowledge of the Future of the
Universe skill][], which I gave one of my Call of Cthulhu characters
[back in January][].

[Knowledge of the Future of the Universe skill]: https://www.lookwhattheshoggothdraggedin.com/post/knowledge-of-the-future-of-the-universe.html
[back in January]: weeknotes-120.html


## Link Roundup

### Roleplaying Games

- [Advancement and Continuous Play](https://dreamingdragonslayer.com/2020/06/12/advancement-and-continuous-play/)
- [Diegetic Advancement Triggers](https://dreamingdragonslayer.com/2020/06/13/diegetic-advancement-triggers/)

### Software Engineering

- [What exactly was the point of [ "x$var" = "xval" ]?](https://www.vidarholen.net/contents/blog/?p=1035)

### Miscellaneous

- [The Crow Whisperer](https://harpers.org/archive/2021/04/the-crow-whisperer-animal-communicators/)
- [Collections: Oaths! How do they Work?](https://acoup.blog/2019/06/28/collections-oaths-how-do-they-work/)
- [You Might as Well Be a Great Copy Editor](https://blog.regehr.org/archives/1471)
