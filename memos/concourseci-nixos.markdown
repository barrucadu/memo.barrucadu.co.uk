---
title: Concourse CI on NixOS
taxon: techdocs-practices
date: 2019-04-07
---

![The Concourse dashboard](concourseci-on-nixos/dashboard.png)

I recently switched from the venerable [Jenkins][] to [Concourse
CI][].  The main reason is that I'm going to be working on a Concourse
thing at work, so it seemed a good idea to get familiar with the
basics.  Concourse also solves a problem with my Jenkins set-up I've
been meaning to address for a while: my Jenkins configuration was all
done by hand and only partially version controlled, whereas Concourse
*only* supports configuration through files and environment variables.

Concourse was *far* more of a pain to set up than Jenkins, so this
memo documents how it works and gives some example CI pipelines.

[Jenkins]: https://jenkins.io/
[Concourse CI]: https://concourse-ci.org/


Containerising my CI (part 1)
-----------------------------

Concourse is strongly opinionated about what you should be able to do,
and in particular likes jobs to be as close to pure functions as
reasonably possible.  One way it does that is by running every job
inside a container.

Now, I already kind of had that benefit with my NixOS Jenkins set-up,
as the NixOS module lets you specify what packages are available in
the `$PATH` of the Jenkins workers.  But for Concourse I had to make a
container image for that.

I opted for [Docker][] because I know almost nothing about containers
and it seems a popular choice.

[Docker]: https://www.docker.com/

After a bit of fiddling around, I came up with this Dockerfile, which
defines the environment I'll use for CI builds:

```
FROM nixos/nix:2.2.1

RUN \
  nix-channel --add https://nixos.org/channels/nixos-18.09 nixpkgs && \
  nix-channel --update && \
  nix-env -iA nixpkgs.openssh \
              nixpkgs.rsync \
              nixpkgs.stack \
              nixpkgs.texlive.combined.scheme-full

ENV \
  LANG=en_GB.UTF-8 \
  LC_ALL=en_GB.UTF-8 \
  LC_CTYPE=en_GB.UTF-8
```

This is an [Alpine][]-based container (a *lot* of containers seem to
use Alpine) which provides [Nix][] version 2.2.1, where I'm pulling in
the latest version of nixpkgs 18.09[^nixpkgs] and installing some
packages and changing the default locale to a UTF-8 one.  The list of
packages closely mirrors what I had made available to the Jenkins
workers.

[^nixpkgs]: I could have instead picked a commit hash of nixpkgs to
    pull in, giving a totally reproducible container, but didn't feel
    like it at the time.

[Alpine]: https://alpinelinux.org/
[Nix]: https://nixos.org/nix/

Next I needed to build this image, and make it available for other CI
jobs.  I set up a private Docker registry on the hostname
`ci-registry` (more on that in the next section), and manually built
and pushed the image like so:

```bash
REPO="ci-registry:5000"
TAG="$(date +'%s')"

docker build -f Dockerfile.ci-agent -t "$REPO/ci-agent:$TAG" .
docker tag "$REPO/ci-agent:$TAG" "$REPO/ci-agent:latest"
docker push "$REPO/ci-agent:$TAG"
docker push "$REPO/ci-agent:latest"
```

Because the meaning of "nixpkgs 18.09" will change over time, I'm
tagging the docker image with the current time.


Running Concourse on NixOS
--------------------------

There is no NixOS package for Concourse[^package], but the
documentation does give a docker-compose file.  I decided to go the
easy route and use systemd to run a collection of containers through
docker-compose.

[^package]: There's a PR adding one, but it's been open for months and
    the author hasn't addressed any of the reviews despite continuing
    to push new commits to their fork, so I'm not hopeful it's going
    to be merged any time soon.

I followed a pattern I've used [elsewhere in my nixfiles][]
repository, making a new `.nix` file which enables and configures the
service when included in the machine configuration:

[elsewhere in my nixfiles]: https://github.com/barrucadu/nixfiles/tree/master/services

```nix
{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.concourseci;
```

Most of the configuration goes into this docker-compose file:

