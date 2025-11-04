return {
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
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup({
        ---Highlight tailwind colors, e.g. 'bg-blue-500'
        enable_tailwind = true,
      })
    end,
  },
}
