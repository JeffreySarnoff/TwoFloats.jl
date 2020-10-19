"""
    Pair{T} = Tuple{T,T}

Pair(a, b) == (maxabs(a,b), minabs(a,b))
"""
const Pair{T} = Tuple{T,T} where {T}

Pair{T}(a::T, b::T) where {T} = abs(a) < abs(b) ? two_hilo_sum(b, a) : two_hilo_sum(a, b)
Pair(a::T, b::T) where {T} = Pair{T}(a, b)

Pair{T}(p::Pair{T}) where {T} = p
Pair(p::Pair{T}) where {T} = p
Pair{T1}(p::Pair{T2}) where {T1,T2} = (T1(p[1]), T1(p[2]))


refine(a::Pair{T}) where {T} = two_sum(a[1], a[2])

"""
    renorm(a::Pair)

*unchecked assumption*: abs(a[1]) >= abs(a[2])
"""
renorm(a::Pair{T}) where {T} = two_hilo_sum(a[1], a[2])
