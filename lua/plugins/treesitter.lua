return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    enabled = true,
    config = function()
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

      require("nvim-treesitter.configs").setup({
        modules = {},
        sync_install = false,
        ignore_install = {},
        auto_install = true,
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "python",
          "markdown",
          "markdown_inline",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "v<CR>",
            node_incremental = "<CR>",
            node_decremental = "<BS>",
            scope_incremental = "<TAB>",
          },
        },
        textobjects = {
          move = {
            enable = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
              ["]n"] = "@number.inner",
              ["]w"] = "@call.outer",
              ["]j"] = "@attribute.inner", -- Not available in python
              ["]v"] = "@comment.inner",
              ["]i"] = "@conditional.outer",
              ["]o"] = "@loop.outer",
              ["]z"] = "@function_name",
              ["]x"] = "@method_name",
              ["]e"] = "@call_name", -- the verstalie one (method_name + function_name)
              ["]h"] = "@return_type",
              ["]p"] = "@function_parameters",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]A"] = "@parameter.inner",
              ["]N"] = "@number.inner",
              ["]W"] = "@call.outer",
              ["]J"] = "@attribute.inner",
              ["]V"] = "@comment.inner",
              ["]I"] = "@conditional.outer",
              ["]O"] = "@loop.outer",
              ["]Z"] = "@function_name",
              ["]X"] = "@method_name",
              ["]E"] = "@call_name",
              ["]H"] = "@return_type",
              ["]P"] = "@function_parameters",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
              ["[n"] = "@number.inner",
              ["[w"] = "@call.outer",
              ["[j"] = "@attribute.inner",
              ["[v"] = "@comment.inner",
              ["[i"] = "@conditional.outer",
              ["[o"] = "@loop.outer",
              ["[z"] = "@function_name",
              ["[x"] = "@method_name",
              ["[e"] = "@call_name",
              ["[h"] = "@return_type",
              ["[p"] = "@function_parameters",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[A"] = "@parameter.inner",
              ["[N"] = "@number.inner",
              ["[W"] = "@call.outer",
              ["[J"] = "@attribute.inner",
              ["[V"] = "@comment.inner",
              ["[I"] = "@conditional.outer",
              ["[O"] = "@loop.outer",
              ["[Z"] = "@function_name",
              ["[X"] = "@method_name",
              ["[E"] = "@call_name",
              ["[H"] = "@return_type",
              ["[P"] = "@function_parameters",
            },
          },
          lsp_interop = {
            enable = true,
            border = "rounded",
            floating_preview_opts = {},
            peek_definition_code = {
              ["<leader>pf"] = "@function.outer",
              ["<leader>pc"] = "@class.outer",
            },
          },
        },
      })
    end,
  },
}
