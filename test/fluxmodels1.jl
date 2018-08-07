#!/usr/bin/env julia
using ReadGlobal

function model2_part!(r1,r2,r3,t11,t12,t13,t22,t23,t33,out1,out2,out3)
    Threads.@threads for i in linearindices(rho)
        @inbounds out1[i] = t11[i]*r1[i] + t12[i]*r2[i] + t13[i]*r3[i]
        @inbounds out2[i] = t12[i]*r1[i] + t22[i]*r2[i] + t23[i]*r3[i]
        @inbounds out3[i] = t13[i]*r1[i] + t23[i]*r2[i] + t33[i]*r3[i]
    end
end

function main()
    N,Fil = getnfilter()
    r1 = "$(Fil)drhodx_N$N" 
    r2 = "$(Fil)drhody_N$N" 
    r3 = "$(Fil)drhodz_N$N" 
    run(`grad.jl $(Fil)rho_N$N $r1 $r2 $r3`)

    t11 = "$(Fil)T11_N$N"
    t12 = "$(Fil)T12_N$N"
    t13 = "$(Fil)T13_N$N"
    t22 = "$(Fil)T22_N$N"
    t23 = "$(Fil)T23_N$N"
    t33 = "$(Fil)T33_N$N"
    doinchunks(model2_part!, input=(r1,r2,r3,t11,t12,t13,t22,t23,t33), output=("2modelflux1", "2modelflux2", "2modelflux3"))
end
