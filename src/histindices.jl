using JLD2

function histindices(input::AbstractString,nbins::Integer)
    field = readfield(input)
    minf,maxf = min_max(field)
    ind = hist_indices(field,minf,maxf,nbins)
    @save "pdf_indices_$(input).jld2" ind
end