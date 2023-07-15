@echo off

zig cc -shared -o rng.dll -lm bin\lua52.dll src\rng.zig
zig cc -shared -o zip.dll -lm -I.\src bin\lua52.dll src\zip.zig src\miniz.c src\miniz_tdef.c src\miniz_tinfl.c src\miniz_zip.c
zig cc -shared -o env.dll -lm -I.\src bin\lua52.dll src\env_win32.zig
