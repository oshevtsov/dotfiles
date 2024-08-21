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

-- Disable automatic comment insertion
-- api.nvim_create_autocmd("BufEnter", {
--   command = "set fo-=c fo-=r fo-=o",
--   group = my_autocmds,
--   pattern = "*",
-- })
