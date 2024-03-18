local M = {}

function M.config()
  local lsp = require("configs.lsp")
  local executors = require("rustaceanvim.executors")
  local opts = {
    tools = {
      executor = executors.toggleterm,
      test_executor = executors.toggleterm,
      crate_test_executor = executors.toggleterm,
    },
    server = {
      on_attach = lsp.on_attach,
      default_settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
          check = {
            command = "clippy",
          },
        },
      },
    },
  }

  vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
end

return M
