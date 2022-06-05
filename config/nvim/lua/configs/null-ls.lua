local M = {}

function M.config()
	-- Formatting and linting
	-- https://github.com/jose-elias-alvarez/null-ls.nvim
	local status_ok, null_ls = pcall(require, "null-ls")
	if status_ok then
		-- Check supported formatters
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
		local formatting = null_ls.builtins.formatting

		-- Check supported linters
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
		local diagnostics = null_ls.builtins.diagnostics

		-- Check supported code actions
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
		local code_actions = null_ls.builtins.code_actions

		null_ls.setup({
			debug = true,
			sources = {
				-- Set formatters
				formatting.prettier,
				formatting.reorder_python_imports,
				formatting.rustfmt,
				formatting.stylua,
				formatting.black.with({ extra_args = { "--line-length", "88" } }),
				-- Set linters
				diagnostics.credo,
				diagnostics.eslint_d,
				diagnostics.gitlint,
				diagnostics.hadolint,
				diagnostics.flake8.with({ extra_args = { "--max-line-length", "88" } }),
				diagnostics.tsc,
				-- Set code actions
				code_actions.gitsigns,
				code_actions.refactoring,
			},
			-- NOTE: You can remove this on attach function to disable format on save
			on_attach = function()
				vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
			end,
		})
	end
end

return M
