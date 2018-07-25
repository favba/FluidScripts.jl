#!/usr/bin/env julia
using ReadGlobal

function makep!(d11::T,d22::T,d33::T,d12::T,d13::T,d23::T,
    w12::T,w13::T,w23::T,
    p11::T,p22::T,p33::T,p12::T,p13::T,p23::T) where {T<:Vector{<:Number}}

    Threads.@threads for i in 1:length(d11)
        @inbounds p11[i] = -2*(d12[i]*w12[i] + d13[i]*w13[i])
        @inbounds p22[i] = 2*(d12[i]*w12[i] - d23[i]*w23[i])
        @inbounds p33[i] = 2*(d13[i]*w13[i] + d23[i]*w23[i])
        @inbounds p12[i] = w12[i]*(d11[i]-d22[i]) - d13[i]*w23[i] - d23[i]*w13[i]
        @inbounds p13[i] = w13[i]*(d11[i]-d33[i]) + d12[i]*w23[i] - d23[i]*w12[i]
        @inbounds p23[i] = w23[i]*(d22[i]-d33[i]) + d12[i]*w13[i] + d13[i]*w12[i]
    end
    return 0
end

function makeP()
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

    p11 = "$(Fil)P11_N$N"
    p22 = "$(Fil)P22_N$N"
    p33 = "$(Fil)P33_N$N"
    p12 = "$(Fil)P12_N$N"
    p13 = "$(Fil)P13_N$N"
    p23 = "$(Fil)P23_N$N"

    doinchunks(makep!,input=(d11,d22,d33,d12,d13,d23,w12,w13,w23),output=(p11,p22,p33,p12,p13,p23))
end

makeP()
