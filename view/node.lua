local UID = require 'utils.uid'

local function append(self, node)
    -- check if self owns the node
    for i = 1, #self.children do
        local child = self.children[i]

        if child.uid == node.uid then
            print("Node : append - attempting to append owned child")
            return
        end
    end

    node:setParent(self)
    table.insert(self.children, node)
end

local function setParent(self, parent)
    -- if node has a parent, remove it
    if self.parent ~= nil then
        self.parent:removeChild(self)
    end
    self.parent = parent
    self.X = parent.X + self.x
    self.Y = parent.Y + self.y
end

local function removeChild(self, node)
    for i = #self.children, 1, -1 do
        local child = self.children[i]
        if child.uid == node.uid then
            table.remove(self.children, i)
            node.X = x
            node.Y = y
            return
        end        
    end
    print("Node : removeChild - node to remove was not find")
end

local function update(self, dt)
    self:updateChildren(dt)
end

local function updateChildren(self, dt)
    for i = #self.children, 1, -1 do
        self.children[i]:update(dt)
    end
end

local function draw(self, dt)
    self:drawChildren()
end

local function drawChildren(self, dt)
    for i = 1, #self.children do
        self.children[i]:draw(dt)
    end
end

-- boolean onClick(self, x, y) perform action if component is clicked
-- and returns true, false if no component was clicked
local function onClick(self, x, y)
    local childrenClicked = self:onChildrenClick(x, y)
    return childrenClicked
end

local function onChildrenClick(self, x, y)
    for i = 1, #self.children do
        local clicked = self.children[i]:onClick(x, y)
        if clicked then return true end
    end
    return false
end

local function Node(x, y)
    local node = {}

    -- unique id
    node.uid = UID()

    -- relative location
    node.x = x
    node.y = y

    -- absolute location
    node.X = x
    node.Y = y

    -- relationships
    node.children = {}
    node.parent = nil
    node.append = append
    node.setParent = setParent
    node.removeChild = node.removeChild

    -- update
    node.update = update
    node.updateChildren = updateChildren

    -- draw
    node.draw = draw
    node.drawChildren = drawChildren

    -- action
    node.onClick = onClick
    node.onChildrenClick = onChildrenClick

    return node
end

return Node