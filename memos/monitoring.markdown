---
title: Monitoring
taxon: techdocs-practices
tags: aws
date: 2021-03-16
---

I have basic monitoring for my servers, checking for availability and
hardware failure.  A monitoring failure sends me a text message and an
email.

[AWS SNS]: https://aws.amazon.com/sns/


Sending notifications: Amazon SNS
---------------------------------

I use [Amazon SNS][] for sending messages.  It's not free, but for my
usage it is [pretty cheap][].  I use [terraform][] to provision all my
AWS stuff, including this notification topic and my phone's
subscription to it:

```terraform
variable "phone" {}

resource "aws_sns_topic" "notifications" {
  name = "host-notifications"
}

resource "aws_sns_topic_subscription" "sms" {
  topic_arn = aws_sns_topic.notifications.arn
  protocol  = "sms"
  endpoint  = var.phone
}
```

Unfortunately Terraform can't set up email subscriptions, so I had to
set that up via the AWS web console.

There's also an IAM policy granting publish access to the topic:

```terraform
data "aws_iam_policy_document" "notifications" {
  statement {
    actions = [
      "sns:Publish",
    ]

    resources = [
      aws_sns_topic.notifications.arn,
    ]
  }
}
```

Currently the AWS access keys are stored in plaintext on every host
which can send me notifications, which isn't ideal.  I can't even
restrict usage of the keys by IP address, as my home server can send
notifications, and my residential IP is dynamic.  I'd like a better
solution for this, but I'm not sure what that is yet.

[Amazon SNS]: https://aws.amazon.com/sns/
[pretty cheap]: https://aws.amazon.com/sns/pricing/
[terraform]: https://www.terraform.io/


Monitoring script
-----------------

I have a generic monitoring script which:

1. Checks for a host-specific monitoring script (not all hosts do
   monitoring)
2. Runs it, capturing the output to a file
3. Sends an alert if it exits with a nonzero status

It looks like this:

```bash
#!/bin/sh

MONITORING_SCRIPT_DIR="$HOME/monitoring-scripts"

# hostname
MY_HOST=`hostname`

if [[ -x "$MONITORING_SCRIPT_DIR/host-scripts/$MY_HOST" ]]; then
  outfile=`mktemp`
  time $MONITORING_SCRIPT_DIR/host-scripts/$MY_HOST > $outfile
  if [[ $? != 0 ]] || [[ "$1" == "test" ]]; then
    if [[ "$1" == "test" ]]; then
        echo "Alert triggered by test run" >> $outfile
    fi
    send-host-alert "file://${outfile}"
  fi
  rm $outfile
else
  echo 'nothing to do!'
fi
```

The `send-host-alert` script is a wrapper around the AWS CLI:

```bash
#! /usr/bin/env nix-shell
#! nix-shell -i bash -p awscli

# aws config
AWS_PROFILE="monitoring"
AWS_TOPIC_ARN="arn:aws:sns:eu-west-1:197544591260:host-notifications"

aws sns publish \
  --profile "${AWS_PROFILE}" \
  --topic-arn "${AWS_TOPIC_ARN}" \
  --subject "Alert: $(hostname)" \
  --message "$1"
```

### Host-specific scripts

These aren't terribly interesting, or useful to anyone other than me,
so I'll just give an example rather than going through each one.

On nyarlathotep, my file server, I use ZFS with mirrored drives. If
one drive fails, I have a reasonable chance of being able to power off
the machine, get a replacement drive, and swap out the dead one; all
before the remaining drive fails.  So the script for nyarlathotep
checks that the ZFS pool is healthy.

It looks like this:

```bash
#!/usr/bin/env bash

if [[ "`zpool status -x`" != "all pools are healthy" ]]; then
  zpool status
  exit 1
fi
```


Monitoring automation: systemd timers
-------------------------------------

The script runs hourly, triggered by a systemd timer which is defined
in my NixOS configuration:

```nix
#############################################################################
## Monitoring
#############################################################################

systemd.timers.monitoring-scripts = {
  wantedBy = [ "timers.target" ];
  timerConfig = {
    OnCalendar = config.services.monitoring-scripts.OnCalendar;
  };
};

systemd.services.monitoring-scripts = {
  description = "Run monitoring scripts";
  serviceConfig.WorkingDirectory = config.services.monitoring-scripts.WorkingDirectory;
  serviceConfig.ExecStart = "${pkgs.zsh}/bin/zsh --login -c ./monitor.sh";
  serviceConfig.User = config.services.monitoring-scripts.User;
  serviceConfig.Group = config.services.monitoring-scripts.Group;
};
```

The working directory, user, group, and frequencies are all
configurable.  nyarlathotep overrides the frequency, to only run every
12 hours.  This is because if I'm at work and one of my hard drives at
home fails I don't want to get a text message every hour which I can't
do anything about.
