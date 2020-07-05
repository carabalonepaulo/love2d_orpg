--[[

get_x
get_y
get_z
get_width
get_height
get_canvas
get_children

set_x
set_y
set_z
set_width
set_height

is_visible
]]
local EventDispatcher = require 'src.event_dispatcher'
local Control = EventDispatcher:extend()
local pp = require 'lib.pp'

local contains = function(list, value)
  for k, v in pairs(list) do
    if v == value then
      return true
    end
  end
  return false
end

local except = function(list, exceptions)
  local new_list = {}
  for k, v in pairs(list) do
    if not contains(exceptions, v) then
      table.insert(new_list, v)
    end
  end
  return new_list
end

local find = function(list, item)
  local index = 0
  for i, v in ipairs() do
    if v == item then
      return index
    end
  end
  return nil
end

function Control:new(x, y, width, height)
  Control.super.new(self, {
    'key_repeated',
    'key_pressed',
    'key_released',
    'text_input',
    'mouse_pressed',
    'mouse_released',
    'mouse_move',
    'mouse_enter',
    'mouse_leave',

    'refresh',
    'destroy',

    strict = true
  })

  assert(x, 'argument error')
  if type(x) == 'table' then
    for k, v in pairs(x) do
      if type(v) == 'function' then
        error('argument error')
      end
      self[k] = v
    end
  else
    assert(y, 'argument error')
    assert(width, 'argument error')
    assert(height, 'argument error')

    self.x = x
    self.y = y
    self.width = width
    self.height = height
  end

  self.z = 0
  self.controls = {}
  self.canvas = love.graphics.newCanvas(width, height)
  self.visible = true
  self.active = false
  self.mouse_inside = false
  self.pipe = {}

  self:on('mouse_move', function(x, y)
    local mouse_over = x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
    if not self.mouse_inside then
      if mouse_over then
        self.mouse_inside = true
        self:dispatch('mouse_enter')
      end
    else
      if not mouse_over then
        self.mouse_inside = false
        self:dispatch('mouse_leave')
      end
    end
  end)
end

function Control:get_x()
  return self.x
end

function Control:set_x(new_x)
  self.x = new_x
end

function Control:get_y()
  return self.y
end

function Control:set_y(new_y)
  self.y = new_y
end

function Control:get_z()
  return self.z
end

function Control:set_z(new_z)
  self.z = new_z
end

function Control:get_width()
  return self.width
end

function Control:set_width(new_width)
  self.width = new_width
end

function Control:get_height()
  return self.height
end

function Control:set_height(new_height)
  self.height = new_height
end

function Control:get_canvas()
  return self.canvas
end

function Control:get_children()
  return self.controls
end

function Control:get_pipe_origin()
  return self.pipe.from
end

function Control:get_pipe_target()
  return self.pipe.to
end

function Control:get_events_piped()
  return self.pipe.events or {}
end

function Control:get_pipe()
  return self.pipe
end

function Control:is_visible()
  return self.visible
end

function Control:pipe_events_to(control, events)
  self.pipe = { to = control, events = events }
  control.pipe = { from = self, events = events }
  control.pipe.callback_tacker = {}

  for i, event_name in ipairs(events) do
    local callback = function(...)
      control:dispatch(event_name, ...)
    end
    table.insert(control.pipe.callback_tacker, callback)
    self:on(event_name, callback)
  end
end

function Control:pipe_all_events_to(control)
  self:pipe_events_to(control, self:get_event_name_list())
end

function Control:pipe_all_events_except(control, exception_list)
  local events = except(
    self:get_event_name_list(),
    { 'mouse_move', 'key_released' }
  )
  self:pipe_events_to(control, events)
end

function Control:add_control(control)
  control.parent = self
  control.x = self.x + control.x
  control.y = self.y + control.y
  control.z = self.z + control.z
  table.insert(self.controls, control)

  if control:is_visible() then
    self:refresh()
  end

  local pipe = control:get_pipe()
  if pipe.from then
    for i, event_name in ipairs(pipe.events) do
      for callback_index, callback in ipairs(pipe.callback_tacker) do
        table.remove(pipe.from.events[event_name], callbac_index)
      end
    end
  end
end

function Control:remove_control(control)
  local index = find(self.controls, control)
  if index then
    table.remove(self.controls, control)
  end

  if control:is_visible() then
    self:refresh()
  end
end

function Control:update(dt)
end

function Control:draw()
  if DEBUG then
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('line', 0, 0, self.width, self.height)
  end
end

function Control:refresh()
  love.graphics.setCanvas(self:get_canvas())
  self:draw()
  if #self.controls > 0 then
    for i, control in pairs(self.controls) do
      love.graphics.draw(control:get_canvas(), control:get_x(), control:get_y())
    end
  end
  love.graphics.setCanvas()
  self:dispatch('refresh')
end

function Control:clear_children()
  for i, child in ipairs(self:get_children()) do
    child:dispatch('destroy')
  end
  self.controls = {}
end

return Control