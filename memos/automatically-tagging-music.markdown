---
title: "Automatically tagging audio files (using systemd and inotify)"
taxon: general
tags: programming, shell
date: 2020-10-14
---

I follow several podcasts and, if you do the same, you may have
noticed that podcast creators are *terrible* at consistently tagging
their files.  For example, is the artist the name of the podcast, the
names of the presenters, just one of the presenters, some
abbreviation, or the names of the presenters in a different order?
Probably all of those, and more, get used inconsistently across the
lifetime of a multi-year-old podcast.

Inconsistent tagging makes it a pain to use tools which use that
information, which is pretty much every audio player.

For some years, my solution was a script which retagged all my
podcasts.  This can be done because I use a standard directory and
file naming convention.  But the downside is that it retagged every
file of every podcast when ran, even though I'd only be adding one new
file at a time.


## systemd path units

I recently discovered [systemd path units][], which seemed like the
solution to this problem: I could have a script which was triggered by
a file being created, tagged it, and moved it to the right place.
Path units turned out not to be the solution to *this* problem, but
they were a solution to a slightly different one.

My first attempt was to add a subdirectory to every podcast directory
called `in`, and to write this path unit:

```
[Unit]
Description=Automatically tag new podcast files
RequiresMountsFor=/mnt/nas

[Path]
PathExistsGlob=/mnt/nas/music/Podcasts/*/in/*.mp3
```

And this service file:

```
[Unit]

[Service]
Environment="PATH=<...>"
ExecStart=/usr/local/bin/tag-podcasts.sh
Group=users
User=barrucadu
WorkingDirectory=/mnt/nas/music/Podcasts/
```

And this bash script:

```bash
#!/usr/bin/env bash

for mp3file in */in/*.mp3; do
  dir="$(echo "$mp3file" | sed 's:/in/.*::')"
  f="$(basename "$mp3file")"

  artist="$(echo "$dir" | sed 's: - .*::')"
  album="$(echo "$dir" | sed 's:.* - ::')"

  if [[ -z "$album" ]]; then
    album="$artist"
  fi

  n="$(echo "$f" | sed 's:\..*::')"
  track="$(echo "$f" | sed 's:^[0-9]*\. \(.*\)\.mp3:\1:')"

  echo "===== $mp3file" >&2
  echo $artist >&2
  echo $album >&2
  echo $n >&2
  echo $track >&2
  echo "$(echo "$mp3file" | sed 's:/in/:/:')" >&2
  echo >&2

  id3v2 -D "$mp3file"
  id3v2 -2 --song   "$track"  "$mp3file"
  id3v2 -2 --track  "$n"      "$mp3file"
  id3v2 -2 --artist "$artist" "$mp3file"
  id3v2 -2 --album  "$album"  "$mp3file"
  mv "$mp3file" "$(echo "$mp3file" | sed 's:/in/:/:')"
done
```

This turned out not to work.  The unit just didn't pick up any file
changes.  Any one podcast would work[^eg], but I didn't really want to
have to make a unit for each of my podcasts... I'd need to update my
system configuration if I started following a new podcast; that feels
like too much mixing of global configuration and how I (admittedly the
single user of the system) use it.

[^eg]: For example, if I changed the `PathExistsGlob` to something like `/mnt/nas/music/Podcasts/The H. P. Lovecraft Literary Podcast/in/*.mp3`

So I had to give up on path units for tagging my podcasts.

[systemd path units]: https://www.freedesktop.org/software/systemd/man/systemd.path.html


## Tagging podcasts

I was too invested at this point to give up entirely, I wanted
automatic tagging.

So I turned to `inotifywatch`, and stuck this at the end of my script:

```bash
# this can't be done as a systemd path unit because it doesn't seem to
# support multiple *s in a pattern
inotifywait --recursive --timeout 3600 --include '/mnt/nas/music/Podcasts/.*/in/.*\.mp3' $(pwd) >&2

# this script is run in a loop by systemd.
```

The next step was to make a systemd unit which just runs that script
in a loop.  Which is defined in my NixOS config as:

