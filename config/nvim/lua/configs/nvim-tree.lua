local M = {}

function M.config()
  local status_ok, nvim_tree = pcall(require, "nvim-tree")
  if not status_ok then
    return
  end

  -- all options are documented in `:help nvim-tree.OPTION_NAME`
  nvim_tree.setup({
    auto_reload_on_write = true,
    sort_by = "name",
    update_cwd = false,
    view = {
      width = 30,
      height = 30,
      side = "left",
      preserve_window_proportions = false,
      number = false,
      relativenumber = false,
      signcolumn = "yes",
    },
    update_focused_file = {
      enable = true,
      update_cwd = true,
      ignore_list = {},
    },
    diagnostics = {
      enable = false,
      show_on_dirs = false,
    },
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
  })
end

return M
