function math.round(x)
    return math.floor(x + 0.5)
end

function math.lerp(from, to, weight)
    return from + (to - from) * weight
end

function math.inverselerp(from, to, value)
    return (value - from) / (to - from)
end

function math.remapRange(value, istart, istop, ostart, ostop)
    return math.lerp(ostart, ostop, math.inverselerp(istart, istop, value))
end
