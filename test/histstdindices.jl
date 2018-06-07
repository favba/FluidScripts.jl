#!/usr/bin/env julia
using FluidScripts.histstdindices

function main(f,ns)
    n = parse(Int,ns)
    histstdindices(f,n)
end

function main(f)
    n = 50
    histstdindices(f,n)
end

main(ARGS...)