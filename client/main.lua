DEBUG = false

local InputManager = require 'src.manager.input'
local ControlManager = require 'src.manager.control'
local SceneManager = require 'src.manager.scene'

function love.load()
  SceneManager:load('account', 'boot', 'login', 'map', 'test')
  SceneManager:call('test')
end

function love.update(dt)
  SceneManager:update(dt)
  ControlManager:update(dt)
end

function love.draw()
  love.graphics.clear(.28, .57, .89)

  SceneManager:draw()
  ControlManager:draw()
end

function love.keypressed(key, scan_code, is_repeat)
  InputManager:on_key_pressed(key, scan_code, is_repeat)
end

function love.keyreleased(key, scan_code)
  InputManager:on_key_released(key, scan_code)
end

function love.textinput(text)
  InputManager:on_text_input(text)
end

function love.mousereleased(x, y, button)
  InputManager:on_mouse_released(x, y, button)
end

function love.mousepressed(x, y, button)
  InputManager:on_mouse_pressed(x, y, button)
end

function love.mousemoved(x, y, dx, dy, is_touch)
  InputManager:on_mouse_moved(x, y, dx, dy, is_touch)
end