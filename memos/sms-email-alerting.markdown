---
title: SMS and Email Alerting for Hardware Failure
tags: aws, programming
date: 2018-07-14
audience: General
---

On nyarlathotep, my file server, I use ZFS with mirrored drives.  If
one drive fails, I have a reasonable chance of being able to power off
the machine, get a replacement drive, and swap out the dead one; all
before the remaining drive fails.  But I had no monitoring or
alerting, so I wouldn't actually know if a drive failed, rendering the
exercise somewhat pointless.  I decided to set that up using Amazon
SNS.

[Amazon Simple Notification Service (SNS)][SNS] lets you set up
"topics", subscribe to them through a variety of protocols (including
SMS and email), and send a message to a topic by hitting a web
endpoint.  This seemed the simplest way to get my computer to text me.

[SNS]: https://aws.amazon.com/sns/


Setting up SNS
--------------

You'll need an AWS account, and you'll also need to be okay with SNS
not being free.  Fortunately, unless you're going to be sending
hundreds of notifications, [it's pretty cheap][pricing].  Then you
need to create an SNS topic and add subscribers to it, which you can
do through the AWS web interface.

I set up the SNS topic and SMS notifications with [Terraform][], a
tool for provisioning infrastructure.  Here's a self-contained
Terraform config for an SNS topic with SMS notifications:

```
locals {
  "phone"      = "your phone number"
  "access_key" = "your aws access key"
  "secret_key" = "your aws secret key"
}

provider "aws" {
  access_key = "${locals.access_key}"
  secret_key = "${locals.secret_key}"
  region     = "eu-west-1"
}

resource "aws_sns_topic" "topic_name" {
  name = "topic-name"
}

resource "aws_sns_topic_subscription" "topic_name_sms" {
  topic_arn = "${aws_sns_topic.topic_name.arn}"
  protocol  = "sms"
  endpoint  = "${locals.phone}"
}
```

In [my actual Terraform configuration][awsfiles], the phone number and
keys are in a file which isn't checked into the repository.
Unfortunately Terraform can't set up email subscriptions, as they need
to be manually confirmed.  So I had to set that up via the AWS web
interface.

You can send test messages through the AWS web interface, so try that
to make sure everything is working.

[pricing]: https://aws.amazon.com/sns/pricing/
[Terraform]: https://www.terraform.io/
[awsfiles]: https://github.com/barrucadu/awsfiles


Sending messages from the command line
--------------------------------------

SNS exposes a web endpoint, so the "simplest" way to send a message to
your topic would be to `curl` that.  I decided to use the excellent
[boto3][] library for Python instead.

I quickly whipped together this script, which I store in
`~/bin/aws-sns`:

```python
#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.boto3

'''
A script to push a message from stdin to a SNS topic.
'''

import argparse
import boto3
import sys

arg_parser = argparse.ArgumentParser(description=__doc__)
arg_parser.add_argument(
    '-t', dest='topic', required=True, help='Topic ARN.')
arg_parser.add_argument(
    '-s', dest='subject', required=True, help='Subject for email.')
arg_parser.add_argument(
    '-R', dest='region', required=False, help='Region to use.', default='eu-west-1')
parsed_args = arg_parser.parse_args()

# boto3 checks for AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY env
# vars automatically.
client = boto3.client('sns', region_name=parsed_args.region)

# message body is stdin
message = sys.stdin.read()

response = client.publish(
    TopicArn=parsed_args.topic,
    Subject=parsed_args.subject,
    Message=message
)
print('Message ID: %s' % response['MessageId'])
```

This is a [nix-shell][nix] script, which fetches boto3 automatically
when invoked.  If you're not a nix user, you'd do the usual
virtualenv/source/pip dance.

You'll need to create a user in the AWS web interface with permissions
to poke SNS, and note down their access key and secret key.  With
those keys, and the ARN of your SNS topic, you should be able to send
a message from the command line:

```bash
$ export AWS_ACCESS_KEY_ID="foo"
$ export AWS_SECRET_ACCESS_KEY="bar"
$ echo "Hello, world" | aws-sns -t "baz" -s "Test Message"
```

[boto3]: https://boto3.readthedocs.io/en/latest/
[nix]: https://nixos.org/nix/


Monitoring for hardware failure
-------------------------------

Now we have the alerting, so we just need the monitoring.  Firstly we
need a script to check whatever condition we care about (zpool status
in my case), and to call the SNS script if it's not good.

Here's a self-contained zpool script:

```bash
#!/usr/bin/env bash

export AWS_ACCESS_KEY_ID="foo"
export AWS_SECRET_ACCESS_KEY="bar"

ZFS_TOPIC_ARN="baz"

if [[ "`zpool status -x`" != "all pools are healthy" ]]; then
  zpool status | aws-sns -t "$ZFS_TOPIC_ARN" -s "zfs zpool status"
fi
```

The final piece of the puzzle is a systemd timer (or cronjob, whatever
your system uses) to periodically run the script.  I have mine run
every 12 hours.  Here's the service definition from my [NixOS][]
config:

[NixOS]: https://nixos.org/

```nix
systemd.timers.monitoring-scripts = {
  wantedBy = [ "timers.target" ];
  timerConfig = {
    OnCalendar = "0/12:00:00";
  };
};

systemd.services.monitoring-scripts = {
  description = "Run monitoring scripts";
  serviceConfig.WorkingDirectory = "/home/barrucadu/monitoring-scripts";
  serviceConfig.ExecStart = "${pkgs.zsh}/bin/zsh --login -c ./monitor.sh";
  serviceConfig.User = "barrucadu";
  serviceConfig.Group = "users";
};
```

Which generates this systemd timer:

```ini
[Unit]

[Timer]
OnCalendar=0/12:00:00
```

And this unit (ignore the scary nix paths):

```ini
[Unit]
Description=Run monitoring scripts

[Service]
Environment="LOCALE_ARCHIVE=/nix/store/vg0s4sl74f5ik64wrrx0q9n6m48vvmgs-glibc-locales-2.26-131/lib/locale/locale-archive"
Environment="PATH=/nix/store/cb3slv3szhp46xkrczqw7mscy5mnk64l-coreutils-8.29/bin:/nix/store/364b5gkvgrm87bh1scxm5h8shp975n0r-findutils-4.6.0/bin:/nix/store/s63b2myh6rxfl4aqwi9yxd6rq66djk33-gnugrep-3.1/bin:/nix/store/navldm477k3ar6cy0zlw9rk43i459g69-gnused-4.4/bin:/nix/store/f9dbl8y4zjgr81hs3y3zf187rqv83apz-systemd-237/bin:/nix/store/cb3slv3szhp46xkrczqw7mscy5mnk64l-coreutils-8.29/sbin:/nix/store/364b5gkvgrm87bh1scxm5h8shp975n0r-findutils-4.6.0/sbin:/nix/store/s63b2myh6rxfl4aqwi9yxd6rq66djk33-gnugrep-3.1/sbin:/nix/store/navldm477k3ar6cy0zlw9rk43i459g69-gnused-4.4/sbin:/nix/store/f9dbl8y4zjgr81hs3y3zf187rqv83apz-systemd-237/sbin"
Environment="TZDIR=/nix/store/brib029xs79az5vhjd5nhixp1l39ni31-tzdata-2017c/share/zoneinfo"
ExecStart=/nix/store/77bsskn86yf6h11mx96xkxm9bqv42kqg-zsh-5.5.1/bin/zsh --login -c ./monitor.sh
Group=users
User=barrucadu
WorkingDirectory=/home/barrucadu/monitoring-scripts
```

The only thing left to do was to test the whole set-up by simulating a
hardware failure.

I powered off nyarlathotep, unplugged a drive, and booted it back up
again.  I then ran the monitoring script directly, to ensure that it
worked, and then waited until midnight (which was closer than noon, at
the time I was doing this) to check that the timer worked.

Both SMSes and emails came through:

![Email alerts from AWS SNS](/sms-email-alerting.png)
