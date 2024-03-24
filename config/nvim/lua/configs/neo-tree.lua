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
          default = "󰈙",
        },
        git_status = {
          symbols = {
            -- Change type
            added = "", -- NOTE: you can set any of these to an empty string to not show them
            deleted = "",
            modified = "",
            renamed = "➜",
            -- Status type
            untracked = "",
            ignored = "◌",
            unstaged = "✗",
            staged = "✓",
            conflict = "",
          },
        },
      },
      -- custom commands and/or command overrides
      -- see https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/370#discussioncomment-6679447
      commands = {
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local vals = {
            ["BASENAME"] = modify(filename, ":r"),
            ["EXTENSION"] = modify(filename, ":e"),
            ["FILENAME"] = filename,
            ["PATH (CWD)"] = modify(filepath, ":."),
            ["PATH (HOME)"] = modify(filepath, ":~"),
            ["PATH"] = filepath,
            ["URI"] = vim.uri_from_fname(filepath),
          }

          -- filter out empty values
          local options = vim.tbl_filter(function(val)
            return vals[val] ~= ""
          end, vim.tbl_keys(vals))

          if vim.tbl_isempty(options) then
            vim.notify("No values to copy", vim.log.levels.WARN)
            return
          end

          table.sort(options)
          vim.ui.select(options, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item)
              return ("%s: %s"):format(item, vals[item])
            end,
          }, function(choice)
            local result = vals[choice]
            if result then
              vim.fn.setreg("+", result)
            end
          end)
        end,
      },
      window = {
        width = 33,
        mappings = {
          ["o"] = "open",
          ["Y"] = "copy_selector",
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
