return {
  "romgrk/barbar.nvim",
  dependencies = {
    "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
    "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  config = function()
    require("barbar").setup({
      animation = false,
      auto_hide = true,
      tabpages = true,
      clickable = true,
      exclude_ft = { "qf" },
      focus_on_close = "left",
      icons = {
        pinned = { button = "", filename = true },
      },
      sidebar_filetypes = {
        NvimTree = {
          text = "File Explorer",
          align = "center",
        },
      },
      no_name_title = "[No Name]",
    })

    -- keymaps
    local map = vim.keymap.set

    map("n", "<S-l>", "<cmd>BufferNext<CR>", { desc = "Next buffer tab" })
    map("n", "<S-h>", "<cmd>BufferPrevious<CR>", { desc = "Previous buffer tab" })

    map("n", "<M-<>", "<cmd>BufferMovePrevious<CR>", { desc = "Move buffer tab left" })
    map("n", "<M->>", "<cmd>BufferMoveNext<CR>", { desc = "Move buffer tab right" })

    map("n", "<M-c>", "<cmd>BufferClose<CR>", { desc = "Close buffer" })
    map("n", "<M-S-c>", "<cmd>BufferRestore<CR>", { desc = "Restore last closed buffer" })
    map("n", "<leader>bb", "<cmd>BufferCloseAllButCurrentOrPinned<CR>", { desc = "Close all buffers except current and pinned" })

    map("n", "<M-p>", "<cmd>BufferPick<CR>", { desc = "Enter buffer-picking mode" })
    map("n", "<M-S-p>", "<cmd>BufferPickDelete<CR>", { desc = "Enter buffer-pick-delete mode" })

    map("n", "<C-p>", "<cmd>BufferPin<CR>", { desc = "Pin/unpin buffer" })
  end,
}
