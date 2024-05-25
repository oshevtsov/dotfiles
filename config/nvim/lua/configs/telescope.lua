local M = {}

-- Custom actions
-- see https://github.com/nvim-telescope/telescope.nvim/issues/1048
-- to understand where it all started

local select_one_or_multi = function(prompt_bufnr)
  local actions = require("telescope.actions")
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local multi_selection = picker:get_multi_selection()
  if not vim.tbl_isempty(multi_selection) then
    actions.close(prompt_bufnr)
    for _, j in pairs(multi_selection) do
      if j.path ~= nil then
        if j.lnum ~= nil then
          vim.cmd(string.format("%s +%s %s", "edit", j.lnum, j.path))
        else
          vim.cmd(string.format("%s %s", "edit", j.path))
        end
      end
    end
  else
    actions.select_default(prompt_bufnr)
  end
end

function M.config()
  local status_ok, telescope = pcall(require, "telescope")
  if status_ok then
    local actions = require("telescope.actions")

    -- custom actions mappings
    local multi_open_mappings = {
      ["<CR>"] = select_one_or_multi,
    }

    telescope.setup({
      defaults = {
        prompt_prefix = " ",
        selection_caret = "❯ ",
        path_display = { "truncate" },
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            width = 0.9,
          },
          vertical = {
            mirror = false,
            height = 0.95,
          },
        },

        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-a>"] = actions.toggle_all,
          },

          n = {
            ["<C-a>"] = actions.toggle_all,
            ["d"] = actions.delete_buffer,
          },
        },
      },
      pickers = {
        oldfiles = {
          mappings = {
            i = multi_open_mappings,
            n = multi_open_mappings,
          },
        },
        find_files = {
          follow = true,
          mappings = {
            i = multi_open_mappings,
            n = multi_open_mappings,
          },
        },
        live_grep = {
          mappings = {
            i = multi_open_mappings,
            n = multi_open_mappings,
          },
        },
        grep_string = {
          mappings = {
            i = multi_open_mappings,
            n = multi_open_mappings,
          },
        },
      },
      extensions = {
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = multi_open_mappings,
            n = multi_open_mappings,
          },
        },
      },
    })

    telescope.load_extension("live_grep_args")
    telescope.load_extension("fzf")
  end
end

return M
