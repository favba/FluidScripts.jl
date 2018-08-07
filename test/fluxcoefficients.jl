#!/usr/bin/env julia
using ReadGlobal

function coef(out,f1,f2,f3,m1,m2,m3,α)
    Threads.@threads for i in linearindices(out)
        @inbounds out[i] = α * muladd(f1[i],m1[i], muladd(f2[i],m2[i],f3[i]*m3[i])) / muladd(m1[i],m1[i], muladd(m2[i],m2[i],m3[i]*m3[i]))
    end
end

function main()
    f1 = readfield("flux1")
    f2 = readfield("flux2")
    f3 = readfield("flux3")
    N,F = getnfilter()
    m1 = readfield("$(F)drhodx_N$N")
    m2 = readfield("$(F)drhody_N$N")
    m3 = readfield("$(F)drhodz_N$N")

    nx,ny,nz,lx,ly,lz = getdimsize()
    Δ = parse(Float64,N)*2π*lx/nx
    S,_,_,_ = read_info("normD.info")

    coef(m1,f1,f2,f3,m1,m2,m3,1/(Δ*Δ*S))
    write("coef_1modelflux",m1)

    read!(m1,"2modelflux1")
    read!(m2,"2modelflux2")
    read!(m3,"2modelflux3")

    coef(m1,f1,f2,f3,m1,m2,m3,1/S)
    write("coef_2modelflux",m1)

    read!(m1,"3modelflux1")
    read!(m2,"3modelflux2")
    read!(m3,"3modelflux3")

    coef(m1,f1,f2,f3,m1,m2,m3,1/(Δ*Δ))
    write("coef_3modelflux",m1)

    read!(m1,"4modelflux1")
    read!(m2,"4modelflux2")
    read!(m3,"4modelflux3")

    coef(m1,f1,f2,f3,m1,m2,m3,1/(Δ*Δ))
    write("coef_4modelflux",m1)

    read!(m1,"5modelflux1")
    read!(m2,"5modelflux2")
    read!(m3,"5modelflux3")

    coef(m1,f1,f2,f3,m1,m2,m3,1/(Δ*Δ))
    write("coef_5modelflux",m1)

end

main()
