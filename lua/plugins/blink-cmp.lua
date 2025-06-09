return {
  "saghen/blink.cmp",
  lazy = true,
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "rafamadriz/friendly-snippets",
    "L3MON4D3/LuaSnip",
  },
  -- test:
  -- lua_ls
  -- blink-cmp-introduction-special-thanks
  enabled = true,
  version = "*", -- either use a release or use the build command below
  -- build = "cargo build --release",
  config = function()
    local has_luasnip, _ = pcall(require, "luasnip")
    require("blink.cmp").setup({
      -- Keymap configuration matching your nvim-cmp setup
      keymap = {
        preset = "none",
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-g>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },

      -- Appearance settings
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      -- Sources configuration matching your nvim-cmp sources
      sources = {
        default = {
          "snippets",
          "lsp",
          "buffer",
          "path",
        },
        -- Define custom providers
        providers = {
          -- Custom buffer source for current buffer only
          current_buffer = {
            name = "Current Buffer",
            module = "blink.cmp.sources.buffer",
            opts = {
              -- Only get completions from the current buffer
              max_sync_buffer_size = math.huge,
              get_bufnrs = function()
                return { vim.api.nvim_get_current_buf() }
              end,
            },
          },
        },
      },

      fuzzy = {
        implementation = "rust",
        sorts = {
          "exact",
          "score",
          "sort_text",
        },
        use_frecency = true,
        use_proximity = true,
        max_typos = function(keyword)
          return math.floor(#keyword / 8)
          -- return 0
        end,
      },

      -- Cmdline configuration with buffer search support
      cmdline = {
        enabled = true,
        keymap = {
          preset = "none",
          ["<Up>"] = { "select_prev", "fallback" },
          ["<Down>"] = { "select_next", "fallback" },
          ["<Tab>"] = { "accept", "fallback" },
          ["<CR>"] = { "select_and_accept" },
        },
        -- Configure sources for different command line modes
        --- @ type function
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward - show CURRENT buffer completions only
          if type == "/" or type == "?" then
            return { "current_buffer" }
          end
          -- Commands - show cmdline completions
          if type == ":" or type == "@" then
            return { "cmdline" }
          end
          return {}
        end,
        completion = {
          trigger = {
            show_on_blocked_trigger_characters = {},
            show_on_x_blocked_trigger_characters = {},
          },
          list = {
            selection = {
              preselect = true,
              auto_insert = true,
            },
          },
          menu = { auto_show = true },
          ghost_text = { enabled = false },
        },
      },

      -- Completion settings
      completion = {
        accept = {
          auto_brackets = { enabled = false }, -- Match nvim-cmp behavior
        },
        menu = {
          auto_show = true,
          border = "none",
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "none" },
        },
        keyword = {
          range = "full",
        },
      },

      -- Signature help (optional)
      signature = {
        enabled = false,
        window = { border = "none" },
      },

      -- Snippets configuration
      snippets = {
        preset = has_luasnip and "luasnip" or "default",
      },
    })
  end,
}
