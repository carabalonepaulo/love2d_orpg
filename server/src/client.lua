local Object = require 'lib.object'
local Client = Object:extend()

function Client:new(id)
  self.id = id
end

function Client:getId()
  return self.id
end

function Client:send(raw_packet)
  error('client interface not implemented')
end

return Client