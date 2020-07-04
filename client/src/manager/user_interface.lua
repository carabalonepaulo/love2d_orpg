local pp = require 'lib.pp'
local parse_xml = require 'lib.xml'
local EventDispatcher = require 'src.event_dispatcher'
local AttributeMapper = require 'src.attribute_mapper'
local Panel = require 'src.control.panel'
local FlatButton = require 'src.control.flat_button'
local UserInterfaceManager = EventDispatcher:extend()

local CONTROLS = { ['panel'] = Panel, ['button'] = FlatButton }

local collect_array = function(list)
  local new_array = {}
  for i, v in ipairs(list) do
    table.insert(new_array, v)
  end
  return new_array
end

local map_table = function(list, callback)
  local new_list = {}
  for k, v in pairs(list) do
    new_list[k] = callback(v)
  end
  return new_list
end

local collect_values = function(hash)
  local new_list = {}
  for k, v in pairs(hash) do
    table.insert(new_list, v)
  end
  return new_list
end

function UserInterfaceManager:new()
  UserInterfaceManager.super.new(self)

end

function UserInterfaceManager:load_node(node)
  local mapper = AttributeMapper()
  local control_label = node.label
  local control_args = mapper:map_object(node.xarg)
  local control = CONTROLS[control_label](control_args)

  if not node.empty then
    for i, inner_node in ipairs(node) do
      local inner_control = self:load_node(inner_node)
      control:add_control(inner_control)
      inner_control:refresh()
    end
  end

  return control
end

function UserInterfaceManager:load_controls(xml_path)
  local xml, size = love.filesystem.read(xml_path)
  local xml_tree = parse_xml(xml)
  local controls = {}
  for i, node in ipairs(xml_tree) do
    table.insert(controls, self:load_node(node))
  end
  return unpack(controls)
end

function UserInterfaceManager:load_controlsx(file_name)
  local content, size = love.filesystem.read(file_name)
  local xml_tree = parse_xml(content)

  local function get_control(node)
    local label = node.label
    local args = map_table(node.xarg, function(v)
      return tonumber(v)
    end)

    local inner_controls = {}
    if not node.empty then
      inner_controls = collect_array(node)
    end

    local control = CONTROLS[label](unpack(collect_values(args)))

    for i, inner_control in pairs(inner_controls) do
      control:add_control(get_control(inner_control))
    end
    return control
  end

  local controls = {}
  for i, node in ipairs(xml_tree) do
    table.insert(controls, get_control(node))
  end
  return unpack(controls)
end

return UserInterfaceManager()