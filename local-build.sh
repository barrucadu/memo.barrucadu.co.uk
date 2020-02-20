#!/usr/bin/env nix-shell
#! nix-shell -i bash -p haskellPackages.pandoc haskellPackages.pandoc-sidenote python3Packages.virtualenv graphviz

set -e

if [[ ! -d venv ]]; then
  virtualenv venv
  source venv/bin/activate
  pip install -r requirements.txt
else
  source venv/bin/activate
fi

ROOT="${1:-file://$(pwd)/_site/index.html}"

./build --root=$ROOT

echo "Open $ROOT in a web browser."
