#=
   Some Pair Arithmetic functions need to process the Pairs in one of a few magnitude relative orderings.
   These functions ensure accurate arithmetic calcuation and allow the use of faster error-free addition.

      minmax_abs <-- order by increasing absolute values
      maxmin_abs <-- order by decreasing absolute values

      mnnmxx_abs <-- reorder args by increasing absolute value
      mxxmnn_abs <-- reorder args by decreasing absolute value

      hitolo_abs <-- reorder by decreasing absolute value of first-in-pair 
=#

"""
    a,b = minmax_abs(a, b)
    a,b,c = minmax_abs(a, b, c)

reorder by increasing absolute value
""" minmax_abs

"""
    a,b = maxmin_abs(a, b) 
    a,b,c = maxmin_abs(a, b, c) 

reorder by decreasing absolute value
""" maxmin_abs
      
minmax_abs(a::T, b::T) where {T<:FastFloat} =
    abs(b) < abs(a) ? (b, a) : (a, b)

minmax_abs(a::Pair{T}, b::Pair{T}) where {T<:FastFloat} =
    abs(b[1]) < abs(a[1]) ? (b, a) : (a, b)

function minmax_abs(a::T, b::T, c::T) where {T<:FastFloat}
    b, c = minmax_abs(b, c)
    a, c = minmax_abs(a, c)
    a, b = minmax_abs(a, b)
    return (a, b, c)
end

maxmin_abs(a::T, b::T) where {T<:FastFloat} =
    abs(b) < abs(a) ? (a, b) : (b, a)

maxmin_abs(a::Pair{T}, b::Pair{T}) where {T<:FastFloat} =
    abs(a[1]) < abs(b[1]) ? (b, a) : (a, b)

function maxmin_abs(a::T, b::T, c::T) where {T<:FastFloat}
    b, c = maxmin_abs(b, c)
    a, c = maxmin_abs(a, c)
    a, b = maxmin_abs(a, b)
    return (a, b, c)
end

#=
function mnnmxx_abs(a::Pair{T}, b::Pair{T}) where {T<:FastFloat}
    ahi, alo = a
    bhi, blo = b
    if bhi < ahi
        if 
        ahi, bhi = bhi, ahi
        if blo < alo
            alo, blo = blo, alo
    end
    return Pair{T}(ahi, alo), Pair{T}(bhi, blo)
   
    if abs(a[1]) > abs(b[1])
      
maxmin_abs(a::T, b::T) where {T<:FastFloat} = abs(b) < abs(a) ? (a, b) : (b, a)




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

=#
