function cpairsum(a::TwoFloat{T}, b::TwoFloat{T}) where {T} =
    TwoFloat{T}(cpairsum(a[1],a[2],b[1],b[2]))
    
function cpairdiff(a::TwoFloat{T}, b::TwoFloat{T}) where {T} =
    TwoFloat{T}(cpairdiff(a[1],a[2],b[1],b[2]))

function cpairprod(a::TwoFloat{T}, b::TwoFloat{T}) where {T} =
    TwoFloat{T}(cpairprod(a[1],a[2],b[1],b[2]))

function cpairdiv(a::TwoFloat{T}, b::TwoFloat{T}) where {T} =
    TwoFloat{T}(cpairdiv(a[1],a[2],b[1],b[2]))

function cpairinv(a::TwoFloat{T}) where {T} =
    TwoFloat{T}(cpairinv(a[1],a[2]))

function cpairinv(a::TwoFloat{T}) where {T} =
    TwoFloat{T}(cpairinv(a[1],a[2]))
                
@inline function cpairsum(ahi::T, alo::T, bhi::T, blo::T) where {T}
    hihi, hilo = two_sum_ordered(ahi, bhi)
    t  = ahi + bhi - hihi
    lo = (t + hilo) + (alo + blo)
    return hi, lo
end

@inline function cpairsum(ahi::T, alo::T, bhi::T, blo::T) where {T}
    hi = ahi + bhi
    t  = ahi + bhi - hi
    lo = t + (alo + blo)
    return hi, lo
end

@inline function cpairdiff(ahi::T, alo::T, bhi::T, blo::T) where {T}
    hi = ahi - bhi
    t  = ahi - bhi - hi
    lo = t + (alo - blo)
    return hi, lo
end

function cpairprod(ahi::T, alo::T, bhi::T, blo::T) where {T}
    hi = a * b
    t  = fma(ahi, bhi, -hi)
    lo = t + (ahi*blo + bhi*alo)
    return hi, lo
end

function cpairinv(bhi::T, blo::T) where {T}
    hi = inv(bhi)
    t  = fma(-hi, bhi, one(T))
    lo = fma(-hi, blo, t) / (bhi + blo)
    return hi, lo
end

function cpairdiv(ahi::T, alo::T, bhi::T, blo::T) where {T}
    hi = ahi / bhi
    t  = fma(-hi, bhi, ahi) + alo
    lo = fma(-hi, blo, t) / (bhi + blo)
    return hi, lo
end

function cpairsqrt(ahi::T, alo::T) where {T}
    hi = sqrt(ahi)
    t  = -fma(hi, hi, -ahi)
    lo = (t + alo) / (2hi)
    return hi, lo
end

Base.:(-)(a::TwoFloat{T}) where {T} = (-a[1], -a[2])
Base.signbit(a::TwoFloat{T}) where {T} = signbit(a[1])
Base.abs(a::TwoFloat{T}) where {T} = signbit(a[1]) ? (abs(a[1]), -a[2]) : a
Base.copysign(a::TwoFloat, b) = signbit(b) ? (signbit(a[1]) ? a : -a) : a
Base.flipsign(a::TwoFloat, b) = signbit(b) ? -a : a

function Base.:(+)(a::TwoFloat{T}, b::TwoFloat{T}) where {T}
    if abs(b[1]) <= abs(a[1])
         ahi, alo = a
         bhi, blo = b
    else
         ahi, alo = b
         bhi, blo = a
    end
    return Base.:(+)(ahi, alo, bhi, blo)
end

function Base.:(+)(ahi::T, alo::T, bhi::T, blo::T)  where {T<:FastFloat}
    t0, t1 = two_hilo_sum(ahi, alo)
    t2, t3 = two_hilo_sum(bhi, blo)
    hi, t4 = two_hilo_sum(t0, t2)
    lo = t4 + (t1 + t3)
    hi, lo = two_hilo_sum(hi, lo)
    
    return TwoFloat{T}((hi, lo))
end


function Base.:(+)(a::TwoFloat{T}, b::TwoFloat{T}) where {T}
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
    return TwoFloat{T}((hi, lo))
end

function Base.:(-)(a::TwoFloat{T}, b::TwoFloat{T}) where {T}
    ahi, alo = a
    bhi, blo = b
    ahi, alo, bhi, blo = mxxmnn_abs(ahi, alo, -bhi, -blo)
    t0, t1 = two_hilo_sum(ahi, alo)
    t2, t3 = two_hilo_sum(bhi, blo)
    hi, t4 = two_hilo_sum(t0, t2)
    lo = t4 + (t1+t3)
    hi, lo = two_hilo_sum(hi, lo)
    return TwoFloat{T}((hi, lo))
end

function Base.:(*)(a::TwoFloat{T}, b::TwoFloat{T}) where {T}
    ahi, alo = a
    bhi, blo = b
    if abs(alo) > abs(bhi)
        alo, bhi = bhi, alo
        alo, blo = maxmin_abs(alo,blo)
    end
    hi = ahi * bhi
    t = fma(ahi, bhi, -hi)
    lo = t + (ahi*blo + bhi*alo)
    return TwoFloat{T}((hi, lo))
end

function Base.:(/)(a::TwoFloat{T}, b::TwoFloat{T}) where {T}
    ahi, alo = a
    bhi, blo = b
    hi = ahi / bhi
    t = fma(-bhi, hi, ahi)
    lo = ((t + alo) - hi*blo) / (bhi + blo)
    return TwoFloat{T}((hi, lo))
end

function Base.inv(b::TwoFloat{T}) where {T}
    bhi, blo = b
    hi = inv(bhi)
    t = fma(-bhi, hi, one(T))
    lo = -(hi * blo) / (bhi + blo)
    return TwoFloat{T}((hi, lo))
end

function Base.sqrt(a::TwoFloat{T}) where {T}
    ahi, alo = a
    hi = sqrt(ahi)
    t = fma(hi, -hi, ahi)
    lo = (t + alo) / (2 * hi)
    return TwoFloat{T}((hi, lo))
end
