module FloatFloats

export Float96, Float48

const FastFloat = Union{Float32, Float64}

using LinearAlgebra
using StructArrays, LoopVectorization
using ErrorfreeArithmetic

include("float_struct.jl")
const Float96 = Float{2, Float64}
const Float48 = Float{2, Float32}

include("floatfloat_arithmetic.jl")
include("reorder_by_magnitude.jl")

end  FloatFloats
