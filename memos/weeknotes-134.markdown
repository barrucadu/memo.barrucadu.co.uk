---
title: "Weeknotes: 134"
taxon: weeknotes-2021
date: 2021-04-11
---

## Work

Another short week, with the bank holiday Monday.

This week I improved some documentation, set up continuous deployment
for another of our apps, tidied up a bit of old code, and opened
another RFC; this time on improving our app healthchecks.


## Books

I didn't finish any books this week.  I've been reading the Google SRE
books and re-reading [Helliconia][].

[Helliconia]: https://en.wikipedia.org/wiki/Helliconia


## Next Programming Project?

I've been trying to think of a big meaty project I can start.
Something to get stuck into, which will stretch what I can comfortably
do.  And I think I might have found the right idea.

My own mini-kubernetes.  Or at least, the scheduling and monitoring
part of it.  Here's the somewhat-fuzzy thinking so far:

### Job & Pods

The right level of scheduling is a "job".  A job defines:

- a collection of containers (a "pod") which run on the same host and
  are bound to the same network interface
- a required number of instances of the pod
- a globally-unique name, for DNS

And a container defines:

- standard container information: image, restart policy, command,
  environment, ports, and dependencies
- a required amount of RAM
- a healthcheck
- any required volumes, which can be shared or non-shared

A full definition might look like this:

```yaml
name: "simple-webapp"
numInstances: 3
containers:
  app:
    # normal container configuration, similar to docker-compose.
    image: web-app-image
    restart: always
    command: ["bin/rails", "s", "--restart"]
    environment:
      - name: DATABASE_URL
        value: postgresql://webapp:webapp@localhost/webapp
    ports:
      - "80:3000"
    depends_on:
      - db

    # have a hard memory limit of 2G, after which allocations will fail
    memory: 2G

    # call /healthcheck every 60s, timing out after 30s, and require two
    # consecutive 200 status codes to switch to "healthy" state, and two
    # consecutive non-200 status codes to switch to "unhealthy" state.
    healthcheck:
      type: http
      port: 3000
      path: /healthcheck
      timeout: 30
      interval: 60
      healthy_threshold: 2
      unhealthy_threshold: 2

    # mount a 1G shared volume at /data/shared, all instances get the same
    # shared volume and see each other's writes; mount a 100M non-shared
    # volume at /data/scratch, which will be lost if the instance or host
    # machine is terminated.
    volumes:
      - type: shared
        path: /data/shared
        space: 1G
      - type: local
        path: /data/scratch
        space: 100M

  db:
    image: postgres:13
    restart: always
    memory: 4G
    environment:
      - name: POSTGRES_USER
        value: webapp
      - name: POSTGRES_PASSWORD
        value: webapp
      - name: POSTGRES_DB
        value: webapp
    volumes:
      - type: local
        path: /var/lib/postgresql/data
        space: 10G
```

This is more-or-less a docker-compose file.  Ideally the syntax of
this is very close to what people know already.

### The Scheduler

Each member of the cluster is running a scheduler process.  This is a
Haskell application I would write.  I'm thinking calling it
[Ozymandias][].

The schedulers store all their state in, and communicate
through, [etcd][]: a distributed, strongly consistent, key-value
store.

[Ozymandias]: https://en.wikipedia.org/wiki/Ozymandias

#### When a user submits a new job

The scheduler checks if the job is feasible by trying to bin-pack the
desired number of instances to the nodes in the cluster.  It does this
based on the memory and disk space constraints.

If there's not enough free memory or disk space in the cluster, the
scheduler rejects the job by returning a [problem details object][]:

```json
{
  "type": "https://github.com/barrucadu/ozymandias/main/docs/errors.markdown#insufficient-memory",
  "title": "Insufficient memory for job",
  "detail": "Job requires 12G of memory but only 10G can be allocated.",
  "job": "my-cool-job"
}
```

If the scheduler did manage to compute an allocation of instances to
nodes, it atomically commits the new job and the schedule to [etcd][],
and returns an OK response to the user.

#### When a user scales a job up

Much the same as when a job is created, the scheduler tries to compute
an allocation for the new instances, either committing the updated job
and new schedule, or returning an error.

#### When a user scales a job down

The scheduler picks instances to terminate, and commits a new schedule
with those instances gone.

#### When a scheduler notices it has been allocated more instances

It starts them up, using [podman][] as the container runtime.  Pods
are started on a [flannel][]-managed network, meaning that any pod can
talk to any other pod in the cluster, regardless of which host it's
running on.

#### When a scheduler notices it has been allocated fewer instances

It terminates any unnecessary instances and cleans up any local
storage they've been using.

#### When a scheduler notices an instance is healthy

A record is added to the [coredns][] state in [etcd][], so that other
pods can find it by name.

