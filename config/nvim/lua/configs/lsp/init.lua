local status_ok, lspconfig = pcall(require, "lspconfig")
if status_ok then
  local handlers = require("configs.lsp.handlers")
  handlers.setup()

  local servers = {}
  local installer_available, lsp_installer = pcall(require, "nvim-lsp-installer")
  if installer_available then
    for _, server in ipairs(lsp_installer.get_installed_servers()) do
      table.insert(servers, server.name)
    end
  end

  for _, server_name in ipairs(servers) do
    local server = lspconfig[server_name]
    local opts = handlers:server_settings(server)
    server.setup(opts)
  end
end
