local Object = require 'lib.object'
local SceneManager = Object:extend()

function SceneManager:new()
  self.scene = nil
  self.scenes = {}
  self.stack = {}
end

function SceneManager:get_current()
  return self.scene
end

function SceneManager:load(...)
  for i, scene_name in ipairs({...}) do
    self:register(scene_name, require('src.scene.'..scene_name))
  end
end

function SceneManager:register(scene_name, scene_class)
  self.scenes[scene_name] = scene_class
end

function SceneManager:call(scene_name, ...)
  self.scene = self.scenes[scene_name](...)
  self.stack[scene_name] = self.scene
end

function SceneManager:go_to(scene_name)
  self.scene = self.stack[scene_name]
end

function SceneManager:update(dt)
  self.scene:update(dt)
end

function SceneManager:draw()
  self.scene:draw()
end

return SceneManager()