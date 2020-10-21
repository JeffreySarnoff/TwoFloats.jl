#=

     All methods, functions, and utilities required to work seamlessly with `StructArrays.jl`

=#

using StructArrays

Base.getproperty(x::TwoFloat, s::Symbol) = 
    (s == :hi ? getfield(x, 1) :
    (s == :lo ? getfield(x, 2) :
          error("($s) is not a field of `TwoFloat`.")))

Base.propertynames(b::TwoFloat) = (:hi, :lo) 

# explicitly give the "schema" of the object to StructArrays

function StructArrays.staticschema(::Type{TwoFloat{T}}) where {T}}
    TwoFloat(::TwoFloat{(:hi, :lo), Base.tuple_type_cons(T, types)}
end

# generate an instance of TwoFloat type
function StructArrays.createinstance(::Type{TwoFloat{T}}, x, args...) where {T}
    TwoFloat(x, T(args)
end
    
