return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "folke/snacks.nvim", -- optional
    },
    config = function()
      local neogit = require("neogit")
      neogit.setup({})
      vim.api.nvim_create_user_command("G", "Neogit", { desc = "Start Neogit" })
      vim.keymap.set("n", "<leader>gg", function()
        neogit.open({ kind = "split" })
      end, { desc = "Open Neogit UI" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {
      {
        "esmuellert/vscode-diff.nvim",
        dependencies = {
          "MunifTanjim/nui.nvim",
        },
        cmd = "CodeDiff",
      },
    },
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
          map("n", "<leader>fs", function()
            gitsigns.stage_buffer()
          end, { desc = "Stage Git buffer" })

          map("n", "<leader>fu", function()
            gitsigns.reset_buffer_index()
          end, { desc = "Unstage Git buffer" })

          map("n", "<leader>fr", function()
            gitsigns.reset_buffer()
          end, { desc = "Reset Git buffer" })

          map("n", "<leader>hs", function()
            gitsigns.stage_hunk()
          end, { desc = "Stage/Unstage Git hunk" })

          map("n", "<leader>hr", function()
            gitsigns.reset_hunk()
          end, { desc = "Reset Git hunk" })

          map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Stage/Unstage Git hunk (visual mode)" })

          map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Reset Git hunk (visual mode)" })

          map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Git hunk" })
          map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview Git hunk inline" })

          map("n", "<leader>lb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "Blame Git line" })
          map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle blame Git line" })
        end,
      })

      vim.api.nvim_create_user_command("D", "CodeDiff", { desc = "Open CodeDiff Tab" })
    end,
  },
}
