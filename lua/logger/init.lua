--=============================================================================
-- logger.lua --- logger implemented in lua
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('logger.base')
local cmd = vim.cmd
local fn = vim.fn

logger.set_name('logger')

function M.info(msg)
  logger.info(msg)
end

function M.warn(msg, ...)
  logger.warn(msg, ...)
end

function M.error(msg)
  logger.error(msg)
end

function M.debug(msg)
  logger.debug(msg)
end

function M.viewRuntimeLog()
  -- this function should be more faster, and view runtime log without filter
  local info = '### SpaceVim runtime log :\n\n' .. logger.view_all()
  cmd('tabnew')
  cmd('setl nobuflisted')
  cmd('nnoremap <buffer><silent> q :tabclose!<CR>')
  -- put info into buffer
  fn.append(0, fn.split(info, '\n'))
  cmd('setl nomodifiable')
  cmd('setl buftype=nofile')
  cmd('setl filetype=SpaceVimLog')
  -- M.syntax_extra()
end

function M.clearRuntimeLog()
  logger.clear()
end


function M.syntax_extra()
  fn.matchadd('ErrorMsg', '.*[\\sError\\s\\].*')
  fn.matchadd('WarningMsg', '.*[\\sWarn\\s\\].*')
end

function M.derive(name)
  local derive = {
    origin_name = logger.get_name(),
    _debug_mode = true,
    derive_name = fn.printf('%' .. fn.strdisplaywidth(logger.get_name()) .. 'S', name),
  }

  function derive.info(msg)
    logger.set_name(derive.derive_name)
    logger.info(msg)
    logger.set_name(derive.origin_name)
  end
  function derive.warn(msg)
    logger.set_name(derive.derive_name)
    logger.warn(msg)
    logger.set_name(derive.origin_name)
  end
  function derive.error(msg)
    logger.set_name(derive.derive_name)
    logger.error(msg)
    logger.set_name(derive.origin_name)
  end

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

M.setup = function(opt)
  require('logger.config').setup(opt)
end

return M
