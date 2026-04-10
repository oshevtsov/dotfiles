return {
  "nvim-mini/mini.nvim",
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      config = function()
        require("ts_context_commentstring").setup({ enable_autocmd = false })
      end,
    },
  },
  version = false,
  config = function()
    require("mini.splitjoin").setup()
    require("mini.comment").setup({
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    })
  end,
}
