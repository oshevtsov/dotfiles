vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<CR>",
  "<cmd>lua require('kulala').run()<cr>",
  { noremap = true, silent = true, desc = "Execute the request" }
)

vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<leader>t",
  "<cmd>lua require('kulala').toggle_view()<cr>",
  { noremap = true, silent = true, desc = "Toggle between body and headers" }
)

vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<leader>p",
  "<cmd>lua require('kulala').scratchpad()<cr>",
  { noremap = true, silent = true, desc = "Open scratchpad" }
)

-- The commands below don't work until you run the first query
vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<leader>s",
  "<cmd>lua require('kulala').search()<cr>",
  { noremap = true, silent = true, desc = "Search all named (with @name) requests in current buffer" }
)

vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "[",
  "<cmd>lua require('kulala').jump_prev()<cr>",
  { noremap = true, silent = true, desc = "Jump to the previous request" }
)

vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "]",
  "<cmd>lua require('kulala').jump_next()<cr>",
  { noremap = true, silent = true, desc = "Jump to the next request" }
)
