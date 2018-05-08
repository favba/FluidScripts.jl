#!/usr/bin/env julia
using FluidScripts.histindices

function main(f,ns)
    n = parse(Int,ns)
    histindices(f,n)
end

function main(f)
    n = 50
    histindices(f,n)
end

main(ARGS...)