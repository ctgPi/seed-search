#!/bin/bash

# zig cc -shared -o libav.so -lavcodec -lavformat -llua5.2 src/libav.c
zig cc -shared -o rng.so -lm -llua5.2 src/rng.zig
zig cc -shared -o zip.so -lm -llua5.2 -I./src src/zip.zig src/miniz.c src/miniz_tdef.c src/miniz_tinfl.c src/miniz_zip.c
zig cc -shared -o env.so -lm -llua5.2 src/env_linux.zig
