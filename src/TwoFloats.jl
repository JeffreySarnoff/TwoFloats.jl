module TwoFloats

export Float96, Float48

const FastFloat = Union{Float32, Float64}

using LinearAlgebra
using StructArrays, LoopVectorization
using ErrorfreeArithmetic

include("twofloat.jl")
const Float96 = TwoFloat{Float64}
const Float48 = TwoFloat{Float32}

inclued("support_StructArrays.jl")

include("floatfloat_arithmetic.jl")
include("reorder_by_magnitude.jl")

end  # TwoFloats
