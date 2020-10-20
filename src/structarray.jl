#=

     All methods, functions, and utilities required to work seamlessly with `StructArrays.jl`

=#


Base.getproperty(p::Pair{T}, s::Symbol) where {T} = getfield(p, 1)
function StructArrays.staticschema(::Type{Pair{T}) where {T}
    Tuple{T, T}
end    
function StaticArrays.createinstance(::Type{Pair{T}}, hilo::Tuple{T,T}) where {T}
    hilo
end
function StaticArrays.createinstance(::Type{Pair{T}}, hi::T, lo::T) where {T}
    renorm(hi, lo)
end


    
