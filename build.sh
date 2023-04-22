#!/bin/bash

zig cc -shared -o libav.so -lavcodec -lavformat -llua5.2 libav.c
