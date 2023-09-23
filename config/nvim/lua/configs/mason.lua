local M = {}

function M.config()
  local status_ok, mason = pcall(require, "mason")
  if status_ok then
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
      },
    })

    require("configs.mason-lspconfig").config()
    require("configs.mason-null-ls").config()
    require("configs.mason-nvim-dap").config()
  end
end

return M
