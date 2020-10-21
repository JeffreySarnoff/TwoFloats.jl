module PairArithmetic

export Paired

const FastFloat = Union{Float32, Float64}

using LinearAlgebra
using StructArrays, LoopVectorization
using ErrorfreeArithmetic

include("typed_pairs.jl")
include("pair_arithmetic.jl")
include("reorder_by_magnitude.jl")

end  # PairArithmetic
