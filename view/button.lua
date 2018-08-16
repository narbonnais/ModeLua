local Panel = require 'view.panel'

local function onClick(self, x, y)
    if self:hovered(x,y) then
        if self.callback then
            self.callback:execute()
        end
        return true
    end
    return false
end

local function setCallback(callback)
    self.callback = callback
end

local function Button(x, y, w, h, callback)
    local btn = Panel(x, y, w, h, callback)

    btn.callback = callback
    btn.onClick = onClick

    return btn
end

return Button