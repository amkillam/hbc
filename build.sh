#!/usr/bin/env bash

docker build -f ./Dockerfile . -t hbc-builder

docker run --rm -v ${PWD}:"$(pwd)" -w "$(pwd)" \
  hbc-builder bash -c "make -Cwiipax && make -Cchannel"

mkdir -p out
[ -f channel/title/channel_retail.wad ] && cp channel/title/channel_retail.wad out
