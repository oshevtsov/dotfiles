return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "folke/snacks.nvim",
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
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "folke/snacks.nvim",
    }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
}
