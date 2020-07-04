local EventDispatcher = require 'src.event_dispatcher'
local InputManager = require 'src.manager.input'
local ControlManager = EventDispatcher:extend()

local find = function(list, value)
  for i, v in ipairs(list) do
    if v == value then
      return i
    end
  end
  return nil
end

local each = function(list, callback)
  for i, v in ipairs(list) do
    callback(v, i)
  end
end

function ControlManager:new()
  ControlManager.super.new(self, {
    'key_repeated',
    'key_pressed',
    'key_released',
    
    'text_input',

    'mouse_pressed',
    'mouse_released',
    'mouse_move',

    strict = true
  })

  self.controls = {}
  self.focus = {}

  for ev, _ in pairs(InputManager:get_events()) do
    InputManager:on(ev, function(...)
      local args = {...}
      each(self.focus, function(control)
        control:dispatch(ev, unpack(args))
      end)
      self:dispatch(ev, ...)
    end)
  end
end

function ControlManager:clear_controls()
  self.controls = {}
end

function ControlManager:get_controls()
  return self.controls
end

function ControlManager:add_control(control)
  control:refresh()
  table.insert(self.controls, control)
  self:sort_controls()
end

function ControlManager:add_controls(...)
  local controls = {...}
  for _, control in ipairs(controls) do
    control:refresh()
    self:propagate(control)
    table.insert(self.controls, control)
  end
  self:sort_controls()
end

function ControlManager:remove_control(control)
  local index = find(self.controls, control)
  if index then
    table.remove(self.controls, index)
  end
end

function ControlManager:update(dt)
  for i, control in ipairs(self.controls) do
    if control.active then
      control:update(dt)
    end
  end
end

function ControlManager:sort_controls()
  table.sort(self.controls, function(a, b)
    return a.z < b.z
  end)
end

function ControlManager:draw()
  for i, control in ipairs(self.controls) do
    if control.visible then
      love.graphics.setBlendMode('alpha', 'premultiplied')
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(control:get_canvas(), control:get_x(), control:get_y())
      love.graphics.setBlendMode('alpha')
    end
  end
end

function ControlManager:get_input_focus(control)
  table.insert(self.focus, control)
end

function ControlManager:release_input_focus(control)
  local index = find(self.focus, control)
  if index then
    table.remove(self.focus, control)
  end
end

return ControlManager()