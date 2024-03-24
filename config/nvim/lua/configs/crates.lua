local M = {}

function M.config()
  local status_ok, crates = pcall(require, "crates")
  if status_ok then
    crates.setup({
      lsp = {
        enabled = true,
        on_attach = require("configs.lsp").on_attach,
        actions = true,
        completion = true,
        hover = true,
      },
    })
  end
end

return M
