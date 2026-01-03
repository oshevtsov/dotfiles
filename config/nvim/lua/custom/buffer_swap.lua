-- Inspired by https://github.com/caenrique/swap-buffers.nvim
local M = {
  config = {
    ignore_ft = { "NvimTree" },
  },
}

---@alias Direction "h" | "j" | "k" | "l"

---Swap the current buffer with its neighbor so that they exchange places in the split window layout.
---@param dir Direction
function M.swap_curr_buf_with(dir)
  vim.validate("dir", dir, function(d)
    return vim.list_contains({ "h", "j", "k", "l" }, d)
  end, "must be one of 'h', 'j', 'k', 'l'")

  local curr_win = vim.api.nvim_get_current_win()

  -- if the cursor is in a floating window, do nothing
  if vim.api.nvim_win_get_config(curr_win).relative ~= "" then
    return
  end

  local curr_buf = vim.api.nvim_get_current_buf()
  local curr_ft = vim.api.nvim_get_option_value("filetype", { buf = curr_buf })

  local neighbor_win = vim.fn.win_getid(vim.fn.winnr(dir))
  local neighbor_buf = vim.api.nvim_win_get_buf(neighbor_win)
  local neighbor_ft = vim.api.nvim_get_option_value("filetype", { buf = neighbor_buf })

  -- do not perform a swap if the source or target buffer filetype is in the ignore-list
  local ignore_ft = M.config.ignore_ft
  if vim.tbl_contains(ignore_ft, curr_ft) or vim.tbl_contains(ignore_ft, neighbor_ft) then
    return
  end

  vim.cmd({ cmd = "b", args = { neighbor_buf } })
  vim.fn.win_gotoid(neighbor_win)
  vim.cmd({ cmd = "b", args = { curr_buf } })
end

return M
