local Object = require 'lib.object'
local EventDispatcher = Object:extend()

function EventDispatcher:new(params)
  self.events = {}

  if params then
    if #params > 0 then
      self:define_events(params)
    end

    self.strict = params.strict or false
  end
end

function EventDispatcher:get_events_count()
  return #self:get_event_name_list()
end

function EventDispatcher:get_event_name_list()
  local names = {}
  for event_name, event_list in pairs(self.events) do
    if event_list ~= nil then
      table.insert(names, event_name)
    end
  end
  return names
end

function EventDispatcher:define_events(events)
  for _, event_name in ipairs(events) do
    self.events[event_name] = {}
  end
end

function EventDispatcher:dispatch(event_name, ...)
  local event = self.events[event_name]

  if self.events[event_name] == nil then
    error('undefined event')
  end

  for i, ev in ipairs(event) do
    ev(...)
  end
end

function EventDispatcher:on(event_name, callback)
  if not self.events[event_name] then
    if self.strict then
      error('undefined event')
    else
      self.events[event_name] = {}
    end
  end

  table.insert(self.events[event_name], callback)
end

function EventDispatcher:clear(event_name)
  if event_name then
    self.events[event_name] = nil
  else
    self.events = {}
  end
end

function EventDispatcher:remove_from(event, callback)
  local index = -1
  for i, cb in ipairs(self.events[event]) do
    if cb == callback then
      index = i
      break
    end
  end

  if index ~= -1 then
    table.remove(self.events[event], index)
  else
    local message = string.format('callback not found on event "%s"', event)
    error(message)
  end
end

function EventDispatcher:propagate(dispatcher)
  for event_name, _ in pairs(self.events) do
    dispatcher.events[event_name] = {}
    self:on(event_name, function(...)
      dispatcher:dispatch(event_name, ...)
    end)
  end
end

return EventDispatcher