"""
    maxminabs(a, b)
    
- assures abs(a) >= abs(b)
    - where a, b = maxminabs(a, b)
"""
maxminabs(a::T, b::T) where {T} = abs(b) < abs(a) ? (a, b) : (b, a)

"""
    maxminabs(a, b, c)
    
- assures abs(a) >= abs(b) >= abs(c)
    - where a, b, c = maxminabs(a, b, c)
"""
function maxminabs(a::T, b::T, c::T) where {T}
    b, c = maxminabs(b, c)
    a, c = maxminabs(a, c)
    a, b = maxminabs(a, b)
    return (a, b, c)
end

"""
    maxxminnabs(ahi, alo, bhi, blo)
    
- assures abs(ahi) >= abs(bhi) >= abs(alo) >= abs(blo)
    - where ahi, alo, bhi, blo = maxxminnabs(ahi, alo, bhi, blo)
"""
function maxxminnabs(ahi::T, alo::T, bhi::T, blo::T) where {T}
    ahi, bhi = maxminabs(ahi, bhi)
    bhi, alo = maxminabs(bhi, alo)
    alo, blo = maxminabs(alo, blo)
    return (ahi, alo, bhi, blo)
end

"""
    minmaxabs(a, b)
    
- assures abs(a) <= abs(b)
    - where a, b = minmaxabs(a, b)
"""
minmaxabs(a::T, b::T) where {T} = abs(b) < abs(a) ? (b, a) : (a, b)

"""
    minmaxabs(a, b, c)
    
- assures abs(a) <= abs(b) <= abs(c)
    - where a, b, c = minmaxabs(a, b, c)
"""
function minmaxabs(a::T, b::T, c::T) where {T}
    b, c = minmaxabs(b, c)
    a, c = minmaxabs(a, c)
    a, b = minmaxabs(a, b)
    return (a, b, c)
end

