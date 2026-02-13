local uv = vim.uv or vim.loop

local rtplog = {} ---@type string[]

---@alias loggerLevel 0|1|2|3|4
---@alias loggerVerbose 1|2|3|4
---@alias loggerLevelStrings { [1]: 'Info ', [2]: 'Warn ', [3]: 'Error ', [4]: 'Debug ' }

---@class loggerMsg
---@field name string
---@field time string
---@field msg string
---@field level loggerLevel
---@field str string

---@class logger.Base
---@field name string
---@field silent integer|boolean
---@field level loggerLevel
---@field verbose loggerVerbose
---@field file string
---@field temp loggerMsg[]
---@field levels string[]
local M = {
  name = '',
  silent = 1,
  level = 1,
  verbose = 1,
  file = '',
  temp = {},
}

M.levels = { 'Info ', 'Warn ', 'Error ', 'Debug ' } ---@type loggerLevelStrings
M.clock = vim.fn.reltime()

---@param sl boolean|integer
function M.set_silent(sl)
  if type(sl) == 'boolean' then
    M.silent = sl
    return
  end
  if type(sl) == 'number' then
    -- this is for backward compatibility.
    M.silent = sl == 1 and true or (sl == 0 and false or M.silent)
  end
end

---@param file string
function M.set_file(file)
  if not file then
    return
  end

  M.file = file
end

---@param vb loggerVerbose
function M.set_verbose(vb)
  -- verbose should be 1 - 4
  -- message type: log debug, info, warn, error
  -- info and debug should not be print to screen.
  -- the default verbose is 1
  -- 1: notify nothing
  -- 2: notify only error
  -- 3: notify warn and error
  M.verbose = vb
end

---@param l loggerLevel
function M.set_level(l)
  if not vim.list_contains({ 0, 1, 2, 3, 4 }, l) then
    return
  end

  -- the level only can be:
  -- 0 : log debug, info, warn, error messages
  -- 1 : log info, warn, error messages
  -- 2 : log warn, error messages
  -- 3 : log error messages
  M.level = l
end

---@param msg string
---@param l loggerLevel
---@return loggerMsg log_msg
function M._build_msg(msg, l)
  msg = msg or ''
  local _, mic = uv.gettimeofday()
  local c = string.format('%s:%03d', os.date('%H:%M:%S'), mic / 1000)
  -- local log = string.format('[ %s ] [%s] [ %s ] %s', M.name, c, M.levels[l], msg)

  return { ---@type loggerMsg
    name = M.name,
    time = c,
    msg = msg,
    level = l,
    str = string.format(
      '[ %s ] [ %s ] [ %s ] %s',
      c,
      M.levels[l],
      M.name,
      msg
    ),
  }
end

---@param log loggerMsg
function M.write(log)
  table.insert(M.temp, log)
  table.insert(rtplog, log.str)
end

function M.clear()
  rtplog = {}
end

---@param msg string
function M.debug(msg)
  if M.level > 0 then
    return
  end

  M.write(M._build_msg(msg, 4))
end

---@param msg string
function M.error(msg)
  M.write(M._build_msg(msg, 3))
end

---@param msg string
function M.warn(msg, ...)
  if M.level > 2 then
    return
  end

  local issilent = select(1, ...)
  if type(issilent) == 'number' then
    issilent = issilent == 1
  elseif type(issilent) ~= 'boolean' then
    issilent = false
  end
  M.write(M._build_msg(msg, 2))
end

---@param msg string
function M.info(msg)
  if M.level > 1 then
    return
  end

  M.write(M._build_msg(msg, 1))
end

---@return string info
function M.view_all()
  local info = table.concat(rtplog, '\n')
  return info
end

---@param l loggerLevel
---@return string info
function M.view(l)
  local info = ''
  for _, log in ipairs(M.temp) do
    if log.level >= l then
      info = string.format('%s%s\n', info, log.str)
    end
  end
  return info
end

---@param name string
function M.set_name(name)
  if type(name) ~= 'string' then
    return
  end

  M.name = name
end

---@return string name
function M.get_name()
  return M.name
end

return M
