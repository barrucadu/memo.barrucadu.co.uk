---
title: "Weeknotes: 160"
taxon: weeknotes-2021
date: 2021-10-10
---

## Work

This week we got another couple of big bits of the integration work
done, or near to it:

- [Vectors of Trust (RFC 8485)][]: merged and deployed.  We've
  actually had this ready for a few weeks, and were waiting for the
  auth service to finish their implementation.  When they did, things
  worked first time: perfect.

- User data migration: implemented, and we'll shake out any bugs when
  we start migrating test users.  The tricky thing here is that, when
  users migrate to the new auth system, all the identifiers will
  change.  So we need code in place to recognise old data and upgrade
  it to use the new identifiers.

- Joined-up cookie consent: in review.  We think it's silly to show
  users two cookie banners when they move between different parts of a
  single, larger, service, just because the service is built by two
  different teams.  And the GDS privacy team agree.  So the technical
  work to pass consent back and forth is being reviewed, and should go
  out early next week.

That's... kind of it.  Unless something unforeseen comes up when we
start testing user migration, all that's left to go is to prepare all
the production configuration, so we can switch over when it's go time.

[Vectors of Trust (RFC 8485)]: https://datatracker.ietf.org/doc/html/rfc8485


## Books

This week I read:

- [Fall of Light][] by Steven Erikson, the second of the [Kharkanas Trilogy][].

  This took a little while, but I think mostly because I've not been
  reading huge fantasy books lately.  I finished Malazan in February
  and have mostly been reading shorter books since then.  I'm out of
  practice.

  But once I got into it, it was great.  A lot of interesting
  revelations which play into the main series, plus some twists and
  turns which ran counter to my expectations.  I'm very much looking
  forward to book 3, Walk in Shadow, when that comes out.

[Fall of Light]: https://malazan.fandom.com/wiki/Fall_of_Light
[Kharkanas Trilogy]:https://en.wikipedia.org/wiki/The_Kharkanas_Trilogy


## Gaming

This week I ran a [session zero][] for my new Traveller campaign,
where we talked about the sort of game we want to run, and then got
through character creation.  No deaths in character creation this
time, but my players have already thrown me a bit of a curveball:
*two* of them got ships as benefits.  So I'll need to figure out how
to handle that.

I'm planning to run this campaign as much more of an episodic sandbox
style game than I'm used to, so I'm looking forward to things taking
off.  It'll be a bit linear in the beginning, as I present them with a
series of adventures and missions to help embed them into the game
world but, once they start making NPC connections and learning about
things going on elsewhere, I hope to be able to turn them loose and
make the campaign more-or-less entirely player-driven.

[session zero]: https://rpg.stackexchange.com/questions/105388/what-is-a-session-0


## Miscellaneous

This week I discovered that you can get systemd to create a FIFO for
the stdin (or -out, or -err) for a service, which is handy for things
like a Minecraft server where being able to send text directly to the
running process is useful (and, indeed, necessary some times).

You just need to define a socket service, like this
`minecraft-stdin.socket`:

```
[Unit]
Description=stdin for Minecraft Server

[Socket]
ListenFIFO=%t/minecraft.stdin
Service=minecraft.service
```

And attach it to your unit file, like this `minecraft.service`:

```
[Unit]
After=network.target
Description=Minecraft Server Service

[Service]
Sockets=minecraft-stdin.socket
StandardInput=socket

(...boring other service definition stuff here...)
```


## Link Roundup

### Roleplaying Games

- [Magicpunk](http://monstersandmanuals.blogspot.com/2021/10/magicpunk.html)
- [The Perfect Languages of Elves ](http://goblinpunch.blogspot.com/2016/09/the-perfect-languages-of-elves.html)

### Software Engineering

- [It takes a PhD to develop that](https://blog.royalsloth.eu/posts/it-takes-a-phd-to-develop-that/)
- [Understanding How Facebook Disappeared from the Internet](https://blog.cloudflare.com/october-2021-facebook-outage/)
