#=
    These function definitions appear on page 4 of "Faithfully Rounded Floating-point Computations"
=#

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
    t = fma(-b, c, a)
    lo = ((t + e) - c*f) / (b + f)
    return Pair((hi, lo))
end

function pair_sqrt(ae::Pair)
    a, e = ae
    hi = sqrt(a)
    t = fma(hi, -hi, a)
    lo = (t + e) / (hi + hi)
    return Pair((hi, lo))
end

