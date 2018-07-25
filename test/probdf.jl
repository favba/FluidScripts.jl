#!/usr/bin/env julia
using ReadGlobal, MyStats

function probdf(file::String)
    writedlm(file*".pdf.txt",hist(readfield(file)))
    return 0
end 
  
function probdf(file::String,condfile::String)
    N = parse(Int,split(condfile,"_")[end][2:end])
    writedlm(file*".cond."*condfile*".pdf.txt",hist(readfield(file),read(condfile,Int64,(N,))))
    return 0
end 
  
probdf(ARGS...)
