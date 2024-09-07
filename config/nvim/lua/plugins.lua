return {
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
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
    "famiu/bufdelete.nvim",
    config = function()
      vim.keymap.set("n", "<leader>c", "<cmd>Bdelete<CR>", { desc = "Close buffer" })
      vim.keymap.set("n", "<leader>q", "<cmd>Bwipeout<CR>", { desc = "Delete buffer" })
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
      require("local-highlight").setup({})
    end,
  },

  -- Better notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
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
      require("nvim-tree").setup({})

      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle Explorer" })
      vim.keymap.set("n", "<leader>o", "<cmd>NvimTreeFocus<CR>", { desc = "Focus Explorer" })
      vim.keymap.set("n", "<leader>z", "<cmd>NvimTreeFindFile<CR>", { desc = "Reveal the open file in Explorer" })
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
          theme = "tokyonight",
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
      map("n", "<leader>rr", "<cmd>Telescope resume<CR>", { desc = "Resume the last picker" })
      map("n", "<leader>fg", "<cmd>Telescope live_grep_args<CR>", { desc = "Search grep" })
      map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "Git status" })
      map("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Git branches" })
      map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
      map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<CR>", { desc = "Search files" })
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
      map("n", "<leader>vd", vim.diagnostic.open_float, { desc = "View diagnostic" })
      map("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnostic previous" })
      map("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnostic next" })
      map("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Fuzzy search in current buffer" })

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
    version = ">=1.0.0",
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
              ["af"] = { query = "@function.outer", desc = "around function " },
              ["if"] = { query = "@function.inner", desc = "inside function " },
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
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v4.x",
      },
      -- JSON schemas
      "b0o/SchemaStore.nvim",
      -- Rust LSP setup
      {
        "mrcjkb/rustaceanvim",
        version = "^5", -- Recommended
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
      local lsp_zero = require("lsp-zero")

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
        vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = bufnr, desc = "Rename symbol" })
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", { buffer = bufnr, desc = "Format buffer" })
        vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = bufnr, desc = "Code action" })
      end

      -- Make sure this is called BEFORE mason-lspconfig setup
      lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- Set up rustaceanvim
      vim.g.rustaceanvim = {
        tools = {
          executor = "toggleterm",
          -- test_executor = "neotest", -- see test runner plugin below
          -- crate_test_executor = "neotest", -- see test runner plugin below
        },
        server = {
          capabilities = lsp_zero.get_capabilities(),
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
          "tsserver",
          "yaml-language-server",
          "gopls",
          -- Linters
          "flake8",
          "shellcheck",
          "revive",
          "checkmake",
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

      require("mason-lspconfig").setup({
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every language server without a "custom handler"
          function(server_name)
            local opts = vim.empty_dict()
            local present, settings = pcall(require, "config.lsp-server-settings." .. server_name)

            if present then
              opts = vim.tbl_deep_extend("force", settings, opts)
            end

            -- NOTE: Temporary fix before https://github.com/williamboman/mason-lspconfig.nvim/pull/459
            -- is merged
            if server_name == "tsserver" then
              server_name = "ts_ls"
            end

            require("lspconfig")[server_name].setup(opts)
          end,

          rust_analyzer = lsp_zero.noop,
        },
      })
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
    },
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      local cmp_action = require("lsp-zero").cmp_action()
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
            return vim_item
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
        }),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
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
          ["<C-f>"] = cmp_action.luasnip_jump_forward(),
          ["<C-b>"] = cmp_action.luasnip_jump_backward(),

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
      }
    end,
  },

  -- Debugger
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

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

      vim.keymap.set("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "Start/Continue [DAP]" })
      vim.keymap.set("n", "<leader>dq", "<cmd>DapTerminate<CR>", { desc = "Terminate [DAP]" })
      vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint [DAP]" })
      vim.keymap.set("n", "<leader>di", "<cmd>DapStepInto<CR>", { desc = "Step into [DAP]" })
      vim.keymap.set("n", "<leader>do", "<cmd>DapStepOver<CR>", { desc = "Step over [DAP]" })
      vim.keymap.set("n", "<leader>dO", "<cmd>DapStepOut<CR>", { desc = "Step out [DAP]" })
      vim.keymap.set("n", "<leader>dr", "<cmd>DapRestartFrame<CR>", { desc = "Restart frame [DAP]" })

      vim.keymap.set("n", "<leader>dR", function()
        require("dap").restart()
      end, { desc = "Restart session [DAP]" })

      vim.keymap.set("n", "<leader>dC", function()
        vim.ui.input({ prompt = "Condition: " }, function(condition)
          if condition then
            require("dap").set_breakpoint(condition)
          end
        end)
      end, { desc = "Set conditional breakpoint [DAP]" })

      vim.keymap.set("n", "<leader>dB", function()
        require("dap").clear_breakpoints()
      end, { desc = "Clear all breakpoints [DAP]" })

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
}
