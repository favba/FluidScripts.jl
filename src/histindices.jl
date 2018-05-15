using JLD2

function histindices(input::AbstractString,nbins::Integer)
    field = readfield(input)
    minf,maxf = min_max(field)
    ind = hist_indices(field,minf,maxf,nbins)
    bins = Bins(minf,maxf,nbins)
    @save "pdf_indices_$(input)_nbins$(nbins).jld2" ind bins
end