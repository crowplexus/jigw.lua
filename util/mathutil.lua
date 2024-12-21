function math.wrapvalue(value, min, max)
    local tmax = max + 1 -- so it actually goes up to the max, temporary prob
    return (value - min) % (tmax - min) + min
end

function math.clampvalue(value, min, max)
    return math.min(math.max(value, min), max)
end