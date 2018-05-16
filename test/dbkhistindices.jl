#!/usr/bin/env julia
using FluidScripts.dbkhistindices

function main(f,ns)
    n = parse(Int,ns)
    dbkhistindices(f,n)
end

function main(f)
    n = 36
    dbkhistindices(f,n)
end

main(ARGS...)