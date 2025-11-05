return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "goimports" },
      rust = { "rustfmt" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      yaml = { "prettier" },
      json = { "prettier" },
      markdown = { "prettier" },
      python = function(bufnr)
        if require("conform").get_formatter_info("ruff_format", bufnr).available then
          return { "ruff_format" }
        else
          return { "isort", "black" }
        end
      end,
      sql = { "sqruff" },

      -- Use the "_" filetype to run formatters on filetypes that don't
      -- have other formatters configured.
      ["_"] = { "trim_whitespace" },
    },

    -- Set this to change the default values when calling conform.format()
    -- This will also affect the default values for format_on_save/format_after_save
    default_format_opts = {
      lsp_format = "fallback",
    },

    -- If this is set, Conform will run the formatter on save.
    -- It will pass the table to conform.format().
    -- This can also be a function that returns the table.
    format_on_save = {
      -- I recommend these options. See :help conform.format for details.
      lsp_format = "fallback",
      timeout_ms = 5000,
    },
  },
}
