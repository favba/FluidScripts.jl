#!/usr/bin/env julia
using MyStats, ReadGlobal

function probdf(file::AbstractString,ntimess::AbstractString="3")
    ntimes = parse(Float64,ntimess)
    field = readfield(file)
    f = string(file,".info")
    if isfile(f)
        m,stand,_,_ = read_info(f)
    else
        m = tmean(field)
        stand = tstd(field,m)
    end
    writedlm(file*".pdf.txt",histstd(field,m,stand,ntimes,36,true))
    return 0
end 

probdf(ARGS...)