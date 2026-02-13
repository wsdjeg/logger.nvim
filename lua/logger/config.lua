---@class loggerOpts
---@field level? loggerLevel
---@field file? string
---@field width? integer set the width of logger name.

---@class logger.Config
local M = {}

---@param opt? loggerOpts
function M.setup(opt)
  opt = opt or {}
  local base = require('logger.base')
  base.set_level(opt.level)
  base.set_file(opt.file)
end

return M
