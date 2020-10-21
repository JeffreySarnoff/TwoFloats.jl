module PairArithmetic
#module FloatFloats

export FloatFloat

const FastFloat = Union{Float32, Float64}

using LinearAlgebra
using StructArrays, LoopVectorization
using ErrorfreeArithmetic

include("typed_floatfloat.jl")
include("floatfloat_arithmetic.jl")
include("reorder_by_magnitude.jl")

end # module
