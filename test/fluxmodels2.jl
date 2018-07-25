#!/usr/bin/env julia
using ReadGlobal
function fluxmodels2()
    nx, ny, nz, xs, ys, zs = getdimsize()
    
    dim = (nx,ny,nz)
    
    place = split(pwd(),"/")
    
    N = place[end][2:end]
    Fil = place[end-1][1]
    
    d11 = Mmap.mmap("$(Fil)D11_N$N",Array{Float64,3},dim)
    d22 = Mmap.mmap("$(Fil)D22_N$N",Array{Float64,3},dim)
    d33 = Mmap.mmap("$(Fil)D33_N$N",Array{Float64,3},dim)
    d12 = Mmap.mmap("$(Fil)D12_N$N",Array{Float64,3},dim)
    d13 = Mmap.mmap("$(Fil)D13_N$N",Array{Float64,3},dim)
    d23 = Mmap.mmap("$(Fil)D23_N$N",Array{Float64,3},dim)
    
    
    w12 = Mmap.mmap("$(Fil)W12_N$N",Array{Float64,3},dim)
    w13 = Mmap.mmap("$(Fil)W13_N$N",Array{Float64,3},dim)
    w23 = Mmap.mmap("$(Fil)W23_N$N",Array{Float64,3},dim)
    
    r1 = Mmap.mmap("$(Fil)drhodx_N$N",Array{Float64,3},dim)
    r2 = Mmap.mmap("$(Fil)drhody_N$N",Array{Float64,3},dim)
    r3 = Mmap.mmap("$(Fil)drhodz_N$N",Array{Float64,3},dim)
    
    
    v1 = Array{Float64}(dim)
    v2 = Array{Float64}(dim)
    v3 = Array{Float64}(dim)
    
    
    #Threads.@threads for i in 1:length(d11)
    for i in 1:length(d11)
        @inbounds v1[i] = d11[i]*r1[i] + d12[i]*r2[i] + d13[i]*r3[i]
        @inbounds v2[i] = d12[i]*r1[i] + d22[i]*r2[i] + d23[i]*r3[i]
        @inbounds v2[i] = d13[i]*r1[i] + d23[i]*r2[i] + d33[i]*r3[i]
    end
    
    write("4modelflux1",v1)
    write("4modelflux2",v2)
    write("4modelflux3",v3)
    
    #Threads.@threads for i in 1:length(d11)
    for i in 1:length(d11)
        @inbounds v1[i] = d11[i]*r1[i] + (d12[i]+w12[i])*r2[i] + (d13[i]+w13[i])*r3[i]
        @inbounds v2[i] = (d12[i]-w12[i])*r1[i] + d22[i]*r2[i] + (d23[i]+w23[i])*r3[i]
        @inbounds v3[i] = (d13[i]-w13[i])*r1[i] + (d23[i]-w23[i])*r2[i] + d33[i]*r3[i]
    end
    
    write("3modelflux1",v1)
    write("3modelflux2",v2)
    write("3modelflux3",v3)
    
    #Threads.@threads for i in 1:length(d11)
    for i in 1:length(d11)
        @inbounds v1[i] = w12[i]*r2[i] + w13[i]*r3[i]
        @inbounds v2[i] = -w12[i]*r1[i] + w23[i]*r3[i]
        @inbounds v3[i] = -w13[i]*r1[i] - w23[i]*r2[i]
    end
    
    write("5modelflux1",v1)
    write("5modelflux2",v2)
    write("5modelflux3",v3)
    
end
fluxmodels2()
