__precompile__()
module FluidScripts
using StaticArrays, LESFilter, InplaceRealFFT, ReadGlobal, MyStats, Derivatives, Decomp, Fluids

includelist = (
"MakeD.jl",
"TensorDirec.jl",
"VectorDirec.jl",
"angle.jl",
"dinfo.jl",
"energydistr.jl",
"filter.jl",
"fluxmodels2.jl",
"makeModel.jl",
"makeP.jl",
"makeT.jl",
"makeflux.jl",
"probdf.jl",
"resize.jl",
"norm.jl",
"histindices.jl"
)

for file in includelist
  include(file)
end

end # module
