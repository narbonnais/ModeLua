local generator = {}

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

local function generator.generateArgs()
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

local function generator.generateCode(lstClasses)
    -- TODO: give choice between singleton, factory, and enum
    for _, class in pairs(lstClasses) do
        local classname = class.titleLabel.text
        local filename = "gen/" .. classname .. ".lua"
        -- open file
        writer:open(filename)
        -- write content
        writer:line("-- private attributes")
        for i = 1, #class.lstPrivateMember do
            local member = class.lstPrivateMember[i]
            writer:line("local " .. member)
        end
        writer:line("")
        writer:line("-- private methods")
        for i = 1, #class.lstPrivateMethod do
            local methodname = class.lstPrivateMethod[i]
            local methodargs = {} -- TODO: give this function arguments
            local args = generateArgs(methodargs)
            writer:line("local function " .. methodname .. "(" .. args .. ")")
            writer:line("end")
        end
        writer:line("")
        local args = generateArgs(class.lstArgs)
        writer:line("local function " .. firstToUpper(classname) .. "(" .. args .. ")")
        writer:indent()
        writer:line("local " .. classname .. " = {}") -- TODO: if parent == nil then {} else parentclassname
        writer:line("")
        writer:line("-- public attributes")
        for i = 1, #class.lstPublicMember do
            local member = class.lstPublicMember[i]
            writer:line(classname .. "." .. member)
        end
        writer:line("")
        writer:line("-- public methods")
        for i = 1, #class.lstPublicMethod do
            local methodname = class.lstPublicMethod[i]
            local methodargs = {} -- TODO: give this function arguments
            local args = generateArgs(methodargs)
            writer:line("function " .. classname .. ":" .. methodname .. "(" .. args .. ")")
            writer:line("end")
        end
        writer:line("")
        writer:line("return " .. classname)
        writer:outdent()
        writer:line("end")
        writer:line("")
        writer:line("return " .. firstToUpper(classname))
        -- close file
        writer:close()
    end

    print("Code generated")
end