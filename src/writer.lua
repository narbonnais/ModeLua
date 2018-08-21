local writer = {}

writer.file = nil
writer.indents = 0

function writer:indent()
    self.indents = self.indents + 1
end
function writer:outdent()
    self.indents = self.indents - 1
    if self.indents < 0 then
        self.indents = 0
    end
end
function writer:open(pFilename)
    if self.file ~= nil then
        self.file:close()
        self.file = nil
    end
    self.file = io.open(pFilename, "w")
end
function writer:line(pLine)
    local line = ""
    for i = 0, self.indents - 1 do
        line = line .. "\t"
    end
    line = line .. pLine
    line = line .. "\n"
    if self.file ~= nil then
        self.file:write(line)
    end
end
function writer:close()
    if self.file ~= nil then
        self.file:close()
        self.file = nil
    end
end

return writer