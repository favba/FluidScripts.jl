#!/usr/bin/env julia
using FluidScripts.MakeD
FFTW.set_num_threads(Threads.nthreads())
MakeD()