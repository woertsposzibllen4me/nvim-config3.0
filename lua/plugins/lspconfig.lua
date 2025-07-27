return {
  {
    "williamboman/mason.nvim",
    event = { "BufReadPre" },
    enabled = true,
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonLog", "MasonUpdate" },
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre" },
    enabled = true,
    opts = {
      automatic_enable = false,
      ensure_installed = {
        -- lua
        "lua_ls",
        -- python
        "pyright",
        "pylsp",
        "basedpyright",
        "ruff",
        -- pwsh
        "powershell_es",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre" },
    enabled = true,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "ray-x/lsp_signature.nvim", enabled = true },
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local lspconfig = require("lspconfig")

      -- Setup completion capabilities
      local has_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      local has_cmp, cmp = pcall(require, "cmp")
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        capabilities = blink.get_lsp_capabilities()
      else
        if has_cmp_lsp then
          capabilities = cmp_lsp.default_capabilities(capabilities)
        end
      end

      -- Setup document symbol features capabilities
      local has_navic, navic = pcall(require, "nvim-navic")
      local has_navbuddy, navbuddy = pcall(require, "nvim-navbuddy")

      --- @ diagnostic disable-next-line: unused-local
      local function custom_attach(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          if has_navic then
            navic.attach(client, bufnr)
          end
          if has_navbuddy then
            navbuddy.attach(client, bufnr)
          end
        end

        -- close completion menu when showing signature help
        vim.keymap.set("i", "<c-s>", function()
          if has_blink and blink.is_visible() then
            blink.hide()
          end
          if has_cmp and cmp.visible() then
            cmp.close()
          end
          vim.lsp.buf.signature_help()
        end, { buffer = bufnr })
      end

      -- Lua LSP setup
      vim.lsp.config("lua_ls", {
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
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- Disable unused variable dimming
          vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "DiagnosticUnnecessary" })
          vim.notify("Lua LSP attached", vim.log.levels.INFO)
          custom_attach(client, bufnr)
        end,
      })

      --  #### Start of Python LSPs setup ####
      local python_std_lib_paths = {
        "c:/Users/*/appdata/local/programs/python/python*/lib/**",
        "/usr/lib/python*/**",
      }
      -- We use Pyright for completions, hover, signatures (it's faster at interactive stuff)
      lspconfig.pyright.setup({
        capabilities = capabilities,
        enabled = true,
        autostart = true,
        settings = {
          python = {
            analysis = {
              ignore = { "*" }, -- we use basedpyright for diagnostics
              typeCheckingMode = "off",
            },
          },
          -- pyright = {
          --   disableTaggedHints = true, -- leaving it in as fallback solution if needed
          -- },
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.renameProvider = false -- can't rename module symbols (pylsp can do it)
          custom_attach(client, bufnr)
        end,
      })

      -- BasedPyright for type checking and diagnostics
      lspconfig.basedpyright.setup({
        capabilities = capabilities,
        enabled = true,
        autostart = true,
        settings = {
          basedpyright = {
            analysis = {
              ignore = python_std_lib_paths,
            },
          },
        },
        on_attach = function(client, bufnr)
          -- Disable capabilities that pyright handles better/faster
          client.server_capabilities.completionProvider = false
          client.server_capabilities.hoverProvider = false
          client.server_capabilities.signatureHelpProvider = false -- pyright has better placement for it
          client.server_capabilities.renameProvider = false -- can't rename module symbols (pylsp can do it)
          client.server_capabilities.documentHighlightProvider = false
          client.server_capabilities.documentSymbolProvider = false
          -- if client.server_capabilities.semanticTokensProvider then
          --   client.server_capabilities.semanticTokensProvider = false
          -- end
          client.server_capabilities.definitionProvider = nil
          client.server_capabilities.declarationProvider = nil
          client.server_capabilities.referencesProvider = nil
          custom_attach(client, bufnr)
        end,
      })

      -- pylsp for renaming (rope)
      lspconfig.pylsp.setup({
        capabilities = capabilities,
        enabled = true,
        autostart = true,
        on_attach = require("config.lsp-settings").pylsp.on_attach,
        settings = require("config.lsp-settings").pylsp.settings,
      })

      -- Ruff for formatting and diagnostics
      lspconfig.ruff.setup({
        capabilities = capabilities,
        on_attach = function(_, bufnr)
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].modifiable then
              -- Make a fake edit to trigger diagnostics directly after attaching
              -- (otherwise wouldn't until a change is made to the buffer)
              vim.api.nvim_buf_set_text(bufnr, 0, 0, 0, 0, { "" })
              vim.bo[bufnr].modified = false
            end
          end)
        end,
        enabled = true,
        autostart = true,
        init_options = {
          settings = {
            exclude = python_std_lib_paths,
          },
        },
      })
      -- #### End of Python LSPs setup ####

      -- Windows specific LSPs
      if OnWindows then
        -- powershell LSP setup
        lspconfig.powershell_es.setup({
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
          capabilities = capabilities,
          --- @ diagnostic disable-next-line: unused-local
          on_attach = function(client, bufnr)
            vim.notify("PowerShell LSP attached", vim.log.levels.INFO)
          end,
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
        local configs = require("lspconfig.configs")
        if not configs.ahk2 then
          configs.ahk2 = { default_config = ahk2_configs }
        end
        lspconfig.ahk2.setup({})
      end
    end,

    -- LSP enabling/disabling (for the newer 0.11+ syntax)
    vim.lsp.enable("lua_ls"),
  },
}
