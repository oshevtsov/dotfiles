return require("yaml-companion").setup({
  lspconfig = {
    settings = {
      yaml = {
        -- CloudFormation custom tags
        customTags = {
          "!And scalar",
          "!If scalar",
          "!Not",
          "!Equals scalar",
          "!Or scalar",
          "!FindInMap scalar",
          "!Base64",
          "!Cidr",
          "!Ref",
          "!Sub scalar",
          "!Sub sequence",
          "!GetAtt",
          "!GetAZs",
          "!ImportValue scalar",
          "!Select sequence",
          "!Split sequence",
          "!Join sequence",
        },
      },
    },
  },
})
