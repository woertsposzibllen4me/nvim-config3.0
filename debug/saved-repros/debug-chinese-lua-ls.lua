-- usage "nvim -u this_filename.lua"
vim.env.LAZY_STDPATH = ".repro"
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()
vim.g.mapleader = " " -- Set leader key to space

--- @ diagnostic disable: missing-fields
require("lazy.minit").repro({
  spec = {
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      enabled = false,
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    {
      "folke/noice.nvim",
      opts = {
        presets = {
          lsp_doc_border = true,
        },
        lsp = {
          signature = {
            enabled = true,
          },
          hover = {
            enabled = true,
          },
          progress = {
            enabled = true,
          },
        },
      },
    },
    {
      "williamboman/mason.nvim",
      cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonLog", "MasonUpdate" },
      opts = {},
    },
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        automatic_enable = false,
        ensure_installed = {
          "lua_ls",
        },
      },
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
      },
      config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        -- local lspconfig = require("lspconfig")

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
        })
      end,

      -- LSP enabling/disabling (for the newer 0.11+ syntax)
      vim.lsp.enable("lua_ls"),
    },
  },
})
