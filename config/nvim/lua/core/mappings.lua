local opts = { silent = true }
local map = vim.keymap.set -- set new key mapping
local cmd = vim.cmd -- execute vimscript commands

-- Allow to save files as sudo (even if Neovim started without sudo)
map("c", "w!!", "w !sudo tee > /dev/null %", { desc = "Sudo write" })

-- Escape terminal emulator
map("t", "<C-q>", "<C-\\><C-n>", { desc = "Escape terminal" })

-- Highlights
map("n", "<leader><Space>", "<cmd>nohlsearch<CR>", { desc = "No highlight" })

-- Better tabbing
map("v", "<", "<gv", { desc = "Unindent line", silent = true })
map("v", ">", ">gv", { desc = "Indent line", silent = true })

-- Navigate buffers
map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer tab" })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer tab" })
map("n", ">b", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer tab right" })
map("n", "<b", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer tab left" })

-- Bufdelete
map("n", "<leader>c", "<cmd>Bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>q", "<cmd>Bwipeout<CR>", { desc = "Delete buffer" })

-- Nvim Tree
-- map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle explorer" })
-- map("n", "<leader>o", ":NvimTreeFocus<CR>", { desc = "Focus explorer" })

-- NeoTree
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle Explorer" })
map("n", "<leader>o", "<cmd>Neotree focus<CR>", { desc = "Focus Explorer" })

-- Git Signs
map("n", "<leader>gj", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next git hunk" })
map("n", "<leader>gk", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous git hunk" })
map("n", "<leader>gl", "<cmd>Gitsigns blame_line<CR>", { desc = "View git blame" })
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview git hunk" })
map("n", "<leader>gh", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset git hunk" })
map("n", "<leader>gr", "<cmd>Gitsigns reset_buffer<CR>", { desc = "Reset git buffer" })
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Stage git hunk" })
map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Unstage git hunk" })
map("n", "<leader>gd", "<cmd>Gitsigns diffthis HEAD<CR>", { desc = "View git diff" })

-- Toggle Term
map("n", "<C-t>", "<cmd>ToggleTermToggleAll<CR>", { desc = "Toggle all terminal windows", silent = true })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "ToggleTerm float" })
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "ToggleTerm horizontal split" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "ToggleTerm vertical split" })
map("n", "<leader>gg", "<cmd>lua require('core.utils').toggle_term_cmd('lazygit')<CR>", { desc = "ToggleTerm lazygit" })
map("n", "<leader>tp", "<cmd>lua require('core.utils').toggle_term_cmd('python')<CR>", { desc = "ToggleTerm python" })
map("n", "<leader>tn", "<cmd>lua require('core.utils').toggle_term_cmd('node')<CR>", { desc = "ToggleTerm node" })

-- Telescope
map(
	"n",
	"<leader>fd",
	"<cmd>lua require('telescope.builtin').find_files({prompt_title='Dotfiles', cwd='$HOME/.dotfiles'})<CR>",
	{ desc = "Search dotfiles" }
)
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Search grep" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "Git status" })
map("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Git branches" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Search files" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Search buffers" })
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "Search marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Search old files" })
map("n", "<leader>sh", "<cmd>Telescope help_tags<CR>", { desc = "Search help" })
map("n", "<leader>sm", "<cmd>Telescope man_pages<CR>", { desc = "Search man" })
map("n", "<leader>sr", "<cmd>Telescope registers<CR>", { desc = "Search registers" })
map("n", "<leader>sk", "<cmd>Telescope keymaps<CR>", { desc = "Search keymaps" })
map("n", "<leader>sc", "<cmd>Telescope commands<CR>", { desc = "Search commands" })
map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Search symbols" })
map("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>", { desc = "Search references" })
map("n", "<leader>lD", "<cmd>Telescope diagnostics<CR>", { desc = "Search diagnostics" })
cmd(":command -nargs=+ Rg :lua require('telescope.builtin').grep_string({search = <q-args>})<CR>")

-- Builtin LSP
map("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP information" })
map("n", "<leader>lI", "<cmd>LspInstallInfo<CR>", { desc = "LSP installer" })

-- LSP Symbols Outline
map("n", "<leader>lo", "<cmd>SymbolsOutline<CR>", { desc = "Symbols outline" })

-- Dashboard
map("n", "<leader>d", "<cmd>Dashboard<CR>", { desc = "Show dashboard" })
map("n", "<leader>fn", "<cmd>DashboardNewFile<CR>", opts)
map("n", "<leader>sl", "<cmd>SessionLoad<CR>", opts)
map("n", "<leader>ss", "<cmd>SessionSave<CR>", opts)

-- Improved terminal mappings
map("t", "<C-h>", "<C-\\><C-n><C-W>h", { desc = "Terminal left window navigation", silent = true })
map("t", "<C-j>", "<C-\\><C-n><C-W>j", { desc = "Terminal down window navigation", silent = true })
map("t", "<C-k>", "<C-\\><C-n><C-W>k", { desc = "Terminal up window navigation", silent = true })
map("t", "<C-l>", "<C-\\><C-n><C-W>l", { desc = "Terminal right window naviation", silent = true })
map("t", "<C-t>", "<cmd>ToggleTermToggleAll<CR>", { desc = "Toggle all terminal windows", silent = true })
