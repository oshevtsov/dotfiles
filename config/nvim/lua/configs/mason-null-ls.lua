local M = {}

function M.config()
  local status_ok, mason_null_ls = pcall(require, "mason-null-ls")
  if status_ok then
    mason_null_ls.setup({
      -- A list of sources to install if they're not already installed.
      -- This setting has no relation with the `automatic_installation` setting.
      ensure_installed = {
        "flake8",
        "black",
        "isort",
      },

      -- Run `require("null-ls").setup`.
      -- Will automatically install masons tools based on selected sources in `null-ls`.
      -- Can also be an exclusion list.
      -- Example: `automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }`
      automatic_installation = false,
    })

    local null_ls_ok, null_ls = pcall(require, "null-ls")

    if null_ls_ok then
      mason_null_ls.setup_handlers({
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(source_name)
          -- all sources with no handler get passed here
        end,

        -- Next, you can provide targeted overrides for specific servers.
        ["flake8"] = function()
          null_ls.register(null_ls.builtins.diagnostics.flake8)
        end,
        ["isort"] = function()
          null_ls.register(null_ls.builtins.formatting.isort)
        end,
        ["black"] = function()
          null_ls.register(null_ls.builtins.formatting.black)
        end,
      })

      null_ls.setup({
        debug = true,
        on_attach = require("configs.lsp").on_attach,
      })
    end
  end
end

return M
