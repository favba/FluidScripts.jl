#!/usr/bin/env julia -O3 --startup-file=no
using FluidScripts.resize
resize(ARGS[1],parse(Int,ARGS[2]),parse(Int,ARGS[3]),parse(Int,ARGS[4]))