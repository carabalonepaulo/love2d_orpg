local ControlManager = require 'src.manager.control'
local UserInterfaceManager = require 'src.manager.user_interface'
local Panel = require 'src.control.panel'
local FlatButton = require 'src.control.flat_button'
local Scene = require 'src.scene'
local TestScene = Scene:extend()

local pp = require 'lib.pp'

function TestScene:new()
  TestScene.super.new(self)
  local control = UserInterfaceManager:load_controls('assets/ui/test_panel.xml')
  local button = control:get_children()[1]

  control:pipe_all_events_to(button)
  button:on('mouse_enter', function() print('enter child') end)

  ControlManager:add_control(control)
  ControlManager:get_input_focus(control)
end

function TestScene:update(dt)
end

function TestScene:draw()
  love.graphics.print('Test')
end

return TestScene