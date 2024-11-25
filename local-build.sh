#!/bin/sh

nix develop --command bash -c "./build --drafts --root=https://misc.barrucadu.co.uk/_site/ --out=$HOME/http/_site"
