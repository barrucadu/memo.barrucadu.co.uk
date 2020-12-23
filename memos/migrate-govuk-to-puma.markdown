---
title: Migrate GOV.UK to Puma
tags: gov.uk, programming
published: 2020-12-23
---

Mere hours after going on leave for the festive period, I've got back
in the mood to do complicated tech things for fun, and the topic which
came to mind is "how hard would it be to migrate GOV.UK from
[Unicorn][] (old and busted) to [Puma][] (new hotness)?"

Not only does Puma have a much prettier website, it's also the Rails
default web server (and has been for a while).  So the wider ecosystem
has decided it's a better server.  Furthermore, Puma potentially
solves an awkward problem we have with Unicorn: **memory usage**.

Unicorn runs multiple worker processes, which can each take up quite a
bit of RAM.  It adds up quickly if you have multiple apps running on
the same server.  If a process is IO bound rather than CPU bound, this
means scaling is more awkward, we either have to bring up new servers,
or embiggen our current ones.

Puma, on the other hand, runs multiple threads within each worker
process.  Threads can be very lightweight, sharing almost all of their
memory.  So we can pack far more threads on the same server, so long
as our application is not CPU bound.

I've done some thinking on how we could try out Puma on GOV.UK.  These
steps are untested, and are based on reading old puppet code and init
scripts at 2AM, so follow them at your peril.  But I think it would be
something like this.

[Unicorn]: https://yhbt.net/unicorn/
[Puma]: https://puma.io/


Configure the app
-----------------

The app needs a Puma config file.  Eventually we would want [something
shared in govuk_app_config][], but if we're trying this out with a
single app to start with, a config file in the app would do.

I think we'll want something like this:

```ruby
# frozen_string_literal: true

max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 1 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

port ENV.fetch("PORT") { 3000 }

environment ENV.fetch("RAILS_ENV") { "development" }

workers ENV.fetch("UNICORN_WORKER_PROCESSES") { 2 }

preload_app!
```

Puma concurrency is `threads * workers`.  We can run Puma in the same
way as we run Unicorn--configure the number of workers, but only give
each 1 thread---which will let us see the performance impact of Puma
by itself.  We can also set `workers` lower and `threads` higher to
start to get the memory savings.  There's probably some tweaking to be
done.

[something shared in govuk_app_config]: https://github.com/alphagov/govuk_app_config/blob/master/lib/govuk_app_config/govuk_unicorn.rb


Add Puma support to unicornherder
---------------------------------

Our [`unicornherder`][] tool is a common abstraction over Unicorn and
[Gunicorn][].  We can add Puma support to it too:

```python
COMMANDS = {
    'unicorn': 'unicorn -D -P "{pidfile}" {args}',
    'unicorn_rails': 'unicorn_rails -D {args}',
    'unicorn_bin': '{unicorn_bin} -D -P "{pidfile}" {args}',
    'gunicorn': 'gunicorn -D -p "{pidfile}" {args}',
    'gunicorn_django': 'gunicorn_django -D -p "{pidfile}" {args}',
    'gunicorn_bin': '{gunicorn_bin} -D -p "{pidfile}" {args}'
    'puma': 'pumactl start -P "{pidfile}" {args}'
}
```

There's also some logic around restarts, waiting for the old master
process to terminate its workers gracefully and then kill it.  I don't
think that will do anything useful under Puma, but I don't think it'll
cause any problems either.

**Note:** `unicornherder` sends a SIGUSR2 which, for Puma, will
perform something like what we call a "deploy with hard restart",
where the old processes get killed and new ones brought up.  However,
the [puma docs][] describe how things are handled gracefully:

- Any in-flight requests get handled before the server is shut down.
- Any requests which start just as the server restarts will experience
  some latency, but will not be dropped.

Since this is a full process restart, any new Ruby version will be
used, and any change to the Puma config will be applied.  This means
we will no longer need to do a separate hard restart for Puma apps
when upgrading Ruby!

Puma also offers a [phased restart][] approach, which restarts one
worker at a time, but that doesn't reload the Puma master process, and
so won't pick up a new Ruby version or new Puma config.  It's also
incompatible with the `preload_app!` option.

