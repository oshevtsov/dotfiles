local M = {}

local colorscheme = require("core.defaults").colorscheme

M.repo = colorscheme.repo

function M.load_scheme()
  local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme.theme)
  if not status_ok then
    vim.notify("colorscheme " .. colorscheme.theme .. " not found!")
  end
end

function M:config()
  local status_ok, scheme = pcall(require, colorscheme.name)
  if not status_ok then
    return
  end

  scheme.setup(colorscheme.config)
  self.load_scheme()
end

return M
