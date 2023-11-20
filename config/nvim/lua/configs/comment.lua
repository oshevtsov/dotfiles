local M = {}

function M.config()
  local ctx_commentstring_ok, ctx_commentstring = pcall(require, "ts_context_commentstring")
  if ctx_commentstring_ok then
    vim.g.skip_ts_context_commentstring_module = true
    ctx_commentstring.setup({ enable_autocmd = false })

    local comment_ok, comment = pcall(require, "Comment")
    if comment_ok then
      comment.setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end
  end
end

return M
