#!/usr/bin/env julia
using ReadGlobal, InplaceRealFFT, LESFilter

function adddx!(out,inp,kim)
    nx,ny,nz = size(inp)
    Threads.@threads for l = 1:nz
        for j = 1:ny
            @simd for i = 1:nx
                @inbounds out[i,j,l] = muladd(inp[i,j,l],kim[i], out[i,j,l])
            end
        end
    end
end

function adddy!(out,inp,kim)
    nx,ny,nz = size(inp)
    Threads.@threads for l = 1:nz
        for j = 1:ny
            @simd for i = 1:nx
                @inbounds out[i,j,l] = muladd(inp[i,j,l],kim[j], out[i,j,l])
            end
        end
    end
end

function adddz!(out,inp,kim)
    nx,ny,nz = size(inp)
    Threads.@threads for l = 1:nz
        for j = 1:ny
            @simd for i = 1:nx
                @inbounds out[i,j,l] = muladd(inp[i,j,l],kim[l], out[i,j,l])
            end
        end
    end
end

function div(t11::AbstractString,t12::AbstractString,t13::AbstractString,t22::AbstractString,t23::AbstractString,t33::AbstractString,f1::AbstractString,f2::AbstractString,f3::AbstractString)
    nx,ny,nz,lx,ly,lz = getdimsize()
    s = (nx,ny,nz)
    kxim = (2π .* rfftfreq(nx,lx) .* im)
    kyim = (2π .* fftfreq(ny,ly) .* im)
    kzim = (2π .* fftfreq(nz,lz) .* im)

    FFTW.set_num_threads(Threads.nthreads())
    isfile("fftw_wisdom") && FFTW.import_wisdom("fftw_wisdom")

    dtype, padded = checkinput(t11,nx,ny,nz)

    aux1 = PaddedArray(t11,s,padded)
    aux2 = similar(aux1)

    begin #f1
        rfft!(aux1)
        adddx!(aux2.c,aux1.c,kxim)

        read!(t12,aux1,padded)
        rfft!(aux1)
        adddy!(aux2.c,aux1.c,kyim)

        read!(t13,aux1,padded)
        rfft!(aux1)
        adddz!(aux2.c,aux1.c,kzim)

        irfft!(aux2)
        write(f1,aux2.r)
    end

    begin #f3
        fill!(aux2.data,0.0)
        adddx!(aux2.c,aux1.c,kxim)

        read!(t33,aux1,padded)
        rfft!(aux1)
        adddz!(aux2.c,aux1.c,kzim)

        read!(t23,aux1,padded)
        rfft!(aux1)
        adddy!(aux2.c,aux1.c,kyim)

        irfft!(aux2)
        write(f3,aux2.r)
    end

    begin #f2
        fill!(aux2.data,0.0)
        adddz!(aux2.c,aux1.c,kzim)

        read!(t22,aux1,padded)
        rfft!(aux1)
        adddy!(aux2.c,aux1.c,kyim)

        read!(t12,aux1,padded)
        rfft!(aux1)
        adddx!(aux2.c,aux1.c,kxim)

        irfft!(aux2)
        write(f2,aux2.r)
    end

    return nothing
end

function div(u1::AbstractString,u2::AbstractString,u3::AbstractString,f::AbstractString)
    nx,ny,nz,lx,ly,lz = getdimsize()
    s = (nx,ny,nz)
    kxim = (2π .* rfftfreq(nx,lx) .* im)
    kyim = (2π .* fftfreq(ny,ly) .* im)
    kzim = (2π .* fftfreq(nz,lz) .* im)

    FFTW.set_num_threads(Threads.nthreads())
    isfile("fftw_wisdom") && FFTW.import_wisdom("fftw_wisdom")

    dtype, padded = checkinput(u1,nx,ny,nz)

    aux1 = PaddedArray(u1,s,padded)
    aux2 = similar(aux1)

    rfft!(aux1)
    adddx!(aux2.c,aux1.c,kxim)

    read!(u2,aux1,padded)
    rfft!(aux1)
    adddy!(aux2.c,aux1.c,kyim)

    read!(u3,aux1,padded)
    rfft!(aux1)
    adddz!(aux2.c,aux1.c,kzim)

    irfft!(aux2)
    write(f,aux2.r)

    return nothing
end

div(ARGS...)