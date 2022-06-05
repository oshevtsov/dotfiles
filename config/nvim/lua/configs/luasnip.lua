local M = {}

function M.config()
	local luasnip_ok, luasnip = pcall(require, "luasnip")
	if luasnip_ok then
		-- Keep memory of the snippet to be able to cycle placeholders at any time
		luasnip.config.setup({
			-- history = true,
		})
	end

	local loader_ok, loader = pcall(require, "luasnip.loaders.from_vscode")
	if loader_ok then
		-- This function can also take paths to custom snippets, see luasnip docs
		loader.lazy_load()
	end
end

return M
