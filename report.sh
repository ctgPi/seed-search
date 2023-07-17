#!/bin/bash

(shopt -s nullglob; for FILE in output/*.txt; do cat $FILE; done) | sort -nk2 | tail -n40
