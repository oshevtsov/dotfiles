local M = {}

function M.config()
  local lint_ok, lint = pcall(require, "lint")
  if lint_ok then
    lint.linters_by_ft = {
      python = { "flake8" },
      terraform = { "tflint" },
      sh = { "shellcheck" },
    }
  end
end

return M
