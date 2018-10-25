#!/usr/bin/env julia6
using ReadGlobal

function makenorm!(txx::AbstractArray,txy,txz,tyy,tyz,tzz,out)
    @inbounds begin
        Threads.@threads for i in linearindices(out)
            p = txx[i]^2 + tyy[i]^2 + tzz[i]^2 + 2 *(txy[i]^2 + txz[i]^2 + tyz[i]^2)
            out[i] = sqrt(2*p)
        end
    end
end
  
function makenorm!(tx::AbstractArray,ty,tz,out)
    @inbounds begin
        Threads.@threads for i in linearindices(out)
            p = tx[i]^2 + ty[i]^2 + tz[i]^2
            out[i] = sqrt(p)
        end
    end
end
  
function makenorm(tx::String,ty,tz,out)
    doinchunks(makenorm!,input=(tx,ty,tz),output=(out,))
end
  
function makenorm(txx::String,txy,txz,tyy,tyz,tzz,out)
    doinchunks(makenorm!,input=(txx,txy,txz,tyy,tyz,tzz),output=(out,))
end

makenorm(ARGS...)
