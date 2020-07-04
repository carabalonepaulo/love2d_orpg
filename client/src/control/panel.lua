local Control = require 'src.control'
local Panel = Control:extend()
local pp = require 'lib.pp'

function Panel:new(x, y, width, height)
  Panel.super.new(self, x, y, width, height)

  self.background_color = { 0, 0, 0, 1 }
end

function Panel:draw()
  love.graphics.setColor(self.background_color)
  love.graphics.rectangle('fill', 0, 0, self.width, self.height)
  love.graphics.setColor(1, 1, 1, 1)
  Panel.super.draw(self)
end

return Panel