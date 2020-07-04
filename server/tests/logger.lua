local test = require 'lib.u-test'
local Logger = require 'src.logger'

test.logger.write_line = function()
  local logger = Logger()
  logger.colors = false
  logger.print = false
  logger.file = false

  local mode = 'debug'
  local line = 'some text'
  local now = os.date('%X')
  local result = string.format("%s %s - %s", string.upper(mode), now, line)
  test.equal(logger:write_line(mode, line), result)
end

test.logger.should_accept_options_on_init = function()
  local logger = Logger { colors = false, print = false, file = false }
  test.equal(logger.colors, false)
  test.equal(logger.file, false)
  test.equal(logger.print, false)
end

test.logger.log_file_name_should_have_date = function()
  local today = string.gsub(os.date('%x'), '/', '-')
  local file_name = string.format('%s.txt', today)

  local logger = Logger()
  test.equal(logger:get_file_name(), file_name)
end