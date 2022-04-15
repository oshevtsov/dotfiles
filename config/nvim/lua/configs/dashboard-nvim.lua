local M = {}

function M.config()
  local g = vim.g
  local fn = vim.fn

  local plugins_count = fn.len(vim.fn.globpath(fn.stdpath "data" .. "/site/pack/packer/start", "*", 0, 1))

  g.dashboard_disable_statusline = 1
  g.dashboard_default_executive = "telescope"
  g.dashboard_custom_header = {
    " ",
    " ",
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
  }

  g.dashboard_custom_section = {
    a = { description = { "   Open dotfiles             SPC f d" }, command = "lua require('telescope.builtin').find_files({prompt_title='Dotfiles', cwd='$HOME/.dotfiles'})" },
    b = { description = { "   Find File                 SPC f f" }, command = "Telescope find_files" },
    c = { description = { "   Recents                   SPC f o" }, command = "Telescope oldfiles" },
    d = { description = { "   Find Word                 SPC f g" }, command = "Telescope live_grep" },
    e = { description = { "   New File                  SPC f n" }, command = "DashboardNewFile" },
    f = { description = { "   Bookmarks                 SPC f m" }, command = "Telescope marks" },
    g = { description = { "   Last Session              SPC s l" }, command = "SessionLoad" },
  }

  g.dashboard_custom_footer = {
    " ",
    " Loaded " .. plugins_count .. " plugins ",
  }
end

return M

