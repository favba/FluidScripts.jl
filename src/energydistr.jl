@inline function energydistr_scalar(t11::T,t22::T,t33::T,t12::T,t13::T,t23::T,
  d11::T,d22::T,d33::T,d12::T,d13::T,d23::T,
  w12::T,w13::T,w23::T) where {T<:Number}

  #ɛ = t11 * d11 + t22 * d22 + t33 * d33 + 2.0*(t12 * d12 + t13*d13 + t23*d23)
  ɛ = muladd(t11, d11 ,muladd(t22, d22, muladd(t33, d33, 2.0*muladd(t12, d12, muladd(t13, d13, t23*d23)))))

  #dir11 = (d11*t11+d12*t12+d13*t13-t12*w12-t13*w13) - ɛ/3.
  dir11 = muladd(d11, t11, muladd(d12, t12, muladd(d13, t13, -muladd(t12, w12, muladd(t13, w13, ɛ/3)))))

  #dir22 = (d12*t12+d22*t22+d23*t23+t12*w12-t23*w23) - ɛ/3.
  dir22 = muladd(d12, t12, muladd(d22, t22, muladd(d23, t23, muladd(t12, w12, -muladd(t23, w23, ɛ/3)))))

  #dir33 = (d13*t13+d23*t23+d33*t33+t13*w13+t23*w23) - ɛ/3.
  dir33 = muladd(d13, t13, muladd(d23, t23, muladd(d33, t33, muladd(t13, w13, muladd(t23, w23, - ɛ/3)))))

  #dir12 = 0.5*(d11*t12+d12*t11+d12*t22+d13*t23+d22*t12+d23*t13+t11*w12-t13*w23-t22*w12-t23*w13)
  dir12 = 0.5*muladd(d11, t12, muladd(d12, t11, muladd(d12, t22, muladd(d13, t23,
             muladd(d22, t12, muladd(d23, t13, muladd(t11, w12, -muladd(t13, w23, muladd(t22, w12, t23*w13)))))))))

  #dir13 = 0.5*(d11*t13+d12*t23+d13*t11+d13*t33+d23*t12+d33*t13+t11*w13+t12*w23-t23*w12-t33*w13)
  dir13 = 0.5*muladd(d11, t13, muladd(d12, t23, muladd(d13, t11, muladd(d13, t33, 
             muladd(d23, t12, muladd(d33, t13, muladd(t11, w13, muladd(t12, w23, -muladd(t23, w12, t33*w13)))))))))

  #dir23 = 0.5*(d12*t13+d13*t12+d22*t23+d23*t22+d23*t33+d33*t23+t12*w13+t13*w12+t22*w23-t33*w23)
  dir23 = 0.5*muladd(d12, t13, muladd(d13, t12, muladd(d22, t23, muladd(d23, t22,
             muladd(d23, t33, muladd(d33, t23, muladd(t12, w13, muladd(t13, w12, muladd(t22, w23, -t33*w23)))))))))
  return ε, dir11, dir22, dir33, dir12, dir13, dir23
end

function energydistr_part!(t11::T,t22::T,t33::T,t12::T,t13::T,t23::T,
                      d11::T,d22::T,d33::T,d12::T,d13::T,d23::T,
                      w12::T,w13::T,w23::T,
                      dir11::T,dir22::T,dir33::T,dir12::T,dir13::T,dir23::T,
                      ɛ::T) where {T<:Vector{<:Number}}

  Threads.@threads for i in 1:length(d11)
    
    @inbounds ɛ[i], dir11[i], dir22[i], dir33[i], dir12[i], dir13[i], dir23[i] = energydistr_scalar(t11[i],t22[i],t33[i],t12[i],t13[i],t23[i],d11[i],d22[i],d33[i],d12[i],d13[i],d23[i],w12[i],w13[i],w23[i])

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
