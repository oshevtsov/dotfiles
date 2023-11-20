local M = {}

function M.config()
  local formatter_ok, formatter = pcall(require, "formatter")
  if formatter_ok then
    local prettier = require("formatter.defaults.prettier")
    local python_formatters = require("formatter.filetypes.python")
    formatter.setup({
      logging = false,
      log_level = vim.log.levels.OFF,
      filetype = {
        lua = {
          require("formatter.filetypes.lua").stylua,
        },
        python = {
          -- function()
          --   return {
          --     exe = "ruff",
          --     args = { "check", "--select", "I", "--fix", "-" },
          --     stdin = true,
          --   }
          -- end,
          -- function()
          --   return {
          --     exe = "ruff",
          --     args = { "format", "-q", "-" },
          --     stdin = true,
          --   }
          -- end,
          python_formatters.isort,
          python_formatters.black,
        },
        elixir = {
          require("formatter.filetypes.elixir").mixformat,
        },
        javascript = {
          prettier,
        },
        javascriptreact = {
          prettier,
        },
        typescript = {
          prettier,
        },
        typescriptreact = {
          prettier,
        },
        yaml = {
          prettier,
        },
        markdown = {
          prettier,
        },
        -- Use the special "*" filetype for defining formatter configurations on any filetype
        ["*"] = {
          -- "formatter.filetypes.any" defines default configurations for any filetype
          require("formatter.filetypes.any").remove_trailing_whitespace,
        },
      },
    })
  end
end

return M
