return {
  settings = {
    ["rust-analyzer"] = {
      -- enable clippy on save
      check = {
        command = "clippy",
      },
    },
  },
}
