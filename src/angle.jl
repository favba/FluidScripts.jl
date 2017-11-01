function angle!(w₁::A,w₂::A,w₃::A,f₁::A,f₂::A,f₃::A,out::A) where {A<:Vector{<:Number}}
  Threads.@threads for i in 1:length(w₁)
    @fastmath @inbounds out[i] = (w₁[i]*f₁[i]+w₂[i]*f₂[i]+w₃[i]*f₃[i])/sqrt((w₁[i]^2 + w₂[i]^2 + w₃[i]^2)*(f₁[i]^2 + f₂[i]^2 + f₃[i]^2))
  end
return 0
end

function angle(u1::String,u2::String,u3::String,w1::String,w2::String,w3::String,out::String)
  doinchunks(angle!,input=(u1,u2,u3,w1,w2,w3),output=(out,))
end
