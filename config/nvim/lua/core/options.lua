-- Neovim Lua API
local g = vim.g -- global editor variables
local fn = vim.fn -- call vim functions
local opt = vim.opt -- editor options (equivalent to using :set)
local cmd = vim.cmd -- execute vimscript commands

-- Map leader
g.mapleader = " "

-- Use Lua to detect filetype
-- g.do_filetype_lua = 1
-- g.did_load_filetypes = 0

-- Disable builtin packages
g.loaded_2html_plugin = false
g.loaded_getscript = false
g.loaded_getscriptPlugin = false
-- g.loaded_gzip = false
g.loaded_logipat = false
g.loaded_netrwFileHandlers = false
g.loaded_netrwPlugin = false
g.loaded_netrwSettngs = false
g.loaded_remote_plugins = false
-- g.loaded_tar = false
-- g.loaded_tarPlugin = false
-- g.loaded_zip = false
-- g.loaded_zipPlugin = false
g.loaded_vimball = false
g.loaded_vimballPlugin = false
-- g.zipPlugin = false

-- Tabs and indentation
opt.shiftwidth = 2 -- Number of space inserted for indentation
opt.tabstop = 2 -- Number of space in a tab
opt.expandtab = true -- Enable the use of space in tab
opt.smartindent = true -- Do auto indenting when starting a new line

-- UI settings
opt.fileencoding = "utf-8" -- File content encoding for the buffer
opt.clipboard = "unnamedplus" -- Connection to the system clipboard
opt.mouse = "nvc" -- Enable mouse support
opt.signcolumn = "yes" -- Always show the sign column
opt.foldmethod = "manual" -- Create folds manually
opt.completeopt = { "menuone", "noselect" } -- Options for insert mode completion
opt.hlsearch = false -- Do not keep the search item highlighted
opt.hidden = true -- Ignore unsaved buffers
opt.ignorecase = true -- Case insensitive searching
opt.smartcase = true -- Case sensitivie searching
opt.showmode = false -- Disable showing modes in command line
opt.showmatch = true -- Show matching bracket on insert
opt.splitbelow = true -- Splitting a new window below the current one
opt.splitright = true -- Splitting a new window at the right of the current one
opt.termguicolors = true -- Enable 24-bit RGB color in the TUI
opt.cursorline = true -- Highlight the text line of the cursor
opt.number = true -- Show numberline
opt.relativenumber = true -- Show relative numberline
opt.wrap = false -- Disable wrapping of lines longer than the width of window
opt.conceallevel = 0 -- Show text normally
opt.scrolloff = 8 -- Number of lines to keep above and below the cursor
opt.sidescrolloff = 8 -- Number of columns to keep at the sides of the cursor
opt.pumheight = 10 -- Height of the pop up menu
opt.history = 100 -- Number of commands to remember in a history table
opt.timeoutlen = 300 -- Length of time to wait for a mapped sequence
opt.updatetime = 300 -- Length of time to wait before triggering the plugin
opt.fillchars = { eob = " " } -- Disable `~` on nonexistent lines
opt.shortmess:append("I") -- Disable startup intro
opt.undofile = true -- Enable persistent undo
opt.listchars = {
  eol = "↵",
  tab = "▷ ",
  extends = "◣",
  precedes = "◢",
  nbsp = "○",
}
opt.list = false

-- Disable automatic comment insertion
cmd("au BufEnter * set fo-=c fo-=r fo-=o")

-- Treat *.avsc files as json
cmd("au BufRead,BufNewFile *.avsc set ft=json")
