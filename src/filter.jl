function filter(inputfile::String,N::Int,fil::String)
  nx,ny,nz,xs,ys,zs = getdimsize()
  dtype, padded = checkinput(inputfile,nx,ny,nz)
  field = PaddedArray(inputfile,dtype,(nx,ny,nz),padded=padded)

  # Ugly fix in case dtype is Float32
  if eltype(field) == Complex{Float32}
    field2 = field
    field = PaddedArray(Float64,size(real(field2)))
    real(field) .= real(field2)
  end

  boxdim = N*2*zs*π/nz
  isfile("wisdom") && FFTW.import_wisdom("wisdom")
  info("Filtering File $inputfile")
  lesfilter!(field, fil=fil, boxdim=boxdim, lengths=(xs,ys,zs))
  info("Done")

  if fil == "G"
    pathoutput = "./Filtered_Fields/Gaussian/N$N"
  elseif fil =="C"
    pathoutput = "./Filtered_Fields/CutOff/N$N"
  end

  isdir(pathoutput) || mkpath(pathoutput)
  outfilename = "$(pathoutput)/$(fil)$(split(split(inputfile,"/")[end],".")[1])_N$(N)"
  info("Saving filtered field in $outfilename")
  write(outfilename,field.r)
  FFTW.export_wisdom("wisdom")
end
