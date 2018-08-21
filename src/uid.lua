local uid = 0

local function UID() 
    uid = uid + 1 
    return uid 
end

return UID