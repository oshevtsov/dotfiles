local M = {}

function M.config()
  local status_ok, lualine = pcall(require, "lualine")
  if status_ok then
    local config = {
      options = {
        disabled_filetypes = { "NvimTree", "neo-tree", "dashboard", "alpha" },
      },
    }

    lualine.setup(config)
  end
end

return M
