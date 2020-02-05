---
title: "How to: set up a new machine"
taxon: techdocs-runbooks
published: 2020-02-05
---

1. **If this isn't a NixOS machine managed by my nixfiles
   repo:**
   
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

2. **If this machine is getting SSH access to things:**

    1. Generate an SSH key:

        ```bash
        ssh-keygen -a 100 -t ed25519
        ```

    2. Add the key to things as appropriate (GitHub, gitolite,
       nixfiles, etc)

3. Set up dotfiles:

    1. Clone dotfiles repo to `~`:

        ```bash
        cd ~
        
        git clone git@github.com:barrucadu/dotfiles.git
        # OR
        git clone https://github.com/barrucadu/dotfiles.git
        ```
    
    2. Symlink dotfiles:
    
        ```bash
        cd dotfiles
        for d in *; do [[ -d $d ]] && stow $d; done
        ```

4. **If this machine has gitolite access:**

    1. Clone secrets repo to `~`:
    
        ```bash
        cd ~
        git clone git@dunwich.barrucadu.co.uk:secrets.git
        ```
    
    2. Symlink secret dotfiles:
    
        ```bash
        cd secrets
        stow dotfiles
        ```

5. Restart terminal.
