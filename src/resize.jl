function resize!(input::PaddedArray{T,3,L},newdim::NTuple{3,Int64}) where {T,L}
  u1_big = similar(input,newdim);
  fill!(complex(u1_big),0.0+0.0im)
  nx,ny,nz = size(input)
  nxb,nyb,nzb = size(u1_big)
  ratio = prod(newdim)/prod(size(real(input)))
  rfft!(input)
  @views begin
      u1_big[1:nx,1:(div(ny,2)),1:(div(nz,2))] .= ratio .* input[:,1:(div(ny,2)),1:(div(nz,2))]
      u1_big[1:nx,(nyb-div(ny,2)):end,1:(div(nz,2))] .= ratio .* input[:,(ny-div(ny,2)):end,1:(div(nz,2))]
      u1_big[1:nx,(nyb-div(ny,2)):end,(nzb-div(nz,2)):end] .= ratio .* input[:,(ny-div(ny,2)):end,(nz-div(nz,2)):end]
  u1_big[1:nx,1:(div(ny,2)),(nzb-div(nz,2)):end] .= ratio .* input[:,1:div(ny,2),(nz-div(nz,2)):end]
  end
  irfft!(u1_big)
  return u1_big
end

function resize(input::String,nnx::Int,nny::Int,nnz::Int)
  nx,ny,nz,_,_,_ = getdimsize()
  dtype,padded = checkinput(input,nx,ny,nz)
  us = PaddedArray(input,dtype,(nx,ny,nz),padded=padded)
  out = resize!(us,(nnx,nny,nnz))
  write(input*"_resized",out)
end