#### When a scheduler notices an instance is unhealthy

Its DNS record is removed from the [coredns][] state, and it gets
restarted in line with its restart policy.

[etcd]: https://etcd.io/
[problem details object]: https://tools.ietf.org/html/rfc7807
[podman]: https://podman.io/
[flannel]: https://github.com/flannel-io/flannel/
[coredns]: https://coredns.io/

### Fault Tolerance

A scheduler stores all of its state using an [etcd lease][], so that
if a scheduler crashes and doesn't come back online, its state expires
and the rest of the cluster knows that any instances running on it
need to be re-allocated.

When the scheduler starts up, it checks if there is already a lease
for that node (this will be the case if the scheduler crashed and
restarted before the lease expired):

- If there is, the scheduler refreshes the lease, and sets about
  bringing its local state to be consistent with the state in
  [etcd][], starting or stopping containers as needed.

- If there isn't, the scheduler terminates any running containers,
  requests a new lease, and adds itself to a list of running
  schedulers.

If one scheduler notices that another has gone offline, it computes an
allocation of job instances to the remaining nodes and atomically
commits that.  The new instances then start up as normal.  If there
aren't enough cluster resources to bring up all the instances, as many
are brought up as can be.

As the new schedule is committed atomically, and only if the current
schedule hasn't been updated, there is no need for a master scheduler
to handle fault tolerance.  Each scheduler can race to reallocate the
missing instances, and the first to compute a schedule will win.

If there is a network partition in the [etcd][] cluster, then some
schedulers will be unable to refresh their leases or see state
changes:

- If the partition lasts long enough for scheduler leases to expire,
  then the affected schedulers will crash, be restarted by the init
  system of the host OS, and hang waiting for [etcd][] to become
  available.

- If the partition is over before any leases expire, then the cluster
  continues as normal.

[etcd lease]: https://etcd.io/docs/v3.4/learning/api/#lease-api

### Ingress

Each node will run an HTTP ingress process.  When that receives a
request, it checks the `Host` header, and proxies the request to the
appropriate job.

I've not really thought about non-HTTP ingress yet, but I suspect I'd
have to do something like run one ingress process per port, which
proxy connections based on the port rather than by a header.  I'd like
to make ingress work globally, so you don't need to know which node a
process is running on.

### Next steps?

Just implementing the scheduler and ingress process would be a big
task, but there are always future improvements:

- I could integrate [Envoy][], a proxy, with the pod definitions.  It
  would be great if attaching an Envoy sidecar to a container was only
  a couple of lines of config.  This would bring with it features like
  load balancing, retries, and readiness healthchecks (in addition to
  liveness healthchecks).

- I could implement rolling deploys.  I've not thought yet about how
  to handle job changes beyond scaling, but will probably start with
  something simple like killing all the old instances and starting new
  ones.  Rolling deploys would be a great addition.

- I could implement instance reallocation, so that if a new node comes
  online it'll take on some jobs from other nodes.  I plan to use node
  busyness (probably in the form of load averages) as a metric when
  scheduling, but being able to move instances after they've started
  would be a nice addition.

- I could implement something like [Kubernetes DaemonSets][], as a way
  to define processes which need to run on every node.  This would be
  a great alternative to having to manually start up [flannel][],
  [coredns][], the ingress process, and anything else you need (like a
  logging or monitoring agent).  The closer the cluster can get to
  automatic bootstrapping, the better.

- I could implement an integration with [HashiCorp Vault][], so that
  containers can be assigned a Vault role when they start, granting
  selective access to secrets, or so that secrets can be pulled from
  Vault and injected into container environment variables.

[Envoy]: https://www.envoyproxy.io/
[Kubernetes DaemonSets]: https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
[HashiCorp Vault]: https://www.vaultproject.io/

## Link Roundup

### Software Engineering

- [RFC 7807: Problem Details for HTTP APIs](https://tools.ietf.org/html/rfc7807)
- [The Architecture Behind A One-Person Tech Startup](https://anthonynsimon.com/blog/one-man-saas-architecture/)
- [Breaking GitHub Private Pages for $35k](https://robertchen.cc/blog/2021/04/03/github-pages-xss)
- [Legalizing Gay Marriage in Crusader Kings III with Ghidra](https://waffleironer.medium.com/legalizing-gay-marriage-in-crusader-kings-iii-with-ghidra-2602e6aa8689)
- [Managing technical quality in a codebase.](https://lethain.com/managing-technical-quality/)

### Roleplaying Games

- [Running the Game: Railroading, Agency, and Choice](https://www.youtube.com/watch?v=KqIZytzzFKU)

### Miscellaneous

- [Get your work recognized: write a brag document](https://jvns.ca/blog/brag-documents/)
