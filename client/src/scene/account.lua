local Scene = require 'src.scene'
local AccountScene = Scene:extend()

function AccountScene:new()
  AccountScene.super.new(self)
end

function AccountScene:update(dt)
end

function AccountScene:draw()
  love.graphics.print('Account')
end

return AccountScene