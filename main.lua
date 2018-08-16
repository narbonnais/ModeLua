local Controller = require 'controller.controller'

local c

function love.load()
    c = Controller()
end

function love.update(dt)
    c:update(dt)
end

function love.draw()
    c:draw()
end

function love.keypressed(k)
    c:keypressed(k)
end

function love.mousepressed(x, y, b)
    c:mousepressed(x, y, b)
end