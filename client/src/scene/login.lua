local Scene = require 'src.scene'
local LoginScene = Scene:extend()

function LoginScene:new()
  LoginScene.super.new(self)
end

function LoginScene:update(dt)
end

function LoginScene:draw()
  love.graphics.print('Login')
end

return LoginScene