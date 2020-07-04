local test = require 'lib.u-test'
local Control = require 'src.control'

local func = function()
  return true
end

_G['love'] = {
  graphics = {
    newCanvas = func,
    setColor = func,
    rectangle = func,
    setBlendMode = func,
    setCanvas = func,
    draw = func
  }
}

test.control.can_use_a_table_with_options_on_init = function()
  local control = Control {
    x = 1,
    y = 2,
    width = 100,
    height = 120,
  }
  test.equal(control:get_x(), 1)
  test.equal(control:get_y(), 2)
  test.equal(control:get_width(), 100)
  test.equal(control:get_height(), 120)
end

test.control.should_not_accept_overwrite_functions_on_init = function()
  test.error_raised(function()
    Control { on = function() return false end }
  end, 'argument error')
end

test.control.need_four_args_to_init = function()
  test.error_raised(Control, 'argument error')
end

test.control.should_have_a_parent_prop_when_nested = function()
  local control_parent = Control(0, 0, 100, 100)
  local control_child = Control(0, 0, 50, 50)
  control_parent:add_control(control_child)

  test.is_not_nil(control_child.parent)
end

test.control.should_add_one_nested_item = function()
  local control = Control(0, 0, 100, 100)
  local inner_control = Control(0, 0, 10, 10)
  control:add_control(inner_control)
  test.equal(#control:get_inner_controls(), 1)
  test.equal(control:get_inner_controls()[1], inner_control)
end

test.control.should_have_a_canvas = function()
  local control = Control(0, 0, 100, 100)
  test.is_not_nil(control:get_canvas())
end

test.control.should_have_refresh_methods = function()
  local control = Control(0, 0, 100, 100)
  test.is_not_nil(control.refresh)
end

test.control.should_be_possible_to_clear_inner_controls = function()
  local control = Control(0, 0, 100, 100)
  local inner_control = Control(0, 0, 10, 10)
  control:add_control(inner_control)
  test.equal(#control:get_inner_controls(), 1)
  control:clear_inner_controls()
  test.equal(#control:get_inner_controls(), 0)
end

test.summary()