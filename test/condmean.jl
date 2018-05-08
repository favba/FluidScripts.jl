#!/usr/bin/env julia
using MyStats.condmean
using ReadGlobal.readfield
using JLD2

function main(inpname::AbstractString, condname::AbstractString, outfilename::AbstractString)
    field = readfield(inpname)
    @load condname ind
    r = condmean(field,ind)
    writedlm(outfilename,r)
    return nothing
end


main(ARGS...)
