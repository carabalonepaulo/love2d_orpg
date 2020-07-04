local test = require 'lib.u-test'
local Client = require 'src.client'

test.client.should_have_id = function()
  local client = Client(10)
  test.is_not_nil(client['id'])
end

test.client.should_have_a_send_method = function()
  local client = Client(0)
  test.is_not_nil(client['send'])
end