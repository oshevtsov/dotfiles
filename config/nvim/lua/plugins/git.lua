return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "folke/snacks.nvim", -- optional
    },
    config = function()
      require("neogit").setup({})
      vim.api.nvim_create_user_command("G", "Neogit", { desc = "Start Neogit" })
      vim.api.nvim_create_user_command("D", "DiffviewOpen", { desc = "Open DiffView Tab" })
    end,
  },
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
          map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Git buffer" })
          map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Git hunk" })
          map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "Blame Git line" })
          map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle blame Git line" })
          map("n", "<leader>td", gitsigns.preview_hunk_inline, { desc = "Toggle Git deleted" })
        end,
      })
    end,
  },
}
