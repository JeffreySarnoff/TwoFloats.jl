module PairArithmetic

export Paired

using LinearAlgebra
using StructArrays, LoopVectorization
using ErrorfreeArithmetic

include("typed_pairs.jl")
include("pair_arithmetic.jl")
include("reorder_by_magnitude.jl")

end  # PairArithmetic
