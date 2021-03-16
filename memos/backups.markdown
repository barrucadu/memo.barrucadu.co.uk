---
title: Backups
taxon: techdocs-practices
tags: aws
date: 2021-03-16
---

I take automatic full and incremental off-site backups using
[duplicity][].  I don't need to take full filesystem backups, because
of the "infrastructure as code" / "configuration as code" approach I
take wherever possible:

- [ops][] has my cloud configuration
- [dotfiles][] has my user configuration
- [nixfiles][] has my system configuration

So really I just need to back up my data and git repositories.

[duplicity]: http://duplicity.nongnu.org/
[ops]: https://github.com/barrucadu/ops
[dotfiles]: https://github.com/barrucadu/dotfiles
[nixfiles]: https://github.com/barrucadu/nixfiles


Backup location: Amazon S3
--------------------------

I store my backups in S3, and move them to the lower-cost (but
harder-to-access) Glacier storage after 64 days.  I use [terraform][]
to provision all my AWS stuff, including this backup location:

```terraform
resource "aws_s3_bucket" "backups" {
  bucket = "barrucadu-backups"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "archive"
    enabled = true

    transition {
      days          = 32
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 64
      storage_class = "GLACIER"
    }
  }
}
```

There's also an IAM policy granting access to the bucket:

```terraform
data "aws_iam_policy_document" "backups" {
  statement {
    sid = "InspectBuckets"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    sid = "ManageBackups"

    actions = [
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      aws_s3_bucket.backups.arn,
      "${aws_s3_bucket.backups.arn}/*",
    ]
  }
}
```

This is the minimal set of permissions to run duplicity, I think.  The
bucket itself is versioned, but I don't grant the backup user any
versioning-related permissions (eg, they can't delete an old version
of a file).  This is so that if the credentials for the backup user
get leaked somehow, and someone deletes or overwrites my backups, I
can recover them.

The backups are encrypted.  However, the encryption key is stored in
the same place as the AWS access keys, so if someone can get one they
likely can get both.  I'd like a better solution for this, but I'm not
sure what that is yet.

[terraform]: https://www.terraform.io/


Backup script: duplicity and shell
----------------------------------

Because I don't take full filesystem backups I have two parts to my
backup scripts.  The main script:

1. Checks for a host-specific backup script (not all hosts take
   backups)
2. Creates a temporary directory for the backup to be generated in
3. Runs the host-specific script
4. Uses duplicity to generate a full or incremental backup, targetting
   the S3 bucket

It looks like this:

```bash
#!/bin/sh

set -e

# location of scripts
BACKUP_SCRIPT_DIR=$HOME/backup-scripts

# hostname
MY_HOST=`hostname`

BACKUP_TYPE=$1
if [[ -z "$BACKUP_TYPE" ]]; then
  echo 'specify a backup type!'
  exit 1
fi

if [[ -d "${BACKUP_SCRIPT_DIR}/host-scripts/${MY_HOST}" ]]; then
  DIR=`mktemp -d`
  trap "rm -rf $DIR" EXIT
  cd $DIR

  mkdir "$MY_HOST"
  pushd "$MY_HOST"
  for script in "${BACKUP_SCRIPT_DIR}/host-scripts/${MY_HOST}"/*.sh; do
    echo "$(basename $script)"
    if ! time "$script"; then
      send-host-alert "Backup failed in ${script}"
      exit 1
    fi
  done
  popd

  if ! time $BACKUP_SCRIPT_DIR/duplicity.sh $BACKUP_TYPE $MY_HOST; then
    send-host-alert "Backup upload failed"
    exit 1
  fi
else
  echo 'nothing to do!'
fi
```

The `duplicity.sh` script sets some environment variables and common
parameters:

```bash
#!/usr/bin/env nix-shell
#!nix-shell -i bash -p duplicity "python3.withPackages (ps: [ps.boto3])"

set -e

# location of scripts
BACKUP_SCRIPT_DIR=$HOME/backup-scripts

# aws config
AWS_PROFILE="backup"
AWS_S3_BUCKET="barrucadu-backups"

if [[ ! -e $BACKUP_SCRIPT_DIR/passphrase.sh ]]; then
  echo 'missing passphrase file!'
  exit 1
fi

source $BACKUP_SCRIPT_DIR/passphrase.sh

export AWS_PROFILE=$AWS_PROFILE
export PASSPHRASE=$PASSPHRASE

duplicity                  \
  --s3-european-buckets    \
  --s3-use-multiprocessing \
  --s3-use-new-style       \
  --verbosity notice       \
  "$@"                     \
  "boto3+s3://${AWS_S3_BUCKET}/$(hostname)"
```

