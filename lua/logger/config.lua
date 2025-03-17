local M = {}

function M.setup(opt)
  opt = opt or {}
  local base = require('logger.base')
  base.set_level(opt.level)
  base.set_file(opt.file)
end

return M
