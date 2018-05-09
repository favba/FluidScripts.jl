#!/usr/bin/env julia
using MyStats.condmean
using ReadGlobal.readfield
using JLD2

function main(inpname::AbstractString, condname::AbstractString, outfilename::AbstractString)
    field = readfield(inpname)
    @load condname ind bins
    r = condmean(field,ind)
    writedlm(outfilename,hcat(bins,r))
    return nothing
end


main(ARGS...)
