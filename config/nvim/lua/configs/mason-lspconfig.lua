local M = {}

function M.config()
  local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if status_ok then
    mason_lspconfig.setup({
      -- A list of servers to automatically install if they're not already installed.
      -- Example: { "rust_analyzer@nightly", "sumneko_lua" }
      -- This setting has no relation with the `automatic_installation` setting.
      ensure_installed = {
        "jsonls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "tsserver",
        "yamlls",
      },
      -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
      -- This setting has no relation with the `ensure_installed` setting.
      -- Can either be:
      --   - false: Servers are not automatically installed.
      --   - true: All servers set up via lspconfig are automatically installed.
      --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
      --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
      automatic_installation = false,
    })

    mason_lspconfig.setup_handlers({
      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      function(server_name) -- default handler (optional)
        local lsp = require("configs.lsp")
        lsp.setup_server(server_name)
      end,

      -- Next, you can provide targeted overrides for specific servers.
      ["rust_analyzer"] = function()
        local lsp = require("configs.lsp")
        local server = require("lspconfig")["rust_analyzer"]
        local server_settings = lsp:server_settings(server)
        require("rust-tools").setup({
          tools = {
            -- how to execute terminal commands
            -- options right now: termopen / quickfix / toggleterm / vimux
            executor = require("rust-tools.executors").toggleterm,
          },
          server = server_settings,
        })
      end,
    })
  end
end

return M
