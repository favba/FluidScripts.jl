#!/usr/bin/env julia
using ReadGlobal

function model4(r1,r2,r3,d11,d12,d13,d22,d23,d33,v1,v2,v3)
    Threads.@threads for i in 1:length(d11)
        @inbounds v1[i] = d11[i]*r1[i] + d12[i]*r2[i] + d13[i]*r3[i]
        @inbounds v2[i] = d12[i]*r1[i] + d22[i]*r2[i] + d23[i]*r3[i]
        @inbounds v2[i] = d13[i]*r1[i] + d23[i]*r2[i] + d33[i]*r3[i]
    end
end

function model3(r1,r2,r3,d11,d12,d13,d22,d23,d33,w12,w13,w23,v1,v2,v3)
    Threads.@threads for i in 1:length(d11)
        @inbounds v1[i] = d11[i]*r1[i] + (d12[i]+w12[i])*r2[i] + (d13[i]+w13[i])*r3[i]
        @inbounds v2[i] = (d12[i]-w12[i])*r1[i] + d22[i]*r2[i] + (d23[i]+w23[i])*r3[i]
        @inbounds v3[i] = (d13[i]-w13[i])*r1[i] + (d23[i]-w23[i])*r2[i] + d33[i]*r3[i]
    end
end

function model5(r1,r2,r3,w12,w13,w23,v1,v2,v3)
    Threads.@threads for i in 1:length(r1)
        @inbounds v1[i] = w12[i]*r2[i] + w13[i]*r3[i]
        @inbounds v2[i] = -w12[i]*r1[i] + w23[i]*r3[i]
        @inbounds v3[i] = -w13[i]*r1[i] - w23[i]*r2[i]
    end
end

function fluxmodels2()
    
    N, Fil = getnfilter()
    
    d11 = "$(Fil)D11_N$N"
    d22 = "$(Fil)D22_N$N"
    d33 = "$(Fil)D33_N$N"
    d12 = "$(Fil)D12_N$N"
    d13 = "$(Fil)D13_N$N"
    d23 = "$(Fil)D23_N$N"
    
    
    w12 = "$(Fil)W12_N$N"
    w13 = "$(Fil)W13_N$N"
    w23 = "$(Fil)W23_N$N"
    
    r1 = "$(Fil)drhodx_N$N"
    r2 = "$(Fil)drhody_N$N"
    r3 = "$(Fil)drhodz_N$N"
    
    doinchunks(model4,input=(r1,r2,r3,d11,d12,d13,d22,d23,d33),output=("4modelflux1","4modelflux2","4modelflux3"))
    
    doinchunks(model3,input=(r1,r2,r3,d11,d12,d13,d22,d23,d33,w12,w13,w23),output=("3modelflux1","3modelflux2","3modelflux3"))
    
    doinchunks(model5,input=(r1,r2,r3,w12,w13,w23),output=("5modelflux1","5modelflux2","5modelflux3"))

end

fluxmodels2()
