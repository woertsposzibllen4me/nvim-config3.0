local original_deprecate = vim.deprecate
vim.deprecate = function(name, alternative, version, plugin, backtrace)
  -- Skip deprecations from lspconfig plugin
  if plugin == "lspconfig" or plugin == "nvim-lspconfig" then
    return
  end
  original_deprecate(name, alternative, version, plugin, backtrace)
end
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
      local lspconfig = require("lspconfig")
      local capabilities = vim.lsp.protocol.make_client_capabilities()

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

      --- @diagnostic disable-next-line: unused-local
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
          -- vim.notify("Lua LSP attached", vim.log.levels.INFO)
          custom_attach(client, bufnr)
        end,
      })

      -- Python LSP setups
      -- We use Pyright for completions, hover, signatures (it's faster at interactive stuff)
      do
        local config = require("lang.python.lsp.python-lsp-settings").pyright
        vim.lsp.config("pyright", {
          capabilities = capabilities,
          settings = config.settings,
          on_attach = function(client, bufnr)
            config.on_attach(client, bufnr)
            custom_attach(client, bufnr)
          end,
        })
      end

      -- BasedPyright for type checking and diagnostics (the GOAT)
      do
        local config = require("lang.python.lsp.python-lsp-settings").basedpyright
        vim.lsp.config("basedpyright", {
          capabilities = capabilities,
          settings = config.settings,
          on_attach = function(client, bufnr)
            -- TODO: remove totally later ? (switching over to basedpyright.disableLanguageServices)
            -- config.on_attach(client, bufnr)
            custom_attach(client, bufnr)
          end,
        })
      end

      -- pylsp for renaming (it's the only one that can rename module symbols properly AFAIK)
      do
        local config = require("lang.python.lsp.python-lsp-settings").pylsp
        vim.lsp.config("pylsp", {
          capabilities = capabilities,
          settings = config.settings,
          on_attach = function(client, bufnr)
            config.on_attach(client, bufnr)
          end,
        })
      end

      -- Ruff for formatting and diagnostics
      do
        local config = require("lang.python.lsp.python-lsp-settings").ruff
        vim.lsp.config("ruff", {
          capabilities = capabilities,
          init_options = {
            settings = config.settings,
          },
        })
      end

      -- Windows specific LSPs
      -- powershell LSP setup
      vim.lsp.config("powershell_es", {
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
        --- @diagnostic disable-next-line: unused-local
        on_attach = function(client, bufnr)
          client.server_capabilities.semanticTokensProvider = nil -- conflict with tokyyo-night ?
          -- vim.notify("PowerShell LSP attached", vim.log.levels.INFO)
        end,
      })

      -- AutoHotkey v2 LSP setup
      vim.lsp.config("ahk2", {
        cmd = {
          "node",
          vim.fn.expand("~/myfiles/programs/vscode-autohotkey2-lsp/server/dist/server.js"),
          "--stdio",
        },
        filetypes = { "ahk", "autohotkey", "ah2" },
        single_file_support = true,
        flags = {
          debounce_text_changes = 500,
        },
        init_options = {
          locale = "en-us",
          InterpreterPath = "C:/Program Files/AutoHotkey/v2/AutoHotkey.exe",
        },
        capabilities = capabilities,
        on_attach = custom_attach,
      })

      -- Enable/disable LSP servers
      -- NOTE: basedpyright not in this list because it uses lspconfig.setup()
      local servers = {
        lua_ls = true,
        pyright = true,
        basedpyright = true,
        pylsp = true,
        ruff = true,
        ahk2 = OnWindows,
        powershell_es = OnWindows,
      }

      for name, ok in pairs(servers) do
        if ok then
          vim.lsp.enable(name)
        end
      end
    end,
  },
}
