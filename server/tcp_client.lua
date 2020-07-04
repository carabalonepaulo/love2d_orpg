local socket = require 'socket'
local client = socket.tcp()
client:connect('127.0.0.1', 5000)
client:send('message\n')
client:close()
socket.sleep(5)