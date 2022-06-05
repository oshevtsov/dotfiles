local M = {}

function M.config()
	local status_ok, better_escape = pcall(require, "better_escape")
	if status_ok then
		better_escape.setup({
			mapping = { "jk", "kj" },
			timeout = vim.o.timeoutlen,
			keys = "<Esc>",
		})
	end
end

return M