```nix
systemd.services.tag-podcasts = {
  enable = true;
  description = "Automatically tag new podcast files";
  wantedBy = ["multi-user.target"];
  path = with pkgs; [ inotifyTools id3v2 ];
  unitConfig.RequiresMountsFor = "/mnt/nas";
  serviceConfig = {
    WorkingDirectory = "/mnt/nas/music/Podcasts/";
    ExecStart = pkgs.writeShellScript "tag-podcasts.sh" (fileContents ./tag-podcasts.sh);
    User = "barrucadu";
    Group = "users";
    Restart = "always";
  };
};
```

And now I've got a script which, once an hour (or on detecting a file
change, whichever is sooner) tags all new podcast files and moves them
to the correct directories.  No more SSHing in and running my tagging
script, I can just save a file as, eg, `How We Roll - Masks of
Nyarlathotep/in/{number}. {title}.mp3`, over Samba or NFS, and within
a few seconds it gets picked up, tagged, and organised.  Nice.


## Tagging albums

I couldn't use a single path unit to trigger my script for tagging
podcasts, but that's not the only time I want to tag some audio files.
I have a collection of CDs, which I very infrequently add to, and I
have those CDs ripped and stored as FLAC files.  Appropriately tagged,
of course.

I use [Exact Audio Copy (EAC)][] to rip my CDs to WAV, which uses a
predictable directory layout and file naming convention.  I already
had a script to take an EAC directory and produce a tagged and
organised FLAC directory, I just needed to make it automatic.

First, here's my systemd configuration:

```nix
systemd.paths.flac-and-tag-album = {
  enable = true;
  description = "Automatically flac and tag new albums";
  wantedBy = ["multi-user.target"];
  unitConfig.RequiresMountsFor = "/mnt/nas";
  pathConfig.PathExistsGlob = "/mnt/nas/music/to_convert/in/*";
};
systemd.services.flac-and-tag-album = {
  path = with pkgs; [ flac ];
  serviceConfig = {
    WorkingDirectory = "/mnt/nas/music/to_convert/in/";
    ExecStart = pkgs.writeShellScript "flac-and-tag-album.sh" (fileContents ./flac-and-tag-album.sh);
    User = "barrucadu";
    Group = "users";
  };
};
```


An album consists of multiple files, but I don't want to try to
convert an album where some of the files are still part-way through
being copied to the NAS; that sounds like an easy way to end up with
incomplete FLACs.  So I came up with this workflow:

1. A CD is ripped to WAV with EAC on my desktop
2. The EAC directory is copied over to `/mnt/nas/music/to_convert` over Samba (which will take a few seconds)
3. Then the directory moved to `/mnt/nas/music/to_convert/in` (which will be instantaneous)
4. The path unit notices the new subdirectory, and triggers the script.

And here's the script:

```bash
#!/usr/bin/env bash

set -e

for artist in *; do
  if [[ -d $artist ]]; then
    pushd $artist
    for album in *; do
      if [[ -d $album ]]; then
        echo "===== $artist - $album" >&2
        pushd $album
        if [[ ! -e "$artist - $album.log" ]]; then
          echo "(missing log file)" >&2
        fi
        if [[ ! -e "cover.jpg" ]] && [[ ! -e "cover.png" ]] && [[ ! -e "cover.gif" ]]; then
          echo "(missing cover file)" >&2
        fi
        flac *.wav
        rm *.wav
        for flacfile in *.flac; do
          n="$(echo "$flacfile" | sed 's:\..*::')"
          track="$(echo "$flacfile" | sed 's:^[0-9]*\. \(.*\)\.flac:\1:')"
          metaflac --set-tag="tracknumber=$n" "$flacfile"
          metaflac --set-tag="title=$track"   "$flacfile"
          metaflac --set-tag="artist=$artist" "$flacfile"
          metaflac --set-tag="album=$album"   "$flacfile"
        done
        popd
        echo
        mv $album "../../out/$artist - $album"
      fi
    done
    popd
    rmdir $artist
  fi
done
```

Nice and straightforward.  I've not ripped any new CDs since setting
this up earlier this week, but I converted some FLACs back to WAVs,
shuffled the directory layout around, and tested that they got picked
up and re-converted properly.

[Exact Audio Copy (EAC)]: http://exactaudiocopy.de/
