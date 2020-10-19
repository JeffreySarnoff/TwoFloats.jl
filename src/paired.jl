# type

"""
    Pair{T} = Tuple{T,T}

Pair(a, b) == (maxabs(a,b), minabs(a,b))
"""
const Pair{T} = Tuple{T,T} where {T}

Pair{T}(a::T, b::T) where {T} = abs(a) < abs(b) ? (b, a) : (a, b)
Pair(a::T, b::T) where {T} = Pair{T}(a, b)

Pair{T}(ab::Pair{T}) where {T} = ab
Pair(ab::Pair{T}) where {T} = ab
Pair{T1}(ab::Pair{T2}) where {T1,T2} = (T1(a), T1(b))
