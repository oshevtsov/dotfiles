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
