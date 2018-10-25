#!/usr/bin/env julia6
using MyStats, ReadGlobal, JLD2

function histindices(input::AbstractString,nbins::Integer)
    field = readfield(input)
    minf,maxf = min_max(field)
    ind = hist_indices(field,minf,maxf,nbins)
    bins = Bins(minf,maxf,nbins)
    @save "pdf_indices_$(input)_nbins$(nbins).jld2" ind bins
end

function main(f,ns)
    n = parse(Int,ns)
    histindices(f,n)
end

function main(f)
    n = 50
    histindices(f,n)
end

main(ARGS...)