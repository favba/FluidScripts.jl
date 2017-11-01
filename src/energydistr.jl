function energydistr_part!(t11::T,t22::T,t33::T,t12::T,t13::T,t23::T,
                      d11::T,d22::T,d33::T,d12::T,d13::T,d23::T,
                      w12::T,w13::T,w23::T,
                      dir11::T,dir22::T,dir33::T,dir12::T,dir13::T,dir23::T,
                      ɛ::T) where {T<:Vector{<:Number}}

  Threads.@threads for i in 1:length(d11)
   @inbounds ɛ[i] = t11[i] * d11[i] + t22[i] * d22[i] + t33[i] * d33[i] + 2.0*(t12[i] * d12[i] + t13[i]*d13[i] + t23[i]*d23[i])

   @inbounds dir11[i] = (d11[i]*t11[i]+d12[i]*t12[i]+d13[i]*t13[i]-t12[i]*w12[i]-t13[i]*w13[i]) - ɛ[i]/3.
   @inbounds dir22[i] = (d12[i]*t12[i]+d22[i]*t22[i]+d23[i]*t23[i]+t12[i]*w12[i]-t23[i]*w23[i]) - ɛ[i]/3.
   @inbounds dir33[i] = (d13[i]*t13[i]+d23[i]*t23[i]+d33[i]*t33[i]+t13[i]*w13[i]+t23[i]*w23[i]) - ɛ[i]/3.
   @inbounds dir12[i] = 0.5*(d11[i]*t12[i]+d12[i]*t11[i]+d12[i]*t22[i]+d13[i]*t23[i]+d22[i]*t12[i]+d23[i]*t13[i]+t11[i]*w12[i]-t13[i]*w23[i]-t22[i]*w12[i]-t23[i]*w13[i])
   @inbounds dir13[i] = 0.5*(d11[i]*t13[i]+d12[i]*t23[i]+d13[i]*t11[i]+d13[i]*t33[i]+d23[i]*t12[i]+d33[i]*t13[i]+t11[i]*w13[i]+t12[i]*w23[i]-t23[i]*w12[i]-t33[i]*w13[i])
   @inbounds dir23[i] = 0.5*(d12[i]*t13[i]+d13[i]*t12[i]+d22[i]*t23[i]+d23[i]*t22[i]+d23[i]*t33[i]+d33[i]*t23[i]+t12[i]*w13[i]+t13[i]*w12[i]+t22[i]*w23[i]-t33[i]*w23[i])
  end
  return nothing
end

function energydistr()
nx, ny, nz, xs, ys, zs = getdimsize()

dim = (nx,ny,nz)

place = split(pwd(),"/")
if ismatch(r"^Model_",place[end])
  N = place[end-1][2:end]
  Fil = place[end-2][1]

  ft11 = "Tm11"
  ft22 = "Tm22"
  ft33 = "Tm33"
  ft12 = "Tm12"
  ft13 = "Tm13"
  ft23 = "Tm23"


  fd11 = "../$(Fil)D11_N$N"
  fd22 = "../$(Fil)D22_N$N"
  fd33 = "../$(Fil)D33_N$N"
  fd12 = "../$(Fil)D12_N$N"
  fd13 = "../$(Fil)D13_N$N"
  fd23 = "../$(Fil)D23_N$N"


  fw12 = "../$(Fil)W12_N$N"
  fw13 = "../$(Fil)W13_N$N"
  fw23 = "../$(Fil)W23_N$N"

else

  N = place[end][2:end]
  Fil = place[end-1][1]

  ft11 = "$(Fil)T11_N$N"
  ft22 = "$(Fil)T22_N$N"
  ft33 = "$(Fil)T33_N$N"
  ft12 = "$(Fil)T12_N$N"
  ft13 = "$(Fil)T13_N$N"
  ft23 = "$(Fil)T23_N$N"


  fd11 = "$(Fil)D11_N$N"
  fd22 = "$(Fil)D22_N$N"
  fd33 = "$(Fil)D33_N$N"
  fd12 = "$(Fil)D12_N$N"
  fd13 = "$(Fil)D13_N$N"
  fd23 = "$(Fil)D23_N$N"


  fw12 = "$(Fil)W12_N$N"
  fw13 = "$(Fil)W13_N$N"
  fw23 = "$(Fil)W23_N$N"

end

fɛ = "Pr"

fdir11 = "dir11"
fdir22 = "dir22"
fdir33 = "dir33"
fdir12 = "dir12"
fdir13 = "dir13"
fdir23 = "dir23"

doinchunks(energydistr_part!,
           input=(ft11,ft22,ft33,ft12,ft13,ft23,fd11,fd22,fd33,fd12,fd13,fd23,fw12,fw13,fw23),
           output=(fdir11,fdir22,fdir33,fdir12,fdir13,fdir23,fɛ))

end
