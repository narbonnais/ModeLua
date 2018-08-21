local writer = require("src.writer")

local generator = {}

local function firstToUpper(str)
    return str:sub(1,1):upper()..str:sub(2)
end

local function firstToLower(str)
    return str:sub(1,1):lower()..str:sub(2)
end

function generator.generateArgs(pLstArgs)
    local args = ""
    for i = 1, #pLstArgs do
        local arg = pLstArgs[i]
        args = args .. " " .. arg
        if i < #pLstArgs then
            args = args .. ","
        end
    end
    return args
end

function generator.generateCode(lstClasses)
    print("generating code")
    -- TODO: give choice between singleton, factory, and enum
    for _, class in pairs(lstClasses) do
        local upperClassname = firstToUpper(class.name)
        local lowerClassname = firstToLower(class.name)
        local Fname = "F" .. upperClassname
        local filename = "gen/" .. Fname .. ".lua"
        -- open file
        writer:open(filename)
        -- write content
        local args = generator.generateArgs(class.lstArgs)
        writer:line("local function " .. Fname .. "(" .. args .. ")")
        writer:indent()
        writer:line("local " .. lowerClassname .. " = {}") -- TODO: if parent == nil then {} else parentclassname
        writer:line("")
        writer:line("-- attributes")
        for i = 1, #class.lstAttributes do
            local attribute = class.lstAttributes[i]
            writer:line(lowerClassname .. "." .. attribute)
        end
        writer:line("")
        writer:line("-- methods")
        for i = 1, #class.lstMethods do
            local methodname = class.lstMethods[i]
            local methodargs = {} -- TODO: give this function arguments
            local args = generator.generateArgs(methodargs)
            writer:line("function " .. lowerClassname .. ":" .. methodname .. "(" .. args .. ")")
            writer:line("end")
        end
        writer:line("")
        writer:line("return " .. lowerClassname)
        writer:outdent()
        writer:line("end")
        writer:line("")
        writer:line("return " .. firstToUpper(Fname))
        -- close file
        writer:close()
    end

    print("Code generated")
end

return generator