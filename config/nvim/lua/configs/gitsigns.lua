local M = {}

function M.config()
	local status_ok, gitsigns = pcall(require, "gitsigns")
	if not status_ok then
		return
	end

	local config = {
		preview_config = {
			border = "rounded",
		},
	}

	gitsigns.setup(config)
end

return M
