return {
  -- REMOVE filetypes override after https://github.com/neovim/neovim/issues/23184 is resolved
  -- neovim needs support for filetypes to contain dashes
  filetypes = { "terraform", "terraform_vars" },
  settings = {
    terraform = {
      languageServer = {
        path = "/home/oshevtsov/Downloads/terraform-ls/terraform-ls",
      },
    },
  },
}
