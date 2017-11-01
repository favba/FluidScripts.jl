field = Mmap.mmap("extract_contour2",Array{Float64,3},(8192,8192,1024))

short = zeros(Float64,(1024,1024,128))

#I = N*i - N + 1
for k=1:128
  for j=1:1024
    for i=1:1024
      short[i,j,k] = field[8*i-7,8*j-7,8*k-7]
    end
  end
end

write("short_extract_contour2",short)
