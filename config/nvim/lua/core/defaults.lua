local defaults = {
  colorscheme = {
    -- catppuccin, see https://github.com/catppuccin/catppuccin
    -- repo = "catppuccin/nvim",
    -- name = "catppuccin",
    -- theme = "catppuccin",
    -- config = {
    --   -- latte, frappe, macchiato, mocha
    --   flavour = "macchiato",
    --   styles = {
    --     comments = { "italic" },
    --   },
    -- },
    -- Nightfox, see https://github.com/EdenEast/nightfox.nvim
    repo = "EdenEast/nightfox.nvim",
    name = "nightfox",
    -- variants: nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox
    theme = "nightfox",
    config = {
      options = {
        styles = {
          comments = "italic",
        },
      },
    },
  },
}

return defaults
