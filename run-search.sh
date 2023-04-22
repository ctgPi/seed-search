#!/bin/bash

set +eu

CORES=$(grep -c ^processor /proc/cpuinfo)

rm -f output/*.tmp
seq $((16#00000)) $((16#0FFFF)) | gargs -p $((CORES - 1)) "nice -n 20 ./search.lua {0}" 2>/dev/null
