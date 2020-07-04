local test = require 'lib.u-test'
local EventDispatcher = require 'src.event_dispatcher'
local event_dispatcher = EventDispatcher()

test.dispatcher.should_have_zero_events = function()
  local dispatcher = EventDispatcher()
  test.equal(dispatcher:get_events_count(), 0)
end

test.dispatcher.should_have_two_events = function()
  local dispatcher = EventDispatcher()
  dispatcher:define_events { 'a', 'b' }
  test.equal(dispatcher:get_events_count(), 2)
end

test.dispatcher.should_fire_an_event = function()
  local dispatcher = EventDispatcher()
  dispatcher:define_events { 'a' }
  dispatcher:on('a', function(param_a, param_b)
    test.equal(param_a, 'param a')
    test.equal(param_b, 'param b')
  end)
  dispatcher:dispatch('a', 'param a', 'param b')
end

test.dispatcher.should_clear_one_event = function()
  local dispatcher = EventDispatcher()
  dispatcher:define_events { 'a' }
  test.equal(dispatcher:get_events_count(), 1)
  dispatcher:clear('a')
  test.equal(dispatcher:get_events_count(), 0)
end

test.dispatcher.should_clear_all_events = function()
  local dispatcher = EventDispatcher()
  dispatcher:define_events { 'a', 'b' }
  dispatcher:clear()
  test.equal(dispatcher:get_events_count(), 0)
end

test.dispatcher.should_remove_one_callback_from_one_event = function()
  local dispatcher = EventDispatcher()
  local callback_a = function() return 'callback_a' end
  local callback_b = function() return 'callback_b' end
  dispatcher:on('a', callback_a)
  dispatcher:on('a', callback_b)
  test.equal(#dispatcher.events['a'], 2)
  dispatcher:remove_from('a', callback_a)
  test.equal(#dispatcher.events['a'], 1)
end

test.dispatcher.should_not_use_undefined_events_when_strict = function()
  local dispatcher = EventDispatcher { strict = true }
  test.error_raised(function()
    dispatcher:on('a', function() return true end)
  end, 'undefined event')
end

test.dispatcher.initialize_with_array_of_events = function()
  local dispatcher = EventDispatcher { 'a', 'b', 'c' }
  test.equal(dispatcher:get_events_count(), 3)
end

test.dispatcher.initialize_with_events_and_strict_enabled = function()
  local dispatcher = EventDispatcher { 'a', 'b', 'c', strict = true }
  test.equal(dispatcher:get_events_count(), 3)
  test.equal(dispatcher.strict, true)
  test.error_raised(function()
    dispatcher:on('d', function() return true end)
  end, 'undefined event')
  test.error_raised(function()
    dispatcher:dispatch('d')
  end, 'undefined event')
end


test.dispatcher.should_propagate_events = function()
  local dispatcher_a = EventDispatcher { 'a', 'b', 'c' }
  local dispatcher_b = EventDispatcher()

  dispatcher_a:propagate(dispatcher_b)
  test.equal(dispatcher_b:get_events_count(), 3)
  test.equal(#dispatcher_a.events['a'], 1)
end

test.summary()