```nix
  dockerComposeFile = pkgs.writeText "docker-compose.yml" ''
    version: '3'

    services:
      concourse:
        image: concourse/concourse
        command: quickstart
        privileged: true
        depends_on: [postgres, registry]
        ports: ["${toString cfg.port}:8080"]
        environment:
          CONCOURSE_POSTGRES_HOST: postgres
          CONCOURSE_POSTGRES_USER: concourse
          CONCOURSE_POSTGRES_PASSWORD: concourse
          CONCOURSE_POSTGRES_DATABASE: concourse
          CONCOURSE_EXTERNAL_URL: "${if cfg.useSSL then "https" else "http"}://${cfg.virtualhost}"
          CONCOURSE_MAIN_TEAM_GITHUB_USER: "${cfg.githubUser}"
          CONCOURSE_GITHUB_CLIENT_ID: "${cfg.githubClientId}"
          CONCOURSE_GITHUB_CLIENT_SECRET: "${cfg.githubClientSecret}"
        networks:
          - ci

      postgres:
        image: postgres
        environment:
          POSTGRES_DB: concourse
          POSTGRES_PASSWORD: concourse
          POSTGRES_USER: concourse
          PGDATA: /database
        networks:
          - ci
        volumes:
          - pgdata:/database

      registry:
        image: registry
        networks:
          ci:
            ipv4_address: "${cfg.registryIP}"
            aliases: [ci-registry]

    networks:
      ci:
        ipam:
          driver: default
          config:
            - subnet: ${cfg.subnet}

    volumes:
      pgdata:
  '';
```

I'm using docker-compose to run Concourse itself, the postgres
database it needs, and also a Docker registry (this is where images
will be pushed to and pulled from).  I'm using a hard-coded subnet and
a static IP for the registry so that I can access it from the host by
adding an entry to `/etc/hosts`.  The reason I'm not just running the
registry on the host is so that I don't need to mess around with
firewall rules to allow access from the Docker subnet.

Next we define all the options, and their defaults:

```nix
in
{
  options.services.concourseci = {
    port = mkOption { type = types.int; default = 3001; };
    useSSL = mkOption { type = types.bool; default = true; };
    forceSSL = mkOption { type = types.bool; default = true; };
    virtualhost = mkOption { type = types.str; };
    githubUser = mkOption { type = types.str; default = "barrucadu"; };
    githubClientId =  mkOption { type = types.str; };
    githubClientSecret =  mkOption { type = types.str; };
    sshPublicKeys = mkOption { type = types.listOf types.str; };
    subnet = mkOption { type = types.str; default = "172.21.0.0/16"; };
    registryIP = mkOption { type = types.str; default = "172.21.0.254"; };
  };
```

The `githubClientId` and `githubClientSecret` options are used to
configure GitHub OAuth, and the `githubUser` defines who the
super-user is.

Now we can define the system configuration.  First, the docker
registry and an entry for `/etc/hosts`:

```nix
  config = {
    networking.hosts."${cfg.registryIP}" = [ "ci-registry" ];
    virtualisation.docker.extraOptions = "--insecure-registry=ci-registry:5000";
```

The systemd unit:

```nix
    systemd.services.concourseci = {
      enable   = true;
      wantedBy = [ "multi-user.target" ];
      requires = [ "docker.service" ];
      serviceConfig = {
        ExecStart = "${pkgs.docker_compose}/bin/docker-compose -f '${dockerComposeFile}' up";
        ExecStop  = "${pkgs.docker_compose}/bin/docker-compose -f '${dockerComposeFile}' down";
        Restart   = "always";
        User      = "concourseci";
        WorkingDirectory = "/srv/concourseci";
      };
    };
```

The nginx virtualhost:

```nix
    services.nginx.virtualHosts."${cfg.virtualhost}" = {
      enableACME = cfg.useSSL;
      forceSSL = cfg.useSSL && cfg.forceSSL;
      locations."/" = {
        proxyPass = "http://localhost:${toString cfg.port}/";
        proxyWebsockets = true;
      };
    };
```

And a user with SSH access and a shell:

```nix
    users.extraUsers.concourseci = {
      home = "/srv/concourseci";
      createHome = true;
      isSystemUser = true;
      extraGroups = [ "docker" ];
      openssh.authorizedKeys.keys = cfg.sshPublicKeys;
      shell = pkgs.bashInteractive;
    };
  };
}
```

The concourse user needs SSH access because I want to be able to
deploy my websites after building, and there's no way to directly talk
to the host from the container.

The host needs to have Docker enabled, but I've got that in my [common
configuration][] rather than in the above file:

[common configuration]: https://github.com/barrucadu/nixfiles/blob/master/common.nix

```nix
virtualisation.docker.enable = true;
virtualisation.docker.autoPrune.enable = true;
```

Finally I include this in my [system configuration][]:

[system configuration]: https://github.com/barrucadu/nixfiles/blob/master/hosts/dunwich/configuration.nix

```nix
  imports = [
    # ...
    ../services/concourseci.nix
    # ...
  ];

  # ...

  services.concourseci = {
    githubClientId = import /etc/nixos/secrets/concourse-github-client-id.nix;
    githubClientSecret = import /etc/nixos/secrets/concourse-github-client-secret.nix;
    virtualhost = "ci.dunwich.barrucadu.co.uk";
    sshPublicKeys =
      [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4Ns3Qlja6/CsRb7w9SghjDniKiA6ohv7JRg274cRBc concourseci+worker@ci.dunwich.barrucadu.co.uk" ];
  };
```


