# type

"""
    Pair{T} = Tuple{T,T}

Pair(a, b) == (maxabs(a,b), minabs(a,b))
"""
const Pair{T} = Tuple{T,T} where {T}

Pair{T}(a::T, b::T) where {T} = abs(a) < abs(b) ? (b, a) : (a, b)
Pair(a::T, b::T) where {T} = Pair{T}(a, b)

