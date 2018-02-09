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

function sym(u::A,v::A) where {A<:PaddedArray{T,N} where {T,N}}
  r = similar(u.rr)
  tplus!(r,u.rr,v.rr)
  return r
end

function antisym(u::A,v::A) where {A<:PaddedArray{T,N} where {T,N}}
  r = similar(u.rr)
  tminus!(r,u.rr,v.rr)
  return r
end


function MakeD()

N,Fil = getnfilter()
nx, ny, nz, lx, ly, lz = getdimsize()
dim = (nx,ny,nz)
isfile("fftw_wisdom") && FFTW.import_wisdom("fftw_wisdom")

aux1 = PaddedArray("$(Fil)u1_N$N",(nx,ny,nz),false)
write("$(Fil)D11_N$N",dx!(aux1,lx))
read!("$(Fil)u1_N$N",aux1)

aux2 = PaddedArray("$(Fil)u2_N$N",(nx,ny,nz),false)
write("$(Fil)D22_N$N",dy!(aux2,ly))
read!("$(Fil)u2_N$N",aux2)

dy!(aux1,ly)
dx!(aux2,lx)
write("$(Fil)D12_N$N", @view(sym(aux2,aux1)[1:(end-2),:,:]))
gc()
write("$(Fil)W12_N$N", @view(antisym(aux2,aux1)[1:(end-2),:,:]))
gc()

read!("$(Fil)u3_N$N",aux2)
write("$(Fil)D33_N$N",dz!(aux2,lz))
gc()
read!("$(Fil)u3_N$N",aux2)

read!("$(Fil)u1_N$N",aux1)

dz!(aux1,lz)
dx!(aux2,lx)
write("$(Fil)D13_N$N", @view(sym(aux2,aux1)[1:(end-2),:,:]))
gc()
write("$(Fil)W13_N$N", @view(antisym(aux2,aux1)[1:(end-2),:,:]))
gc()

read!("$(Fil)u2_N$N",aux1)
read!("$(Fil)u3_N$N",aux2)
dz!(aux1,lz)
dy!(aux2,ly)
write("$(Fil)D23_N$N", @view(sym(aux2,aux1)[1:(end-2),:,:]))
gc()
write("$(Fil)W23_N$N", @view(antisym(aux2,aux1)[1:(end-2),:,:]))

return 0
end