Duplicity's incremental backups are based on hashing chunks of files,
so it can take incremental backups even though all the file
modification times will have changed (because the backup is generated
anew every time) since the last full backup.

### Alerting

The main backup script calls a `send-host-alert` script on failure,
which sends me an email and a text message using [Amazon SNS][].

This is documented more in the [monitoring memo][].

[Amazon SNS]: https://aws.amazon.com/sns/
[monitoring memo]: monitoring.html

### Encryption

The backups are encrypted with a 512-character password (the
`PASSPHRASE` environment variable in `duplicity.sh`).  The same
password is used for all the backups, and each machine which takes
backups has a copy of the password.  The backups are useless if I lose
the password, but for that to happen, I'd have to lose:

- Both of my home computers, in London
- Two VPSes, in Nuremberg somewhere
- A dedicated server, in France somewhere

That seems pretty unlikely.  Even if it does happen, any event (or
sequence of events) which takes out all those locations in quick
succession would probably give me big enough problems that not having
a backup of my git repositories or RPG PDFs is a small concern---it
could also take out my backups themselves, which are in Ireland.

### Host-specific scripts

These aren't terribly interesting, or useful to anyone other than me,
so I'll just give an example rather than go through each one.

The script for dunwich, one of my VPSes, backs up:

- All my public github repositories (I don't have any private ones)
- All my self-hosted repositories
- My [syncthing][] directory

Here's the git repository step:

```bash
#! /usr/bin/env nix-shell
#! nix-shell -i bash -p jq

source ~/secrets/backup-scripts/dreamlands-git-token.sh

# I have no private github repos, and under 100 public ones; so this
# use of the public API is fine.
function clone_public_github_repos() {
  curl 'https://api.github.com/users/barrucadu/repos?per_page=100' 2>/dev/null | \
    jq -r '.[].clone_url' | \
    while read url; do
      git clone --bare "$url"
    done
}

function clone_all_private_dreamlands_repos() {
  curl -H "Authorization: token ${DREAMLANDS_GIT_TOKEN}" https://git.barrucadu.dev/api/v1/orgs/private/repos 2>/dev/null | \
    jq -r '.[].ssh_url' | \
    while read url; do
      git clone --bare "$url"
    done
}

function clone_all_public_dreamlands_repos() {
  curl -H "Authorization: token ${DREAMLANDS_GIT_TOKEN}" https://git.barrucadu.dev/api/v1/users/barrucadu/repos 2>/dev/null | \
    jq -r '.[].ssh_url' | \
    while read url; do
      git clone --bare "$url"
    done
}

set -e

mkdir -p git/dreamlands/private
mkdir -p git/dreamlands/public
mkdir -p git/github.com

pushd git/dreamlands/private
clone_all_private_dreamlands_repos
popd

pushd git/dreamlands/public
clone_all_public_dreamlands_repos
popd

pushd git/github.com
clone_public_github_repos
popd
```

[syncthing]: https://syncthing.net/


Backup automation: systemd timers
---------------------------------

I run a full backup monthly, at midnight on the 1st.  I run an
incremental backup at 4am every Monday.  The difference in times is to
avoid overlap if the first of the month is a Monday (and I didn't want
to faff around with lock files).

The backups are taken by two systemd services which are defined in my
NixOS configuration:

```nix
#############################################################################
## Backups
#############################################################################

systemd.timers.backup-scripts-full = {
  wantedBy = [ "timers.target" ];
  timerConfig = {
    OnCalendar = config.services.backup-scripts.OnCalendarFull;
  };
};

systemd.timers.backup-scripts-incr = {
  wantedBy = [ "timers.target" ];
  timerConfig = {
    OnCalendar = config.services.backup-scripts.OnCalendarIncr;
  };
};

systemd.services.backup-scripts-full = {
  description = "Take a full backup";
  serviceConfig.WorkingDirectory = config.services.backup-scripts.WorkingDirectory;
  serviceConfig.ExecStart = "${pkgs.zsh}/bin/zsh --login -c './backup.sh full'";
  serviceConfig.User = config.services.backup-scripts.User;
  serviceConfig.Group = config.services.backup-scripts.Group;
};

systemd.services.backup-scripts-incr = {
  description = "Take an incremental backup";
  serviceConfig.WorkingDirectory = config.services.backup-scripts.WorkingDirectory;
  serviceConfig.ExecStart = "${pkgs.zsh}/bin/zsh --login -c './backup.sh incr'";
  serviceConfig.User = config.services.backup-scripts.User;
  serviceConfig.Group = config.services.backup-scripts.Group;
};
```

The working directory, user, group, and frequencies are all
configurable---but so far no host overrides them.  I thought about
having a separate backup user, but---as everything I want to back up
is owned by user anyway---decided that it didn't gain any security and
made everything more awkward.
