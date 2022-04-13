local M = {}

local opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap

-- Allow to save files as sudo (even if Neovim started without sudo)
map("c", "w!!", "w !sudo tee > /dev/null %", opts)

-- Escape terminal emulator
map("t", "<C-q>", "<C-\\><C-n>", opts)

-- Highlights
map("n", "<leader><Space>", "<cmd>set hlsearch!<CR>", opts)

-- Better tabbing
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Nvim Tree
map("n", "<C-n>", ":NvimTreeToggle<CR>", opts)
map("n", "<M-n>", ":NvimTreeFindFile<CR>", opts)

-- Git Signs
map("n", "<leader>gj", "<cmd>Gitsigns next_hunk<CR>", opts)
map("n", "<leader>gk", "<cmd>Gitsigns prev_hunk<CR>", opts)
map("n", "<leader>gl", "<cmd>Gitsigns blame_line<CR>", opts)
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", opts)
map("n", "<leader>gh", "<cmd>Gitsigns reset_hunk<CR>", opts)
map("n", "<leader>gr", "<cmd>Gitsigns reset_buffer<CR>", opts)
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", opts)
map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", opts)
map("n", "<leader>gd", "<cmd>Gitsigns diffthis HEAD<CR>", opts)

-- Toggle Term
map("n", "<C-\\>", "<cmd>ToggleTerm<CR>", opts)
map("n", "<leader>gg", "<cmd>lua require('core.utils').toggle_term_cmd('lazygit')<CR>", opts)
map("n", "<leader>tp", "<cmd>lua require('core.utils').toggle_term_cmd('python')<CR>", opts)

return M
