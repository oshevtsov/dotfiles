local M = {}

function M.config()
  local status_ok, gitsigns = pcall(require, "gitsigns")
  if status_ok then
    local config = {
      preview_config = {
        border = "rounded",
      },
    }

    gitsigns.setup(config)
  end
end

return M
