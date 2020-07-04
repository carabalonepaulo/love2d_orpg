local test = require 'lib.u-test'
local Listener = require 'src.listener'

test.listener.should_have_host_and_port = function()
  local listener = Listener("*", 5000)
  test.is_not_nil(listener['host'])
  test.is_not_nil(listener['port'])
end

test.listener.must_fail_without_host_and_port = function()
  test.error_raised(Listener, 'argument error')
  test.error_raised(function() Listener("*") end, 'argument error')
end

test.listener.should_have_a_send_method = function()
  local listener = Listener('*', 5000)
  test.is_not_nil(listener['send'])
end

test.listener.should_have_three_events = function()
  local listener = Listener('*', 5000)
  test.equal(listener:get_events_count(), 3)
end