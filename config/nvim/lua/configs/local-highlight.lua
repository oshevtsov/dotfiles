local M = {}

function M.config()
  local local_hl_ok, local_hl = pcall(require, "local-highlight")
  if local_hl_ok then
    local_hl.setup({
      disable_file_types = {},
      hlgroup = "Search",
      cw_hlgroup = nil,
      insert_mode = false,
      min_match_len = 2,
      max_match_len = math.huge,
      highlight_single_match = true,
    })
  end
end

return M
