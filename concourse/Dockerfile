FROM nixos/nix:2.13.1

RUN nix-channel --add https://nixos.org/channels/nixos-21.11 nixpkgs && \
    nix-channel --update

ENV LANG=en_GB.UTF-8 \
    LC_ALL=en_GB.UTF-8 \
    LC_CTYPE=en_GB.UTF-8

RUN nix-env -iA \
        nixpkgs.git \
        nixpkgs.graphviz \
        nixpkgs.haskellPackages.pandoc \
        nixpkgs.python3Packages.virtualenv
