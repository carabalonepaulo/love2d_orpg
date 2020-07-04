local socket = require 'socket'
local conf = require 'conf'

local Logger = require 'src.logger'
local TcpClient = require 'src.client.tcp'
local Listener = require 'src.listener'
local TcpListener = Listener:extend()

-- helper function to determine if has available data
local can_read = function(sck)
  local r, w, e = socket.select({ sck }, nil, 0)
  return #r > 0
end

function TcpListener:new(host, port)
  TcpListener.super.new(self, host, port)

  self.clients = {}
  self.high_index = 0
  self.free_indices = {}

  self.listener = socket.tcp()
  self.listener:bind(self.host, self.port)
  self.listener:listen(conf.max_queue)
  self.listener:settimeout(0)
  self.listener:setoption('tcp-nodelay', true)
end

function TcpListener:get_free_index()
  if #self.free_indices > 0 then
    return table.remove(self.free_indices)
  else
    self.high_index = self.high_index + 1
    return self.high_index
  end
end

function TcpListener:accept()
  local index = self:get_free_index()
  self.clients[index] = TcpClient(index, self.listener:accept())
  self:dispatch('connect', index)
end

function TcpListener:update()
  local status, return_value = pcall(can_read, self.listener)
  if status and return_value == true then
    self:accept()
  end

  for index, client in pairs(self.clients) do
    if client ~= nil and can_read(client.socket) then
      local message, status = client.socket:receive('*l')

      -- local logger = Logger { file = false }
      -- logger:write_line('critical', message)
      -- logger:write_line('critical', status)

      if status == 'closed' then
        self.clients[index] = nil
        self:dispatch('disconnect', index)
        -- logger:write_line('critical', 'removed')
      elseif message and message:len() > 0 then
        self:dispatch('receive', index, message)
      end
    end
  end
end

function TcpListener:send(client_id, raw_packet)
  self.clients[client_id]:send(raw_packet)
end

return TcpListener