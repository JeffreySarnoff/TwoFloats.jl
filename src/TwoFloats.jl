module TwoFloats

export Float96, Float48

const FastFloat = Union{Float32, Float64}

using LinearAlgebra
using StructArrays, LoopVectorization
using ErrorfreeArithmetic

include("float_struct.jl")
const Float96 = Floats{2, Float64}
const Float48 = Floats{2, Float32}

inclued("support_StructArrays.jl")


include("floatfloat_arithmetic.jl")
include("reorder_by_magnitude.jl")

end  TwoFloats
