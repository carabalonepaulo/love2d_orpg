local EventDispatcher = require 'src.event_dispatcher'
local AttributeMapper = EventDispatcher:extend()

function AttributeMapper:map_object(object)
  assert(object, 'argument error')

  local new_object = {}
  for key, value in pairs(object) do
    assert(type(value) == 'string', 'argument error')
    new_object[key] = self:map_value(value)
  end
  return new_object
end

function AttributeMapper:map_value(value)
  if string.match(value, '%d+') then
    return tonumber(value)
  elseif string.lower(value) == 'true' then
    return true
  elseif string.lower(value) == 'false' then
    return false
  else
    return value
  end
end

return AttributeMapper