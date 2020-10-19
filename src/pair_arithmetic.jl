Base.:(-)(a::Pair) = (-a[1], -a[2])
Base.signbit(a::Pair) = signbit(a[1])
Base.abs(a::Pair) = signbit(a[1]) ? (abs(a[1]), -a[2]) : a
Base.copysign(a::Pair, b) = signbit(b) ? (signbit(a[1]) ? a : -a) : a
Base.flipsign(a::Pair, b) = signbit(b) ? -a : a

function Base.:(+)(a::Pair, b::Pair)
    ahi, alo = a
    bhi, blo = b
    ahi, alo, bhi, blo = maxxminnabs(ahi, alo, bhi, blo)
    t0, t1 = two_hilo_sum(ahi, alo)
    t2, t3 = two_hilo_sum(bhi, blo)
    hi, t4 = two_hilo_sum(t0, t2)
    lo = t4 + (t1+t3)
    hi, lo = two_hilo_sum(hi, lo)
    return Pair((hi, lo))
end

function Base.:(-)(a::Pair, b::Pair)
    ahi, alo = a
    bhi, blo = b
    ahi, alo, bhi, blo = maxxminnabs(ahi, alo, -bhi, -blo)
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
        alo, blo = maxminabs(alo,blo)
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

#=
    These function definitions appear on page 4 of "Faithfully Rounded Floating-point Computations"
=#
#=
function pair_sum(ae::Pair, bf::Pair)
    a, e = ae
    b, f = bf
    hi = a + b
    t = (a + b) - hi      # reference wants to use TwoSum here??
    lo = t + (e + f)
    return Pair((hi, lo))
end
 
function pair_diff(ae::Pair, bf::Pair)
    a, e = ae
    b, f = bf
    hi = a - b
    t = (a - b) - hi      # reference wants to use TwoSum here??
    lo = t + (e - f)
    return Pair((hi, lo))
end
 
function pair_prod(ae::Pair, bf::Pair)
    a, e = ae
    b, f = bf
    hi = a * b
    t = fma(a, b, -hi)
    lo = t + (a*f + b*e)
    return Pair((hi, lo))
end

function pair_div(ae::Pair, bf::Pair)
    a, e = ae
    b, f = bf
    hi = a / b
    t = fma(-b, hi, a)
    lo = ((t + e) - hi*f) / (b + f)
    return Pair((hi, lo))
end

function pair_sqrt(ae::Pair)
    a, e = ae
    hi = sqrt(a)
    t = fma(hi, -hi, a)
    lo = (t + e) / (hi + hi)
    return Pair((hi, lo))
end
=#
