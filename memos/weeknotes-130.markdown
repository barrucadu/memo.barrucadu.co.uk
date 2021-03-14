---
title: "Weeknotes: 130"
taxon: weeknotes-2021
date: 2021-03-14
---

## Work

I spent most of this week migrating code into a [new microservice][],
and refactoring code in the [Transition Checker][].  I think I've
added more code than I've deleted (alas), but most of the complexity
is in the new microservice now, and more parts of GOV.UK will be able
to implement account-based functionality.  Or "personalisation", as
the buzzword is.

I did a lot of the coding this week which, while enjoyable, is also
not very good delegation or future-proofing.  If I have the best
knowledge of everything (because I implemented all of the core, and
others only reviewed it or implemented smaller pieces), then the
team's bus factor is dangerously low.  Also it's less fun for everyone
else to spend all their time reviewing code and not writing any.

So I'll try to hold off a bit next week and do more reviewing and
helping, than direct implementation.

[new microservice]: https://github.com/alphagov/account-api
[Transition Checker]: https://www.gov.uk/transition-check/questions


## Books

This week I read:

- Volume 2 of [The Book of the New Sun][] by Gene Wolfe.

  In which Severian *finally* makes it to Thrax and takes up his post
  as the Lictor (the Roman term refers to a kind of bodyguard, but in
  this case he seems to be the head of the prison system, as well as
  its executioner).  Then leaves, goes on further adventures, meets
  the Autarch again, and <span class="spoiler">becomes the
  Autarch</span>.

  This was good, though I think I should have read it closer to the
  first volume.  There were a few times where a previous event was
  referenced and I had to look it up.  I think I'll have to get [The
  Urth of the New Sun][] as well.

[The Book of the New Sun]: https://en.wikipedia.org/wiki/The_Book_of_the_New_Sun
[The Urth of the New Sun]: https://en.wikipedia.org/wiki/The_Urth_of_the_New_Sun


## Concourse and Secrets Management

I set up secrets management for my [Concourse][] instance, which
turned out to be *incredibly* easy, and not really worth putting off
for over a year, as I had done.

I decided to use the [AWS SSM credential manager][], which only
required me to set up a new AWS IAM user and give it a small set of
permissions.  I did consider the [Vault credential manager][], but
when the Vault server starts up it requires a human operator to enter
the master decryption key.  That's not so great for me, as I have
automatic updates and reboots enabled on the server which would run
it.  It *can* store the master key in AWS Secrets Manager, but I
thought that if I'm going to have to use AWS anyway I may as well skip
Vault entirely.

I hit a weird problem with the Concourse IAM policy.  Normally, you
can omit the AWS region and account ID when specifying which resources
it applies to, but that didn't work.  I just got a permission denied
error when I tried to get or put any secrets.  So I ended up
specifying them in [the policy][]:

```terraform
    resources = [
      # "arn:aws:ssm:::parameter/..." doesn't seem to work in this
      # policy, but specifying the account ID explicitly does.
      "arn:aws:ssm:eu-west-2:${var.aws_account_id}:parameter/concourse",
      "arn:aws:ssm:eu-west-2:${var.aws_account_id}:parameter/concourse/*",
    ]
```

But it's all working now.  Maybe AWS SSM Parameter Store policies are
just picky.

And I've been able to migrate away from interpolating YAML variables
into using proper secrets, which means I got to delete a text file
full of credentials.  It also allows me to define my Concourse
pipelines in the repos which they refer to (rather than having one
repo with the pipeline templates + a script to interpolate the
variables).

This, along with setting up a new IAM user and policy, has triggered
some thinking about how I manage my cloud stuff (it's all more complex
than it needs to be), so I think I'll do some wider refactoring in the
near future too.

[Concourse]: https://concourse-ci.org/
[AWS SSM credential manager]: https://concourse-ci.org/aws-ssm-credential-manager.html
[Vault credential manager]: https://concourse-ci.org/vault-credential-manager.html
[the policy]: https://github.com/barrucadu/awsfiles/blob/master/terraform/projects/concourse/main.tf


## Link Roundup

### Programming

- [Using the viewport meta tag to control layout on mobile browsers](https://developer.mozilla.org/en-US/docs/Web/HTML/Viewport_meta_tag)
- [Ruby 2.7 adds Enumerable#filter_map](https://blog.saeloun.com/2019/05/25/ruby-2-7-enumerable-filter-map.html)

### Roleplaying Games

- [Basic Depthcrawl Procedure](https://technoskald.me/2020/08/30/basic-depthcrawl-procedure/)
- [Festivities as a social depth-crawl](https://seedofworlds.blogspot.com/2021/02/festivities-as-social-depth-crawl.html)
- [Game Structure: Party Planning](https://thealexandrian.net/wordpress/37995/roleplaying-games/game-structure-party-planning)
- [Level up your descriptions with this one simple trick](http://spriggans-den.com/2021/02/27/level-up-your-descriptions-with-this-one-simple-trick/)
