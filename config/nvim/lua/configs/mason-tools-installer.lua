local M = {}

function M.config()
  local mti_ok, mti = pcall(require, "mason-tool-installer")
  if mti_ok then
    mti.setup({
      -- All lsp servers, linters, formatters, etc., see https://mason-registry.dev/registry/list.
      ensure_installed = {
        -- LSP servers
        "typescript-language-server",
        "lua-language-server",
        "json-lsp",
        "pyright",
        "rust_analyzer",
        "tsserver",
        "yaml-language-server",
        -- Linters
        "flake8",
        -- formatters
        "black",
        "isort",
        "stylua",
        -- Debuggers
        "debugpy",
        "codelldb",
      },

      -- if set to true this will check each tool for updates. If updates
      -- are available the tool will be updated. This setting does not
      -- affect :MasonToolsUpdate or :MasonToolsInstall.
      -- Default: false
      auto_update = false,

      -- automatically install / update on startup. If set to false nothing
      -- will happen on startup. You can use :MasonToolsInstall or
      -- :MasonToolsUpdate to install tools and check for updates.
      -- Default: true
      run_on_start = false,

      -- set a delay (in ms) before the installation starts. This is only
      -- effective if run_on_start is set to true.
      -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
      -- Default: 0
      start_delay = 0,

      -- Only attempt to install if 'debounce_hours' number of hours has
      -- elapsed since the last time Neovim was started. This stores a
      -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
      -- This is only relevant when you are using 'run_on_start'. It has no
      -- effect when running manually via ':MasonToolsInstall' etc....
      -- Default: nil
      debounce_hours = nil,
    })
  end
end

return M
