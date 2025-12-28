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

          local refresh_diff_git_status = function()
            local curr_buf = vim.api.nvim_get_current_buf()
            local diff_lifecycle = require("vscode-diff.render.lifecycle")
            local tabpage = diff_lifecycle.find_tabpage_by_buffer(curr_buf)

            if tabpage ~= nil then
              local session = diff_lifecycle.get_session(tabpage)
              if session ~= nil then
                if session.mode == "explorer" then
                  local diff_explorer = require("vscode-diff.render.explorer")
                  local explorer = diff_lifecycle.get_explorer(tabpage)
                  diff_explorer.refresh(explorer)
                end
              end
            end
          end

          -- Actions
          map("n", "<leader>bs", function()
            gitsigns.stage_buffer(refresh_diff_git_status)
          end, { desc = "Stage Git buffer" })

          map("n", "<leader>bu", function()
            gitsigns.reset_buffer_index(refresh_diff_git_status)
          end, { desc = "Unstage Git buffer" })

          map("n", "<leader>br", function()
            gitsigns.reset_buffer()
            refresh_diff_git_status()
          end, { desc = "Reset Git buffer" })

          map("n", "<leader>hs", function()
            gitsigns.stage_hunk(nil, nil, refresh_diff_git_status)
          end, { desc = "Stage/Unstage Git hunk" })

          map("n", "<leader>hr", function()
            gitsigns.reset_hunk(nil, nil, refresh_diff_git_status)
          end, { desc = "Reset Git hunk" })

          map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }, nil, refresh_diff_git_status)
          end, { desc = "Stage/Unstage Git hunk (visual mode)" })

          map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }, nil, refresh_diff_git_status)
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
