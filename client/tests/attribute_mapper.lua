local test = require 'lib.u-test'
local AttributeMapper = require 'src.attribute_mapper'

test.should_fail_without_and_object = function()
  local mapper = AttributeMapper()

  test.error_raised(function()
    mapper:map_object()
  end, 'argument error')
end

test.should_receive_an_object_with_string_values = function()
  local mapper = AttributeMapper()
  test.error_raised(function()
    mapper:map_object({ a = 0 })
  end, 'argument error')
end

test.should_return_a_valid_object = function()
  local mapper = AttributeMapper()
  local obj = mapper:map_object({
    name = 'Paulo',
    age = '22',
    bool = 'true'
  })

  test.equal(obj.name, 'Paulo')
  test.equal(obj.age, 22)
  test.equal(obj.bool, true)
end

test.summary()