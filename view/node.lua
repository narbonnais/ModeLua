local UID = require 'src.utils.uid'

local function append(self, node)
    -- check if self owns the node
    for local i = 1, #self.children do
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
    for local i = #self.children, 1, -1 do
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
    for local i = #self.children, 1, -1 do
        self.children[i]:update(dt)
    end
end

local function draw(self, dt)
    self:drawChildren()
end

local function drawChildren(self, dt)
    for local i = 1, #self.children do
        self.children[i]:draw(dt)
    end
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
    node.parent
    node.append = append
    node.setParent = setParent
    node.removeChild = node.removeChild

    -- update
    node.update = update
    node.updateChildren = updateChildren

    -- draw
    node.draw = draw
    node.drawChildren = drawChildren

    return node
end

return Node