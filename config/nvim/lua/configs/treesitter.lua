local M = {}

function M.config()
  local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
  if status_ok then
    local config = {
      ensure_installed = {
        "astro",
        "bash",
        "comment",
        "css",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "scss",
        "tsx",
        "typescript",
        "vimdoc",
        "yaml",
      },
      sync_install = false,
      ignore_install = {},
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-Space>",
          node_incremental = "<C-Space>",
          scope_incremental = "<C-s>",
          node_decremental = "<C-Backspace>",
        },
      },
      autotag = { enable = true },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["ak"] = { query = "@block.outer", desc = "around block" },
            ["ik"] = { query = "@block.inner", desc = "inside block" },
            ["ac"] = { query = "@class.outer", desc = "around class" },
            ["ic"] = { query = "@class.inner", desc = "inside class" },
            ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
            ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
            ["af"] = { query = "@function.outer", desc = "around function " },
            ["if"] = { query = "@function.inner", desc = "inside function " },
            ["al"] = { query = "@loop.outer", desc = "around loop" },
            ["il"] = { query = "@loop.inner", desc = "inside loop" },
            ["aa"] = { query = "@parameter.outer", desc = "around argument" },
            ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]k"] = { query = "@block.outer", desc = "Next block start" },
            ["]m"] = { query = "@function.outer", desc = "Next function start" },
            ["]]"] = { query = "@class.outer", desc = "Next class start" },
          },
          goto_next_end = {
            ["]K"] = { query = "@block.outer", desc = "Next block end" },
            ["]M"] = { query = "@function.outer", desc = "Next function end" },
            ["]["] = { query = "@class.outer", desc = "Next class end" },
          },
          goto_previous_start = {
            ["[k"] = { query = "@block.outer", desc = "Previous block start" },
            ["[m"] = { query = "@function.outer", desc = "Previous function start" },
            ["[["] = { query = "@class.outer", desc = "Previous class start" },
          },
          goto_previous_end = {
            ["[K"] = { query = "@block.outer", desc = "Previous block end" },
            ["[M"] = { query = "@function.outer", desc = "Previous function end" },
            ["[]"] = { query = "@class.outer", desc = "Previous class end" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = { query = "@parameter.inner", desc = "Swap next parameter" },
            ["<leader>k"] = { query = "@block.outer", desc = "Swap next block" },
            ["<leader>m"] = { query = "@function.outer", desc = "Swap next function" },
          },
          swap_previous = {
            ["<leader>A"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
            ["<leader>K"] = { query = "@block.outer", desc = "Swap previous block" },
            ["<leader>M"] = { query = "@function.outer", desc = "Swap previous function" },
          },
        },
        lsp_interop = {
          enable = true,
          border = "rounded",
          peek_definition_code = {
            ["<leader>pf"] = { query = "@function.outer", desc = "Peek function definition" },
            ["<leader>pc"] = { query = "@class.outer", desc = "Peek class definition" },
          },
        },
      },
    }

    treesitter.setup(config)
  end
end

return M
