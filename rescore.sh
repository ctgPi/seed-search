#!/bin/bash

cat output/*.txt | sort -nrk2 | cut -c1-10 | python3 -c"import sys; print('\n'.join(list({k: True for k in [str(int(L) >> 16) for L in sys.stdin.readlines()]}.keys())))" | gargs -p 7 "FACTORIO_HOME=$HOME/factorio/1.1.80 nice -n 20 lua5.2 worker.lua {0}"
