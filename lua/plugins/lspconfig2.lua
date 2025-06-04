if false then
  return {}
end
return {
  {
    "williamboman/mason.nvim",
    event = { "BufReadPre" },
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonLog", "MasonUpdate" },
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre" },
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
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "ray-x/lsp_signature.nvim", enabled = true },
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      -- Setup completion capabilities
      local has_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      local has_cmp, cmp = pcall(require, "cmp")
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        capabilities = blink.get_lsp_capabilities()
        vim.notify("Blink is available (lsp)", vim.log.levels.INFO)
      else
        if has_cmp_lsp then
          capabilities = cmp_lsp.default_capabilities(capabilities)
        end
      end

      --- @ diagnostic disable-next-line: unused-local
      local function custom_attach(client, bufnr)
        -- NOTE: we prefer Noice's builtin signature help over this rn

        -- require("lsp_signature").on_attach({
        --   bind = true,
        --   use_lspsaga = true,
        --   -- floating_window = true,
        --   fix_pos = true,
        --   hint_enable = false,
        --   hi_parameter = "MatchParen",
        --   toggle_key = "<c-s>",
        --   toggle_key_flip_floatwin_setting = true, -- toggle key will enable|disable floating_window flag
        --   handler_opts = {
        --     border = "rounded",
        --   },
        --   --   -- max_height = 12,
        --   --   -- max_width = 80,
        -- }, bufnr)

        -- close completion menu when showing signature help
        vim.keymap.set("i", "<c-s>", function()
          if has_blink and blink.is_visible() then
            blink.hide()
          else
            if has_cmp and cmp.visible() then
              cmp.close()
            end
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

      -- Python LSPs setup
      lspconfig.basedpyright.setup({
        on_attach = function(client, bufnr)
          client.server_capabilities.renameProvider = false -- we use pylsp rope plugin for renaming
          custom_attach(client, bufnr)
        end,
        enabled = false,
        -- autostart = true,
        settings = {
          basedpyright = {
            analysis = {
              ignore = { "c:/Users/ville/appdata/local/programs/python/python312/lib/**" },
              -- diagnosticMode = "workspace",
            },
          },
        },
      })

      lspconfig.pyright.setup({ -- quite a bit faster than basedpyright it seems like rn
        capabilities = capabilities,
        enabled = true,
        autostart = true,
        settings = {
          python = {
            analysis = {
              ignore = { "c:/Users/ville/appdata/local/programs/python/python312/lib/**" },
              -- autoSearchPaths = true,
              typeCheckingMode = "strict",
              -- diagnosticMode = "workspace",
              -- useLibraryCodeForTypes = true,
              -- autoImportCompletions = true,
            },
          },
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.renameProvider = false -- cannot rename module imports
          custom_attach(client, bufnr)
        end,
      })

      lspconfig.pylsp.setup({
        capabilities = capabilities,
        enabled = false,
        autostart = true,
        on_attach = require("config.lsp-settings").pylsp.on_attach,
        settings = require("config.lsp-settings").pylsp.settings,
      })

      -- lspconfig.ruff.setup({
      --   capabilities = capabilities,
      --   on_attach = custom_attach,
      --   enabled = false,
      --   autostart = true,
      -- })

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
    end,

    -- LSP enabling/disabling (for the newer 0.11+ syntax)
    vim.lsp.enable("lua_ls"),
  },
}
