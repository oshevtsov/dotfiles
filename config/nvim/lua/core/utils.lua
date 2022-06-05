local M = {}

function M.initialize_packer()
  local fn = vim.fn
  local status_ok, packer = pcall(require, "packer")
  if not status_ok then
    local packer_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    vim.fn.delete(packer_path, "rf")
    vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      packer_path,
    })
    print("Cloning packer...\nSetup Neovim")
    vim.cmd("packadd packer.nvim")
    status_ok, packer = pcall(require, "packer")
    if not status_ok then
      error("Failed to load packer at:" .. packer_path .. "\n\n" .. packer)
    end
  end
  return packer
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
