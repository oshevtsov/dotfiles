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

-- Close all buffers except the current one
local function close_all_buffes_except_current()
  local bufs = vim.api.nvim_list_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, i in ipairs(bufs) do
    if i ~= current_buf then
      vim.api.nvim_buf_delete(i, {})
    end
  end
end
map("n", "<leader>bb", close_all_buffes_except_current, { desc = "Close all buffers except current one", silent = true })

-- Diagnostics
map("n", "<leader>vd", vim.diagnostic.open_float, { desc = "View diagnostic" })

map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Diagnostic previous" })

map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Diagnostic next" })
