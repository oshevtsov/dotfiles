local M = {}

function M.setup()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = true,
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}
	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

local function lsp_highlight_document(client)
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
		vim.api.nvim_create_autocmd("CursorHold", {
			group = "lsp_document_highlight",
			pattern = "<buffer>",
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = "lsp_document_highlight",
			pattern = "<buffer>",
			callback = vim.lsp.buf.clear_references,
		})
	end
end

function M.on_attach(client, bufnr)
	if client.name == "tsserver" then
		client.server_capabilities.document_formatting = false
	elseif client.name == "jsonls" then
		client.server_capabilities.document_formatting = false
	elseif client.name == "html" then
		client.server_capabilities.document_formatting = false
	elseif client.name == "sumneko_lua" then
		client.server_capabilities.document_formatting = false
	end

	-- Keymaps
	local map = vim.keymap.set
	map("n", "K", function()
		vim.lsp.buf.hover()
	end, { desc = "Hover symbol details", buffer = bufnr })

	map("n", "<leader>la", function()
		vim.lsp.buf.code_action()
	end, { desc = "LSP code action", buffer = bufnr })

	map("n", "<leader>ld", function()
		vim.diagnostic.open_float()
	end, { desc = "Hover diagnostics", buffer = bufnr })

	map("n", "<leader>lf", function()
		vim.lsp.buf.format({ async = true })
	end, { desc = "Format code", buffer = bufnr })

	map("n", "<leader>lh", function()
		vim.lsp.buf.signature_help()
	end, { desc = "Signature help", buffer = bufnr })

	map("n", "<leader>rn", function()
		vim.lsp.buf.rename()
	end, { desc = "Rename current symbol", buffer = bufnr })

	map("n", "gD", function()
		vim.lsp.buf.declaration()
	end, { desc = "Declaration of current symbol", buffer = bufnr })

	map("n", "gd", function()
		vim.lsp.buf.definition()
	end, { desc = "Definition of current symbol", buffer = bufnr })

	map("n", "gi", function()
		vim.lsp.buf.implementation()
	end, { desc = "Implementation of current symbol", buffer = bufnr })

	map("n", "gr", function()
		vim.lsp.buf.references()
	end, { desc = "References of current symbol", buffer = bufnr })

	map("n", "gl", function()
		vim.diagnostic.open_float()
	end, { desc = "Hover diagnostics", buffer = bufnr })

	map("n", "[d", function()
		vim.diagnostic.goto_prev()
	end, { desc = "Previous diagnostic", buffer = bufnr })

	map("n", "]d", function()
		vim.diagnostic.goto_next()
	end, { desc = "Next diagnostic", buffer = bufnr })

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
		vim.lsp.buf.format({ async = true })
	end, { desc = "Format file with LSP" })

	lsp_highlight_document(client)
end

M.disable_formatting = function(client)
	client.server_capabilities.documentFormattingProvider = false
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	M.capabilities = capabilities
else
	M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

function M:server_settings(server)
	local opts = vim.empty_dict()
	local present, settings = pcall(require, "configs.lsp.server-settings." .. server.name)

	if present then
		opts = vim.tbl_deep_extend("force", settings, opts)
	end

	opts.capabilities = vim.tbl_deep_extend("force", self.capabilities, server.capabilities or {})

	opts.on_attach = function(client, bufnr)
		self.on_attach(client, bufnr)
		if present and type(settings.on_attach) == "function" then
			settings.on_attach(client, bufnr)
		end
	end
	return opts
end

return M
