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

-- Disable automatic comment insertion
api.nvim_create_autocmd("BufEnter", {
  command = "set fo-=c fo-=r fo-=o",
  group = my_autocmds,
  pattern = "*",
})

-- Treat *.avsc files as json
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  command = "set ft=json",
  group = my_autocmds,
  pattern = "*.avsc",
})

-- Treat *.mdx files as markdown
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  command = "set ft=markdown",
  group = my_autocmds,
  pattern = "*.mdx",
})

-- Treat *.tf files as terraform
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  command = "set ft=terraform",
  group = my_autocmds,
  pattern = { "*.tf", "*.tfvars" },
})

-- Recognize HCL files
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  command = "set ft=hcl",
  group = my_autocmds,
  pattern = "*.hcl",
})

api.nvim_create_autocmd("User", {
  group = my_autocmds,
  pattern = "VeryLazy",
  callback = function()
    require("core.keymaps")
  end,
})
