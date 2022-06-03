local M = {}

function M.config()
	local luasnip_ok, luasnip = pcall(require, "luasnip")
	if not luasnip_ok then
		return
	end

	-- Keep memory of the snippet to be able to cycle placeholders at any time
	luasnip.config.setup({
		-- history = true,
	})

	local loader_ok, loader = pcall(require, "luasnip.loaders.from_vscode")
	if not loader_ok then
		return
	end

	-- This function can also take paths to custom snippets, see luasnip docs
	loader.lazy_load()
end

return M
