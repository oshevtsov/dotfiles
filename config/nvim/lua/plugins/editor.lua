return {
  -- Smart indentation
  {
    "nmac427/guess-indent.nvim",
    config = function()
      require("guess-indent").setup({})
    end,
  },

  -- Surround selections
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
          require("ts_context_commentstring").setup({ enable_autocmd = false })
        end,
      },
    },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },

  -- Smooth escaping
  {
    "max397574/better-escape.nvim",
    event = "InsertCharPre",
    config = function()
      require("better_escape").setup({})
    end,
  },

  -- Highlight all matches under cursor
  {
    "tzachar/local-highlight.nvim",
    config = function()
      require("local-highlight").setup({ animate = false })
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lualine").setup({
        options = {
          disabled_filetypes = { "NvimTree", "neo-tree", "dashboard", "alpha" },
          theme = "auto",
        },
      })
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("bufferline").setup({
        options = {
          offsets = {
            { filetype = "NvimTree", text = "File Explorer" },
            { filetype = "neo-tree", text = "File Explorer" },
          },
          buffer_close_icon = "󰅖",
          modified_icon = "",
          close_icon = "",
          show_close_icon = true,
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 14,
          max_prefix_length = 13,
          tab_size = 20,
          show_tab_indicators = true,
          enforce_regular_tabs = false,
          show_buffer_close_icons = true,
          separator_style = "thin",
          always_show_bufferline = false,
          diagnostics = "nvim_lsp",
          custom_filter = function(buf_number, buf_numbers)
            if vim.bo[buf_number].filetype ~= "qf" then
              return true
            end
            return false
          end,
        },
      })

      vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer tab" })
      vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer tab" })
      vim.keymap.set("n", ">b", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer tab right" })
      vim.keymap.set("n", "<b", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer tab left" })
    end,
  },

  -- Splits/windows
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    config = function()
      -- recommended mappings
      -- resizing splits
      -- these keymaps will also accept a range,
      -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
      vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left, { desc = "Resize split left" })
      vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down, { desc = "Resize split down" })
      vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up, { desc = "Resize split up" })
      vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right, { desc = "Resize split right" })
      -- moving between splits
      vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "Move cursor to split left" })
      vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "Move cursor to split down" })
      vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "Move cursor to split up" })
      vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "Move cursor to split right" })
      -- swapping buffers between windows
      vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left, { desc = "Move buffer to split left" })
      vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down, { desc = "Move buffer to split down" })
      vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up, { desc = "Move buffer to split up" })
      vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right, { desc = "Move buffer to split right" })
    end,
  },

  -- Terminal integration
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.35
          end
        end,
        shade_terminals = false,
        persist_size = true,
        direction = "horizontal",
        winbar = {
          enabled = true,
        },
      })

      -- Switch between terminals (preserving current terminal's direction),
      -- inspired by https://github.com/akinsho/toggleterm.nvim/issues/525
      local function get_term_index(current_id, terms)
        local idx
        for i, v in ipairs(terms) do
          if v.id == current_id then
            idx = i
          end
        end
        return idx
      end

      local function go_prev_term()
        local current_id = vim.b.toggle_number
        if current_id == nil then
          return
        end

        local terms = require("toggleterm.terminal").get_all(true)
        local prev_index

        local index = get_term_index(current_id, terms)
        if index > 1 then
          prev_index = index - 1
        else
          prev_index = #terms
        end
        require("toggleterm").toggle(terms[index].id, nil, nil, terms[index].direction)
        require("toggleterm").toggle(terms[prev_index].id, nil, nil, terms[index].direction)
      end

      local function go_next_term()
        local current_id = vim.b.toggle_number
        if current_id == nil then
          return
        end

        local terms = require("toggleterm.terminal").get_all(true)
        local next_index

        local index = get_term_index(current_id, terms)
        if index == #terms then
          next_index = 1
        else
          next_index = index + 1
        end
        require("toggleterm").toggle(terms[index].id, nil, nil, terms[index].direction)
        require("toggleterm").toggle(terms[next_index].id, nil, nil, terms[index].direction)
      end

      vim.keymap.set({ "n", "t" }, "<F7>", function()
        go_prev_term()
      end, { desc = "Toggle term (switch previous)" })
      vim.keymap.set({ "n", "t" }, "<F8>", function()
        go_next_term()
      end, { desc = "Toggle term (switch next)" })

      local Terminal = require("toggleterm.terminal").Terminal
      local python = Terminal:new({ cmd = "python3", hidden = true })
      local node = Terminal:new({ cmd = "node", hidden = true })
      vim.keymap.set("n", "<C-t>", "<cmd>ToggleTermToggleAll<CR>", { desc = "Toggle all terminal windows", silent = true })
      vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "ToggleTerm float" })
      vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "ToggleTerm horizontal split" })
      vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "ToggleTerm vertical split" })
      vim.keymap.set("n", "<leader>tp", function()
        python:toggle()
      end, { desc = "ToggleTerm python" })
      vim.keymap.set("n", "<leader>tn", function()
        node:toggle()
      end, { desc = "ToggleTerm node" })
      vim.keymap.set("n", "<leader>\\", function()
        if vim.v.count == 0 then
          vim.cmd("ToggleTerm")
        else
          vim.cmd("ToggleTerm")
          vim.cmd(vim.v.count .. "ToggleTerm")
        end
      end, { desc = "Open new terminal avoiding side-by-side split" })
    end,
  },

  -- HTTP Client
  -- {
  --   "mistweaverco/kulala.nvim",
  --   opts = {
  --     winbar = true,
  --   },
  --   config = function(_, opts)
  --     require("kulala").setup(opts)
  --     vim.keymap.set("n", "<leader>pp", function()
  --       require("kulala").scratchpad()
  --     end, { desc = "Open scratchpad [Kulala]" })
  --   end,
  -- },

  -- Better markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
