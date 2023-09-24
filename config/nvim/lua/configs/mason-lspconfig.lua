local M = {}

function M.config()
  local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if status_ok then
    local handlers = {
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
    }

    mason_lspconfig.setup({ handlers = handlers })
  end
end

return M
