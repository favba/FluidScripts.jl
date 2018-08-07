#!/usr/bin/env julia
using ReadGlobal, InplaceRealFFT, Derivatives

#=
Calculate the gradient of a field.
usage: grad.jl inputfile dx_filename dy_filename dz_filename
=#

function _main(field::AbstractArray,lx,ly,lz,f1::AbstractString,f2::AbstractString,f3::AbstractString)
    out = copy(field)
    dx!(out,lx)
    write(f1,out.r)
    copy!(out,field)
    dy!(out,ly)
    write(f2,out.r)
    copy!(out,field)
    dz!(out,lz)
    write(f3,out.r)
end

function main()
    nx,ny,nz,lx,ly,lz = getdimsize()
    dtype, padded = checkinput(ARGS[1],nx,ny,nz)
    field = PaddedArray{dtype}(ARGS[1],(nx,ny,nz),padded)
    _main(field,lx,ly,lz,ARGS[2],ARGS[3],ARGS[4])
end

main()
