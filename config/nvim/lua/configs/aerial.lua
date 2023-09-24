local M = {}

function M.config()
  local status_ok, aerial = pcall(require, "aerial")
  if status_ok then
    aerial.setup({
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = {
        min_width = 28,
        default_direction = "prefer_right",
        placement = "edge",
      },
      show_guides = true,
      filter_kind = {
        "Array",
        "Boolean",
        "Class",
        "Constant",
        "Constructor",
        "Enum",
        "EnumMember",
        "Event",
        "Field",
        "File",
        "Function",
        "Interface",
        "Key",
        "Method",
        "Module",
        "Namespace",
        "Null",
        "Number",
        "Object",
        "Operator",
        "Package",
        "Property",
        "String",
        "Struct",
        "TypeParameter",
        "Variable",
      },
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
    })
  end
end

return M
