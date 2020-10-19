module PairArithmetic

export Paired

using LinearAlgebra
using StructArrays, LoopVectorization
using ErrorfreeArithmetic

include("paired.jl")
include("pair_arithmetic.jl")
include("maxminabs.jl")

end  # PairArithmetic
