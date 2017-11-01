#!/usr/bin/env julia -O3 --startup-file=no
using FluidScripts.TensorDirec

TensorDirec(ARGS[1],ARGS[4],ARGS[6],ARGS[2],ARGS[3],ARGS[5],ARGS[7])
