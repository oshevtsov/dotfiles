local M = {}

function M.config()
  local status_ok, telescope = pcall(require, "telescope")
  if status_ok then
    local actions = require("telescope.actions")

    -- custom actions mappings
    local custom_actions = M.make_custom_actions()
    local multi_open_mappings = {
      ["<C-v>"] = custom_actions.multi_selection_open_vertical,
      ["<C-s>"] = custom_actions.multi_selection_open_horizontal,
      ["<C-t>"] = custom_actions.multi_selection_open_tab,
      ["<CR>"] = custom_actions.multi_selection_open,
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

-- Custom actions
-- see https://github.com/nvim-telescope/telescope.nvim/issues/1048
-- to understand where it all started

local function multiopen(prompt_bufnr, method)
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local edit_file_cmd_map = {
    vertical = "vsplit",
    horizontal = "split",
    tab = "tabedit",
    default = "edit",
  }
  local edit_buf_cmd_map = {
    vertical = "vert sbuffer",
    horizontal = "sbuffer",
    tab = "tab sbuffer",
    default = "buffer",
  }
  local picker = action_state.get_current_picker(prompt_bufnr)
  local multi_selection = picker:get_multi_selection()

  if #multi_selection > 1 then
    require("telescope.pickers").on_close_prompt(prompt_bufnr)
    pcall(vim.api.nvim_set_current_win, picker.original_win_id)

    local first_open_bufnr
    for i, entry in ipairs(multi_selection) do
      local filename, row, col

      if entry.path or entry.filename then
        filename = entry.path or entry.filename

        row = entry.row or entry.lnum
        col = vim.F.if_nil(entry.col, 1)
      elseif not entry.bufnr then
        local value = entry.value
        if not value then
          return
        end

        if type(value) == "table" then
          value = entry.display
        end

        local sections = vim.split(value, ":")

        filename = sections[1]
        row = tonumber(sections[2])
        col = tonumber(sections[3])
      end

      local entry_bufnr = entry.bufnr

      if entry_bufnr then
        if not vim.api.nvim_buf_get_option(entry_bufnr, "buflisted") then
          vim.api.nvim_buf_set_option(entry_bufnr, "buflisted", true)
        end
        local command = i == 1 and "buffer" or edit_buf_cmd_map[method]
        pcall(vim.cmd, string.format("%s %s", command, vim.api.nvim_buf_get_name(entry_bufnr)))
      else
        local command = i == 1 and "edit" or edit_file_cmd_map[method]
        if vim.api.nvim_buf_get_name(0) ~= filename or command ~= "edit" then
          filename = require("plenary.path"):new(vim.fn.fnameescape(filename)):normalize(vim.loop.cwd())
          pcall(vim.cmd, string.format("%s %s", command, filename))
        end
      end

      if i == 1 then
        first_open_bufnr = vim.api.nvim_get_current_buf()
      end

      if row and col then
        pcall(vim.api.nvim_win_set_cursor, 0, { row, col - 1 })
      end
    end
    --[[ vim.cmd({ cmd = "buffer", args = { first_open_bufnr } }) ]]
    vim.cmd.buffer(first_open_bufnr)
  else
    actions["select_" .. method](prompt_bufnr)
  end
end

function M.make_custom_actions()
  local transform_mod = require("telescope.actions.mt").transform_mod
  return transform_mod({
    multi_selection_open_vertical = function(prompt_bufnr)
      multiopen(prompt_bufnr, "vertical")
    end,
    multi_selection_open_horizontal = function(prompt_bufnr)
      multiopen(prompt_bufnr, "horizontal")
    end,
    multi_selection_open_tab = function(prompt_bufnr)
      multiopen(prompt_bufnr, "tab")
    end,
    multi_selection_open = function(prompt_bufnr)
      multiopen(prompt_bufnr, "default")
    end,
  })
end

return M
