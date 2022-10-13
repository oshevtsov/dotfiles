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

function M.on_attach(client, bufnr)
  local capabilities = client.server_capabilities

  -- Keymaps
  local map = vim.keymap.set

  -- diagnostics
  map("n", "<leader>ld", function()
    vim.diagnostic.open_float()
  end, { desc = "Hover diagnostics", buffer = bufnr })

  map("n", "gl", function()
    vim.diagnostic.open_float()
  end, { desc = "Hover diagnostics", buffer = bufnr })

  map("n", "[d", function()
    vim.diagnostic.goto_prev()
  end, { desc = "Previous diagnostic", buffer = bufnr })

  map("n", "]d", function()
    vim.diagnostic.goto_next()
  end, { desc = "Next diagnostic", buffer = bufnr })

  -- code action
  if capabilities.codeActionProvider then
    map({ "n", "v" }, "<leader>la", function()
      vim.lsp.buf.code_action()
    end, { desc = "LSP code action", buffer = bufnr })
  end

  -- declaration
  if capabilities.declarationProvider then
    map("n", "gD", function()
      vim.lsp.buf.declaration()
    end, { desc = "Declaration of current symbol", buffer = bufnr })
  end

  -- definition
  if capabilities.definitionProvider then
    map("n", "gd", function()
      vim.lsp.buf.definition()
    end, { desc = "Definition of current symbol", buffer = bufnr })
  end

  -- formatting
  if capabilities.documentFormattingProvider then
    map({ "n", "v" }, "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "Format code", buffer = bufnr })

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "Format file with LSP" })

    local format_on_save = true
    if format_on_save then
      local autocmd_group = "auto_format_" .. bufnr
      vim.api.nvim_create_augroup(autocmd_group, { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = autocmd_group,
        buffer = bufnr,
        desc = "Auto format buffer " .. bufnr .. " before save",
        callback = function() vim.lsp.buf.format({ async = false }) end,
      })
    end
  end

  -- syntax highlighting
  if capabilities.documentHighlightProvider then
    local highlight_name = vim.fn.printf("lsp_document_highlight_%d", bufnr)
    vim.api.nvim_create_augroup(highlight_name, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = highlight_name,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = highlight_name,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- hover
  if capabilities.hoverProvider then
    map("n", "K", function()
      vim.lsp.buf.hover()
    end, { desc = "Hover symbol details", buffer = bufnr })
  end

  -- implementation
  if capabilities.implementationProvider then
    map("n", "gi", function()
      vim.lsp.buf.implementation()
    end, { desc = "Implementation of current symbol", buffer = bufnr })
  end

  -- references
  if capabilities.referencesProvider then
    map("n", "gr", function()
      vim.lsp.buf.references()
    end, { desc = "References of current symbol", buffer = bufnr })
  end

  -- rename
  if capabilities.renameProvider then
    map("n", "<leader>rn", function()
      vim.lsp.buf.rename()
    end, { desc = "Rename current symbol", buffer = bufnr })
  end

  if capabilities.signatureHelpProvider then
    map("n", "<leader>lh", function()
      vim.lsp.buf.signature_help()
    end, { desc = "Signature help", buffer = bufnr })
  end

  if capabilities.typeDefinitionProvider then
    map("n", "gT", function()
      vim.lsp.buf.type_definition()
    end, { desc = "Definition of current type", buffer = bufnr })
  end
end

M.disable_formatting = function(client)
  client.server_capabilities.documentFormattingProvider = false
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

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
    if type(server.on_attach) == "function" then
      server.on_attach(client, bufnr)
    end

    self.on_attach(client, bufnr)

    if present and type(settings.on_attach) == "function" then
      settings.on_attach(client, bufnr)
    end
  end
  return opts
end

function M.setup_server(server_name)
  local server = require("lspconfig")[server_name]
  local opts = M:server_settings(server)
  server.setup(opts)
end

return M
