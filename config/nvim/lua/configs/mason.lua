local M = {}

function M.config()
	local status_ok, mason = pcall(require, "mason")
	if status_ok then
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_uninstalled = "✗",
					package_pending = "⟳",
				},
			},
		})
	end
end

return M
