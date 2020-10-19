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
    a, b, c = minmaxabs(a, b, c)
    t,h = two_prod(c,b)
    x,e = two_prod(t,a)
    y = fma(a, h, e)
    return x, y
end
