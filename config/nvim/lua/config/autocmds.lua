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

-- Disable automatic comment insertion
-- api.nvim_create_autocmd("BufEnter", {
--   command = "set fo-=c fo-=r fo-=o",
--   group = my_autocmds,
--   pattern = "*",
-- })

-- See https://github.com/rmarganti/.dotfiles/blob/main/dots/.config/nvim/lua/rmarganti/core/autocommands.lua#L69
local function delete_qf_items()
  local mode = vim.api.nvim_get_mode()["mode"]

  local start_idx
  local count

  if mode == "n" then
    -- Normal mode
    start_idx = vim.fn.line(".")
    count = vim.v.count > 0 and vim.v.count or 1
  else
    -- Visual mode
    local v_start_idx = vim.fn.line("v")
    local v_end_idx = vim.fn.line(".")

    start_idx = math.min(v_start_idx, v_end_idx)
    count = math.abs(v_end_idx - v_start_idx) + 1

    -- Go back to normal
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(
        "<esc>", -- what to escape
        true, -- Vim leftovers
        false, -- Also replace `<lt>`?
        true -- Replace keycodes (like `<esc>`)?
      ),
      "x", -- Mode flag
      false -- Should be false, since we already `nvim_replace_termcodes()`
    )
  end

  local qflist = vim.fn.getqflist()

  for _ = 1, count, 1 do
    table.remove(qflist, start_idx)
  end

  vim.fn.setqflist(qflist, "r")
  vim.fn.cursor(start_idx, 1)
end

vim.api.nvim_create_autocmd("FileType", {
  group = my_autocmds,
  pattern = "qf",
  callback = function()
    -- Do not show quickfix in buffer lists.
    vim.api.nvim_set_option_value("buflisted", false, { buf = 0 })

    -- Escape closes quickfix window.
    vim.keymap.set("n", "<ESC>", "<CMD>cclose<CR>", { buffer = true, remap = false, silent = true })

    -- `dd` deletes an item from the list.
    vim.keymap.set("n", "dd", delete_qf_items, { buffer = true })
    vim.keymap.set("x", "d", delete_qf_items, { buffer = true })
  end,
  desc = "Quickfix tweaks",
})

-- LSP rename files
-- See https://github.com/folke/snacks.nvim/blob/main/docs/rename.md
vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions[1].type == "move" then
      Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
    end
  end,
})

-- TODO: This is not working
-- local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "NvimTreeSetup",
--   callback = function()
--     local events = require("nvim-tree.api").events
--     events.subscribe(events.Event.NodeRenamed, function(data)
--       print("Node renamed from " .. data.old_name .. " to " .. data.new_name)
--       if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
--         prev = data -- note that this line is incorrect in the link above
--         Snacks.rename.on_rename_file(data.old_name, data.new_name)
--       end
--     end)
--   end,
-- })