Containerising my CI (part 2)
-----------------------------

It feels a bit unsatisfying to have a CI tool which is entirely
configured by environment variables, configuration files... and a
hand-built special Docker image.  So I came up with [a Concourse
pipeline][ci-agent] to build and push the image.  There are a few
steps, so let's go through them one at a time.

[ci-agent]: https://github.com/barrucadu/concoursefiles/blob/master/pipelines/ci-agent.yml

Firstly, we say what *resources* the pipeline depends on.  Concourse
jobs are stateless, and can only communicate through defined
resources.  Inside a job you can define inputs and outputs used to
communicate between stages of the job.  The Dockerfile is in my
[concoursefiles][] git repository, so:

[concoursefiles]: https://github.com/barrucadu/concoursefiles

```yaml
resources:
- name: concoursefiles-git
  type: git
  source:
    branch: master
    uri: https://github.com/barrucadu/concoursefiles.git
```

Next we define a list of jobs.  In this pipeline there will only be
one job, which pulls the git repository, builds the docker image, and
pushes it to my repository.  A job consists of a `plan`, which is a
list of steps:

**First step:** get the git repository:

```
jobs:
- name: ci-agent
  serial: true
  plan:
    - get: concoursefiles-git
```

**Next step:** build and push the image.  This requires using Docker,
which means we'll have Docker inside a Docker container.  For that to
work we need an image with Docker available (I went for
[`amidos/dcind`][]) and to run the container in "privileged" mode.  We
also need to explicitly specify that the git repository from the
previous step is an input to the task:

```yaml
    - task: build-and-push
      privileged: true
      config:
        platform: linux
        image_resource:
          type: docker-image
          source:
            repository: amidos/dcind
        inputs:
          - name: concoursefiles-git
```

[`amidos/dcind`]: https://hub.docker.com/r/amidos/dcind/

Finally we have the `run` component of the `task` which here is a
shell script:

```yaml
        run:
          path: sh
          args:
            - -ce
            - |
              REPO="ci-registry:5000"
              TAG="$(date +'%s')"

              source /docker-lib.sh

              cd concoursefiles-git

              # $1 is a list of insecure repositories
              start_docker "$REPO"

              set -x

              docker build -f Dockerfile.ci-agent -t "$REPO/ci-agent:$TAG" .
              docker tag "$REPO/ci-agent:$TAG" "$REPO/ci-agent:latest"
              docker push "$REPO/ci-agent:$TAG"
              docker push "$REPO/ci-agent:latest"
```

By manually triggering this pipeline, I can build a new Docker image
and push it to my repository, making it available for other pipelines.
Much better than manually running a sequence of Docker commands (or
even a script).


Example Pipeline: barrucadu.co.uk
---------------------------------

![The barrucadu.co.uk pipeline](concourseci-on-nixos/barrucadu.co.uk-pipeline.png)

Now let's look at a somewhat-complex example pipeline, the one which
deploys www.barrucadu.co.uk and memo.barrucadu.co.uk.  There are three
git repositories and two jobs involved here:

- Pushing to [cv.git][] or [barrucadu.co.uk.git][] should trigger a
  deploy of www.barrucadu.co.uk.
- Pushing to [memo.barrucadu.co.uk.git][] should trigger a deploy of
  memo.barrucadu.co.uk and also [send an ActivityPub notification][].

[cv.git]: https://github.com/barrucadu/cv
[barrucadu.co.uk.git]: https://github.com/barrucadu/barrucadu.co.uk
[memo.barrucadu.co.uk.git]: https://github.com/barrucadu/memo.barrucadu.co.uk
[send an ActivityPub notification]: https://ap.barrucadu.co.uk/memo

First we need to define the resources.  This is like the other
pipeline, we just have more of them:

```yaml
resources:
- name: cv-git
  type: git
  source:
    branch: master
    uri: https://github.com/barrucadu/cv.git

- name: memo-git
  type: git
  source:
    branch: master
    uri: https://github.com/barrucadu/memo.barrucadu.co.uk.git

- name: www-git
  type: git
  source:
    branch: master
    uri: https://github.com/barrucadu/barrucadu.co.uk.git
```

There's a lot in common between both websites: they're built with
[hakyll][] and deployed with rsync; deployment needs access to a
secret SSH private key; and the tasks will all use the same container
configuration.  So I decided to factor out the common components:

[hakyll]: https://jaspervdj.be/hakyll/

