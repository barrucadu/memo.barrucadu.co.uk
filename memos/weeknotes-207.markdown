---
title: "Weeknotes: 207"
taxon: weeknotes-2022
date: 2022-09-04
---

## Books

This week I read:

- Volume 4 of [Delicious in Dungeon][] by Ryoko Kui

  Well, they did it: they accomplished their goal of rescuing their party member
  from a dragon's stomach.  But there are still so many volumes to go! I guess
  that was just the first arc.

[Delicious in Dungeon]: https://en.wikipedia.org/wiki/Delicious_in_Dungeon


## Roleplaying Games

Only one player was available today, so I ran an unusual one-shot:

- They rolled up three level 1 OSE characters (a Magic-User, a Moss Dwarf, and a
  Woodgrue).
- I rolled a random Dolmenwood hex, date, and time of day.
- And I told them where the nearest settlement was.

Then we started!

It was actually pretty fun, and I think that's really a testament to the quality
of the Dolmenwood material, that I was able to pick a random location I'd not
looked at before and string together a fun two and a half hours of adventure.

There were no survivors.

The Magic-User got eaten by giant crabs as the party tried to cross a river
(swept away by the current, unable to escape the river or regain her footing
before plowing into the giant crabs they'd noticed and evaded previously).  The
Moss Dwarf and Woodgrue got killed by an undead crow-man as they tried to rescue
some ensorcelled children from his grasp.  A heroic way to go.

Along the way the party were accosted by some suspicious druids, encountered a
mysterious chalk monolith engraved with hundreds of names, and talked to the
birds to learn about a tree with lots of good bugs.

I think this is definitely a one-shot scenario I'll keep for future use: roll up
some characters, let them loose in the world, and see what happens.


## Miscellaneous

It's been a fairly technical week.

### Journal validation

I've been meaning to implement some pre-commit validation for my [hledger
files][], and this week finally whipped something up:

```python
#!/usr/bin/env python3

import csv
import subprocess
import io
import sys

IGNORE_NEGATIVE_BALANCE = [
    # This was an automated transaction by AJ Bell.  I think the unit
    # price changed between the order being put in and the order
    # completing, hence over-charging by 2p.  To address this going
    # forwards, I changed the auto investment to use slightly less
    # than the full amount.
    ("2021-05-12", "assets:investments:ajbell", "1.46 VANEA, £-0.02"),
]


def hledger_command(args):
    """Run a hledger command, throw an error if it fails, and return the
    stdout.
    """

    real_args = ["hledger"]
    real_args.extend(args)

    proc = subprocess.run(real_args, check=True, capture_output=True)
    return proc.stdout.decode("utf-8")


errors = []

# Check asset account balances are non-negative
asset_accounts = hledger_command(["accounts", "assets"]).splitlines()
for account in asset_accounts:
    for posting in csv.DictReader(io.StringIO(hledger_command(["reg", account, "-O", "csv"]))):
        if "-" in posting["total"]:
            if (posting["date"], posting["account"], posting["total"]) in IGNORE_NEGATIVE_BALANCE:
                continue
            errors.append(f"Account {account} has negative balance ({posting['total']}) in transaction '{posting['description']}' on '{posting['date']}'.")
            break

# Check transactions are ordered
all_postings = []
for posting in csv.DictReader(io.StringIO(hledger_command(["print", "-O", "csv"]))):
    all_postings.append((int(posting["txnidx"]), posting["date"], posting["description"]))

prior_date = "0000-00-00"
prior_txnidx = None
for txnidx, date, description in sorted(all_postings):
    if txnidx == prior_txnidx:
        continue
    else:
        prior_txnidx = txnidx

    if date < prior_date:
        errors.append(f"Transaction '{description}' on '{date}' is out-of-order.")
    else:
        prior_date = date

if errors:
    for error in errors:
        print(error, file=sys.stderr)
    sys.exit(1)
```

I then fixed all the validation errors in my 2022, 2021, 2020, 2019, and 2018
journal files.  Mostly out-of-order transactions where I'd typo'd the date one
day early or late, but there were a couple of transactions where I'd made a
budgeting mishap and overspent from an asset category (effectively borrowing
money from another category without explicitly noting down that I was doing
that).

I didn't fix my 2017 and 2016 data because they were a mess.  There are a lot of
mistakes, and my approach to accounting in those first two years was so
different, in terms of how I tracked things and how I modelled my accounts, that
it would be a big task to ever pull that into my long-term finance dashboard.

But yeah, this is quite good.  `hledger check ordereddates` is nice and all, but
there's no built-in check for non-negative asset balances, and that's something
I've wanted on occasion.  I now have this set up as a pre-commit hook, so when I
do my weekly reconciliation I'm more likely to catch these small mistakes.

[hledger files]: personal-finance.html

### Dotfiles

I have also been tinkering with my dotfiles.  This week I've been looking into:

- [doom emacs][], for my emacs config
- [home-manager][], as a replacement for [stow][] & some globally installed
  packages
- [oh-my-zsh][], for my shell config

I wasn't too impressed with [oh-my-zsh][].  I know it's very popular, but the
handful of plugins I looked at were outdated compared to their upstreams, and
also my ZSH config isn't *that* complex.  So I decided not to adopt it, but I
did [reorganise & simplify my config][] instead.

