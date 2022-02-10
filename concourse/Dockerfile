FROM nixos/nix:2.6.0

RUN nix-channel --add https://nixos.org/channels/nixos-20.09 nixpkgs && \
    nix-channel --add https://nixos.org/channels/nixos-unstable unstable && \
    nix-channel --update

ENV LANG=en_GB.UTF-8 \
    LC_ALL=en_GB.UTF-8 \
    LC_CTYPE=en_GB.UTF-8

RUN nix-env -iA \
        nixpkgs.git \
        nixpkgs.graphviz \
        unstable.haskellPackages.pandoc \
        nixpkgs.python3Packages.virtualenv
