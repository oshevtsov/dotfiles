return {
  -- REMOVE filetypes and cmd override after https://github.com/neovim/neovim/issues/23184
  -- is resolved neovim needs support for filetypes to contain dashes
  filetypes = { "terraform", "terraform_vars" },
  cmd = { "/home/oshevtsov/Downloads/terraform-ls/terraform-ls", "serve" },
}
