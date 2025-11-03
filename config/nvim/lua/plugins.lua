return {
  -- Colorscheme
  -- {
  --   "sonph/onehalf",
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function(plugin)
  --     -- specify subdirectory in the repo that is relevant for Neovim
  --     vim.opt.rtp:append(plugin.dir .. "/vim")
  --     -- load the colorscheme here
  --     vim.cmd([[colorscheme onehalflight]])
  --   end,
  -- },

  {
    "catppuccin/nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function(plugin)
      -- load the colorscheme here
      -- variants: catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
      vim.cmd([[colorscheme catppuccin]])
    end,
  },

  -- Color highlights
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup({
        ---Highlight tailwind colors, e.g. 'bg-blue-500'
        enable_tailwind = true,
      })
    end,
  },

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

  -- Better buffer closing
  {
    "nvim-mini/mini.bufremove",
    config = function()
      vim.keymap.set("n", "<leader>c", function()
        require("mini.bufremove").delete(0)
      end, { desc = "Delete buffer" })
      vim.keymap.set("n", "<leader>q", function()
        require("mini.bufremove").wipeout(0)
      end, { desc = "Wipeout buffer" })
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

  -- Better notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      notify.setup({
        background_colour = "#000000",
      })
      vim.notify = notify
      vim.keymap.set("n", "<leader>dn", function()
        notify.dismiss()
      end, { desc = "Dismiss notifications" })
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = {
            min = 30,
            max = -1,
            padding = 1,
          },
        },
      })

      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle Explorer" })
      vim.keymap.set("n", "<leader>o", "<cmd>NvimTreeFocus<CR>", { desc = "Focus Explorer" })
      vim.keymap.set("n", "<leader>z", "<cmd>NvimTreeFindFile<CR>", { desc = "Reveal the open file in Explorer" })
    end,
  },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
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
          end,
        },
      })

      vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer tab" })
      vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer tab" })
      vim.keymap.set("n", ">b", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer tab right" })
      vim.keymap.set("n", "<b", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer tab left" })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-symbols.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
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

      -- custom actions mappings
      local multi_open_mappings = {
        ["<CR>"] = select_one_or_multi,
      }

      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix = "  ",
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
      telescope.load_extension("notify")

      local map = vim.keymap.set -- set new key mapping
      local cmd = vim.cmd -- execute vimscript commands
      map(
        "n",
        "<leader>fd",
        "<cmd>lua require('telescope.builtin').find_files({prompt_title='Dotfiles', cwd='$HOME/.dotfiles'})<CR>",
        { desc = "Search dotfiles" }
      )
      map("n", "<leader>lr", "<cmd>Telescope lsp_references show_line=false<CR>", { desc = "Show all reference to symbol under cursor" })
      map("n", "<leader>rr", "<cmd>Telescope resume<CR>", { desc = "Resume the last picker" })
      map("n", "<leader>fg", "<cmd>Telescope live_grep_args<CR>", { desc = "Search grep" })
      map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "Git status" })
      map("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Git branches" })
      map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
      map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<CR>", { desc = "Search files (respect .gitignore)" })
      map("n", "<leader>fi", "<cmd>Telescope find_files hidden=true no_ignore=true<CR>", { desc = "Search files (include ignored)" })
      map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Search buffers" })
      map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "Search marks" })
      map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Search old files" })
      map("n", "<leader>fe", "<cmd>Telescope symbols<CR>", { desc = "Search and insert emojis" })
      map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Search for LSP document symbols" })
      map("n", "<leader>sh", "<cmd>Telescope help_tags<CR>", { desc = "Search help" })
      map("n", "<leader>sm", "<cmd>Telescope man_pages<CR>", { desc = "Search man" })
      map("n", "<leader>sr", "<cmd>Telescope registers<CR>", { desc = "Search registers" })
      map("n", "<leader>sk", "<cmd>Telescope keymaps<CR>", { desc = "Search keymaps" })
      map("n", "<leader>sc", "<cmd>Telescope commands<CR>", { desc = "Search commands" })
      map("n", "<leader>bd", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Buffer diagnostics" })
      map("n", "<leader>wd", "<cmd>Telescope diagnostics<CR>", { desc = "Workspace diagnostics" })
      map("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Fuzzy search in current buffer" })
      map("n", "<leader>vd", vim.diagnostic.open_float, { desc = "View diagnostic" })

      map("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, { desc = "Diagnostic previous" })

      map("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, { desc = "Diagnostic next" })

      cmd(":command -nargs=+ Rg :lua require('telescope.builtin').grep_string({search = <q-args>})<CR>")
    end,
  },

  -- Git integration
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
      require("neogit").setup({})
      vim.api.nvim_create_user_command("G", "Neogit", { desc = "Start Neogit" })
      vim.api.nvim_create_user_command("D", "DiffviewOpen", { desc = "Open DiffView Tab" })
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end)

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end)

          -- Actions
          map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage Git hunk" })
          map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset Git hunk" })
          map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Stage Git hunk (visual mode)" })
          map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Reset Git hunk (visual mode)" })
          map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo stage Git hunk" })
          map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Git buffer" })
          map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Git hunk" })
          map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "Blame Git line" })
          map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle blame Git line" })
          map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle Git deleted" })
        end,
      })
    end,
  },

  -- Splits/windows
  {
    "mrjones2014/smart-splits.nvim",
    version = ">=2.0.0",
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

  -- Syntax highlighting and context objects
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      {
        "windwp/nvim-ts-autotag",
        config = function()
          require("nvim-ts-autotag").setup({
            opts = {
              enable_close = true, -- Auto close tags
              enable_rename = true, -- Auto rename pairs of tags
              enable_close_on_slash = true, -- Auto close on trailing </
            },
          })
        end,
      },
    },
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "astro",
          "bash",
          "comment",
          "css",
          "go",
          "html",
          "http", -- required by the HTTP Client (see below)
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "rust",
          "tsx",
          "typescript",
          "vimdoc",
          "yaml",
        },
        sync_install = false,
        indent = {
          enable = true,
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-Space>",
            node_incremental = "<C-Space>",
            scope_incremental = "<C-s>",
            node_decremental = "<C-Backspace>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["ak"] = { query = "@block.outer", desc = "around block" },
              ["ik"] = { query = "@block.inner", desc = "inside block" },
              ["ac"] = { query = "@class.outer", desc = "around class" },
              ["ic"] = { query = "@class.inner", desc = "inside class" },
              ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
              ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
              ["af"] = { query = "@function.outer", desc = "around function" },
              ["if"] = { query = "@function.inner", desc = "inside function" },
              ["al"] = { query = "@loop.outer", desc = "around loop" },
              ["il"] = { query = "@loop.inner", desc = "inside loop" },
              ["aa"] = { query = "@parameter.outer", desc = "around argument" },
              ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]k"] = { query = "@block.outer", desc = "Next block start" },
              ["]m"] = { query = "@function.outer", desc = "Next function start" },
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
            },
            goto_next_end = {
              ["]K"] = { query = "@block.outer", desc = "Next block end" },
              ["]M"] = { query = "@function.outer", desc = "Next function end" },
              ["]["] = { query = "@class.outer", desc = "Next class end" },
            },
            goto_previous_start = {
              ["[k"] = { query = "@block.outer", desc = "Previous block start" },
              ["[m"] = { query = "@function.outer", desc = "Previous function start" },
              ["[["] = { query = "@class.outer", desc = "Previous class start" },
            },
            goto_previous_end = {
              ["[K"] = { query = "@block.outer", desc = "Previous block end" },
              ["[M"] = { query = "@function.outer", desc = "Previous function end" },
              ["[]"] = { query = "@class.outer", desc = "Previous class end" },
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = { query = "@parameter.inner", desc = "Swap next parameter" },
              ["<leader>k"] = { query = "@block.outer", desc = "Swap next block" },
              ["<leader>m"] = { query = "@function.outer", desc = "Swap next function" },
            },
            swap_previous = {
              ["<leader>A"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
              ["<leader>K"] = { query = "@block.outer", desc = "Swap previous block" },
              ["<leader>M"] = { query = "@function.outer", desc = "Swap previous function" },
            },
          },
          lsp_interop = {
            enable = true,
            border = "rounded",
            peek_definition_code = {
              ["<leader>pf"] = { query = "@function.outer", desc = "Peek function definition" },
              ["<leader>pc"] = { query = "@class.outer", desc = "Peek class definition" },
            },
          },
        },
      })
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

  -- LSP
  {
    "neovim/nvim-lspconfig",
    tag = "v2.5.0",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      -- JSON schemas
      "b0o/SchemaStore.nvim",
      -- Rust LSP setup
      {
        "mrcjkb/rustaceanvim",
        version = "^6", -- Recommended
        lazy = false, -- This plugin is already lazy
      },
      -- Integration with crates.io
      {
        "saecki/crates.nvim",
        tag = "stable",
        event = { "BufRead Cargo.toml" },
      },
    },
    config = function()
      -- lsp_attach is where you enable features that only work
      -- if there is a language server active in the file
      local lsp_attach = function(client, bufnr)
        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { buffer = bufnr, desc = "Hover over" })
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { buffer = bufnr, desc = "Go to definition" })
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { buffer = bufnr, desc = "Go to declaration" })
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { buffer = bufnr, desc = "Go to implementation" })
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { buffer = bufnr, desc = "Type definition" })
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { buffer = bufnr, desc = "Find references" })
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { buffer = bufnr, desc = "Signature help" })
        vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = bufnr, desc = "Rename symbol" })
        vim.keymap.set(
          { "n", "x" },
          "<leader>bf",
          "<cmd>lua vim.lsp.buf.format({async = true})<cr>",
          { buffer = bufnr, desc = "Format buffer" }
        )
        vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = bufnr, desc = "Code action" })
      end

      vim.lsp.config("*", {
        capabilities = vim.lsp.protocol.make_client_capabilities(),
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my-lsp-attach", { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          lsp_attach(client, bufnr)
        end,
      })

      -- Set up rustaceanvim
      vim.g.rustaceanvim = {
        tools = {
          executor = "toggleterm",
          -- test_executor = "neotest", -- see test runner plugin below
          -- crate_test_executor = "neotest", -- see test runner plugin below
        },
      }

      -- Set up crates.io integration
      require("crates").setup({
        lsp = {
          enabled = true,
          on_attach = lsp_attach,
          actions = true,
          completion = true,
          hover = true,
        },
      })

      require("mason-tool-installer").setup({
        -- All lsp servers, linters, formatters, etc., see https://mason-registry.dev/registry/list.
        ensure_installed = {
          -- LSP servers
          "typescript-language-server",
          "lua-language-server",
          "json-lsp",
          "pyright",
          "ts_ls",
          "yaml-language-server",
          "gopls",
          "eslint-lsp",
          -- Linters
          "flake8",
          "shellcheck",
          "revive",
          "checkmake",
          "sqruff", -- both linter and formatter for SQL
          -- formatters
          "black",
          "isort",
          "stylua",
          "goimports",
          "prettier",
          -- Debuggers
          "debugpy",
          "codelldb",
          "delve",
          "js-debug-adapter",
        },

        -- if set to true this will check each tool for updates. If updates
        -- are available the tool will be updated. This setting does not
        -- affect :MasonToolsUpdate or :MasonToolsInstall.
        -- Default: false
        auto_update = false,

        -- automatically install / update on startup. If set to false nothing
        -- will happen on startup. You can use :MasonToolsInstall or
        -- :MasonToolsUpdate to install tools and check for updates.
        -- Default: true
        run_on_start = false,

        -- set a delay (in ms) before the installation starts. This is only
        -- effective if run_on_start is set to true.
        -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
        -- Default: 0
        start_delay = 0,

        -- Only attempt to install if 'debounce_hours' number of hours has
        -- elapsed since the last time Neovim was started. This stores a
        -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
        -- This is only relevant when you are using 'run_on_start'. It has no
        -- effect when running manually via ':MasonToolsInstall' etc....
        -- Default: nil
        debounce_hours = nil,
      })

      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_uninstalled = "✗",
            package_pending = "⟳",
          },
        },
      })
      vim.keymap.set("n", "<leader>lI", "<cmd>Mason<CR>", { desc = "LSP installer" })
      vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP information" })

      -- see https://github.com/jay-babu/mason-nvim-dap.nvim?tab=readme-ov-file#advanced-customization
      require("mason-nvim-dap").setup({
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every DAP adapter without a "custom handler"
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      })

      -- Add extra config options to selected language servers
      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
            format = { enable = false },
          },
        },
      })

      vim.lsp.config(
        "yamlls",
        require("yaml-companion").setup({
          lspconfig = {
            settings = {
              yaml = {
                -- CloudFormation custom tags
                customTags = {
                  "!And scalar",
                  "!If scalar",
                  "!Not",
                  "!Equals scalar",
                  "!Or scalar",
                  "!FindInMap scalar",
                  "!Base64",
                  "!Cidr",
                  "!Ref",
                  "!Sub scalar",
                  "!Sub sequence",
                  "!GetAtt",
                  "!GetAZs",
                  "!ImportValue scalar",
                  "!Select sequence",
                  "!Split sequence",
                  "!Join sequence",
                },
              },
            },
          },
        })
      )

      vim.lsp.config("pyright", {
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              diagnosticMode = "openFilesOnly",
              indexing = true,
            },
          },
        },
      })

      -- See:
      -- 1. https://github.com/neovim/nvim-lspconfig/issues/3827
      -- 2. https://github.com/neovim/nvim-lspconfig/pull/3844
      -- 3. https://github.com/neovim/nvim-lspconfig/blob/master/lsp/eslint.lua
      vim.lsp.config("eslint", {
        -- override the on_attach definition form nvim-lspconfig since it applies only
        -- to the current buffer, i.e. id = 0.
        on_attach = function(client, bufnr)
          vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
            client:exec_cmd({
              title = "Fix all Eslint errors in buffer",
              command = "eslint.applyAllFixes",
              arguments = {
                {
                  uri = vim.uri_from_bufnr(bufnr),
                  version = vim.lsp.util.buf_versions[bufnr],
                },
              },
            }, { bufnr = bufnr })
          end, { desc = "Fix all Eslint errors in buffer" })

          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "LspEslintFixAll",
          })
        end,
      })

      -- See https://github.com/williamboman/nvim-config/tree/mason-v2-example
      require("mason-lspconfig").setup({
        automatic_enable = {
          exclude = {
            "rust_analyzer",
          },
        },
      })
      -- Find mapping between mason package names and the correspodnig LSP name
      -- local registry = require("mason-registry")
      -- local mason_installed = registry.get_installed_package_names()
      -- local mason_to_lspconfig_map = {}
      -- for _, pkg_spec in ipairs(registry.get_all_package_specs()) do
      --   if vim.list_contains(mason_installed, pkg_spec.name) then
      --     local lspconfig = vim.tbl_get(pkg_spec, "neovim", "lspconfig")
      --     if lspconfig then
      --       mason_to_lspconfig_map[pkg_spec.name] = lspconfig
      --     end
      --   end
      -- end
      --
      -- vim.schedule(function()
      --   vim.lsp.enable(vim.tbl_values(mason_to_lspconfig_map))
      -- end)
    end,
  },

  -- LSP signature help
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      toggle_key = "<M-x>",
      select_signature_key = "<M-n>",
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },

  -- YAML companion
  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "rcarriga/cmp-dap",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp", -- optional
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      "brenoprata10/nvim-highlight-colors",
    },
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local kind_icons = {
        Array = "󰅪",
        Boolean = "⊨",
        Class = "󰠱",
        Color = "󰏘",
        Constant = "󰏿",
        Constructor = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "󰜢",
        File = "󰈙",
        Folder = "󰉋",
        Function = "󰊕",
        Interface = "",
        Key = "󰌆",
        Keyword = "󰌋",
        Method = "󰆧",
        Module = "",
        Namespace = "󰅪",
        Null = "NULL",
        Number = "#",
        Object = "󰀚",
        Operator = "󰆕",
        Package = "󰏗",
        Property = "󰜢",
        Reference = "",
        Snippet = "",
        String = "󰀬",
        Struct = "󰙅",
        Text = "󰉿",
        TypeParameter = "󰊄",
        Unit = "󰑭",
        Value = "󰎠",
        Variable = "󰀫",
      }

      cmp.setup({
        enabled = function()
          return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
        preselect = cmp.PreselectMode.None,
        formatting = {
          expandable_indicator = true,
          format = function(entry, vim_item)
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return require("nvim-highlight-colors").format(entry, vim_item)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
          { name = "render-markdown" },
        }),
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          -- confirm completion item
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          -- trigger completion menu
          ["<C-Space>"] = cmp.mapping.complete(),

          -- more convenient navigation
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),

          -- scroll up and down the documentation window
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),

          -- navigate between snippet placeholders
          ["<C-f>"] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<C-b>"] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          -- disable one-character completion
          ["<C-y>"] = cmp.config.disable,
        }),
      })

      cmp.setup.filetype({
        -- uncomment below when https://github.com/rcarriga/cmp-dap/issues/7 is fixed,
        -- for now - use <C-x><C-o> to use omnifunc for completion suggestions
        -- "dap-repl",
        "dapui_watches",
        "dapui_hover",
      }, {
        sources = {
          { name = "dap" },
        },
      })
    end,
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports" },
        rust = { "rustfmt" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        yaml = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_format" }
          else
            return { "isort", "black" }
          end
        end,
        sql = { "sqruff" },

        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ["_"] = { "trim_whitespace" },
      },

      -- Set this to change the default values when calling conform.format()
      -- This will also affect the default values for format_on_save/format_after_save
      default_format_opts = {
        lsp_format = "fallback",
      },

      -- If this is set, Conform will run the formatter on save.
      -- It will pass the table to conform.format().
      -- This can also be a function that returns the table.
      format_on_save = {
        -- I recommend these options. See :help conform.format for details.
        lsp_format = "fallback",
        timeout_ms = 5000,
      },
    },
  },

  -- Linter
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        python = { "flake8" },
        sh = { "shellcheck" },
        go = { "revive" },
        make = { "checkmake" },
        sql = { "sqruff" },
      }
    end,
  },

  -- Debugger
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("nvim-dap-virtual-text").setup()

      -- js-debug adapter is installed via mason-nvim-dap (js-debug-adapter),
      -- but we still need to register all the adapters referenced below.
      for _, adapter_name in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge" }) do
        if not dap.adapters[adapter_name] then
          dap.adapters[adapter_name] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
              command = "node",
              args = {
                vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
                "${port}",
              },
            },
          }
        end
      end

      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              name = "Launch current file (Node)",
              type = "pwa-node",
              request = "launch",
              program = "${file}",
              cwd = "${workspaceFolder}",
              sourceMaps = true,
              resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
              console = "integratedTerminal",
            },
            {
              name = "Attach to running process",
              type = "pwa-node",
              request = "attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
              sourceMaps = true,
              restart = true,
            },
            {
              name = "Nest.js: start debug",
              type = "pwa-node",
              request = "launch",
              cwd = "${workspaceFolder}",
              runtimeArgs = { "--inspect-brk", "node_modules/.bin/nest", "start", "--watch" },
              sourceMaps = true,
              resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
              console = "integratedTerminal",
            },
            {
              name = "Nest.js: attach 9229",
              type = "pwa-node",
              request = "attach",
              cwd = "${workspaceFolder}",
              address = "localhost",
              port = 9229,
            },
            {
              name = "React: Chrome http://localhost:3000",
              type = "pwa-chrome",
              request = "launch",
              url = "http://localhost:3000",
              webRoot = "${workspaceFolder}",
            },
            {
              name = "React: MS Edge http://localhost:3000",
              type = "pwa-msedge",
              request = "launch",
              url = "http://localhost:3000",
              webRoot = "${workspaceFolder}",
            },
          }
        end
      end

      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      dapui.setup({
        floating = {
          border = "rounded",
        },
        layouts = {
          {
            elements = {
              {
                id = "scopes",
                size = 0.25,
              },
              {
                id = "breakpoints",
                size = 0.25,
              },
              {
                id = "stacks",
                size = 0.25,
              },
              {
                id = "watches",
                size = 0.25,
              },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              {
                id = "repl",
                size = 0.5,
              },
              {
                id = "console",
                size = 0.5,
              },
            },
            position = "bottom",
            size = 15,
          },
        },
      })

      -- see https://github.com/tjdevries/config.nvim/blob/master/lua/custom/plugins/dap.lua
      vim.keymap.set("n", "<leader>?", function()
        dapui.eval(nil, { enter = true })
      end, { desc = "Eval variable under cursor [DAP]" })

      vim.keymap.set("n", "<F1>", dap.continue, { desc = "Start/Continue [DAP]" })
      vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Step into [DAP]" })
      vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Step over [DAP]" })
      vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Step out [DAP]" })
      vim.keymap.set("n", "<F5>", dap.restart, { desc = "Restart current session [DAP]" })
      vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "Run to cursor [DAP]" })
      vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "Terminate [DAP]" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint [DAP]" })
      vim.keymap.set("n", "<leader>dB", dap.clear_breakpoints, { desc = "Clear all breakpoints [DAP]" })

      vim.keymap.set("n", "<leader>dC", function()
        vim.ui.input({ prompt = "Condition: " }, function(condition)
          if condition then
            require("dap").set_breakpoint(condition)
          end
        end)
      end, { desc = "Set conditional breakpoint [DAP]" })

      vim.keymap.set("n", "<leader>dh", function()
        require("dap.ui.widgets").hover()
      end, { desc = "Hover over [DAP]" })

      vim.keymap.set("n", "<leader>dv", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
      end, { desc = "View variables in the current scopes [DAP]" })
    end,
  },

  -- Test runner (with DAP integration)
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- adapters
      {
        "fredrikaverpil/neotest-golang",
        dependencies = {
          "leoluz/nvim-dap-go",
        },
      },
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-jest",
      "mrcjkb/rustaceanvim",
      -- this is to make sure mason is loaded first (otherwise codelldb fails to be found sometimes)
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-golang"),
          require("neotest-python"),
          require("rustaceanvim.neotest"),
          require("neotest-jest")({
            jestCommand = "npm test --",
            strategy_config = function(default_strategy, _)
              default_strategy["resolveSourceMapLocations"] = {
                "${workspaceFolder}/**",
                "!**/node_modules/**",
              }
              return default_strategy
            end,
            env = { CI = true },
            jestConfigFile = function(file)
              if string.find(file, "/packages/") then
                return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
              end

              return vim.fn.getcwd() .. "/jest.config.ts"
            end,
            cwd = function(file)
              if string.find(file, "/packages/") then
                return string.match(file, "(.-/[^/]+/)src")
              end
              return vim.fn.getcwd()
            end,
          }),
        },
      })

      vim.keymap.set("n", "<leader><leader>tt", function()
        require("neotest").run.run(vim.fn.expand("%"))
      end, { desc = "Run File [Neotest]" })

      vim.keymap.set("n", "<leader><leader>ta", function()
        require("neotest").run.run(vim.fn.getcwd())
      end, { desc = "Run All Test Files [Neotest]" })

      vim.keymap.set("n", "<leader><leader>tr", function()
        require("neotest").run.run()
      end, { desc = "Run Nearest [Neotest]" })

      vim.keymap.set("n", "<leader><leader>tl", function()
        require("neotest").run.run_last()
      end, { desc = "Run Last [Neotest]" })

      vim.keymap.set("n", "<leader><leader>ts", function()
        require("neotest").summary.toggle()
      end, { desc = "Toggle Summary [Neotest]" })

      vim.keymap.set("n", "<leader><leader>to", function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end, { desc = "Show Output [Neotest]" })

      vim.keymap.set("n", "<leader><leader>tP", function()
        require("neotest").output_panel.toggle()
      end, { desc = "Toggle Output Panel [Neotest]" })

      vim.keymap.set("n", "<leader><leader>tS", function()
        require("neotest").run.stop()
      end, { desc = "Stop [Neotest]" })

      vim.keymap.set("n", "<leader><leader>tw", function()
        require("neotest").watch.toggle(vim.fn.expand("%"))
      end, { desc = "Toggle Watch [Neotest]" })
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
    ft = { "markdown", "codecompanion" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },

  -- MCP Hub
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "bundled_build.lua", -- Bundles `mcp-hub` binary along with the neovim plugin
    config = function()
      require("mcphub").setup({
        use_bundled_binary = true, -- Use local `mcp-hub` binary
      })
    end,
  },

  -- AI companion
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- Optional, but recommended
      "ravitemer/mcphub.nvim",
      "ravitemer/codecompanion-history.nvim",
    },
    config = function()
      -- see:
      -- 1. https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
      -- 2. https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/adapters/gemini.lua
      require("codecompanion").setup({
        adapters = {
          http = {
            gemini = function()
              return require("codecompanion.adapters").extend("gemini", {
                env = {
                  api_key = "GEMINI_API_KEY",
                  model = "schema.model.default",
                },
                schema = {
                  model = {
                    default = "gemini-2.5-flash",
                  },
                },
              })
            end,
            openai = function()
              return require("codecompanion.adapters").extend("openai", {
                env = {
                  api_key = "OPENAI_API_KEY",
                },
              })
            end,
          },
        },
        strategies = {
          chat = {
            adapter = "gemini",
            slash_commands = {
              ["buffer"] = {
                opts = {
                  provider = "telescope",
                },
              },
              ["file"] = {
                opts = {
                  provider = "telescope",
                },
              },
              ["symbols"] = {
                opts = {
                  provider = "telescope",
                },
              },
            },
            keymaps = {
              close = {
                modes = {
                  n = "<Esc>",
                  i = "<Esc>",
                },
              },
            },
          },
          inline = {
            adapter = "gemini",
          },
          cmd = {
            adapter = "gemini",
          },
        },
        display = {
          action_palette = {
            provider = "telescope",
          },
        },
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              make_vars = true,
              make_slash_commands = true,
              show_result_in_chat = true,
            },
          },
          history = {
            enabled = true,
          },
        },
      })

      vim.keymap.set("n", "<leader>cc", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Toggle CodeCompanion chat" })
      vim.keymap.set("n", "<leader>cn", "<cmd>CodeCompanionChat<CR>", { desc = "Start new CodeCompanion chat" })
    end,
  },
}
