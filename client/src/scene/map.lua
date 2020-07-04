local Scene = require 'src.scene'
local MapScene = Scene:extend()

function MapScene:new()
  MapScene.super.new(self)
end

function MapScene:update(dt)
end

function MapScene:draw()
  love.graphics.print('Map')
end

return MapScene