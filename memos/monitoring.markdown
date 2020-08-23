---
title: Monitoring
taxon: techdocs-practices
tags: aws
date: 2020-08-23 02:00:00
---

I have basic monitoring for my servers, checking for availability and
hardware failure.  A monitoring failure sends me a text message and an
email through [AWS SNS][].

[AWS SNS]: https://aws.amazon.com/sns/

Setting up SNS
--------------

You'll need an AWS account, and you'll also need to be okay with SNS
not being free.  Fortunately, unless you're going to be sending
hundreds of notifications, [it's pretty cheap][].

I set up the SNS topic and SMS subscription with [Terraform][], a tool
for provisioning infrastructure:

```terraform
variable "phone" {}

resource "aws_sns_topic" "host-notifications" {
  provider = "aws"
  name     = "host-notifications"
}

resource "aws_sns_topic_subscription" "host-notifications-sms" {
  provider  = "aws"
  topic_arn = aws_sns_topic.host-notifications.arn
  protocol  = "sms"
  endpoint  = var.phone
}
```

Unfortunately Terraform can't set up email subscriptions, so I had to
set that up via the AWS web console.

There's also an IAM policy granting access to the topic:

```terraform
resource "aws_iam_policy" "host-notifications" {
  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": "${aws_sns_topic.host-notifications.arn}",
      "Action": [
        "sns:Publish"
      ]
    }
  ]
}
EOF
}
```

[it's pretty cheap]: https://aws.amazon.com/sns/pricing/
[Terraform]: https://www.terraform.io/


Monitoring scripts
------------------

I have a generic monitoring script which:

1. Checks for a host-specific monitoring script
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


Monitoring automation
---------------------

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
