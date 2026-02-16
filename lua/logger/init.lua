---@class logger
local M = {}

local base = require('logger.base')

base.set_name('logger')

M.setup = require('logger.config').setup

---@param msg string
function M.info(msg)
  base.info(msg)
end

---@param msg string
function M.warn(msg, ...)
  base.warn(msg, ...)
end

---@param msg string
function M.error(msg)
  base.error(msg)
end

---@param msg string
function M.debug(msg)
  base.debug(msg)
end

function M.viewRuntimeLog()
  -- this function should be more faster, and view runtime log without filter
  local info = string.format('### Runtime log :\n\n%s', base.view_all())
  vim.cmd.tabnew()

  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_option_value('buflisted', false, { buf = bufnr })
  vim.keymap.set(
    'n',
    'q',
    ':bd!<CR>',
    { noremap = true, silent = true, buffer = bufnr }
  )

  -- put info into buffer
  vim.fn.append(0, vim.fn.split(info, '\n'))
  vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = bufnr })
  vim.api.nvim_set_option_value('filetype', 'RuntimeLog', { buf = bufnr })
  -- M.syntax_extra()
end

function M.clearRuntimeLog()
  base.clear()
end

function M.syntax_extra()
  vim.fn.matchadd('ErrorMsg', '.*[\\sError\\s\\].*')
  vim.fn.matchadd('WarningMsg', '.*[\\sWarn\\s\\].*')
end

---@param name string
function M.derive(name)
  ---@class loggerDerive
  local derive = {}

  local derive_name =
    string.format('%' .. string.format('%ds', base.width), name)
  local origin_name = base.get_name()

  function derive.set_level(level)
    if vim.tbl_contains({ 0, 1, 2, 3 }, level) then
      derive.level = level
    end
  end

  ---@param msg string
  function derive.info(msg)
    base.set_name(derive_name)
    local l = base.level
    base.set_level(derive.level)
    base.info(msg)
    base.set_level(l)
    base.set_name(origin_name)
  end

  ---@param msg string
  function derive.warn(msg)
    base.set_name(derive_name)
    local l = base.level
    base.set_level(derive.level)
    base.warn(msg)
    base.set_level(l)
    base.set_name(origin_name)
  end

  ---@param msg string
  function derive.error(msg)
    base.set_name(derive_name)
    local l = base.level
    base.set_level(derive.level)
    base.error(msg)
    base.set_level(l)
    base.set_name(origin_name)
  end

  ---@param msg string
  function derive.debug(msg)
    base.set_name(derive_name)
    local l = base.level
    base.set_level(derive.level)
    base.debug(msg)
    base.set_level(l)
    base.set_name(origin_name)
  end
  return derive
end

return M
