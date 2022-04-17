local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then
	impatient.enable_profile()
end

-- Set options
require("core.options")

-- Disable unused built-ins
local utils = require("core.utils")
utils.disable_builtins()

-- Set colorscheme
require("core.colorscheme").load_scheme()

-- Set up plugins
local is_bootstrapped = utils.bootstrap_packer()
require("core.plugins")

if is_bootstrapped then
	require("packer").sync()
end

-- Set key mappings
require("core.mappings")

-- Set autocommands
vim.cmd([[
  augroup packer_conf
    autocmd!
    autocmd bufwritepost plugins.lua source <afile> | PackerSync
  augroup end
]])
