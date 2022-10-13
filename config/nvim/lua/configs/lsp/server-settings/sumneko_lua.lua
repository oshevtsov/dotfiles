return {
  settings = {
    Lua = {
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.stdpath("config") .. "/lua",
        },
        ignoreDire = {
          vim.fn.stdpath("config") .. "/.undo",
          vim.fn.stdpath("config") .. "/.swp",
        },
      },
    },
  },
}
