Base.:(-)(a::Pair) = (-a[1], -a[2])
Base.signbit(a::Pair) = signbit(a[1])
Base.abs(a::Pair) = signbit(a[1]) ? (abs(a[1]), -a[2]) : a
Base.copysign(a::Pair, b) = signbit(b) ? (signbit(a[1]) ? a : -a) : a
Base.flipsign(a::Pair, b) = signbit(b) ? -a : a

function Base.:(+)(a::Pair{T}, b::Pair{T}) where {T}
    if abs(b[1]) <= abs(a[1])
         ahi, alo = a
         bhi, blo = b
    else
         ahi, alo = b
         bhi, blo = a
    end
    return Base.:(+)(ahi, alo, bhi, blo)
end

function Base.:(+)(ahi::T, alo::T, bhi::T, blo::T)  where {T}
    t0, t1 = two_hilo_sum(ahi, alo)
    t2, t3 = two_hilo_sum(bhi, blo)
    hi, t4 = two_hilo_sum(t0, t2)
    lo = t4 + (t1 + t3)
    hi, lo = two_hilo_sum(hi, lo)
    
    return Pair((hi, lo))
end


function Base.:(+)(a::Pair, b::Pair)
    if abs(b[1]) <= abs(a[1])
         ahi, alo = a
         bhi, blo = b
    else
         ahi, alo = b
         bhi, blo = a
    end
    t0, t1 = two_hilo_sum(ahi, alo)
    t2, t3 = two_hilo_sum(bhi, blo)
    hi, t4 = two_hilo_sum(t0, t2)
    lo = t4 + (t1+t3)
    hi, lo = two_hilo_sum(hi, lo)
    return Pair((hi, lo))
end

#=
function Base.:(+)(a::Pair, b::Pair)
    ahi, alo = a
    bhi, blo = b
    # ahi, alo, bhi, blo = mxxmnn_abs(ahi, alo, bhi, blo)
    ahi, alo, bhi, blo = hitolo_abs(ahi, alo, bhi, blo)
    t0, t1 = two_hilo_sum(ahi, alo)
    t2, t3 = two_hilo_sum(bhi, blo)
    hi, t4 = two_hilo_sum(t0, t2)
    lo = t4 + (t1+t3)
    hi, lo = two_hilo_sum(hi, lo)
    return Pair((hi, lo))
end
=#

function Base.:(-)(a::Pair, b::Pair)
    ahi, alo = a
    bhi, blo = b
    ahi, alo, bhi, blo = mxxmnn_abs(ahi, alo, -bhi, -blo)
    t0, t1 = two_hilo_sum(ahi, alo)
    t2, t3 = two_hilo_sum(bhi, blo)
    hi, t4 = two_hilo_sum(t0, t2)
    lo = t4 + (t1+t3)
    hi, lo = two_hilo_sum(hi, lo)
    return Pair((hi, lo))
end

function Base.:(*)(a::Pair, b::Pair)
    ahi, alo = a
    bhi, blo = b
    if abs(alo) > abs(bhi)
        alo, bhi = bhi, alo
        alo, blo = maxmin_abs(alo,blo)
    end
    hi = ahi * bhi
    t = fma(ahi, bhi, -hi)
    lo = t + (ahi*blo + bhi*alo)
    return Pair((hi, lo))
end

function Base.:(/)(a::Pair, b::Pair)
    ahi, alo = a
    bhi, blo = b
    hi = ahi / bhi
    t = fma(-bhi, hi, ahi)
    lo = ((t + alo) - hi*blo) / (bhi + blo)
    return Pair((hi, lo))
end

function Base.inv(b::Pair{T}) where {T}
    bhi, blo = b
    hi = inv(bhi)
    t = fma(-bhi, hi, one(T))
    lo = -(hi * blo) / (bhi + blo)
    return Pair((hi, lo))
end

function Base.sqrt(a::Pair)
    ahi, alo = a
    hi = sqrt(ahi)
    t = fma(hi, -hi, ahi)
    lo = (t + alo) / (2 * hi)
    return Pair((hi, lo))
end
