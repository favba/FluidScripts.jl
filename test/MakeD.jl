#!/usr/bin/env julia -O3 --startup-file=no
using FluidScripts.MakeD
FFTW.set_num_threads(Threads.nthreads())
MakeD()