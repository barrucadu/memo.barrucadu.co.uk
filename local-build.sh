#!/bin/sh

ROOT="https://misc.barrucadu.co.uk/_site/"

if [[ "$(hostname)" == "azathoth" ]]; then
  ROOT="file:///home/barrucadu/http/_site/"
fi

if command -v docker &>/dev/null; then
  docker="docker"
else
  docker="podman"
fi

$docker run -it --rm -v $(pwd):/src -v $HOME/http/_site:/build -w /src registry.barrucadu.dev/memo-builder sh -c "
  virtualenv venv
  source venv/bin/activate
  pip install -r requirements.txt
  git config --global --add safe.directory /src
  ./build --drafts --root=$ROOT --out=/build"
