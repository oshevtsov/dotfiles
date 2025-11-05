return {
  {
    "neovim/nvim-lspconfig",
    tag = "v2.5.0",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      -- JSON schemas
      "b0o/SchemaStore.nvim",
      -- Rust LSP setup
      {
        "mrcjkb/rustaceanvim",
        version = "^6", -- Recommended
        lazy = false, -- This plugin is already lazy
      },
      -- Integration with crates.io
      {
        "saecki/crates.nvim",
        tag = "stable",
        event = { "BufRead Cargo.toml" },
      },
    },
    config = function()
      -- lsp_attach is where you enable features that only work
      -- if there is a language server active in the file,
      -- the `_` in the first argument is the LSP client
      local lsp_attach = function(_, bufnr)
        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { buffer = bufnr, desc = "Hover over" })
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { buffer = bufnr, desc = "Go to definition" })
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { buffer = bufnr, desc = "Go to declaration" })
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { buffer = bufnr, desc = "Go to implementation" })
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { buffer = bufnr, desc = "Type definition" })
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { buffer = bufnr, desc = "Find references" })
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { buffer = bufnr, desc = "Signature help" })
        vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = bufnr, desc = "Rename symbol" })
        vim.keymap.set(
          { "n", "x" },
          "<leader>bf",
          "<cmd>lua vim.lsp.buf.format({async = true})<cr>",
          { buffer = bufnr, desc = "Format buffer" }
        )
        vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = bufnr, desc = "Code action" })
      end

      vim.lsp.config("*", {
        capabilities = vim.lsp.protocol.make_client_capabilities(),
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my-lsp-attach", { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          lsp_attach(client, bufnr)
        end,
      })

      -- Set up rustaceanvim
      vim.g.rustaceanvim = {
        tools = {
          executor = "toggleterm",
          -- test_executor = "neotest", -- see test runner plugin below
          -- crate_test_executor = "neotest", -- see test runner plugin below
        },
      }

      -- Set up crates.io integration
      require("crates").setup({
        lsp = {
          enabled = true,
          on_attach = lsp_attach,
          actions = true,
          completion = true,
          hover = true,
        },
      })

      require("mason-tool-installer").setup({
        -- All lsp servers, linters, formatters, etc., see https://mason-registry.dev/registry/list.
        ensure_installed = {
          -- LSP servers
          "typescript-language-server",
          "lua-language-server",
          "json-lsp",
          "pyright",
          "ts_ls",
          "yaml-language-server",
          "gopls",
          "eslint-lsp",
          -- Linters
          "flake8",
          "shellcheck",
          "revive",
          "checkmake",
          "sqruff", -- both linter and formatter for SQL
          -- formatters
          "black",
          "isort",
          "stylua",
          "goimports",
          "prettier",
          -- Debuggers
          "debugpy",
          "codelldb",
          "delve",
          "js-debug-adapter",
        },

        -- if set to true this will check each tool for updates. If updates
        -- are available the tool will be updated. This setting does not
        -- affect :MasonToolsUpdate or :MasonToolsInstall.
        -- Default: false
        auto_update = false,

        -- automatically install / update on startup. If set to false nothing
        -- will happen on startup. You can use :MasonToolsInstall or
        -- :MasonToolsUpdate to install tools and check for updates.
        -- Default: true
        run_on_start = false,

        -- set a delay (in ms) before the installation starts. This is only
        -- effective if run_on_start is set to true.
        -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
        -- Default: 0
        start_delay = 0,

        -- Only attempt to install if 'debounce_hours' number of hours has
        -- elapsed since the last time Neovim was started. This stores a
        -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
        -- This is only relevant when you are using 'run_on_start'. It has no
        -- effect when running manually via ':MasonToolsInstall' etc....
        -- Default: nil
        debounce_hours = nil,
      })

      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_uninstalled = "✗",
            package_pending = "⟳",
          },
        },
      })
      vim.keymap.set("n", "<leader>lI", "<cmd>Mason<CR>", { desc = "LSP installer" })
      vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP information" })

      -- see https://github.com/jay-babu/mason-nvim-dap.nvim?tab=readme-ov-file#advanced-customization
      require("mason-nvim-dap").setup({
        automatic_installation = false,
        ensure_installed = {},
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every DAP adapter without a "custom handler"
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      })

      -- Add extra config options to selected language servers
      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
            format = { enable = false },
          },
        },
      })

      vim.lsp.config("pyright", {
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              diagnosticMode = "openFilesOnly",
              indexing = true,
            },
          },
        },
      })

      -- See:
      -- 1. https://github.com/neovim/nvim-lspconfig/issues/3827
      -- 2. https://github.com/neovim/nvim-lspconfig/pull/3844
      -- 3. https://github.com/neovim/nvim-lspconfig/blob/master/lsp/eslint.lua
      -- 4. checrry-picked root_dir from v2.4.0 tag since it identifies incorrectly in monorepos
      vim.lsp.config("eslint", {
        settings = {
          workingDirectory = { mode = "location" },
        },
        -- override the on_attach definition from nvim-lspconfig since it applies only
        -- to the current buffer, i.e. id = 0.
        on_attach = function(client, bufnr)
          vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
            client:exec_cmd({
              title = "Fix all Eslint errors in buffer",
              command = "eslint.applyAllFixes",
              arguments = {
                {
                  uri = vim.uri_from_bufnr(bufnr),
                  version = vim.lsp.util.buf_versions[bufnr],
                },
              },
            }, { bufnr = bufnr })
          end, { desc = "Fix all Eslint errors in buffer" })

          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "LspEslintFixAll",
          })
        end,
        -- override root_dir definition from nvim-lspconfig since it does not correctly
        -- identify the root of the package in monorepos
        root_dir = function(bufnr, on_dir)
          local util = require("lspconfig.util")
          local eslint_config_files = {
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json",
            "eslint.config.js",
            "eslint.config.mjs",
            "eslint.config.cjs",
            "eslint.config.ts",
            "eslint.config.mts",
            "eslint.config.cts",
          }
          -- The project root is where the LSP can be started from
          -- As stated in the documentation above, this LSP supports monorepos and simple projects.
          -- We select then from the project root, which is identified by the presence of a package
          -- manager lock file.
          local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
          -- Root markers priority:
          -- 1. eslint_config_files
          -- 2. root_markers
          -- 3. .git
          --
          -- stylua: ignore start
          root_markers = vim.fn.has("nvim-0.11.3") == 1
            and { eslint_config_files, root_markers, { ".git" } }
            or vim.list_extend(eslint_config_files, vim.list_extend(root_markers, { ".git" }))
          -- stylua: ignore end

          -- We fallback to the current working directory if no project root is found
          local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

          -- We know that the buffer is using ESLint if it has a config file
          -- in its directory tree.
          --
          -- Eslint used to support package.json files as config files, but it doesn't anymore.
          -- We keep this for backward compatibility.
          local filename = vim.api.nvim_buf_get_name(bufnr)
          local eslint_config_files_with_package_json = util.insert_package_json(eslint_config_files, "eslintConfig", filename)
          local is_buffer_using_eslint = vim.fs.find(eslint_config_files_with_package_json, {
            path = filename,
            type = "file",
            limit = 1,
            upward = true,
            stop = vim.fs.dirname(project_root),
          })[1]
          if not is_buffer_using_eslint then
            return
          end

          on_dir(project_root)
        end,
      })

      -- See https://github.com/williamboman/nvim-config/tree/mason-v2-example
      require("mason-lspconfig").setup({
        automatic_enable = {
          exclude = {
            "rust_analyzer",
          },
        },
      })
      -- Find mapping between mason package names and the correspodnig LSP name
      -- local registry = require("mason-registry")
      -- local mason_installed = registry.get_installed_package_names()
      -- local mason_to_lspconfig_map = {}
      -- for _, pkg_spec in ipairs(registry.get_all_package_specs()) do
      --   if vim.list_contains(mason_installed, pkg_spec.name) then
      --     local lspconfig = vim.tbl_get(pkg_spec, "neovim", "lspconfig")
      --     if lspconfig then
      --       mason_to_lspconfig_map[pkg_spec.name] = lspconfig
      --     end
      --   end
      -- end
      --
      -- vim.schedule(function()
      --   vim.lsp.enable(vim.tbl_values(mason_to_lspconfig_map))
      -- end)
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      toggle_key = "<M-x>",
      select_signature_key = "<M-n>",
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
}
