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
    draw = func,
    print = func
  },
  filesystem = {}
}

test.should_load_controls_from_xml = function()
  _G['love'].filesystem.read = function(...)
    return [[
      <panel x="0" y="0" width="100" height="50" />
    ]]
  end
  local control = UserInterfaceManager:load_controls('')
  test.equal(control:get_x(), 0)
  test.equal(control:get_y(), 0)
  test.equal(control:get_width(), 100)
  test.equal(control:get_height(), 50)

  _G['love'].filesystem.read = function(...)
    return [[
      <panel x="0" y="0" width="100" height="50">
        <button text="shit" x="0" y="0" width="100" height="500" />
      </panel>
    ]]
  end
  local control = UserInterfaceManager:load_controls('')
  test.equal(#control:get_children(), 1)
  test.equal(control:get_children()[1].text, "shit")
  test.equal(control:get_children()[1].width, 100)
end

test.summary()