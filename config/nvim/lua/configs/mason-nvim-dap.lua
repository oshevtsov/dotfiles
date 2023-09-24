local M = {}

function M.config()
  local mason_nvim_dap_ok, mason_nvim_dap = pcall(require, "mason-nvim-dap")
  if mason_nvim_dap_ok then
    mason_nvim_dap.setup({ handlers = {} })
  end
end

return M
