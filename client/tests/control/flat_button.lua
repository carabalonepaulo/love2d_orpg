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

test.should_accept_color_as_array = function()
  local button = FlatButton(0, 0, 100, 20)
  button:set_background_color { 1, 2, 3 }
  local color = button:get_background_color()
  for i, v in ipairs(color) do
    test.equal(v, i)
  end
end

test.should_accept_multiple_args = function()
  local button = FlatButton(0, 0, 100, 20)
  button:set_background_color(1, 2, 3)
  local color = button:get_background_color()
  for i, v in ipairs(color) do
    test.equal(v, i / 255)
  end
end

test.should_accept_values_between_0_and_1 = function()
  local button  = FlatButton(0, 0, 100, 20)
  button:set_background_color(0, .5, 1)
  local color = button:get_background_color()

  test.equal(color[1], 0)
  test.equal(color[2], .5)
  test.equal(color[3], 1)
end

test.should_accept_values_between_0_and_255 = function()
  local button  = FlatButton(0, 0, 100, 20)
  button:set_background_color(0, 130, 255)
  local color = button:get_background_color()

  test.equal(color[1], 0)
  test.equal(color[2], 130 / 255)
  test.equal(color[3], 255 / 255)
end

test.should_accept_alpha = function()
  local button = FlatButton(0, 0, 100, 20)
  button:set_background_color(.2, .3, .5, 1)
  local color = button:get_background_color()
  test.equal(color[4], 1)
end

test.summary()