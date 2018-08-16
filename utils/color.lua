local function Color(pr, pg, pb, pa)
    local r = pr or 1
    local g = pg or 1
    local b = pb or 1
    local a = pa or 1
    local color = {r, g, b, a}
    return color
end

return Color