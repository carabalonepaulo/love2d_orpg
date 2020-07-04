return {
  -- network interface ('tcp' | 'enet' | 'websocket')
  network_interface = 'tcp',
  -- host and port information
  host = '*',
  port = 5000,
  -- max client connections awaiting to be accepted
  max_queue = 32
}