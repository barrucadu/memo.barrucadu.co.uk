#!/bin/sh

docker run -it --rm -v $(pwd):/src -v $HOME/http/_site:/build -w /src registry.barrucadu.dev/barrucadu.co.uk-builder sh -c "
  virtualenv venv
  source venv/bin/activate
  pip install -r requirements.txt
  ./build --root=https://misc.barrucadu.co.uk/_site/ --out=/build"
