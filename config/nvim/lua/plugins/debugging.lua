return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("nvim-dap-virtual-text").setup({})

    -- js-debug adapter is installed via mason-nvim-dap (js-debug-adapter),
    -- but we still need to register all the adapters referenced below.
    for _, adapter_name in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge" }) do
      if not dap.adapters[adapter_name] then
        dap.adapters[adapter_name] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end
    end

    for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
      if not dap.configurations[language] then
        dap.configurations[language] = {
          {
            name = "Launch current file (Node)",
            type = "pwa-node",
            request = "launch",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
            console = "integratedTerminal",
          },
          {
            name = "Attach to running process",
            type = "pwa-node",
            request = "attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            restart = true,
          },
          {
            name = "Nest.js: start debug",
            type = "pwa-node",
            request = "launch",
            cwd = "${workspaceFolder}",
            runtimeArgs = { "--inspect-brk", "node_modules/.bin/nest", "start", "--watch" },
            sourceMaps = true,
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
            console = "integratedTerminal",
          },
          {
            name = "Nest.js: attach 9229",
            type = "pwa-node",
            request = "attach",
            cwd = "${workspaceFolder}",
            address = "localhost",
            port = 9229,
          },
          {
            name = "React: Chrome http://localhost:3000",
            type = "pwa-chrome",
            request = "launch",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
          },
          {
            name = "React: MS Edge http://localhost:3000",
            type = "pwa-msedge",
            request = "launch",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
          },
        }
      end
    end

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    dapui.setup({
      floating = {
        border = "rounded",
      },
      layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.25,
            },
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "stacks",
              size = 0.25,
            },
            {
              id = "watches",
              size = 0.25,
            },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            {
              id = "repl",
              size = 0.5,
            },
            {
              id = "console",
              size = 0.5,
            },
          },
          position = "bottom",
          size = 15,
        },
      },
    })

    -- see https://github.com/tjdevries/config.nvim/blob/master/lua/custom/plugins/dap.lua
    vim.keymap.set("n", "<leader>?", function()
      dapui.eval(nil, { enter = true })
    end, { desc = "Eval variable under cursor [DAP]" })

    vim.keymap.set("n", "<F1>", dap.continue, { desc = "Start/Continue [DAP]" })
    vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Step into [DAP]" })
    vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Step over [DAP]" })
    vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Step out [DAP]" })
    vim.keymap.set("n", "<F5>", dap.restart, { desc = "Restart current session [DAP]" })
    vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "Run to cursor [DAP]" })
    vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "Terminate [DAP]" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint [DAP]" })
    vim.keymap.set("n", "<leader>dB", dap.clear_breakpoints, { desc = "Clear all breakpoints [DAP]" })

    vim.keymap.set("n", "<leader>dC", function()
      vim.ui.input({ prompt = "Condition: " }, function(condition)
        if condition then
          require("dap").set_breakpoint(condition)
        end
      end)
    end, { desc = "Set conditional breakpoint [DAP]" })

    vim.keymap.set("n", "<leader>dh", function()
      require("dap.ui.widgets").hover()
    end, { desc = "Hover over [DAP]" })

    vim.keymap.set("n", "<leader>dv", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.scopes)
    end, { desc = "View variables in the current scopes [DAP]" })
  end,
}
