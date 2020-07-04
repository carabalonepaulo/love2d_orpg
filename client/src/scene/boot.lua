local Scene = require 'src.scene'
local BootScene = Scene:extend()

function BootScene:new()
  BootScene.super.new(self)
end

function BootScene:update(dt)
end

function BootScene:draw()
  love.graphics.print('boot')
end

return BootScene