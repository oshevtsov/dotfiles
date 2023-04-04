local M = {}

function M.config()
  local cmp_status_ok, cmp = pcall(require, "cmp")
  local snip_status_ok, luasnip = pcall(require, "luasnip")
  if cmp_status_ok and snip_status_ok then
    local kind_icons = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "ﰠ",
      Variable = "",
      Class = "",
      Interface = "",
      Module = "",
      Property = "",
      Unit = "",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "פּ",
      Event = "",
      Operator = "",
      TypeParameter = "",
    }

    cmp.setup({
      preselect = cmp.PreselectMode.None,
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(_, vim_item)
          vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
          return vim_item
        end,
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        documentation = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
      },
      experimental = {
        ghost_text = false,
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500 },
        { name = "path", priority = 250 },
      }),
      mapping = {
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping(function()
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          end
        end, {
          "i",
          "s",
        }),
        ["<C-p>"] = cmp.mapping(function()
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          end
        end, {
          "i",
          "s",
        }),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable,
        ["<C-e>"] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ["<CR>"] = cmp.mapping.confirm({
          select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expandable() then
            luasnip.expand()
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
      },
    })
  end
end

return M
