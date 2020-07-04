local Control = require 'src.control'
local FlatButton = Control:extend()

local DEFAULT_BG_COLOR = { 0, 0, 0 }
local DEFAULT_FG_COLOR = { 1, 1, 1 }
local MOUSE_OVER_COLOR = { 1, 0, 1 }

function FlatButton:new(x, y, width, height)
  self.text = ''
  self.background_color = DEFAULT_BG_COLOR
  self.foreground_color = DEFAULT_FG_COLOR

  FlatButton.super.new(self, x, y, width, height)

  self:on('mouse_enter', function()
    self.background_color = MOUSE_OVER_COLOR
  end)
  self:on('mouse_leave', function()
    self.background_color = DEFAULT_BG_COLOR
  end)
end

function FlatButton:get_text()
  return self.text
end

function FlatButton:set_text(new_text)
  self.text = new_text
end

function FlatButton:draw()
  love.graphics.setColor(self.background_color)
  love.graphics.rectangle('fill', 0, 0, self.width, self.height)
  love.graphics.setColor(self.foreground_color)
  love.graphics.print(self.text, 0, 0)
end

return FlatButton