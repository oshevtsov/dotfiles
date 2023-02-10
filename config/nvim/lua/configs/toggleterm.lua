local M = {}

function M.config()
  local status_ok, toggleterm = pcall(require, "toggleterm")
  if status_ok then
    local config = {
      open_mapping = [[<C-\>]],
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.35
        end
      end,
      shade_terminals = false,
      persist_size = false,
      direction = "horizontal",
      float_opts = {
        border = "curved",
      },
    }

    toggleterm.setup(config)
  end
end

return M
