local M = {}

function M.config()
  local status_ok, tmux = pcall(require, "tmux")
  if status_ok then
    tmux.setup({
      copy_sync = {
        sync_clipboard = false,
      },
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
end

return M
