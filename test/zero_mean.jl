#!/usr/bin/env julia
using ReadGlobal, InplaceRealFFT


FFTW.set_num_threads(Threads.nthreads())

function main()

  nx, ny, nz, lx, ly, lz = getdimsize()
  dim = (nx,ny,nz)
  isfile("fftw_wisdom") && FFTW.import_wisdom("fftw_wisdom")
  dtype, padded = checkinput(ARGS[1],nx,ny,nz)
  aux1 = PaddedArray{dtype}(ARGS[1],(nx,ny,nz),padded)
  rfft!(aux1)
  aux1[1] = zero(Complex{dtype})
  irfft!(aux1)
  write(ARGS[2], aux1.data)

  FFTW.export_wisdom("fftw_wisdom")
  return 0
end

main()