[`unicornherder`]: https://github.com/gds-operations/unicornherder
[Gunicorn]: https://gunicorn.org/
[puma docs]: https://github.com/puma/puma/blob/master/docs/restart.md#hot-restart
[phased restart]: https://github.com/puma/puma/blob/master/docs/restart.md#phased-restart


Add Puma support to govuk_spinup
--------------------------------

The confusing initialisation of a GOV.UK app begins in a sysvinit
script, ...

Which calls [`govuk_spinup`][], ...

Which calls `start-stop-daemon`, ...

Which calls `unicornherder`, ...

Which finally calls the app server.

I think the changes needed here are to `govuk_spinup`.  We'll need a
new app type, let's call it "puma":

```bash
  puma)
    status "Spawning rack app under puma"

    if [ ! -e '${GOVUK_APP_ROOT}/config/puma.rb' ]; then
      error "Missing Puma config file"
    fi

    CMD="bundle exec unicornherder -u puma -p '${GOVUK_APP_RUN}/app.pid' -- -C '${GOVUK_APP_ROOT}/config/puma.rb'"
    ;;
```

There's also a [`govuk_unicorn_reload`][] script, called during
deploys, but I don't think that needs to change.

[`govuk_spinup`]: https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/files/usr/local/bin/govuk_spinup
[`govuk_unicorn_reload`]: https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/files/usr/local/bin/govuk_unicorn_reload


Set up monitoring for Puma apps
-------------------------------

The [`govuk::app::config`][] class in [govuk-puppet][] defines a bunch
of Icinga alerts which'll need changing, or copying, for our new
"puma" app type to be as monitored as it should be.

This:

```puppet
  # Set up monitoring
  if $app_type in ['rack', 'bare', 'procfile'] {
    $default_collectd_process_regex = $app_type ? {
      'rack' => "unicorn (master|worker\\[[0-9]+\\]).* -P ${govuk_app_run}/app\\.pid",
      'bare' => inline_template('<%= Regexp.escape(@command) + "$" -%>'),
      'procfile' => "gunicorn .* ${govuk_app_run}/app\\.pid",
    }
```

And this:

```puppet
  if ($app_type == 'rack') or $monitor_unicornherder {
    @@icinga::check { "check_app_${title}_unicornherder_up_${::hostname}":
      ensure              => $ensure,
      check_command       => "check_nrpe!check_proc_running_with_arg!unicornherder /var/run/${title}/app.pid",
      service_description => "${title} app unicornherder not running",
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(unicorn-herder),
      contact_groups      => $additional_check_contact_groups,
    }
  }
```

And this:

```puppet
  if $app_type == 'rack' {
    include icinga::client::check_unicorn_ruby_version
    @@icinga::check { "check_app_${title}_unicorn_ruby_version_${::hostname}":
      ensure              => $ensure,
      check_command       => "check_nrpe!check_unicorn_ruby_version!${title}",
      service_description => "${title} is not running the expected ruby version",
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(ruby-version),
      contact_groups      => $additional_check_contact_groups,
    }
  }
```

[`govuk::app::config`]: https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/manifests/app/config.pp
[govuk-puppet]: https://github.com/alphagov/govuk-puppet


Change the app to a Puma app
----------------------------

Now that we've got our new app type, we need to stick `app_type =>
'puma'` in the relevant call to `govuk::app` elsewhere in
govuk-puppet.

And that's it!


Finally, deploy the change
--------------------------

Since we're using proper init scripts with pidfile management, I
*think* that deploying Puppet will be a graceful change:

1. Puppet will trigger a restart of the app due to the change to its
   config and `govuk_spinup`.
2. The init script will read the existing pidfile and stop the old
   Unicorn process in the usual SIGINT / SIGKILL way.
3. The init script will start the app up with Puma via the modified
   `govuk_spinup` / `unicornherder`.

If not, I think the steps to deploy will be:

1. Pause Puppet on the affected (perhaps afflicted?) machines
2. Deploy Puppet
3. For each machine:
   1. Manually stop the app
   2. Unpause and run Puppet
