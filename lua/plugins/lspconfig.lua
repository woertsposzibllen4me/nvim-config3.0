return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
    opts = {
      ensure_installed = {
        "basedpyright",
        "powershell-editor-services",
        "ruff",
        "pylint",
        "lua-language-server",
        "python-lsp-server",
        "taplo", -- TOML formatter
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")

      -- Configure each LSP server
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      lspconfig.powershell_es.setup({
        cmd = { "powershell_es", "--stdio" },
        settings = {
          powershell = {
            scriptAnalysis = { enable = true },
            codeFormatting = { preset = "OTBS" },
          },
        },
      })

      lspconfig.pylsp.setup({
        enabled = true,
        autostart = true,
        settings = require("plugins.lsp_settings.pylsp").settings,
        on_attach = require("plugins.lsp_settings.pylsp").on_attach,
      })

      lspconfig.pyright.setup({
        enabled = false, -- Using basedpyright instead right now
        autostart = true,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              typeCheckingMode = "strict",
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              -- autoImportCompletions = true,
            },
          },
        },
        on_attach = function(client, _)
          client.server_capabilities.signatureHelpProvider = false
          client.server_capabilities.referencesProvider = true
          client.server_capabilities.renameProvider = false -- cannot rename module imports
          client.server_capabilities.definitionProvider = true
        end,
      })

      lspconfig.ruff.setup({
        enabled = true,
        autostart = true,
      })

      lspconfig.basedpyright.setup({
        enabled = true,
        settings = {
          python = {
            analysis = {
              diagnosticMode = "workspace",
            },
          },
        },
      })

      lspconfig.yamlls.setup({})
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["powershell"] = { "powershell_es" },
        ["python"] = { "ruff_format" },
        ["yaml"] = { "prettier" },
      },
      formatters = {
        ruff_format = {
          args = { "--line-length", "88" },
        },
      },
    },
  },
}
