#=

   Some Pair Arithmetic functions need to process the Pairs in one of a few magnitude relative orderings.
   These functions ensure accurate arithmetic calcuation and allow the use of faster error-free addition.

      maxmin_abs <-- reorder by decreasing absolute value
      minmax_abs <-- reorder by increasing absolute value

      hitolo_abs <-- reorder by decreasing absolute value of first-in-pair 
      mxxmnn_abs <-- reorder pairwise by decreasing absolute value
      
=#

"""
    minmax_abs(a, b)
    
- assures abs(a) <= abs(b)
    - where a, b = minmax_abs(a, b)
"""
minmax_abs(a::T, b::T) where {T} = abs(b) < abs(a) ? (b, a) : (a, b)

"""
    minmax_abs(a, b, c)
    
- assures abs(a) <= abs(b) <= abs(c)
    - where a, b, c = minmax_abs(a, b, c)
"""
function minmax_abs(a::T, b::T, c::T) where {T}
    b, c = minmax_abs(b, c)
    a, c = minmax_abs(a, c)
    a, b = minmax_abs(a, b)
    return (a, b, c)
end

"""
    maxmin_abs(a, b)
    
- assures abs(a) >= abs(b)
    - where a, b = maxmin_abs(a, b)
"""
maxmin_abs(a::T, b::T) where {T} = abs(b) < abs(a) ? (a, b) : (b, a)

"""
    maxmin_abs(a, b, c)
    
- assures abs(a) >= abs(b) >= abs(c)
    - where a, b, c = maxmin_abs(a, b, c)
"""
function maxmin_abs(a::T, b::T, c::T) where {T}
    b, c = maxmin_abs(b, c)
    a, c = maxmin_abs(a, c)
    a, b = maxmin_abs(a, b)
    return (a, b, c)
end

"""
    hitolo_abs(ahi, alo, bhi, blo)
    
- assures abs(ahi) >= abs(bhi) 
    - where ahi, alo, bhi, blo = mxmn_abs(ahi, alo, bhi, blo)
"""
function hi2lo_abs(ahi, alo, bhi, blo)
      if abs(ahi) < abs(bhi)
         bhi, blo, ahi, alo
      else
         ahi, alo, bhi, blo
      end
end   

"""
    mxxmnn_abs(ahi, alo, bhi, blo)
    
- assures abs(ahi) >= abs(bhi) >= abs(alo) >= abs(blo)
    - where ahi, alo, bhi, blo = mxxmnn_abs(ahi, alo, bhi, blo)
"""
function mxxmnn_abs(ahi::T, alo::T, bhi::T, blo::T) where {T}
    ahi, bhi = maxmin_abs(ahi, bhi)
    bhi, alo = maxmin_abs(bhi, alo)
    alo, blo = maxmin_abs(alo, blo)
    return (ahi, alo, bhi, blo)
end


