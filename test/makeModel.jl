#!/usr/bin/env julia
using FluidScripts.makeModel
for f::String in ARGS
  makeModel(f)
end
