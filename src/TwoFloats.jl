module TwoFloats

export Float96, Float48

const FastFloat = Union{Float32, Float64}

using LinearAlgebra
using StructArrays, LoopVectorization
using ErrorfreeArithmetic

include("twofloat.jl")

include("support_StructArrays.jl")

include("floatfloat_arithmetic.jl")
include("doubleword_arithmetic.jl")
include("reorder_by_magnitude.jl")
include("pair_arithmetic.jl")

end  # TwoFloats
