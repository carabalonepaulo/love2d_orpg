local term = require 'term'
local colors = term.colors
local Object = require 'lib.object'
local Logger = Object:extend()

function Logger:new(options)
  self.colors = true
  self.print = true
  self.file = true

  if options then
    for k, v in pairs(options) do
      self[k] = v
    end
  end

  if self.file then
    self.opened_file = io.open('./logs/'..self:get_file_name(), 'a')
  end
end

function Logger:disable_colors()
  self.colors = false
end

function Logger:get_file_name()
  local today = string.gsub(os.date('%x'), '/', '-')
  return string.format('%s.txt', today)
end

-- debug, warning, critical
function Logger:write_line(mode, line)
  local now = os.date('%X')
  local result = string.format("%s %s - %s", string.upper(mode), now, line)
  local fore_color = colors.reset
  local back_color = colors.clear
  local inc = '\t'

  local format_mode = function(spaces_left, text, spaces_right)
    return table.concat({ string.rep(' ', spaces_left), text, string.rep(' ', spaces_right) })
  end

  if self.print then
    if mode == 'debug' then
      mode = format_mode(1, mode, 4)
      fore_color = colors.black
      back_color = colors.onblue
    elseif mode == 'warning' then
      mode = format_mode(1, mode, 2)
      fore_color = colors.black
      back_color = colors.onyellow
    elseif mode == 'critical' then
      mode = format_mode(1, mode, 1)
      fore_color = colors.white
      back_color = colors.onred
    end

    if self.colors then
      local frags = {
        string.format('%s%s%s%s ', back_color, fore_color, string.upper(mode), colors.reset),
        string.format('%s%s%s - ', colors.blue, now, colors.reset),
        string.format('%s%s%s', colors.white, line, colors.reset)
      }
      print(table.concat(frags, ''))
    else
      print(result)
    end
  end

  if self.file then
    if not self.opened_file then
      self.opened_file = io.open('./logs/'..self:get_file_name(), 'a')
    end
    self.opened_file:write(result..'\n')
  end

  return result
end

return Logger