---
title: "Weeknotes: 106"
taxon: weeknotes-2020
date: 2020-09-27
---

## Work

The cat is out of the bag, and [GOV.UK Accounts][], the project I have
been working on since the beginning of June, has been announced.  So
now I'll feel more comfortable talking about OAuth and OpenID Connect
with people, without needing to worry about whether I'm letting enough
information slip for them to put two and two together.

There's been a lot of talk, both internal and now external, about
"personalisation"---using the data a user provides to do things like
recommend services, or highlight bits of content, or otherwise change
how GOV.UK behaves for them---but personally I think that even if all
we achieve is just having one single account for government web
services, that would be enough of a game-changer.  Right now the big
one is Government Gateway (run by HMRC), but also Companies House,
DfE, and a few other departments have their own systems; if we can get
those all using GOV.UK Accounts (*particularly* if we make it possible
to log into your GOV.UK account with your Government Gateway account
and vice versa) some users would no longer need to remember several
sets of credentials.

[GOV.UK Accounts]: https://gds.blog.gov.uk/2020/09/22/introducing-gov-uk-accounts/


## Books

This week I read:

- [House of Chains][] by Steven Erikson, the fourth of the [Malazan Book of the Fallen][].

  Another great entry in the series, introducing yet more characters,
  locations, and backstory.  It's cool to see how the events of one
  book end up referenced or portrayed in another book, given that we
  see things through so many points of view.  I know there are still
  many books to go, but I'm really looking forward to seeing how the
  series ends, as every book is just adding more and more detail to
  the story of the Crippled God.

[House of Chains]: https://en.wikipedia.org/wiki/House_of_Chains
[Malazan Book of the Fallen]: https://en.wikipedia.org/wiki/Malazan_Book_of_the_Fallen


## Network rebuild

This week I've been putting together all my new network hardware.
It's not been a completely smooth process---one of the sockets in my
power distribution unit is dead so I need to replace it, and Amazon
sent me the wrong cables for the hot-swap bays in my new server
case---but it's been a lot of fun.  I've even had a pleasant surprise
in that the network cabinet I got is more spacious than I expected, so
1U of space I planned to use for cable management is actually free,
giving me more room for future expansion.

I've been [chronicling my build, with photos, on Twitter][].

---

On the software side, I've been playing with a few new things:

I've set up the new root SSD for the server in the "[erase your
darlings][]" style, so `/` gets wiped on boot, with separate volumes
for `/boot`, `/nix`, and `/persist`.  Getting this working was fun,
and has already saved me a few times: I did `sudo mv /etc/shadow`
once, which locked me out of future `sudo` usage, but I was able to
just regenerate the file by rebooting.  Though I wouldn't have been
messing with that file if I hadn't been trying to move it to my
`/persist` volume, so...

![Screenshot of the Prometheus / Grafana monitoring dashboard](weeknotes-106/dashboard.png)

I decided to set up [Prometheus][] for monitoring, and even ended up
writing my own [speedtest.net monitoring plugin][].  I'm undecided on
whether I *really* need to run a speedtest every 5 minutes, but for
now it's neat.

![Screenshot of the start page](weeknotes-106/startpage.png)

I also revamped my start page, after finding [/r/startpages][] and
feeling that my old one was a bit inadequate.  The data is from [the
OpenWeather "current weather" API][] and GOV.UK's ["when do the clocks
change"][] and [bank holiday][] feeds.

---

Hopefully the final bits of the hardware will arrive soon, though the
projected delivery date for the cables I need to hook up my HDDs is
currently *November*...  I should at least have the network cabinet
assembled soon.

[chronicling my build, with photos, on Twitter]: https://twitter.com/barrucadu/status/1310242323666808833
[erase your darlings]: https://grahamc.com/blog/erase-your-darlings
[Prometheus]: https://prometheus.io/
[speedtest.net monitoring plugin]: https://github.com/barrucadu/prometheus-speedtest-exporter
[/r/startpages]: https://www.reddit.com/r/startpages/
[the OpenWeather "current weather" API]: https://openweathermap.org/current
["when do the clocks change"]: https://www.gov.uk/when-do-the-clocks-change.json
[bank holiday]: https://www.gov.uk/bank-holidays/england-and-wales.json


## Link Roundup

- [Internet: Old TV caused village broadband outages for 18 months](https://www.bbc.co.uk/news/uk-wales-54239180)
- [Raspberry Pi 4 2U rack-mount bracket](https://www.youtube.com/watch?v=splC57efBFQ)
- [Let's Encrypt postpone the ISRG Root transition](https://scotthelme.co.uk/lets-encrypt-postpone-isrg-root-transition/)
- [Creating an Autonomous System for Fun and Profit](https://blog.thelifeofkenneth.com/2017/11/creating-autonomous-system-for-fun-and.html)
