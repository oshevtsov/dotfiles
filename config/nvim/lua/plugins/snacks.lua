return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = {
      enabled = true,
      layout = {
        preset = "dropdown",
        layout = {
          width = function()
            return vim.o.columns >= 100 and 0.75 or 0
          end,
          height = 0.9,
          min_width = 0,
          max_width = 180,
        },
      },
      win = {
        input = {
          keys = {
            ["p"] = { "focus_preview", mode = { "n" } },
          },
        },
        list = {
          keys = {
            ["p"] = "focus_preview",
          },
        },
      },
    },
    terminal = { enabled = true },
  },
  keys = {
    -- notifier
    {
      "<leader>dn",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss all notifications",
    },
    {
      "<leader>sn",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Search notifications",
    },
    -- picker
    {
      "<leader>ff",
      function()
        Snacks.picker.files({
          hidden = true,
        })
      end,
      desc = "Find files",
    },
    {
      "<leader>fi",
      function()
        Snacks.picker.files({
          hidden = true,
          ignored = true,
        })
      end,
      desc = "Find files (include ignored)",
    },
    {
      "<leader>fd",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Find dotfile config",
    },
    {
      "<leader>lr",
      function()
        Snacks.picker.lsp_references()
      end,
      desc = "LSP references",
    },
    {
      "<leader>rr",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume the last picker",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.grep({
          hidden = true,
          cmd = "rg",
        })
      end,
      desc = "Find grep",
    },
    {
      "<leader>fo",
      function()
        Snacks.picker.recent()
      end,
      desc = "Find old files",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Search keymaps",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Find buffers",
    },
    {
      "<leader>bd",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Buffer diagnostics",
    },
    {
      "<leader>wd",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Workspace diagnostics",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "Search help",
    },
    {
      "<leader>sr",
      function()
        Snacks.picker.registers()
      end,
      desc = "Search registers",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.lines()
      end,
      desc = "Search in current buffer",
    },
    {
      "<leader>bs",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "Buffer LSP symbols",
    },
    {
      "<leader>ws",
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "Workspace LSP symbols",
    },
  },
  init = function()
    local cmd = vim.cmd -- execute vimscript commands
    cmd(":command -nargs=+ Rg :lua Snacks.picker.grep_word({search = <q-args>})<CR>")
  end,
}
