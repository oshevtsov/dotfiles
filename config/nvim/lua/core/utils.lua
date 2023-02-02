local M = {}

function M.initialize_lazy()
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  vim.opt.rtp:prepend(lazy_path)
  local status_ok, lazy = pcall(require, "lazy")
  if not status_ok then
    vim.fn.delete(lazy_path, "rf")
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazy_path,
    })
    status_ok, lazy = pcall(require, "lazy")
    if not status_ok then
      error("Failed to load lazy at:" .. lazy_path .. "\n\n" .. lazy)
    end
  end
  return lazy
end

M.user_terminals = {}
function M:toggle_term_cmd(cmd)
  if self.user_terminals[cmd] == nil then
    self.user_terminals[cmd] = require("toggleterm.terminal").Terminal:new({
      cmd = cmd,
      hidden = true,
      direction = "float",
    })
  end

  self.user_terminals[cmd]:toggle()
end

return M

