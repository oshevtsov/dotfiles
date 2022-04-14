local M = {}

function M.disable_builtins()
  local g = vim.g
  g.loaded_2html_plugin = false
  g.loaded_getscript = false
  g.loaded_getscriptPlugin = false
  g.loaded_gzip = false
  g.loaded_logipat = false
  g.loaded_netrwFileHandlers = false
  g.loaded_netrwPlugin = false
  g.loaded_netrwSettngs = false
  g.loaded_remote_plugins = false
  g.loaded_tar = false
  g.loaded_tarPlugin = false
  g.loaded_zip = false
  g.loaded_zipPlugin = false
  g.loaded_vimball = false
  g.loaded_vimballPlugin = false
  g.zipPlugin = false
end

function M.bootstrap_packer()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  local is_bootstrapped = false
  if fn.empty(fn.glob(install_path)) > 0 then
    is_bootstrapped = fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })
    print("Cloning packer...\nSetup Neovim")
    vim.cmd("packadd packer.nvim")
  end
  return is_bootstrapped
end

local _user_terminals = {}

function M.toggle_term_cmd(cmd)
  if _user_terminals[cmd] == nil then
    _user_terminals[cmd] = require("toggleterm.terminal").Terminal:new({ cmd = cmd, hidden = true })
  end

  _user_terminals[cmd]:toggle()
end

return M
