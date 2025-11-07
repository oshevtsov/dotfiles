return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- adapters
    {
      "fredrikaverpil/neotest-golang",
      dependencies = {
        "leoluz/nvim-dap-go",
      },
    },
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-jest",
    "mrcjkb/rustaceanvim",
    -- this is to make sure mason is loaded first (otherwise codelldb fails to be found sometimes)
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-golang"),
        require("neotest-python"),
        require("rustaceanvim.neotest"),
        require("neotest-jest")({
          jestCommand = "npm test --",
          strategy_config = function(default_strategy, _)
            default_strategy["resolveSourceMapLocations"] = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            }
            return default_strategy
          end,
          env = { CI = true },
          jestConfigFile = function(file)
            if string.find(file, "/packages/") then
              return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
            end

            return vim.fn.getcwd() .. "/jest.config.ts"
          end,
          cwd = function(file)
            if string.find(file, "/packages/") then
              return string.match(file, "(.-/[^/]+/)src")
            end
            return vim.fn.getcwd()
          end,
        }),
      },
    })

    vim.keymap.set("n", "<leader><leader>tt", function()
      require("neotest").run.run(vim.fn.expand("%"))
    end, { desc = "Run File [Neotest]" })

    vim.keymap.set("n", "<leader><leader>ta", function()
      require("neotest").run.run(vim.fn.getcwd())
    end, { desc = "Run All Test Files [Neotest]" })

    vim.keymap.set("n", "<leader><leader>tr", function()
      require("neotest").run.run()
    end, { desc = "Run Nearest [Neotest]" })

    vim.keymap.set("n", "<leader><leader>tl", function()
      require("neotest").run.run_last()
    end, { desc = "Run Last [Neotest]" })

    vim.keymap.set("n", "<leader><leader>ts", function()
      require("neotest").summary.toggle()
    end, { desc = "Toggle Summary [Neotest]" })

    vim.keymap.set("n", "<leader><leader>to", function()
      require("neotest").output.open({ enter = true, auto_close = true })
    end, { desc = "Show Output [Neotest]" })

    vim.keymap.set("n", "<leader><leader>tP", function()
      require("neotest").output_panel.toggle()
    end, { desc = "Toggle Output Panel [Neotest]" })

    vim.keymap.set("n", "<leader><leader>tS", function()
      require("neotest").run.stop()
    end, { desc = "Stop [Neotest]" })

    vim.keymap.set("n", "<leader><leader>tw", function()
      require("neotest").watch.toggle(vim.fn.expand("%"))
    end, { desc = "Toggle Watch [Neotest]" })
  end,
}
