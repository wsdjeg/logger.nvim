---@class logger
local M = {}

local logger = require('logger.base')

logger.set_name('logger')

---@param msg string
function M.info(msg)
  logger.info(msg)
end

---@param msg string
function M.warn(msg, ...)
  logger.warn(msg, ...)
end

---@param msg string
function M.error(msg)
  logger.error(msg)
end

---@param msg string
function M.debug(msg)
  logger.debug(msg)
end

function M.viewRuntimeLog()
  -- this function should be more faster, and view runtime log without filter
  local info = '### Runtime log :\n\n' .. logger.view_all()
  vim.cmd.tabnew()

  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_option_value('buflisted', false, { buf = bufnr })
  vim.keymap.set('n', 'q', ':bd!<CR>', { noremap = true, silent = true, buffer = bufnr })

  -- put info into buffer
  vim.fn.append(0, vim.fn.split(info, '\n'))
  vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = bufnr })
  vim.api.nvim_set_option_value('filetype', 'RuntimeLog', { buf = bufnr })
  -- M.syntax_extra()
end

function M.clearRuntimeLog()
  logger.clear()
end

function M.syntax_extra()
  vim.fn.matchadd('ErrorMsg', '.*[\\sError\\s\\].*')
  vim.fn.matchadd('WarningMsg', '.*[\\sWarn\\s\\].*')
end

---@param name string
function M.derive(name)
  ---@class loggerDerive
  local derive = {
    origin_name = logger.get_name(),
    _debug_mode = true,
    derive_name = vim.fn.printf(
      '%' .. string.format('%sS', vim.fn.strdisplaywidth(logger.get_name())),
      name
    ),
  }

  ---@param msg string
  function derive.info(msg)
    logger.set_name(derive.derive_name)
    logger.info(msg)
    logger.set_name(derive.origin_name)
  end

  ---@param msg string
  function derive.warn(msg)
    logger.set_name(derive.derive_name)
    logger.warn(msg)
    logger.set_name(derive.origin_name)
  end

  ---@param msg string
  function derive.error(msg)
    logger.set_name(derive.derive_name)
    logger.error(msg)
    logger.set_name(derive.origin_name)
  end

  ---@param msg string
  function derive.debug(msg)
    if derive._debug_mode then
      logger.set_name(derive.derive_name)
      logger.debug(msg)
      logger.set_name(derive.origin_name)
    end
  end

  function derive.start_debug()
    derive._debug_mode = true
  end

  function derive.stop_debug()
    derive._debug_mode = false
  end

  function derive.debug_enabled() -- {{{
    return derive._debug_mode
  end
  -- }}}

  return derive
end

---@param opt? loggerOpts
function M.setup(opt)
  require('logger.config').setup(opt)
end

return M
