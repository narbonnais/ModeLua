local function execute(self)
    self.func(self.caller, self.params)
end

local function Callback(caller, func, params)
    local cb = {}
    
    cb.caller = caller
    cb.func = func
    cb.params = params

    cb.execute = execute

    return cb
end

return Callback