---@class loggerOpts
---@field level? 0|1|2|3
---@field file? string

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
