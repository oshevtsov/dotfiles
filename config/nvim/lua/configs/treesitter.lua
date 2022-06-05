local M = {}

function M.config()
	local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
	if status_ok then
		local config = {
			ensure_installed = {},
			sync_install = false,
			ignore_install = {},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			incremental_selection = {
				enable = true,
			},
			context_commentstring = {
				enable = true,
			},
			rainbow = {
				enable = true,
				disable = { "html" },
				extended_mode = false,
				max_file_lines = nil,
			},
			autotag = {
				enable = true,
			},
		}

		treesitter.setup(config)
	end
end

return M