I'm undecided about [home-manager][].  On the one hand, it does seem a very nice
idea: managing my user config the same way I manage my system config
(declaratively via nix), to the extent of even installing packages.  But on the
other hand, I share my dotfiles repo with my work laptop and, while I *could*
install Nix and home-manager on that, it'd be nice to not deviate too
significantly from how it's set up by default.  So maybe I could have
home-manager just copy files & install packages, while keeping the file layout
[stow][]-compatible for my work laptop.

I'll have to see, I only really skimmed the documentation.

From initial impressions, [doom emacs][] seems promising.  A bunch of
keybindings are different, which is a pain, but they're not hugely different.
It's also let me really reduce my emacs config, from 400+ lines to under 50
lines (90, of which about 50 are the auto-generated module list which I've
slightly tweaked).

I'm still getting used to it, and finding small bits of behaviours to tweak,
I'll have a stronger opinion next week.

[oh-my-zsh]: https://ohmyz.sh/
[doom emacs]: https://doomemacs.org
[home-manager]: https://github.com/nix-community/home-manager
[stow]: https://www.gnu.org/software/stow/
[reorganise & simplify my config]: https://github.com/barrucadu/dotfiles/commit/441e12266c3594cf135145ee852613287336765d

### Hardware problems

Finally, I've got to the bottom of the hardware problems that have plagued my
NAS basically since I set it up.

Sometimes, the NAS will hang.  It's hard to track down because logs just cut off
(evidently the hang made them not persist to disk), but the symptoms were kind
of weird: existing processes, like SSH connections to my VPS, would still work,
but starting new processes would hang; and I could still access the Samba / NFS
shares, but not SSH in.

So it seemed to be something relating to launching processes.

Often this happened on the 1st of the month, which is when I take a full backup,
so I thought maybe it was related to that, but the timing data I could get
didn't support that: the hang would often occur hours after the backup
completed.

Then this week it happened again, and I had to force power-off.  When I booted
back up, a file was corrupted, and ZFS wanted me to run a scrub.  I started the
scrub: a few hours later it hung.  I force-rebooted and started the scrub again:
a few hours later it hung.  And again.  And again.

Well, that's new: I could now reliably trigger it with a scrub.

Since existing processes keep running, I SSHed in, ran `journalctl -f`, `watch
zpool status -v`, `htop`, and `iotop` in tmux.  Then I started a scrub.  A few
hours later, it hung: and I had log entries in the journal this time.  The SATA
connection to the SSD got reset.

So now let's review the symptoms:

- Existing processes keep running, but new processes hang.
- Samba & NFS shares, which are all on the HDD, keep working.
- There are log entries showing the SSD connection being reset.
- There *aren't* log entries showing the HDD connections being reset.
- The SSD is the root device, so it's got all the binaries on it, so if that's
  unavailable then processes won't start.

However, I was scrubbing the HDDs, not the SSD, but the SSD had the issue.  THat
feels weird, until you consider that the SSD and half the HDDs are connected to
a PCI-e SATA card: could it be a problem with that card?  Could putting too much
load on the HDDs cause the connection to the SSD fail?

Thinking about it, this wasn't the first time I'd had issues with the SSD, but
I'd chalked those up to cables not being properly connected, or to too much dust
causing thermal issues.  But maybe...

But first, why is the SSD, the boot volume for this machine, connected to a
PCI-e card and not the motherboard?  Well, the motherboard only has 4 SATA
ports, and I have 9 drive bays to hook up: 8 HDDs in a zpool of 4 mirrored
pairs, and 1 SSD.  For redundancy, I didn't want two HDDs in the same pair to be
connected to the same SATA controller, so I had to connect 4 to the mobo and 4
to the PCI-e card, which didn't leave any space on the mobo for the SSD.  So it
also had to go on the PCI-e card.

Fortunately I have loads of free space on the HDDs with only 3 pairs hooked up,
so I could disconnect the 4th pair to free up a SATA port on the mobo.

I plugged the SSD into the mobo.  I started a scrub: it did *not* hang.

I'm going to leave it a bit longer before declaring the problem definitely fixed
(or at least, worked-around), but this isn't a permanent solution: I now have an
HDD bay I can't use since it's not plugged into anything.  I think ideally I'll
replace the mobo with one that has 5+ SATA ports.

Also, if IO load on the PCI-e card is the problem, why have I never had HDDs
disconnecting?  It's only the SSD.  So I feel like something else has to be
going on, but I don't have anything further to go on unless another problem
crops up.

But anyway, the problem seems to be fixed *for now*.


## Link Roundup

### Roleplaying games

- [Your Dragons Suck](https://www.paperspencils.com/your-dragons-suck/)
- [How I Construct Dragons](https://www.paperspencils.com/how-i-construct-dragons/)

### Software engineering

- [Converting Integers to Floats Using Hyperfocus](https://blog.m-ou.se/floats/)

### Miscellaneous

- [Post-Pandemic Mystery at Heathrow](http://fearoflanding.com/demystifying/post-pandemic-mystery-at-heathrow/)
