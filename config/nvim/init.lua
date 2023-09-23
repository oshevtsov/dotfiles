-- set editor options (including `mapleader` before lazy.nvim setup so that mappings work)
require("core.options")
require("core.autocmds")
require("core.utils").initialize_lazy().setup("plugins", {
  install = {
    missing = true,
    colorscheme = { "nightfox", "habamax" }, -- colorscheme applied to lazy.nvim UI
  },
  checker = {
    enabled = false, -- automatically check for plugin updates
  },
  performance = {
    disabled_plugins = {
      "gzip",
      -- "matchit",
      -- "matchparen",
      -- "netrwPlugin",
      "tarPlugin",
      "tohtml",
      "tutor",
      "zipPlugin",
    },
  },
})
