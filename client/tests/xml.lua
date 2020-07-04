local test = require 'lib.u-test'
local parse_xml = require 'lib.xml'
local pp = require 'lib.pp'

test.simples_node = function()
  local xml = '<node></node>'
  local node = parse_xml(xml)

  test.equal(#node, 1)
  test.equal(node[1].label, 'node')
  test.equal(#node[1].xarg, 0)
end

test.simple_empyt_node = function()
  local xml = '<node />'
  local node = parse_xml(xml)

  test.equal(#node, 1)
  test.equal(node[1].label, 'node')
  test.equal(node[1].empty, 1)
end

-- TODO: Attribute mapper
test.node_with_attributes = function()
  local xml = '<node x="0" y="1"></node>'
  local node = parse_xml(xml)

  test.equal(node[1].xarg.x, '0')
  test.equal(node[1].xarg.y, '1')
end

test.node_with_inner_node = function()
  local xml = '<node><nested /></node>'
  local node = parse_xml(xml)

  test.equal(node[1][1].label, 'nested')
end

test.summary()