```yaml
x-task-config: &x-task-config
  platform: linux
  image_resource:
    type: docker-image
    source:
      repository: ci-registry:5000/ci-agent
      insecure_registries: ["ci-registry:5000"]

x-task-deploy: &x-task-deploy
  task: deploy
  params:
    SSH_PRIVATE_KEY: {{ssh-private-key}}
  config:
    <<: *x-task-config
    inputs:
      - name: site
    run:
      path: sh
      args:
        - -ce
        - |
          echo "${SSH_PRIVATE_KEY}" > sshkey
          chmod 700 sshkey

          set -x

          cd site
          for subdomain in *; do
            rsync -e 'ssh -o StrictHostKeyChecking=no -i ../sshkey' -avzc --delete "${subdomain}/" "concourseci@barrucadu.co.uk:/srv/http/barrucadu.co.uk/${subdomain}/"
          done
```

The `x-task-deploy` looks a little complex, but it's not really.  It's
just verbose.  The `{{ssh-private-key}}` is a variable that will be
interpolated by `fly`, the Concourse command line tool, using a second
yaml file.  That second yaml file is in a private repository.  Using
variable interpolation seemed much simpler than setting up [Vault][]
or something.  All this task is doing is setting up an SSH key and
then using rsync to copy every directory in the input (`site`) to a
corresponding directory on the host (`barrucadu.co.uk`).

[Vault]: https://www.vaultproject.io/

Now we have the jobs.  Let's start with the one to build
memo.barrucadu.co.uk:

```yaml
- name: memo.barrucadu.co.uk
  serial: true
  plan:
    - get: memo-git
      trigger: true

    - task: build
      config:
        <<: *x-task-config
        inputs:
          - name: memo-git
        outputs:
          - name: site
        caches:
          - path: .stack
          - path: memo-git/.stack-work
        run:
          path: sh
          args:
            - -cex
            - |
              cd memo-git
              stack --no-terminal build
              stack --no-terminal exec hakyll build

              mv _site ../site/memo

    - <<: *x-task-deploy

    - task: notify
      params:
        PLEROMA_PASSWORD: {{pleroma-user-memo-password}}
      config:
        <<: *x-task-config
        inputs:
          - name: memo-git
        run:
          path: memo-git/post-pleroma-status
```

Tasks run sequentially, and the job as a whole aborts if any fail, so
this is how it plays out:

1. Concourse notices a change to the git repository and triggers a
   build of the job (the `trigger: true` line).
2. Concourse clones the repository, and any submodules.
3. The `build` task runs, which builds the site with hakyll and puts
   the result in `site/memo`[^cache].
4. The `deploy` task runs, which is entirely defined by
   `x-task-deploy` above.
5. The `notify` task runs, which calls [this script in the
   repository][].

Because the scripts use `-e`, if any line of script fails the job as a
whole will be aborted.

[^cache]: The `caches` hash is used to persist directories between
    runs.  This is handy, because compiling Haskell is slow, so
    caching build artefacts is good.  But I'm not convinced it's
    working.

[this script in the repository]: https://github.com/barrucadu/memo.barrucadu.co.uk/blob/master/post-pleroma-status

The www.barrucadu.co.uk job is a bit more complex because it involves
two repositories, both of which trigger a build:

```yaml
- name: www.barrucadu.co.uk
  serial: true
  plan:
    - aggregate:
      - get: cv-git
        trigger: true
      - get: www-git
        trigger: true

    - task: build
      config:
        <<: *x-task-config
        inputs:
          - name: cv-git
          - name: www-git
        outputs:
          - name: site
        caches:
          - path: .stack
          - path: www-git/.stack-work
        run:
          path: sh
          args:
            - -cex
            - |
              cd cv-git
              latexmk -pdf -xelatex cv-full.tex

              cd ../www-git
              stack --no-terminal build
              stack --no-terminal exec hakyll build

              mv _site ../site/www
              mv ../cv-git/cv-full.pdf ../site/www/cv.pdf

    - <<: *x-task-deploy
```

The only new thing here is the `aggregate` step, which runs a list of
steps in parallel (failing if any of the substeps fail), which is
handy for fetching multiple resources in one go.

A previous iteration of this job was structured like this:

```yaml
plan:
  - aggregate:
     - fetch cv-git
     - fetch www-git
  - aggregate:
    - build cv-git
    - build www-git
  - combine cv-git and www-git
  - use standard deploy
```

But it takes almost no time at all to build `cv-git` and shuffling
around the inputs and outputs made the job rather more complex, so I
combined the build steps.


Conclusions?
------------

I now have Concourse up and running, it's doing everything I had
Jenkins doing, and it has the advantage that all the configuration is
version controlled.

It was more fiddly to set up, but a lot of the difficulty I had was
due to unfamiliarity with docker-compose and how it handles
networking, which led to me wasting a couple of hours trying to get a
Docker registry working on the host while I had the subnet
firewalled...  In any case, it's set up now.

It would be nice to be able to define my Concourse pipelines in my
NixOS config, so that if I change VPS hosts again I don't need to
manually re-register the pipelines and trigger a build of the ci-agent
Docker image, but those are small problems compared to *all* of my
Jenkins jobs and plugins being hand-configured.
