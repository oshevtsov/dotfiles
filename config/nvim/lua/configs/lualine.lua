local M = {}

function M.config()
  local status_ok, lualine = pcall(require, "lualine")
  if not status_ok then
    return
  end

  local config = {
    options = {
      disabled_filetypes = { "NvimTree", "dashboard" },
    },
  }

  lualine.setup(config)
end

return M
