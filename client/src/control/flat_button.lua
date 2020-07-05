local Control = require 'src.control'
local FlatButton = Control:extend()

local DEFAULT_BG_COLOR = { .3, .3, 0 }
local DEFAULT_FG_COLOR = { 1, 1, 1 }
local MOUSE_OVER_COLOR = { 1, 0, 1 }

local set_color = function(target_table, ...)
  local args = {...}
  if type(args[1]) == 'table' then
    target_table = args[1]
  elseif type(args[1]) == 'number' then
    local one_byte_mode = false
    for i, color_value in ipairs(args) do
      if color_value > 1 then
        one_byte_mode = true
      end
    end

    local color = {}
    for i = 1, #args do
      if one_byte_mode then
        args[i] = args[i] / 255
      end
      table.insert(color, args[i])
    end
    target_table = color
  else
    error('argument error')
  end
end

function FlatButton:new(x, y, width, height)
  self.text = ''
  self.background_color = DEFAULT_BG_COLOR
  self.foreground_color = DEFAULT_FG_COLOR

  FlatButton.super.new(self, x, y, width, height)

  self:on('mouse_enter', function()
    self.background_color = MOUSE_OVER_COLOR
    self:refresh()
  end)
  self:on('mouse_leave', function()
    self.background_color = DEFAULT_BG_COLOR
    self:refresh()
  end)
end

function FlatButton:get_background_color()
  return self.background_color
end

function FlatButton:set_background_color(...)
  local args = {...}
  if type(args[1]) == 'table' then
    self.background_color = args[1]
  elseif type(args[1]) == 'number' then
    local one_byte_mode = false
    for i, color_value in ipairs(args) do
      if color_value > 1 then
        one_byte_mode = true
      end
    end

    local color = {}
    for i = 1, #args do
      if one_byte_mode then
        args[i] = args[i] / 255
      end
      table.insert(color, args[i])
    end
    self.background_color = color
  else
    error('argument error')
  end
end

function FlatButton:get_foreground_color()
  return self.foreground_color
end

function FlatButton:set_foreground_color(...)
  local args = {...}
  if type(args[1]) == 'table' then
    self.foreground_color = args[1]
  elseif type(args[1]) == 'number' then
    local one_byte_mode = false
    for i, color_value in ipairs(args) do
      if color_value > 1 then
        one_byte_mode = true
      end
    end

    local color = {}
    for i = 1, #args do
      if one_byte_mode then
        args[i] = args[i] / 255
      end
      table.insert(color, args[i])
    end
    self.foreground_color = color
  else
    error('argument error')
  end
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

function FlatButton:__tostring()
  return 'FlatButton'
end

return FlatButton