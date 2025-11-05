return {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      python = { "flake8" },
      sh = { "shellcheck" },
      go = { "revive" },
      make = { "checkmake" },
      sql = { "sqruff" },
    }
  end,
}
