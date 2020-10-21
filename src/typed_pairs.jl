#=
FloatFloat{T} = Tuple{T,T}
FloatFloat(a, b) == (maxabs(a,b), minabs(a,b))
=#

const FloatFloat{T} = Tuple{T,T} where {T}

FloatFloat{T}(a::T, b::T) where {T} =
    abs(a) < abs(b) ? two_hilo_sum(b, a) : two_hilo_sum(a, b)
FloatFloat(a::T, b::T) where {T} = FloatFloat{T}(a, b)

FloatFloat{T}(p::FloatFloat{T}) where {T} = p
FloatFloat(p::FloatFloat{T}) where {T} = p
FloatFloat{T1}(p::FloatFloat{T2}) where {T1,T2} = (T1(p[1]), T1(p[2]))

"""
    refresh(a::FloatFloat)

resets the canonical form
- a = refine(a)
"""
refresh(a::FloatFloat{T}) where {T} = two_sum(a[1], a[2])

"""
    renorm(a::FloatFloat)

*unchecked assumption*: abs(a[1]) >= abs(a[2])
- a = renorm(a)
"""
renorm(a::FloatFloat{T}) where {T} = two_hilo_sum(a[1], a[2])
