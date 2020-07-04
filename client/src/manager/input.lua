local EventDispatcher = require 'src.event_dispatcher'
local Object = require 'lib.object'
local InputManager = Object:extend()

function InputManager:new()
  self.dispatcher = EventDispatcher {
    'key_repeated',
    'key_pressed',
    'key_released',

    'text_input',

    'mouse_pressed',
    'mouse_released',
    'mouse_move',

    strict = true
  }
end

function InputManager:get_events()
  return self.dispatcher.events
end

function InputManager:on(event, callback)
  self.dispatcher:on(event, callback)
end

function InputManager:remove_from(event, callback)
  self.dispatcher:remove_from(event, callback)
end

function InputManager:propagate(dispatcher)
  self.dispatcher:propagate(dispatcher)
end

function InputManager:on_key_pressed(key, scan_code, is_repeated)
  if is_repeated then
    self.dispatcher:dispatch('key_repeated', key, scan_code)
  else
    self.dispatcher:dispatch('key_pressed', key, scan_code)
  end
end

function InputManager:on_key_released(key, scan_code)
  self.dispatcher:dispatch('key_released', key, scan_code)
end

function InputManager:on_text_input(char)
  self.dispatcher:dispatch('text_input', char)
end

function InputManager:on_mouse_pressed(x, y, button)
  self.dispatcher:dispatch('mouse_pressed', x, y, button)
end

function InputManager:on_mouse_released(x, y, button)
  self.dispatcher:dispatch('mouse_released', x, y, button)
end

function InputManager:on_mouse_moved(x, y, dx, dy, is_touched)
  self.dispatcher:dispatch('mouse_move', x, y, dx, dy, is_touched)
end

return InputManager()