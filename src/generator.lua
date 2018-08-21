local writer = require("src.writer")

local generator = {}

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
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
        local classname = "F" .. firstToUpper(class.name)
        local filename = "gen/" .. classname .. ".lua"
        -- open file
        writer:open(filename)
        -- write content
        writer:line("")
        local args = generator.generateArgs(class.lstArgs)
        writer:line("local function " .. classname .. "(" .. args .. ")")
        writer:indent()
        writer:line("local " .. class.name .. " = {}") -- TODO: if parent == nil then {} else parentclassname
        writer:line("")
        writer:line("-- attributes")
        for i = 1, #class.lstAttributes do
            local attribute = class.lstAttributes[i]
            writer:line(classname .. "." .. attribute)
        end
        writer:line("")
        writer:line("-- methods")
        for i = 1, #class.lstMethods do
            local methodname = class.lstMethods[i]
            local methodargs = {} -- TODO: give this function arguments
            local args = generator.generateArgs(methodargs)
            writer:line("function " .. class.name .. ":" .. methodname .. "(" .. args .. ")")
            writer:line("end")
        end
        writer:line("")
        writer:line("return " .. class.name)
        writer:outdent()
        writer:line("end")
        writer:line("")
        writer:line("return " .. firstToUpper(classname))
        -- close file
        writer:close()
    end

    print("Code generated")
end

return generator