#=
    TwoFloat{T}(a, b) --> (a, b)

    TwoFloat( a, b )  --> two_sum(a, b)
    TwoFloat((a, b))  --> two_hilo_sum(a, b)
=#    

struct TwoFloat{T} <: AbstractFloat
    hi::T
    lo::T

    function TwoFloat{T}(a::T, b::T) where {T}
        return new{T}(a,b)
    end
end

function TwoFloat(a::T, b::T) where {T}
    a, b = two_sum(a, b)
    return TwoFloat{T}(a, b)
end            

function TwoFloat(ab::Tuple{T,T}) where {T}
    a, b = two_hilo_sum(a, b)
    return TwoFloat{T}(a, b)
end

const Float96 = TwoFloat{Float64}
const Float48 = TwoFloat{Float32}

Float96(x::Float96) = x
Float48(x::Float48) = x

Float96(x::Float64, y::Float64) = two_sum(x, y)
Float48(x::Float32, y::Float32) = two_sum(x, y)

@inline function two_sum(a::T, b::T) where {T}
   hi = a + b
   v  = hi - a
   lo = (a - (hi - v)) + (b - v)
   return hi, lo
end

@inline function two_hilo_sum(a::T, b::T) where {T}
   hi = a + b
   lo = b - (hi - a)
   return hi, lo
end

@inline function two_div(a::T, b::T) where {T}
    hi = a / b
    lo = fma(-hi, b, a)
    lo /= b
    return hi, lo
end

@inline function two_prod(a::T, b::T) where {T}
   hi = a * b
   lo = fma(a, b, -hi)
   hi, lo
end

Base.:(==)(x::TwoFloat{T}, y::TwoFloat{T}) where {T} =
   (x.hi === y.hi) && (x.lo === y.lo)
Base.:(!=)(x::TwoFloat{T}, y::TwoFloat{T}) where {T} =
   (x.hi !=== y.hi) || (x.lo !=== y.lo)
Base.:(<=)(x::TwoFloat{T}, y::TwoFloat{T}) where {T} =
   (x.hi < y.hi) || ((x.hi === y.hi) & (x.lo <= y.lo))
Base.:(>=)(x::TwoFloat{T}, y::TwoFloat{T}) where {T} =
   (x.hi > y.hi) || ((x.hi === y.hi) & (x.lo >= y.lo))
Base.:(<)(x::TwoFloat{T}, y::TwoFloat{T}) where {T} =
   (x.hi < y.hi) || ((x.hi === y.hi) & (x.lo < y.lo))
Base.:(>)(x::TwoFloat{T}, y::TwoFloat{T}) where {T} =
   (x.hi > y.hi) || ((x.hi === y.hi) & (x.lo > y.lo))

Base.isequal(x::TwoFloat, y::TwoFloat) = 
    isequal(x.hi ,y.hi) & isequal(x.lo, y.lo)
Base.isless(x::TwoFloat, y::TwoFloat) = 
    ifelse(!isequal(x.hi,y.hi), isless(x.hi,y.hi), isless(x.lo,y.lo))

Base.hash(x::TwoFloat, h::UInt) = hash(x.lo, hash(x.hi, h))
Base.eltype(x::Type{TwoFloat{T}}) where {T} = T

Base.length(x::TwoFloat{T}) where {T} = 2
Base.nfields(x::TwoFloat{T}) where {T} = 2
Base.fieldcount(::Type{TwoFloat{T}}) where {T} = 2
Base.fieldnames(::Type{TwoFloat{T}}) where {T} = (:hi, :lo)

Base.firstindex(x::TwoFloat{T}) where {T} = 1
Base.lastindex(x::TwoFloat{T})  where {T} = 2
Base.first(x::TwoFloat{T}) where {T} = x.hi
Base.last(x::TwoFloat{T})  where {T} = x.lo

Base.getindex(x::TwoFloat, i::Int) = getfield(x, i)
Base.getindex(x::TwoFloat, i::Real) = getfield(x, convert(Int, i))
Base.getindex(x::TwoFloat, i::Symbol) = getfield(x, i)

Base.iterate(x::TwoFloat{T}, iter=1) where {T} =
    iter > lastidex(x) ? nothing : (getfield(x, iter), iter + 1)
Base.indexed_iterate(x::TwoFloat{T}, i::Int, state=1) where {T} =
    (getfield(t, i), i+1)

Base.prevind(x::TwoFloat{T}, i::Integer) where{T} = Int(i)-1
Base.nextind(x::TwoFloat{T}, i::Integer) where {T} = Int(i)+1

Base.convert(::Type{TwoFloat{T}}, x::TwoFloat{T}) where {T} = x
function Base.convert(::Type{TwoFloat{T1}}, x::TwoFloat{T2}) where {T1,T2}
    TwoFloat{T1}(convert(T1, x[1]), convert(T1, x[2]))
end
Base.promote_rule(::Type{TwoFloat{T1}}, ::Type{TwoFloat{T2}) where {T1,T2} =
    TwoFloat{promote_type(T1, T2)}


"""
    refresh(a::TwoFloat)

resets the canonical form
- a = refine(a)
"""
refresh(a::TwoFloat{T}) where {T} = two_sum(a.hi, a.lo)

"""
    renorm(a::TwoFloat)

*unchecked assumption*: abs(a[1]) >= abs(a[2])
- a = renorm(a)
"""
renorm(a::TwoFloat{T}) where {T} = two_hilo_sum(a.hi, a.lo)
