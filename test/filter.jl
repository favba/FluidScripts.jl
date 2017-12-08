#!/usr/bin/env julia
using FluidScripts.filter
if length(ARGS) == 3
  inputfile = ARGS[1]
  N = parse(Int,ARGS[2])
  fil = ARGS[3]

  filter(inputfile,N,fil)
else
  inputfile = ARGS[1]
  N1 = parse(Int,ARGS[2])
  N2 = parse(Int,ARGS[3])
  fil = ARGS[4]

  filter(inputfile,N1,N2,fil)
end