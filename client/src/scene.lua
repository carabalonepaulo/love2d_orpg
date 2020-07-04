local Object = require 'lib.object'
local Scene = Object:extend()

function Scene:new()
end

function Scene:update(dt)
  error('function not implemented')
end

function Scene:draw()
  error('function not implemented')
end

return Scene