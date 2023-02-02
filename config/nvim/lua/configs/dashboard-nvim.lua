local M = {}

function M.config()
  local status_ok, db = pcall(require, "dashboard")

  if status_ok then
    local utils = require("dashboard.utils")
    db.setup({
      theme = "doom",
      config = {
        header = {
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          " ██████   ██████  ███████ ██   ██ ███████ ██    ██ ████████ ███████  ██████  ██    ██",
          "██    ██ ██    ██ ██      ██   ██ ██      ██    ██    ██    ██      ██    ██ ██    ██",
          "██ ██ ██ ██    ██ ███████ ███████ █████   ██    ██    ██    ███████ ██    ██ ██    ██",
          "██ ██ ██ ██    ██      ██ ██   ██ ██       ██  ██     ██         ██ ██    ██  ██  ██ ",
          " █ ████   ██████  ███████ ██   ██ ███████   ████      ██    ███████  ██████    ████  ",
          " ",
          " ",
          " ",
          " ",
        },
        center = {
          {
            icon = "  ",
            desc = "Open dotfiles             ",
            key = "d",
            action = "lua require('telescope.builtin').find_files({prompt_title='Dotfiles', cwd='$HOME/.dotfiles'})",
          },
          {
            icon = "  ",
            desc = "Find File                 ",
            key = "f",
            action = "Telescope find_files",
          },
          {
            icon = "  ",
            desc = "Recents                   ",
            key = "o",
            action = "Telescope oldfiles",
          },
          {
            icon = "  ",
            desc = "Find Word                 ",
            key = "g",
            action = "Telescope live_grep",
          },
          {
            icon = "  ",
            desc = "New File                  ",
            key = "n",
            action = "enew",
          },
          {
            icon = "  ",
            desc = "Bookmarks                 ",
            key = "m",
            action = "Telescope marks",
          },
        },
        footer = {
          "",
          "",
          "✨ neovim loaded " .. utils.get_packages_count() .. " packages",
        },
      },
    })
  end
end

return M
