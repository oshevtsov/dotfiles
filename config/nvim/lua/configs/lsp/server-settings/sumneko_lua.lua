return {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      format = { enable = false },
      telemetry = { enable = false },
      runtime = { version = _VERSION },
      semantic = { enable = false },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.stdpath("config") .. "/lua",
        },
      },
    },
  },
}
