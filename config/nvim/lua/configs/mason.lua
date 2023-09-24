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

    require("configs.mason-tools-installer").config()
    require("configs.mason-lspconfig").config()
    require("configs.nvim-lint").config()
    require("configs.formatter").config()
    require("configs.mason-nvim-dap").config()
  end
end

return M
