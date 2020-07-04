local test = require 'lib.u-test'
local UserInterfaceManager = require 'src.manager.user_interface'
local func = function() return true end

_G['love'] = {
  graphics = {
    newCanvas = func,
    setColor = func,
    rectangle = func,
    setBlendMode = func,
    setCanvas = func,
    draw = func
  },
  filesystem = {
  }
}

test.should_load_controls_from_xml = function()
  local control = UserInterfaceManager:load_controls([[
    <panel x="0" y="0" width="100" height="50" />
  ]])
  test.equal(control:get_x(), 0)
  test.equal(control:get_y(), 0)
  test.equal(control:get_width(), 100)
  test.equal(control:get_height(), 50)

  local control = UserInterfaceManager:load_controls([[
    <panel x="0" y="0" width="100" height="50">
      <button text="shit" x="0" y="0" width="100" height="500" />
    </panel>
  ]])
  test.equal(#control.controls, 1)
  test.equal(control.controls[1].text, "shit")
  test.equal(control.controls[1].width, 100)
end

test.summary()