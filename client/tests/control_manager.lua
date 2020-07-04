local test = require 'lib.u-test'
local Control = require 'src.control'
local ControlManager = require 'src.manager.control'

_G['love'] = {
  graphics = {
    newCanvas = function()
    end
  }
}

test.control_manager.should_have_a_list_of_controls = function()
  test.is_not_nil(ControlManager:get_controls())
  test.equal(#ControlManager:get_controls(), 0)
end

test.control_manager.should_add_one_control = function()
  ControlManager:add_control(Control(0, 0, 100, 100))
  test.equal(#ControlManager:get_controls(), 1)
  ControlManager:clear_controls()
end

test.control_manager.should_add_multiple_controls = function()
  local control_a = Control(0, 0, 100, 100)
  local control_b = Control(0, 0, 100, 100)

  ControlManager:add_controls(control_a, control_b)

  local control_list = ControlManager:get_controls()
  test.equal(#control_list, 2)
  test.equal(control_list[2], control_b)
  ControlManager:clear_controls()
end

test.control_manager.should_clear_control_list = function()
  test.is_not_nil(ControlManager.clear)
end

test.control_manager.should_sort_controls = function()
  local controls = {}
  for i = 1, 3 do
    controls[i] = Control(0, 0, 100, 100)
    controls[i].z = 4 - i
  end
  ControlManager:add_controls(unpack(controls))
  test.equal(ControlManager:get_controls()[1].z, controls[3].z)
end

test.summary()