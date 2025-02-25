local M = {}

M.notify = vim.notify

function M.setup(opt)
	opt = opt or {}
	M.notify = opt.notify or M.notify
end

return M
