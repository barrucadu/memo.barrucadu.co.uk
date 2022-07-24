---
title: Backups
taxon: techdocs-practices
tags: aws
date: 2022-07-24
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

1. Creates a temporary directory for the backup to be generated in
2. Runs a collection of host-specific scripts (defined in my NixOS
   configuration)
4. Uses duplicity to generate a full or incremental backup, targetting
   the S3 bucket

It looks like this:

```nix
let
  runScript = cmd: name: source: ''
    echo "${name}"
    mkdir "${name}"
    pushd "${name}"
    if ! time ${cmd} "${pkgs.writeText "${name}.backup-script" source}"; then
      fail "Backup failed in ${name}"
    fi
    popd
  '';

  script = pkgs.writeShellScript "backup.sh" ''
    set -e

    function fail(){
      export AWS_ACCESS_KEY_ID=$ALERT_AWS_ACCESS_KEY_ID
      export AWS_SECRET_ACCESS_KEY=$ALERT_AWS_SECRET_ACCESS_KEY
      echo "Backup failed: $1"
      aws sns publish --topic-arn "$TOPIC_ARN" --subject "Alert: ${hostname}" --message "$1"
      exit 1
    }

    BACKUP_TYPE=$1
    if [[ -z "$BACKUP_TYPE" ]]; then
      echo 'specify a backup type!'
      exit 1
    fi

    DIR=`mktemp -d`
    trap "rm -rf $DIR" EXIT
    cd $DIR

    mkdir "${hostname}"
    pushd "${hostname}"

    ${concatStringsSep "\n" (mapAttrsToList (runScript "bash -e -o pipefail") cfg.scripts)}
    ${concatStringsSep "\n" (mapAttrsToList (runScript "python3") cfg.pythonScripts)}

    popd

    export AWS_ACCESS_KEY_ID=$DUPLICITY_AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY=$DUPLICITY_AWS_SECRET_ACCESS_KEY
    if ! time duplicity --s3-european-buckets --s3-use-multiprocessing --s3-use-new-style --verbosity notice "$BACKUP_TYPE" "${hostname}" "boto3+s3://barrucadu-backups/${hostname}"; then
      fail "Backup upload failed"
    fi
  '';

  # ...
```

Duplicity's incremental backups are based on hashing chunks of files,
so it can take incremental backups even though all the file
modification times will have changed (because the backup is generated
anew every time) since the last full backup.

### Alerting

The main backup script sends me an email and a text message using [Amazon SNS][] on failure.

[Amazon SNS]: https://aws.amazon.com/sns/

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


Backup automation: systemd timers
---------------------------------

I run a full backup monthly, at midnight on the 1st.  I run an
incremental backup at 4am every Monday.  The difference in times is to
avoid overlap if the first of the month is a Monday (and I didn't want
to faff around with lock files).

The backups are taken by two systemd services which are defined in my
NixOS configuration:

```nix
systemd.timers.backup-scripts-full = {
  wantedBy = [ "timers.target" ];
  timerConfig.OnCalendar = cfg.onCalendarFull;
};

systemd.timers.backup-scripts-incr = {
  wantedBy = [ "timers.target" ];
  timerConfig.OnCalendar = cfg.onCalendarIncr;
};

systemd.services.backup-scripts-full = {
  description = "Take a full backup";
  path = servicePath;
  environment.PYTHONPATH = servicePythonPath;
  serviceConfig = serviceConfig "full";
};

systemd.services.backup-scripts-incr = {
  description = "Take an incremental backup";
  path = servicePath;
  environment.PYTHONPATH = servicePythonPath;
  serviceConfig = serviceConfig "incr";
};
```

The units run as my user.  I thought about having a separate backup
user, but---as everything I want to back up is owned by my user
anyway---decided that it didn't gain any security and made everything
more awkward.
