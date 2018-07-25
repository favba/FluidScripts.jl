#!/usr/bin/env julia
using ReadGlobal

function VectorDirec_part!(w₁::A,w₂::A,w₃::A,out::A) where {A<:Vector{<:Number}}
    Threads.@threads for i in 1:length(w₁)
        @inbounds out[i] = w₃[i]/sqrt((w₁[i]^2 + w₂[i]^2 + w₃[i]^2))
    end
    return 0
end
  
function VectorDirec(w1::String,w2::String,w3::String,out::String)
    doinchunks(VectorDirec_part!,input=(w1,w2,w3),output=(out,))
end

VectorDirec(ARGS...)
