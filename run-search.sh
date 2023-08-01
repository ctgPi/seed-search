#!/bin/bash

set +eu

CORES=$(grep -c ^processor /proc/cpuinfo)

rm -f output/*.tmp
seq $((16#0000)) $((16#FFFF)) | gargs -p $((CORES - 1)) "nice -n 20 lua5.2 generate.lua {0}"
