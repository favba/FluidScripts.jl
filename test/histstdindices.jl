#!/usr/bin/env julia6
using ReadGlobal, MyStats, JLD2

function histstdindices(input::AbstractString,nbins::Integer,nstd::Number)
    field = readfield(input)
    med,stdv,_,_ = read_info(input*".info")
    minf = med - nstd*stdv
    maxf = med + nstd*stdv
    ind = hist_indices(field,minf,maxf,nbins)
    bins = Bins(minf,maxf,nbins)
    @save "pdf_std$(nstd)_indices_$(input)_nbins$(nbins).jld2" ind bins
end

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
