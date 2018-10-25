#!/usr/bin/env julia6
using ReadGlobal, Decomp, StaticArrays

function TensorDirec_part!(t11::Vector{T},t22::Vector{T},t33::Vector{T},t12::Vector{T},t13::Vector{T},t23::Vector{T},dir::Vector{T}) where T<:AbstractFloat
    eigg  = [MVector{3,T}() for i in 1:Threads.nthreads()]
    eigv1 = [MVector{3,T}() for i in 1:Threads.nthreads()]
    eigv2 = [MVector{3,T}() for i in 1:Threads.nthreads()]
    eigv3 = [MVector{3,T}() for i in 1:Threads.nthreads()]
    Threads.@threads for i in 1:length(t11)
        j = Threads.threadid()
        @inbounds eigen!(t11[i],t22[i],t33[i],t12[i],t13[i],t23[i],eigg[j],eigv1[j],eigv2[j],eigv3[j])
        @inbounds dir[i] = abs(eigv1[j][3])
    end
end

function TensorDirec(t11::String,t22::String,t33::String,t12::String,t13::String,t23::String,out::String)
    doinchunks(TensorDirec_part!,input=(t11,t22,t33,t12,t13,t23),output=(out,))
    return 0
end

TensorDirec(ARGS[1],ARGS[4],ARGS[6],ARGS[2],ARGS[3],ARGS[5],ARGS[7])
