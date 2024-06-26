local M = {}

function M.setup()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "󰌵" },
    { name = "DiagnosticSignInfo", text = "󰋼" },
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

  -- set up neodev for better lua dev experience with neovim config
  local neodev_ok, neodev = pcall(require, "neodev")
  if neodev_ok then
    neodev.setup({})
  end

  -- set up LSP for Gleam (the language server comes shipped with the toolchain)
  if vim.fn.executable("gleam") == 1 then
    M.setup_server("gleam")
  end
end

---@param client lsp.Client
---@param bufnr integer
function M.on_attach(client, bufnr)
  -- Keymaps
  local map = vim.keymap.set

  -- code action
  if client.supports_method("codeActionProvider") then
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
  end

  -- declaration
  if client.supports_method("declarationProvider") then
    map("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Goto declaration" })
  end

  -- definition
  if client.supports_method("definitionProvider") then
    map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Goto definition" })
  end

  -- formatting
  if client.supports_method("documentFormattingProvider") then
    map({ "n", "v" }, "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, { buffer = bufnr, desc = "Format code" })

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "Format file with LSP" })

    local format_on_save = true
    if format_on_save then
      local autocmd_group = "auto_format_" .. string.format("%d_%s", bufnr, client.name)
      vim.api.nvim_create_augroup(autocmd_group, { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = autocmd_group,
        buffer = bufnr,
        desc = "Auto format buffer " .. bufnr .. " before save",
        callback = function()
          if not format_on_save then
            return
          end
          vim.lsp.buf.format({ async = false })
        end,
      })
      vim.api.nvim_create_user_command("AutoFormatToggle", function()
        format_on_save = not format_on_save
        print("Setting auto-formatting to: " .. tostring(format_on_save))
      end, { desc = "Toggle auto-formatting" })
    end
  end

  -- hover
  if client.supports_method("hoverProvider") then
    map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover documentation" })
  end

  -- implementation
  if client.supports_method("implementationProvider") then
    map("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Goto implementation" })
  end

  -- references
  if client.supports_method("referencesProvider") then
    map("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Goto references" })
  end

  -- Telescope LSP integration
  map("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", { buffer = bufnr, desc = "Document symbols" })
  map(
    "n",
    "<leader>ws",
    "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
    { buffer = bufnr, desc = "Workspace symbols" }
  )

  -- rename
  if client.supports_method("renameProvider") then
    map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
  end

  if client.supports_method("signatureHelpProvider") then
    map("n", "<C-s>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature documentation" })
    -- local lsp_overloads_ok, lsp_overloads = pcall(require, "lsp-overloads")
    -- if lsp_overloads_ok then
    --   lsp_overloads.setup(client, {
    --     keymaps = {
    --       next_signature = "<M-j>",
    --       previous_signature = "<M-k>",
    --       next_parameter = "<M-l>",
    --       previous_parameter = "<M-h>",
    --       close_signature = "<M-s>",
    --     },
    --   })
    -- end
  end

  if client.supports_method("typeDefinitionProvider") then
    map("n", "gT", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Type definition" })
  end
end

---@param client lsp.Client
M.disable_formatting = function(client)
  client.server_capabilities.documentFormattingProvider = false
end

function M.make_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
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
  if status_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  return capabilities
end

function M:server_settings(server)
  local opts = vim.empty_dict()
  local present, settings = pcall(require, "configs.lsp.server-settings." .. server.name)

  if present then
    opts = vim.tbl_deep_extend("force", settings, opts)
  end

  opts.capabilities = vim.tbl_deep_extend("force", self.make_client_capabilities(), server.capabilities or {})

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

---@param server_name string
function M.setup_server(server_name)
  local server = require("lspconfig")[server_name]
  local opts = M:server_settings(server)
  server.setup(opts)
end

return M
