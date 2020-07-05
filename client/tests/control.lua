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
  test.equal(#control:get_children(), 1)
  test.equal(control:get_children()[1], inner_control)
end

test.control.should_have_a_canvas = function()
  local control = Control(0, 0, 100, 100)
  test.is_not_nil(control:get_canvas())
end

test.control.should_have_refresh_methods = function()
  local control = Control(0, 0, 100, 100)
  test.is_not_nil(control.refresh)
end

test.control.should_be_possible_to_clear_children = function()
  local control = Control(0, 0, 100, 100)
  local inner_control = Control(0, 0, 10, 10)
  control:add_control(inner_control)
  test.equal(#control:get_children(), 1)
  control:clear_children()
  test.equal(#control:get_children(), 0)
end

-- test.should_return_pipe_origin
-- test.should_return_pipe_target
-- test.can_only_pipe_to_event_dispatcher_instance

test.parent_should_pipe_all_events_to_child = function()
  local control = Control(0, 0, 100, 100)
  local inner_control = Control(0, 0, 50, 50)

  -- control:pipe_events_to(control, { 'key_repeated', 'mouse_move' })
  control:pipe_all_events_to(inner_control)
  test.equal(#control:get_events_piped(), 11)
end

test.parent_should_pipe_only_two_events = function()
  local control = Control(0, 0, 100, 100)
  local inner_control = Control(0, 0, 50, 50)

  control:add_control(inner_control)
  control:pipe_events_to(control, { 'mouse_move', 'mouse_move' })
  test.equal(#control:get_events_piped(), 2)
end

test.parent_should_pipe_all_events_except_two = function()
  local control = Control(0, 0, 100, 100)
  local inner_control = Control(0, 0, 50, 50)

  control:add_control(inner_control)
  control:pipe_all_events_except(inner_control, { 'mouse_move' })
  test.equal(#control:get_events_piped(), 9)
end

test.summary()