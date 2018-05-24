#!/usr/bin/env julia
using MyStats.condmean
using ReadGlobal: readfield, readfield!
using JLD2

function main(condname::AbstractString, inpname::AbstractVector{<:AbstractString}, outfilename::AbstractVector{<:AbstractString})
    @load condname ind bins
    field = readfield(inpname[1])
    for i in linearindices(inpname)
        readfield!(inpname[i],field)
        r = condmean(field,ind)
        writedlm(outfilename[i],hcat(bins,r))
    end
    return nothing
end

function main(args::Vector{<:AbstractString})
    condname = args[1]
    iseven(length(args)) && error()
    p = div(length(args) - 1, 2) + 1
    inpname = args[2:p]
    outfilename = args[p+1:end]
    main(condname,inpname,outfilename)
end

main(ARGS)
