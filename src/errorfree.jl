#=
    contents

hi, lo = two_sum(a, b)
hi, lo = two_sum(a, b, c)
hi, lo = two_hilo_sum(a, b)
hi, lo = two_lohi_sum(a, b)

hi, lo = two_diff(a, b)
hi, lo = two_hilo_diffa, b)
hi, lo = two_lohi_diffa, b)

hi, lo = two_prod(a, b)
hi, lo = two_prod(a, b, c)

=#

"""
    two_sum(a, b)

Computes `hi = fl(a+b)` and `lo = err(a+b)`.
- Unchecked Precondition: !(isinf(a) | isinf(b))
"""
@inline function two_sum(a::T, b::T) where {T}
    hi = a + b
    db = b - (hi - a)
    da = a - (hi - b)
    lo = da + db
    return hi, lo
end

"""
    two_sum_ordered(a, b)

Computes `hi = fl(a+b)` and `lo = err(a+b)`.
"""
@inline function two_sum_ordered(a::T, b::T) where {T}
    if abs(a) < abs(b)
        a, b = b, a
    end    
    hi = a + b
    lo = b - (hi - a)
    return hi, lo
end

"""
   two_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `lo = err(a+b+c)`.
"""
function two_sum(a::T, b::T, c::T) where {T}
    t0, t1 = two_sum(b, c) 
    hi, t0 = two_sum(a, t0)
    t0 += t1
    hi, lo = two_hilo_sum(hi, t0)
    return hi, lo
end


# arguments sorted by magnitude

"""
    two_hilo_sum(a, b)
*unchecked* requirement `|a| ≥ |b|`
Computes `hi = fl(a+b)` and `lo = err(a+b)`.
"""
@inline function two_hilo_sum(a::T, b::T) where {T}
    hi = a + b
    lo = b - (hi - a)
    return hi, lo
end

"""
    two_lohi_sum(a, b)

*unchecked* requirement `|b| ≥ |a|`
Computes `hi = fl(a+b)` and `lo = err(a+b)`.
"""
@inline function two_lohi_sum(a::T, b::T) where {T}
    hi = b + a
    lo = a - (hi - b)
    return hi, lo
end

"""
    two_diff(a, b)
Computes `s = fl(a-b)` and `e = err(a-b)`.
- Unchecked Precondition: !(isinf(a) | isinf(b))
"""
@inline function two_diff(a::T, b::T) where {T}
    hi = a - b
    db = (a - hi) - b
    da = a - (hi + b)
    lo = da + db
    return hi, lo
end

"""
    two_hilo_diff(a, b)
    
*unchecked* requirement `|a| ≥ |b|`
Computes `hi = fl(a-b)` and `lo = err(a-b)`.
"""
@inline function two_hilo_diff(a::T, b::T) where {T}
    hi = a - b
    lo = (a - hi) - b
    hi, lo
end

"""
    two_lohi_diff(a, b)
    
*unchecked* requirement `|b| ≥ |a|`
Computes `hi = fl(a-b)` and `lo = err(a-b)`.
"""
@inline function two_lohi_diff(a::T, b::T) where {T}
    hi = b - a
    lo = (b - hi) - a
    hi, lo
end

"""
    two_prod(a, b)

Computes `hi = fl(a*b)` and `lo = fl(err(a*b))`.
- Unchecked Precondition: !(isinf(a) | isinf(b))
"""
@inline function two_prod(a::T, b::T) where {T}
    hi = a * b
    lo = fma(a, b, -hi)
    hi, lo
end

"""
   two_prod(a, b, c)
    
Computes `hi = fl(a*b*c)` and `lo = err(a*b*c)`.
"""
function two_prod(a,b,c)
    a, b, c = maxminabs(a, b, c)
    cbhi, cblo = two_prod(c, b)
    hi, cba = two_prod(cbhi, a)
    lo = fma(a, cblo, cba)
    return hi, lo
end
