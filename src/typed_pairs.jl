const Float96 = Tuple{Float64, Float64}
const Float48 = Tuple{Float32, Float32}

Float96(x::Float96) = x
Float48(x::Float48) = x

Float96(x::Float64, y::Float64) = two_sum(x, y)
Float48(x::Float24, y::Float24) = two_sum(x, y)

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


hash(x::TwoFloat, h::UInt) = hash(x.lo, hash(x.hi, h))

eltype(x::Type{TwoFloat{T}}) where {T} = T}

length(x::TwoFloat{T}) where {T} = 2

iterate(x::TwoFloat, i=1) = i > 2 ? nothing : (getfield(p, i), i + 1)
indexed_iterate(x::TwoFloat, i::Int, state=1) = (getfield(p, i), i + 1)


==(x::TwoFloat{T}, y::TwoFloat{T}) where {T} =
   (x.hi === y.hi) & (x.lo === y.lo)

!=(x::TwoFloat{T}, y::TwoFloat{T}) where {T} =
   (x.hi !=== y.hi) | (x.lo !=== y.lo)

<=(x::TwoFloat{T}, y::TwoFloat{T}) where {T} =
   (x.hi < y.hi) || ((x.hi === y.hi) & (x.lo <= y.lo))

>=(x::TwoFloat{T}, y::TwoFloat{T}) where {T} =
   (x.hi > y.hi) || ((x.hi === y.hi) & (x.lo >= y.lo))

<(x::TwoFloat{T}, y::TwoFloat{T}) where {T} =
   (x.hi < y.hi) || ((x.hi === y.hi) & (x.lo < y.lo))

>(x::TwoFloat{T}, y::TwoFloat{T}) where {T} =
   (x.hi > y.hi) || ((x.hi === y.hi) & (x.lo > y.lo))

isequal(x::TwoFloat, y::TwoFloat) = 
    isequal(x.hi ,y.hi) & isequal(x.lo, y.lo)

isless(x::TwoFloat, y::TwoFloat) = 
    ifelse(!isequal(x.hi,y.hi), isless(x.hi,y.hi), isless(x.lo,y.lo))

getindex(x::TwoFloat, i::Int) = getfield(p,i)
getindex(x::TwoFloat, i::Real) = getfield(p, convert(Int, i))

firstindex(x::TwoFloat{T}) where {T} = 1
lastindex(x::TwoFloat{T})  where {T} = 2
first(x::TwoFloat{T}) where {T} = x.hi
last(x::TwoFloat{T})  where {T} = x.lo

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
