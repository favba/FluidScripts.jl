#!/usr/bin/env julia
using ReadGlobal, MyStats, JLD2

function dbkhistindices(input::AbstractString,nbins::Integer)
    field = readfield(input)
    minf,maxf = min_max(field)
    ind = dbkhist_indices(field,nbins)
    centers =  zeros(nbins)
    @inbounds for i in 1:nbins
        centers[i] = mean(view(field,ind[i]))
    end
    bins = centers
    @save "pdf_dbkindices_$(input)_nbins$(nbins).jld2" ind bins
end

function main(f,ns)
    n = parse(Int,ns)
    dbkhistindices(f,n)
end

function main(f)
    n = 36
    dbkhistindices(f,n)
end

main(ARGS...)