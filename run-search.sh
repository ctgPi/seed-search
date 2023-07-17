#!/bin/bash

set +eu

CORES=$(grep -c ^processor /proc/cpuinfo)
export FACTORIO_HOME="/home/fabio/factorio/1.1.80"

rm -f output/*.tmp
seq $((16#0000)) $((16#FFFF)) | gargs -p $((CORES - 1)) "nice -n 20 lua5.2 worker.lua {0}"
