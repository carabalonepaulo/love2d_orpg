local conf = require 'conf'

local Logger = require 'src.logger'
local Listener = require 'src.listener.tcp'
local Object = require 'lib.object'
local Server = Object:extend()

function Server:new()
  self.logger = Logger()
  self.listener = Listener(conf.host, conf.port)
  self.listener:on('connect', function(id)
    self.logger:write_line('warning', 'new connection on slot '..tostring(id))
  end)
  self.listener:on('receive', function(id, raw_data)
    self.logger:write_line('warning', string.format('received data "%s" on slot %i', raw_data, id))
  end)
  self.listener:on('disconnect', function(id)
    self.logger:write_line('warning', string.format('disconnected from slot %i', id))
  end)
  self.logger:write_line('debug', 'Server initialized on port '..tostring(conf.port))
end

function Server:run()
  self.running = true
  while self.running do
    self.listener:update()
  end
end

function Server:__tostring()
  return "Server"
end

return Server