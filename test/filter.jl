#!/usr/bin/env julia -O3 --startup-file=no
using FluidScripts.filter

inputfile = ARGS[1]
N = parse(Int,ARGS[2])
fil = ARGS[3]

filter(inputfile,N,fil)
