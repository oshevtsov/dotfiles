local M = {}

function M.config()
  local null_ls_ok, null_ls = pcall(require, "null-ls")
  if null_ls_ok then
    null_ls.setup({
      debug = true,
      on_attach = function(client, bufnr)
        for _, _ in ipairs(null_ls.get_source({ name = "black" })) do
          -- 'black' does not support comment formatting
          -- this pieace of code makes ure that we are not trying to format ranges
          -- with `gq` using 'black', this will use the default vim fomatter instead
          -- see https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131
          vim.bo[bufnr].formatexpr = nil
          client.server_capabilities.documentRangeFormattingProvider = false
        end
        require("configs.lsp").on_attach(client, bufnr)
      end,
      sources = {
        null_ls.builtins.formatting.black.with({
          cwd = function(params)
            return vim.fn.fnamemodify(params.bufname, ':h')
          end,
        }),
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.mix,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.credo,
        null_ls.builtins.diagnostics.flake8,
      },
    })
  end

  local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")
  if mason_null_ls_ok then
    mason_null_ls.setup({
      -- A list of sources to install if they're not already installed.
      -- This setting has no relation with the `automatic_installation` setting.
      ensure_installed = {
        "flake8",
        "black",
        "isort",
        "stylua",
      },
      automatic_installation = false,
      automatic_setup = false,
    })
  end
end

return M
