#!/bin/bash

zig cc -shared -o libav.so -lavcodec -lavformat -llua5.2 libav.c
zig cc -shared -o rng.so -lm -llua5.2 rng.zig
