#!/usr/bin/env julia -O3 --startup-file=no
using FluidScripts.makeModel
for f::String in ARGS
  makeModel(f)
end
