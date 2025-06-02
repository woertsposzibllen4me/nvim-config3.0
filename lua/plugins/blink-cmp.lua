return {
  "saghen/blink.cmp",
  lazy = false,
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "rafamadriz/friendly-snippets",
    "L3MON4D3/LuaSnip", -- Keep LuaSnip if you want to use it
  },
  -- test:
  -- lua_ls
  -- blink-cmp-introduction-special-thanks
  enabled = true,
  -- version = "*",
  build = "cargo build --release",
  config = function()
    -- Load snippets configuration (same as your nvim-cmp setup)
    require("plugins.plugin_configs.snippets_config")

    require("blink.cmp").setup({
      -- Keymap configuration matching your nvim-cmp setup
      keymap = {
        preset = "none",
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-f>"] = { "show", "show_documentation", "hide_documentation" },
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
        default = { "lsp", "snippets", "buffer", "path" },
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
          return math.floor(#keyword / 6)
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
        list = {
          max_items = 200,
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
        preset = "luasnip",
      },
    })
  end,
}
