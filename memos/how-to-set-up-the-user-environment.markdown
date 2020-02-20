---
title: "How to: set up the user environment"
taxon: techdocs-runbooks
published: 2020-02-20
---

## Initial set-up for non-NixOS machines

1. Install Nix:

    ```bash
    curl https://nixos.org/nix/install | sh
    ```

2. Install any missing useful packages:

    ```bash
    for cmd in emacs git stow tmux mosh zsh; do
        if ! type $cmd &> /dev/null
            nix-env --install $cmd
        fi
    done
    ```

3. Change user shell to zsh.


## General set-up

1. Generate an SSH key:

    ```bash
    ssh-keygen -a 100 -t ed25519
    ```

2. Add the key to things as appropriate (GitHub, private git,
   nixfiles, etc)

3. Clone and symlink dotfiles:

    ```bash
    cd ~

    git clone git@github.com:barrucadu/dotfiles.git
    # OR
    git clone https://github.com/barrucadu/dotfiles.git

    cd dotfiles
    for d in *; do [[ -d $d ]] && stow $d; done
    ```

4. Clone and symlink secrets (if this machine has private git access):

    ```bash
    cd ~

    git clone git@dunwich.barrucadu.co.uk:secrets.git

    cd secrets
    stow dotfiles
    for d in *; do [[ -d $d ]] && stow $d; done
    ```

5. Restart terminal.
