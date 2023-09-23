local M = {}

function M.config()
  local status_ok, neotree = pcall(require, "neo-tree")
  if status_ok then
    -- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/v3.x/lua/neo-tree/defaults.lua
    neotree.setup({
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_diagnostics = true,
      default_component_configs = {
        indent = {
          padding = 1,
          with_expanders = nil,
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          default = "",
        },
        git_status = {
          symbols = {
            added = "",
            deleted = "",
            modified = "",
            renamed = "➜",
            untracked = "★",
            ignored = "◌",
            unstaged = "✗",
            staged = "✓",
            conflict = "",
          },
        },
      },
      window = {
        width = 33,
        mappings = {
          ["o"] = "open",
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_by_name = {
            ".DS_Store",
            "thumbs.db",
            "node_modules",
            "__pycache__",
          },
        },
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(_)
            vim.opt_local.signcolumn = "auto"
          end,
        },
        {
          event = "file_opened",
          handler = function(_)
            vim.cmd({ cmd = "Neotree", args = { "close" } })
          end,
        },
      },
    })
  end
end

return M
