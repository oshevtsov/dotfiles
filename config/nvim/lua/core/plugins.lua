local M = {}

local plugins_list = {
  -- Plugin manager
  {
    "wbthomason/packer.nvim",
  },

  -- Optimiser
  {
    "lewis6991/impatient.nvim",
  },

  -- Color scheme
  {
    require("core.colorscheme").repo,
    config = function()
      require("core.colorscheme"):config()
    end,
  },

  -- Tmux integration (navigation + resize)
  {
    "aserowy/tmux.nvim",
    config = function()
      require("configs.tmux").config()
    end,
  },

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    setup = function()
      vim.g.neo_tree_remove_legacy_commands = true
    end,
    config = function()
      require("configs.neo-tree").config()
    end,
  },

  -- Handy mappings
  {
    "tpope/vim-unimpaired",
  },

  -- Surround selections
  {
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
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
    requires = {
      "kyazdani42/nvim-web-devicons",
    },
    config = function()
      require("configs.lualine").config()
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    requires = {
      "kyazdani42/nvim-web-devicons",
    },
    config = function()
      require("configs.bufferline").config()
    end,
  },

  -- Git integration
  {
    "tpope/vim-fugitive",
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
    requires = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("configs.telescope").config()
    end,
  },

  -- Fuzzy sorter (performance improvemet)
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    after = "telescope.nvim",
    run = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    run = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
      require("configs.treesitter").config()
    end,
  },

  -- Parenthesis highlighting
  {
    "p00f/nvim-ts-rainbow",
    after = "nvim-treesitter",
  },

  -- Autoclose tags
  {
    "windwp/nvim-ts-autotag",
    after = "nvim-treesitter",
  },

  -- Context based commenting
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    after = "nvim-treesitter",
  },

  -- Additional text objects via treesitter
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  },

  -- Formatting and linting (configured by mason-null-ls)
  {
    "jose-elias-alvarez/null-ls.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- Built-in LSP (lsps are configured by mason-lspconfig)
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("configs.lsp").setup()
    end,
  },

  -- LSP manager (configure by mason-lspconfig)
  {
    "williamboman/mason.nvim",
  },

  -- LSP manager lspconfig extension
  {
    "williamboman/mason-lspconfig.nvim",
    after = { "mason.nvim", "nvim-lspconfig" },
    config = function()
      require("configs.mason-lspconfig").config()
      require("configs.mason").config()
    end,
  },

  -- LSP manager null-ls extension
  {
    "jayp0521/mason-null-ls.nvim",
    after = { "mason.nvim", "null-ls.nvim" },
    config = function()
      require("configs.mason-null-ls").config()
    end,
  },

  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      require("configs.nvim-cmp").config()
    end,
  },

  -- LSP completion source
  {
    "hrsh7th/cmp-nvim-lsp",
    after = "nvim-cmp",
  },

  -- Buffer completion source
  {
    "hrsh7th/cmp-buffer",
    after = "nvim-cmp",
  },

  -- Path completion source
  {
    "hrsh7th/cmp-path",
    after = "nvim-cmp",
  },

  -- Function signature completion source
  {
    "hrsh7th/cmp-nvim-lsp-signature-help",
    after = "nvim-cmp",
  },

  -- Snippet completion source
  {
    "saadparwaiz1/cmp_luasnip",
    after = "nvim-cmp",
  },

  -- Snippet collection
  {
    "rafamadriz/friendly-snippets",
    after = "nvim-cmp",
  },

  -- Snippet engine
  {
    "L3MON4D3/LuaSnip",
    after = "friendly-snippets",
    config = function()
      require("configs.luasnip").config()
    end,
  },

  -- Dashboard
  {
    "glepnir/dashboard-nvim",
    config = function()
      require("configs.dashboard-nvim").config()
    end,
  },

  -- Smooth escaping
  {
    "max397574/better-escape.nvim",
    event = "InsertCharPre",
    config = function()
      require("configs.better-escape").config()
    end,
  },
}

local packer = require("core.utils").initialize_packer()
packer.startup({
  function(use)
    for _, plugin in ipairs(plugins_list) do
      use(plugin)
    end
  end,
  config = {
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "rounded" })
      end,
    },
    profile = {
      enable = true,
      threshold = 0.0001,
    },
    auto_clean = true,
    compile_on_sync = true,
  },
})

return M
