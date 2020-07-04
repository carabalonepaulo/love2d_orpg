local EventDispatcher = require 'src.event_dispatcher'
local Listener = EventDispatcher:extend()

function Listener:new(host, port)
  Listener.super.new(self)

  assert(host, 'argument error')
  assert(port, 'argument error')

  self.host = host
  self.port = port

  self:define_events {
    'connect',
    'receive',
    'disconnect'
  }
end

function Listener:send(id, raw_packet)
  error('Listener interface not implemented')
end

return Listener