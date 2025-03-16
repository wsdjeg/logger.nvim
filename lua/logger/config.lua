local M = {}

function M.setup(opt)
  opt = opt or {}
  local base = require('logger.base')
  base.set_level(opt.level)
end

return M
