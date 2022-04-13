local M = {}

function M.config()
  local status_ok, tmux = pcall(require, "tmux")
  if not status_ok then
    return
  end

  tmux.setup({
    navigation = {
      -- enables default navigation keybindings (C-hjkl) for normal mode
      enable_default_keybindings = true,
    },
    resize = {
      -- enables default resize keybindings (A-hjkl) for normal mode
      enable_default_keybindings = true,
    },
  })
end

return M
