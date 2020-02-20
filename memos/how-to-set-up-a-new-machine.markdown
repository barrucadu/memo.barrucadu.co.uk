---
title: "How to: set up a new machine"
taxon: techdocs-runbooks
published: 2020-02-20
tags: nixos
---

1. Boot into the NixOS installer.

2. Follow the [NixOS manual][] up to the step of editing
   `configuration.nix`.

3. Set up the initial NixOS configuration file:

    1. On a machine with git push access, create a basic config ([a
       recent example][]), and push it to GitHub.

    2. On the new machine, set up `/mnt/etc/nixos`:

        ```bash
        nix-env --install git

        cd /mnt/etc/nixos

        git clone https://github.com/barrucadu/nixfiles.git
        mv nixos/* nixos/.* .
        rmdir nixos

        ln -s hosts/HOSTNAME host
        mv hardware-configuration.nix host/hardware.nix
        ```

4. Continue with the NixOS installation instructions, and reboot into
   the installed OS.

5. [Set up the user environment][]: NixOS machines generally have ssh
   and private git access.

6. Change the `barrucadu` password and add the new password to
   KeePassXC.

7. Disable the root account:

    ```bash
    sudo passwd -l root
    ```

8. Change ownership of `/etc/nixos` to `barrucadu`:

    ```bash
    sudo chown -R barrucadu.users /etc/nixos
    ```

9. Commit and push `hardware.nix`:

    ```bash
    cd /etc/nixos
    git add .
    git commit -m "[HOSTNAME] Commit generated hardware.nix"
    git remote rm origin
    git remote add origin git@github.com:barrucadu/nixfiles.git
    git push -u origin master
    ```

[NixOS manual]: https://nixos.org/nixos/manual/index.html#sec-installation
[a recent example]: https://github.com/barrucadu/nixfiles/commit/4682b5f2dfbedcb509104ec3cbc07e0f95a4e43d
[Set up the user environment]: how-to-set-up-the-user-environment.html
