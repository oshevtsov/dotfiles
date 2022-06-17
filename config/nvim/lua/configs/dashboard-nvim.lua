local M = {}

function M.config()
	local status_ok, db = pcall(require, "dashboard")

	if status_ok then
		db.custom_header = {
			" ",
			" ",
			" ",
			" ██████   ██████  ███████ ██   ██ ███████ ██    ██ ████████ ███████  ██████  ██    ██",
			"██    ██ ██    ██ ██      ██   ██ ██      ██    ██    ██    ██      ██    ██ ██    ██",
			"██ ██ ██ ██    ██ ███████ ███████ █████   ██    ██    ██    ███████ ██    ██ ██    ██",
			"██ ██ ██ ██    ██      ██ ██   ██ ██       ██  ██     ██         ██ ██    ██  ██  ██",
			" █ ████   ██████  ███████ ██   ██ ███████   ████      ██    ███████  ██████    ████",
			" ",
			" ",
			" ",
			" ",
		}

		db.custom_center = {
			{
				icon = "  ",
				desc = "Open dotfiles             ",
				shortcut = "SPC f d",
				action = "lua require('telescope.builtin').find_files({prompt_title='Dotfiles', cwd='$HOME/.dotfiles'})",
			},
			{
				icon = "  ",
				desc = "Find File                 ",
				shortcut = "SPC f f",
				action = "Telescope find_files",
			},
			{
				icon = "  ",
				desc = "Recents                   ",
				shortcut = "SPC f o",
				action = "Telescope oldfiles",
			},
			{
				icon = "  ",
				desc = "Find Word                 ",
				shortcut = "SPC f g",
				action = "Telescope live_grep",
			},
			{
				icon = "  ",
				desc = "New File                  ",
				shortcut = "SPC f n",
				action = "DashboardNewFile",
			},
			{
				icon = "  ",
				desc = "Bookmarks                 ",
				shortcut = "SPC f m",
				action = "Telescope marks",
			},
			{
				icon = "  ",
				desc = "Last Session              ",
				shortcut = "SPC s l",
				action = "SessionLoad",
			},
		}
	end
end

return M
