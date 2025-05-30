vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
return {
  {
    "williamboman/mason.nvim",
    event = { "BufReadPre" },
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre" },
    opts = {
      ensure_installed = {
        "lua_ls",
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
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local lspconfig = require("lspconfig")
      if has_cmp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
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
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable()
        end
      end

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
