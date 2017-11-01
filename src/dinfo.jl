function dinfo(file::String)
  field = readfield(file)
  nx,ny,nz,_,_,_ = getdimsize()
  fdims = (nx,ny,nz)
  med = mean(field)
  devi = std(field,mean=med)
  imax =  indmax(field)
  fmax = field[imax]
  imax = ind2sub(fdims,imax)
  imin =  indmin(field)
  fmin = field[imin]
  imin = ind2sub(fdims,imin)

  println("Mean: ",med)
  println("Std: ",devi)
  println("Max: ",fmax," at ",imax)
  println("Min: ",fmin," at ",imin)
  return 0
end

function dinfo(file1::String,file2::String,file3::String)
  field = FVector(file1,file2,file3)
  nx,ny,nz,_,_,_ = getdimsize()
  fdims = (nx,ny,nz)
  med = mean(field)
  devi = std(field,mean=med)
  imax =  indmax(mod(field))
  fmax = field[imax]
  imax = ind2sub(fdims,imax)
  imin =  indmin(mod(field))
  fmin = field[imin]
  imin = ind2sub(fdims,imin)

  println("Mean: ",med)
  println("Std: ",devi)
  println("Max: ",fmax," at ",imax)
  println("Min: ",fmin," at ",imin)
  return 0
end
               #d11           d12           d13           d22   d23    d33
function dinfo(file1::String,file2::String,file3::String,file4,file5,file6)
  field = SymTensor(file1,file4,file6,file2,file3,file5)
  nx,ny,nz,_,_,_ = getdimsize()
  fdims = (nx,ny,nz)
  med = mean(field)
  devi = std(field,mean=med)
  imax =  indmax(mod(field))
  fmax = field[imax]
  imax = ind2sub(fdims,imax)
  imin =  indmin(mod(field))
  fmin = field[imin]
  imin = ind2sub(fdims,imin)

  println("Mean: ",med)
  println("Std: ",devi)
  println("Max: ",fmax," at ",imax)
  println("Min: ",fmin," at ",imin)
  return 0
end
