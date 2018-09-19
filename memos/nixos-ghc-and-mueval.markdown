---
title: NixOS, GHCi, and Mueval
tags: haskell, howto, nixos, programming, tech
date: 2017-03-17
audience: Narrow
---


Making libraries available in GHCi
----------------------------------

Because everything on NixOS is immutable, you can't just install Haskell packages and have them
available in your GHC package database. Well, you *can*, but only in your user-level package
database. You can't do something like this:

```
$ cat shell.nix
with import <nixpkgs> {};
{
  demoEnv = stdenv.mkDerivation {
    name = "demo-env";
    buildInputs = with pkgs.haskellPackages [ ghc text ];
  };
}
$ nix-shell
[nix-shell:~/tmp]$ ghci
GHCi, version 8.0.1: http://www.haskell.org/ghc/  :? for help
Prelude> import Data.Text

<no location info>: error:
    Could not find module ‘Data.Text’
    Perhaps you meant
      Data.Set (from containers-0.5.7.1@containers-0.5.7.1)
```

You instead have to construct a GHC whose package database has the packages you desire. Like so:

```
$ cat shell.nix
with import <nixpkgs> {};
{
  demoEnv = stdenv.mkDerivation {
    name = "demo-env";
    buildInputs = with pkgs.haskellPackages; [ (ghcWithPackages (p: [p.text])) ];
  };
}
$ nix-shell
[nix-shell:~/tmp]$ ghci
GHCi, version 8.0.1: http://www.haskell.org/ghc/  :? for help
Prelude> import Data.Text
Prelude Data.Text>
```


Making packages available in GHCi and Mueval
--------------------------------------------

This all breaks if you use `mueval`, as it pulls in the regular GHC. This behaviour seems very odd
to me, I'm not sure if it's a bug or not, but it is how it is:

```
$ cat shell.nix
with import <nixpkgs> {};
{
  demoEnv = stdenv.mkDerivation {
    name = "demo-env";
    buildInputs = with pkgs.haskellPackages; [ mueval (ghcWithPackages (p: [p.text])) ];
  };
}
$ nix-shell
[nix-shell:~/tmp]$ ghci
GHCi, version 8.0.1: http://www.haskell.org/ghc/  :? for help
Prelude> import Data.Text

<no location info>: error:
    Could not find module ‘Data.Text’
    Perhaps you meant
      Data.Set (from containers-0.5.7.1@containers-0.5.7.1)
```

Instead you have to override the `ghc` that `hint`, one of `mueval`'s dependencies, pulls in:

```
$ cat shell.nix
with import <nixpkgs> {};
let
  extraHaskellLibs = p:
    # extra libraries you want
    [ p.text ] ++
    # mueval itself needs these packages
    [ p.mtl p.QuickCheck p.show p.simple-reflect ];
  ghc'    = haskellPackages.ghcWithPackages extraHaskellLibs;
  hint'   = haskellPackages.hint.override { ghc = ghc'; };
  mueval' = haskellPackages.mueval.override { hint = hint'; };
in {
  demoEnv = stdenv.mkDerivation {
    name = "demo-env";
    buildInputs = [ mueval' ];
  };
}
$ nix-shell
[nix-shell:~/tmp]$ ghci
GHCi, version 8.0.1: http://www.haskell.org/ghc/  :? for help
Prelude> import Data.Text
Prelude Data.Text>
```

However, `mueval` will not be able to see your new packages yet:

```
[nix-shell:~/tmp]$ mueval -XOverloadedStrings -m Data.Text -e 'Data.Text.Length "hello world"'
<no location info>: error:
    Could not find module ‘Data.Text’
    Perhaps you meant
      Data.Set (from containers-0.5.7.1@containers-0.5.7.1)
    Use -v to see a list of the files searched for.
```

This is because `mueval` doesn't know about the package database set up by
`ghcWithPackages`. Fortunately, we can discover where that is:

```
#! /nix/store/gabjbkwga2dhhp2wzyaxl83r8hjjfc37-bash-4.3-p48/bin/bash -e
export NIX_GHC="/nix/store/w7s4z1v5y0r8nbvq23b4xm4lddcmar3r-ghc-8.0.1-with-packages/bin/ghc"
export NIX_GHCPKG="/nix/store/w7s4z1v5y0r8nbvq23b4xm4lddcmar3r-ghc-8.0.1-with-packages/bin/ghc-pkg"
export NIX_GHC_DOCDIR="/nix/store/w7s4z1v5y0r8nbvq23b4xm4lddcmar3r-ghc-8.0.1-with-packages/share/doc/ghc/html"
export NIX_GHC_LIBDIR="/nix/store/w7s4z1v5y0r8nbvq23b4xm4lddcmar3r-ghc-8.0.1-with-packages/lib/ghc-8.0.1"
exec /nix/store/b0749p1rjpyvq2wyw58x6vgwpkwxcmnn-ghc-8.0.1/bin/ghci "-B$NIX_GHC_LIBDIR" "${extraFlagsArray[@]}" "$@"
```

Export the `NIX_GHC_LIBDIR` variable and try again:

```
[nix-shell:~/tmp]$ export NIX_GHC_LIBDIR="/nix/store/w7s4z1v5y0r8nbvq23b4xm4lddcmar3r-ghc-8.0.1-with-packages/lib/ghc-8.0.1"

[nix-shell:~/tmp]$ mueval -XOverloadedStrings -m Data.Text -e 'Data.Text.length "hello world"'
11
```

For a concrete example of this, see yukibot's [README][] and [shell.nix][].

[README]: https://github.com/barrucadu/yukibot#readme
[shell.nix]: https://github.com/barrucadu/yukibot/blob/master/shell.nix
