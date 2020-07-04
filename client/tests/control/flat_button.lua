local test = require 'lib.u-test'
local FlatButton = require 'src.control.flat_button'

local func = function()
  return true
end

_G['love'] = {
  graphics = {
    newCanvas = func,
    setColor = func,
    rectangle = func,
    setBlendMode = func,
    setCanvas = func
  }
}

test.flat_button.should_initialize_with_rect = function()
  local button = FlatButton(0, 0, 100, 20)
  test.is_not_nil(button)
end

test.flat_button.should_change_background_color = function()
  local button = FlatButton(0, 0, 100, 20)
  button:set_background_color(1, 1, 1)
  button:set_foreground_color(0, 0, 0)
end

test.summary()