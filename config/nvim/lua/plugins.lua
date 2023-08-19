return {
  -- Color scheme
  {
    require("core.colorscheme").repo,
    config = function()
      require("core.colorscheme"):config()
    end,
  },

  -- Smart indentation
  {
    "nmac427/guess-indent.nvim",
    config = function()
      require("guess-indent").setup({})
    end,
  },

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = true
    end,
    config = function()
      require("configs.neo-tree").config()
    end,
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("configs.nvim-web-devicons").config()
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
    config = function()
      require("configs.comment").config()
    end,
  },

  -- Better buffer closing
  {
    "famiu/bufdelete.nvim",
    cmd = { "Bdelete", "Bwipeout" },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("configs.lualine").config()
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("configs.bufferline").config()
    end,
  },

  -- Handy mappings
  {
    "tpope/vim-unimpaired",
  },

  -- Git integration
  {
    "tpope/vim-fugitive",
  },

  -- Tmux integration (navigation + resize)
  {
    "aserowy/tmux.nvim",
    config = function()
      require("configs.tmux").config()
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("configs.gitsigns").config()
    end,
  },

  -- Terminal integration
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("configs.toggleterm").config()
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      require("configs.telescope").config()
    end,
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
      require("configs.treesitter").config()
    end,
  },

  -- Dashboard
  -- {
  --   "nvimdev/dashboard-nvim",
  --   event = "VimEnter",
  --   config = function()
  --     require("configs.dashboard-nvim").config()
  --   end,
  -- },
  -- {
  --   "goolord/alpha-nvim",
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   config = function()
  --     require("configs.alpha").config()
  --   end,
  -- },

  -- Smooth escaping
  {
    "max397574/better-escape.nvim",
    event = "InsertCharPre",
    config = function()
      require("configs.better-escape").config()
    end,
  },

  -- JSON schemas
  {
    "b0o/SchemaStore.nvim",
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

  -- Kubernetes Helm templates support
  {
    "towolf/vim-helm",
  },

  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      {
        "L3MON4D3/LuaSnip",
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
        config = function()
          require("configs.luasnip").config()
        end,
      },
    },
    event = "InsertEnter",
    config = function()
      require("configs.nvim-cmp").config()
    end,
  },

  -- Package manager for LSP servers, DAP servers, linters, and formatters
  {
    "williamboman/mason.nvim",
    config = function()
      require("configs.mason").config()
    end,
  },

  -- Built-in LSP
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      {
        "neovim/nvim-lspconfig",
        "simrat39/rust-tools.nvim",
        config = function()
          require("configs.lsp").setup()
        end,
      },
    },
    config = function()
      require("configs.mason-lspconfig").config()
    end,
  },

  -- Formatting and linting
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
      },
    },
    config = function()
      require("configs.mason-null-ls").config()
    end,
  },
}
