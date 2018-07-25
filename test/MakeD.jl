#!/usr/bin/env julia
using ReadGlobal, InplaceRealFFT, Derivatives

function tplus!(r::Array{T,N},u::Array{T,N},v::Array{T,N}) where {T,N}
    Threads.@threads for i::Int in 1:length(u)
      @inbounds r[i] = 0.5*(u[i] + v[i])
    end
    return r
end
  
function tminus!(r::Array{T,N},u::Array{T,N},v::Array{T,N}) where {T,N}
    Threads.@threads for i::Int in 1:length(u)
      @inbounds r[i] = 0.5*(u[i] - v[i])
    end
    return r
end
  
function sym!(r,u::A,v::A) where {A<:PaddedArray{T,N} where {T,N}}
    urr = data(u)
    vrr = data(v)
    tplus!(data(r),urr,vrr)
    return r
end
  
function antisym!(r,u::A,v::A) where {A<:PaddedArray{T,N} where {T,N}}
    urr = data(u)
    vrr = data(v)
    tminus!(data(r),urr,vrr)
    return r
end
  
  
function MakeD()
  
  N,Fil = getnfilter()
  nx, ny, nz, lx, ly, lz = getdimsize()
  dim = (nx,ny,nz)
  isfile("fftw_wisdom") && FFTW.import_wisdom("fftw_wisdom")
  
  aux1 = PaddedArray("$(Fil)u1_N$N",(nx,ny,nz),false)
  write("$(Fil)D11_N$N",dx!(aux1,lx))
  read!("$(Fil)u1_N$N",aux1,false)
  
  aux2 = PaddedArray("$(Fil)u2_N$N",(nx,ny,nz),false)
  write("$(Fil)D22_N$N",dy!(aux2,ly))
  read!("$(Fil)u2_N$N",aux2,false)
  
  dy!(aux1,ly)
  dx!(aux2,lx)
  
  aux3 = similar(aux1)
  write("$(Fil)D12_N$N", real(sym!(aux3,aux2,aux1)))
  write("$(Fil)W12_N$N", real(antisym!(aux3,aux2,aux1)))
  
  read!("$(Fil)u3_N$N",aux2,false)
  write("$(Fil)D33_N$N",dz!(aux2,lz))
  read!("$(Fil)u3_N$N",aux2,false)
  
  read!("$(Fil)u1_N$N",aux1,false)
  
  dz!(aux1,lz)
  dx!(aux2,lx)
  write("$(Fil)D13_N$N", real(sym!(aux3,aux2,aux1)))
  write("$(Fil)W13_N$N", real(antisym!(aux3,aux2,aux1)))
  
  read!("$(Fil)u2_N$N",aux1,false)
  read!("$(Fil)u3_N$N",aux2,false)
  dz!(aux1,lz)
  dy!(aux2,ly)
  write("$(Fil)D23_N$N", real(sym!(aux3,aux2,aux1)))
  write("$(Fil)W23_N$N", real(antisym!(aux3,aux2,aux1)))
  
  return 0
end

FFTW.set_num_threads(Threads.nthreads())
MakeD()