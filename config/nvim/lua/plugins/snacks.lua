return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    indent = {
      enabled = true,
      indent = {
        enabled = true, -- set to false to not render non-current scopes
        only_scope = false, -- set to true to only render for current and children
      },
    },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = {
      enabled = true,
      layout = function(source)
        local dropdown_sources = {
          "buffers",
          "diagnostics",
          "diagnostics_buffer",
          "files",
          "grep",
          "help",
          "keymaps",
          "lsp_references",
          "lsp_symbols",
          "lsp_workspace_symbols",
          "notifications",
          "recent",
          "registers",
        }
        local it = vim.iter(dropdown_sources)
        local is_dropdown_source = function(dropdown_source)
          return dropdown_source == source
        end
        if it:any(is_dropdown_source) then
          return {
            preset = "dropdown",
            layout = {
              width = function()
                return vim.o.columns >= 100 and 0.75 or 0
              end,
              height = 0.8,
              min_width = 0,
              max_width = 180,
            },
          }
        else
          return {
            preset = "default",
          }
        end
      end,
      win = {
        input = {
          keys = {
            ["p"] = { "focus_preview", mode = { "n" } },
          },
        },
        list = {
          keys = {
            ["p"] = "focus_preview",
          },
        },
      },
    },
    rename = { enabled = true },
    terminal = { enabled = true },
    zen = {
      enabled = true,
      toggles = {
        dim = false,
      },
    },
  },
  keys = {
    -- notifier
    {
      "<leader>dn",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss all notifications",
    },
    -- picker
    {
      "<leader>s/",
      function()
        Snacks.picker.search_history()
      end,
      desc = "Search history",
    },
    {
      "<leader>s:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command history",
    },
    {
      "<leader>sc",
      function()
        Snacks.picker.colorschemes({ layout = { preset = "vertical" } })
      end,
      desc = "Search colorschemes",
    },
    {
      "<leader>si",
      function()
        Snacks.picker.icons()
      end,
      desc = "Search icons",
    },
    {
      "<leader>sn",
      function()
        Snacks.picker.notifications()
      end,
      desc = "Search notifications",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files({
          hidden = true,
        })
      end,
      desc = "Find files",
    },
    {
      "<leader>fi",
      function()
        Snacks.picker.files({ hidden = true, ignored = true })
      end,
      desc = "Find files (include ignored)",
    },
    {
      "<leader>fd",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Find dotfile config",
    },
    {
      "<leader>lr",
      function()
        Snacks.picker.lsp_references({ include_current = true, auto_confirm = false })
      end,
      desc = "LSP references",
    },
    {
      "<leader>rr",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume the last picker",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.grep({
          hidden = true,
          cmd = "rg",
        })
      end,
      desc = "Find grep",
    },
    {
      "<leader>fo",
      function()
        Snacks.picker.recent()
      end,
      desc = "Find old files",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Search keymaps",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Find buffers",
    },
    {
      "<leader>bd",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Buffer diagnostics",
    },
    {
      "<leader>wd",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Workspace diagnostics",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "Search help",
    },
    {
      "<leader>sr",
      function()
        Snacks.picker.registers()
      end,
      desc = "Search registers",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.lines()
      end,
      desc = "Search in current buffer",
    },
    {
      "<leader>ss",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "Buffer LSP symbols",
    },
    {
      "<leader>ws",
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "Workspace LSP symbols",
    },
    {
      "<leader>ft",
      function()
        local terms = Snacks.terminal.list()

        if #terms == 0 then
          vim.notify("No open terminals", vim.log.levels.INFO)
          return
        end

        Snacks.picker.select(terms, {
          prompt = "Select terminal:",
          format_item = function(item)
            return string.format("%s", item.opts.title or item.opts.wo.winbar)
          end,
        }, function(_, item_idx)
          for idx, item in ipairs(terms) do
            if idx == item_idx then
              item:show()
            else
              item:hide()
            end
          end
        end)
      end,
      desc = "Find terminal",
    },
    -- terminal
    {
      "<C-\\>",
      function()
        local curr_buf = vim.api.nvim_get_current_buf()
        local terms = Snacks.terminal.list()

        for _, term in ipairs(terms) do
          if term.buf == curr_buf then
            term:toggle()
            break
          end
        end
      end,
      mode = { "t" },
      desc = "Toggle current terminal off",
    },
    {
      "<C-\\>",
      function()
        Snacks.terminal(nil, {
          win = {
            position = "bottom",
            width = 0,
            height = 0.2,
            wo = {
              winbar = vim.fn.fnamemodify(vim.o.shell, ":t") .. " (" .. vim.v.count1 .. ")",
            },
          },
        })
      end,
      mode = { "n" },
      desc = "Toggle terminal on (use count for opening multiple)",
    },
    {
      "<leader>tn",
      function()
        local cmd = "node"
        Snacks.terminal(cmd, {
          win = {
            position = "bottom",
            width = 0,
            height = 0.2,
            wo = {
              winbar = cmd .. " (" .. vim.v.count1 .. ")",
            },
          },
        })
      end,
      desc = "Toggle node REPL on (use count for opening multiple)",
    },
    {
      "<leader>tp",
      function()
        local cmd = "python"
        Snacks.terminal(cmd, {
          win = {
            position = "bottom",
            width = 0,
            height = 0.2,
            wo = {
              winbar = cmd .. " (" .. vim.v.count1 .. ")",
            },
          },
        })
      end,
      desc = "Toggle python REPL on (use count for opening multiple)",
    },
    {
      "<M-a>",
      function()
        Snacks.terminal.toggle({ "amp", "--ide" }, {
          win = {
            position = "right",
            height = 0,
            width = 0.4,
          },
        })
      end,
      desc = "Toggle AMP CLI terminal (split right)",
    },
    -- zen
    {
      "<leader>bz",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen mode",
    },
  },
  init = function()
    local cmd = vim.cmd -- execute vimscript commands
    cmd(":command -nargs=+ Rg :lua Snacks.picker.grep_word({search = <q-args>})<CR>")
  end,
}
