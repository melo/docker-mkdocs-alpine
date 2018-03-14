#!/bin/sh

set -e

mkdir -p build

exec docker run -it --rm -v `pwd`/docs:/docs -v `pwd`/build:/build -p 8000:8000 melopt/mkdocs "$@"
