-- Neovim Lua API
local api = vim.api -- call vim api

-- Custom auto commands that are not related to any plugins
local my_autocmds = api.nvim_create_augroup("oshevtsov_autocmd", { clear = true })

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "PmenuSel" })
  end,
  group = my_autocmds,
  pattern = "*",
})

-- Set up linting (see https://github.com/mfussenegger/nvim-lint)
api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    require("lint").try_lint()
  end,
  group = my_autocmds,
  pattern = "*",
})

-- Make line numbers more visible (see :help guifg for available colors)
api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "LightGray" })
    vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "LightGray" })
  end,
  group = my_autocmds,
  once = true,
})

-- This can be implemented in eslint LSP config, see:
-- https://github.com/neovim/nvim-lspconfig/pull/3844/files
api.nvim_create_autocmd("BufWritePre", {
  group = my_autocmds,
  command = "LspEslintFixAll",
  pattern = { "*.js", "*.jsx", "*.mjs", "*.cjs", "*.ts", "*.tsx", "*.mts", "*.cts" },
})

-- Disable automatic comment insertion
-- api.nvim_create_autocmd("BufEnter", {
--   command = "set fo-=c fo-=r fo-=o",
--   group = my_autocmds,
--   pattern = "*",
-- })
