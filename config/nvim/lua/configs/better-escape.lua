local M = {}

function M.config()
	local present, better_escape = pcall(require, "better_escape")
	if not present then
		return
	end

	better_escape.setup({
		mapping = { "jk", "kj" },
		timeout = vim.o.timeoutlen,
		keys = "<Esc>",
	})
end

return M
