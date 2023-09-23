local M = {}

function M.config()
  local status_ok, alpha = pcall(require, "alpha")

  if status_ok then
    local stats = require("lazy").stats()
    local dashboard = require("alpha.themes.dashboard")
    dashboard.section.header.val = {
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
    }
    dashboard.section.header.opts.hl = "DashboardHeader"
    dashboard.section.footer.opts.hl = "DashboardFooter"

    dashboard.section.buttons.val = {
      dashboard.button(
        "d",
        "  Open dotfiles",
        ":lua require('telescope.builtin').find_files({prompt_title='Dotfiles', cwd='$HOME/.dotfiles'})<CR>"
      ),
      dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
      dashboard.button("o", "  Recents", ":Telescope oldfiles<CR>"),
      dashboard.button("g", "  Find word", ":Telescope live_grep_args<CR>"),
      dashboard.button("n", "  New file", ":enew<CR>"),
      dashboard.button("m", "  Bookmarks", ":Telescope marks<CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }
    dashboard.section.footer.val = {
      "",
      "",
      "✨ neovim loaded " .. stats.loaded .. " of " .. stats.count .. " packages",
    }
    dashboard.config.opts.noautocmd = true
    alpha.setup(dashboard.config)
  end
end

return M
