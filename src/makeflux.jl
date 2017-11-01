function makefluxsgs!(r::Array{T,N},u::Array{T,N},v::Array{T,N}) where {T<:Number,N}
  Threads.@threads for i::Int in 1:length(u)
    @inbounds r[i] = r[i] - u[i]*v[i]
  end
  return r
end

function makeflux()

place = split(pwd(),"/")
N = place[end][2:end]
Fil = place[end-1][1]

nx, ny, nz, lx, ly, lz = getdimsize()

aux1 = readfield("$(Fil)u1rho_N$N",nx,ny,nz)
aux2 = readfield("$(Fil)rho_N$N",nx,ny,nz)
aux3 = readfield("$(Fil)u1_N$N",nx,ny,nz)
write("flux1",makefluxsgs!(aux1,aux2,aux3))

read!("$(Fil)u2rho_N$N",aux1)
read!("$(Fil)u2_N$N",aux3)
write("flux2",makefluxsgs!(aux1,aux2,aux3))

read!("$(Fil)u3rho_N$N",aux1)
read!("$(Fil)u3_N$N",aux3)
write("flux3",makefluxsgs!(aux1,aux2,aux3))

return 0
end