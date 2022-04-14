local M = {}

local packer_status_ok, packer = pcall(require, "packer")
if not packer_status_ok then
  return
end

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
    "kyazdani42/nvim-tree.lua",
    requires = {
      "kyazdani42/nvim-web-devicons",
    },
    config = function()
      require("configs.nvim-tree").config()
    end,
  },

  -- Handy mappings
  {
    "tpope/vim-unimpaired",
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    config = function()
      require("configs.comment").config()
    end,
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
      'nvim-lua/plenary.nvim',
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
    run = ":TSUpdate",
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


  -- Built-in LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("configs.lsp")
    end,
  },

  -- LSP manager
  {
    "williamboman/nvim-lsp-installer",
    requires = {
      "neovim/nvim-lspconfig",
    },
  },

  -- LSP symbols
  {
    "simrat39/symbols-outline.nvim",
    requires = {
      "neovim/nvim-lspconfig",
    },
    setup = function()
      require("configs.symbols-outline").setup()
    end,
  },

  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
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

  -- Formatting and linting
  {
    "jose-elias-alvarez/null-ls.nvim",
    requires = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require("configs.null-ls").config()
    end,
  },
}

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
