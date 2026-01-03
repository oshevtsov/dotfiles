local map = vim.keymap.set -- set new key mapping

-- Allow to save files as sudo (even if Neovim started without sudo)
map("c", "w!!", "w !sudo tee > /dev/null %", { desc = "Sudo write" })

-- Enter select mode from insert mode (useful for jumping between snippet nodes)
map("i", "<M-g>", "<Esc>gh", { desc = "Insert mode --> select mode" })

-- Escape terminal emulator
map("t", "<C-q>", "<C-\\><C-n>", { desc = "Escape terminal" })

-- Create new empty buffer
map("n", "<leader>fn", "<cmd>enew<CR>", { desc = "Create empty buffer", silent = true })

-- Better tabbing
map("v", "<", "<gv", { desc = "Unindent line", silent = true })
map("v", ">", ">gv", { desc = "Indent line", silent = true })

-- Move cursor between windows
map("n", "<C-h>", "<C-W>h", { desc = "Move cursor to the window on the left", silent = true })
map("n", "<C-j>", "<C-W>j", { desc = "Move cursor to the window below", silent = true })
map("n", "<C-k>", "<C-W>k", { desc = "Move cursor to the window above", silent = true })
map("n", "<C-l>", "<C-W>l", { desc = "Move cursor to the window on the right", silent = true })

-- Resize windows
-- simple mnemonics behind the keymaps: left or down means decrease, right or up mean increase
map("n", "<A-h>", "<C-W><", { desc = "Decrease window width", silent = true })
map("n", "<A-j>", "<C-W>-", { desc = "Decrease window height", silent = true })
map("n", "<A-k>", "<C-W>+", { desc = "Increase window height", silent = true })
map("n", "<A-l>", "<C-W>>", { desc = "Increase window width", silent = true })

-- Improved terminal mappings
map("t", "<C-h>", "<C-\\><C-n><C-W>h", { desc = "Terminal left window navigation", silent = true })
map("t", "<C-j>", "<C-\\><C-n><C-W>j", { desc = "Terminal down window navigation", silent = true })
map("t", "<C-k>", "<C-\\><C-n><C-W>k", { desc = "Terminal up window navigation", silent = true })
map("t", "<C-l>", "<C-\\><C-n><C-W>l", { desc = "Terminal right window naviation", silent = true })

-- Some of the mappings inspired by vim-unimpaired
map("n", "[q", "<cmd>cprevious<CR>", { desc = "Previous in quickfix list", silent = true })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next in quickfix list", silent = true })
map("n", "[Q", "<cmd>cfirst<CR>", { desc = "First in quickfix list", silent = true })
map("n", "]Q", "<cmd>clast<CR>", { desc = "Last in quickfix list", silent = true })
map("n", "[<Space>", "<cmd>call append(line('.')-1, '')<CR>", { desc = "Insert empty line above", silent = true })
map("n", "]<Space>", "<cmd>call append(line('.'), '')<CR>", { desc = "Insert empty line below", silent = true })

-- Diagnostics
map("n", "<leader>vd", vim.diagnostic.open_float, { desc = "View diagnostic" })

map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Diagnostic previous" })

map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Diagnostic next" })
