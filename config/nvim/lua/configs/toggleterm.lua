local M = {}

function M.config()
  local status_ok, toggleterm = pcall(require, "toggleterm")
  if not status_ok then
    return
  end

  local config = {
    shade_terminals = false,
    direction = "float",
    float_opts = {
      border = "curved",
    },
  }

  toggleterm.setup(config)
end

return M
