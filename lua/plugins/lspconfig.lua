return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({})
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- lsp servers
          -- "basedpyright",
          -- "pylint",
          -- "ruff",
          -- "python-lsp-server",
          -- "powershell-editor-services",
          "lua_ls",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "ray-x/lsp_signature.nvim", enabled = true },
    },
    enabled = true,
    config = function()
      vim.lsp.handlers["textDocument/definition"] = function(_, result, ctx, _)
        if result == nil or vim.tbl_isempty(result) then
          return nil
        end

        -- Use current window for jumps
        vim.cmd("norm! m'") -- Set jumplist mark
        local target = result[1].targetUri or result[1].uri
        local line = result[1].targetRange and result[1].targetRange.start.line or result[1].range.start.line

        vim.api.nvim_win_set_buf(0, vim.uri_to_bufnr(target))
        vim.api.nvim_win_set_cursor(0, { line + 1, 0 })
        vim.cmd("norm! zz")
      end

      local lspconfig = require("lspconfig")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      else
        -- Fallback if cmp_nvim_lsp is not available
        capabilities = vim.lsp.protocol.make_client_capabilities()
      end

      local function custom_attach(client, bufnr)
        require("lsp_signature").on_attach({
          bind = true,
          -- use_lspsaga = true,
          floating_window = true,
          fix_pos = true,
          hint_enable = false,
          hi_parameter = "MatchParen",
          toggle_key = "<c-s>",
          toggle_key_flip_floatwin_setting = true, -- toggle key will enable|disable floating_window flag
          handler_opts = {
            border = "rounded",
          },
          -- max_height = 12,
          -- max_width = 80,
        }, bufnr)
      end

      -- Configure each LSP server
      lspconfig.lua_ls.setup({
        enabled = true,
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "DiagnosticUnnecessary" })
          -- Turn off document highlighting in insert mode to prevent visual mess with copilot ghost text
          local orig_highlighting = client.server_capabilities.documentHighlightProvider
          vim.api.nvim_create_autocmd("InsertEnter", {
            buffer = bufnr,
            callback = function()
              client.server_capabilities.documentHighlightProvider = false
            end,
          })

          vim.api.nvim_create_autocmd("InsertLeave", {
            buffer = bufnr,
            callback = function()
              client.server_capabilities.documentHighlightProvider = orig_highlighting
            end,
          })
          custom_attach(client, bufnr)
        end,
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
        capabilities = capabilities,
        on_attach = custom_attach,
        cmd = {
          "pwsh",
          "-NoLogo",
          "-NoProfile",
          "-Command",
          "&'"
            .. vim.fn.stdpath("data")
            .. "/mason/packages/powershell-editor-services/PowerShellEditorServices/Start-EditorServices.ps1'",
          "-Stdio",
        },
        settings = {
          powershell = {
            scriptAnalysis = { enable = true },
            codeFormatting = { preset = "OTBS" },
          },
        },
      })

      lspconfig.pylsp.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          custom_attach(client, bufnr)
          require("plugins.lsp_settings.pylsp").on_attach(client, bufnr)
        end,
        enabled = true,
        autostart = true,
        settings = require("plugins.lsp_settings.pylsp").settings,
      })

      lspconfig.pyright.setup({
        capabilities = capabilities,
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
        on_attach = function(client, bufnr)
          custom_attach(client, bufnr)
          client.server_capabilities.signatureHelpProvider = false
          client.server_capabilities.referencesProvider = true
          client.server_capabilities.renameProvider = false -- cannot rename module imports
          client.server_capabilities.definitionProvider = true
        end,
      })

      lspconfig.ruff.setup({
        capabilities = capabilities,
        on_attach = custom_attach,
        enabled = true,
        autostart = true,
      })

      lspconfig.basedpyright.setup({
        capabilities = capabilities,
        on_attach = custom_attach,
        enabled = true,
        settings = {
          python = {
            analysis = {
              diagnosticMode = "workspace",
            },
          },
        },
      })

      lspconfig.yamlls.setup({
        capabilities = capabilities,
        on_attach = custom_attach,
      })

      -- AutoHotkey v2 LSP setup
      local ahk2_configs = {
        autostart = true,
        cmd = {
          "node",
          vim.fn.expand("~/myfiles/programs/vscode-autohotkey2-lsp/server/dist/server.js"),
          "--stdio",
        },
        filetypes = { "ahk", "autohotkey", "ah2" },
        init_options = {
          locale = "en-us",
          InterpreterPath = "C:/Program Files/AutoHotkey/v2/AutoHotkey.exe",
        },
        single_file_support = true,
        flags = { debounce_text_changes = 500 },
        capabilities = capabilities,
        on_attach = custom_attach,
      }

      -- Register the custom AHK2 LSP configuration
      local configs = require("lspconfig.configs")
      if not configs.ahk2 then
        configs.ahk2 = { default_config = ahk2_configs }
      end

      -- Set up the AHK2 LSP
      lspconfig.ahk2.setup({})
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["powershell"] = { "powershell_es" },
        ["python"] = { "ruff_format" },
        ["yaml"] = { "prettier" },
        ["toml"] = { "taplo" },
        ["lua"] = { "stylua" },
      },
      formatters = {
        ruff_format = {
          args = { "--line-length", "88" },
        },
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
      },
      format_on_save = {
        timer = 500,
        lsp_fallback = true,
      },
    },
  },
}
