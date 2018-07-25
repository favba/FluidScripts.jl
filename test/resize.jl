#!/usr/bin/env julia
using ReadGlobal, InplaceRealFFT

function resize(input::PaddedArray{T,3,L},newdim::NTuple{3,Int64}) where {T,L}
    u1_big = similar(input,newdim);
    fill!(complex(u1_big),0.0+0.0im)
    nx,ny,nz = size(input)
    nxb,nyb,nzb = size(u1_big)
    ratio = prod(newdim)/prod(size(real(input)))
  
    #get smallest one
    nxs = min(nx,nxb)
    nys = min(ny,nyb)
    nzs = min(nz,nzb)
  
    rfft!(input)
    @views begin
        u1_big[1:nxs,1:(div(nys,2)),1:(div(nzs,2))] .= ratio .* input[1:nxs,1:(div(nys,2)),1:(div(nzs,2))]
        u1_big[1:nxs,(nyb-div(nys,2)):end,1:(div(nzs,2))] .= ratio .* input[1:nxs,(ny-div(nys,2)):end,1:(div(nzs,2))]
        u1_big[1:nxs,(nyb-div(nys,2)):end,(nzb-div(nzs,2)):end] .= ratio .* input[1:nxs,(ny-div(nys,2)):end,(nz-div(nzs,2)):end]
        u1_big[1:nxs,1:(div(nys,2)),(nzb-div(nzs,2)):end] .= ratio .* input[1:nxs,1:div(nys,2),(nz-div(nzs,2)):end]
    end
    irfft!(u1_big)
    return u1_big
end
  
function resize(input::String,nnx::Int,nny::Int,nnz::Int)
    nx,ny,nz,_,_,_ = getdimsize()
    dtype,padded = checkinput(input,nx,ny,nz)
    us = PaddedArray{dtype}(input,(nx,ny,nz),padded)
    out = resize(us,(nnx,nny,nnz))
    write(input*"_resized",out)
end


resize(ARGS[1],parse(Int,ARGS[2]),parse(Int,ARGS[3]),parse(Int,ARGS[4]))