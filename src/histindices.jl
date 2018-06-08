using JLD2

function histindices(input::AbstractString,nbins::Integer)
    field = readfield(input)
    minf,maxf = min_max(field)
    ind = hist_indices(field,minf,maxf,nbins)
    bins = Bins(minf,maxf,nbins)
    @save "pdf_indices_$(input)_nbins$(nbins).jld2" ind bins
end

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

function histstdindices(input::AbstractString,nbins::Integer,nstd::Number)
    field = readfield(input)
    med,stdv,_,_ = read_info(input*".info")
    minf = med - nstd*stdv
    maxf = med + nstd*stdv
    ind = hist_indices(field,minf,maxf,nbins)
    bins = Bins(minf,maxf,nbins)
    @save "pdf_std($nstd)_indices_$(input)_nbins$(nbins).jld2" ind bins
end
