local Client = require 'src.client'
local TcpClient = Client:extend()

function TcpClient:new(id, socket)
  self.super.new(self, id)
  self.socket = socket
end

function TcpClient:getId()
  return self.id
end

function TcpClient:send(raw_packet)
  self.socket:send(raw_packet..'\n')
end

return TcpClient