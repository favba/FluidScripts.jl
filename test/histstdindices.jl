#!/usr/bin/env julia
using FluidScripts.histstdindices

function main(f,ns,nstds)
    n = parse(Int,ns)
    nstd = parse(Float64,nstds)
    histstdindices(f,n,nstd)
end

function main(f,ns)
    n = parse(Int,ns)
    histstdindices(f,n,2.)
end

main(f) = histstdindices(f,50,2.)

main(ARGS...)
