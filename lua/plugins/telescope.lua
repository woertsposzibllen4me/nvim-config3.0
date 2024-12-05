return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
  keys = {
    {
      "<leader>sf",
      "<cmd>Telescope find_files<cr>",
      desc = "Find files (default)",
    },
    {
      "<leader><leader>",
      function()
        require("telescope.builtin").find_files({
          entry_maker = require("plugins.custom_pickers.find_files").entry_maker(),
        })
      end,
      desc = "Find files (custom)",
    },
    {
      "<leader>sr",
      function()
        require("telescope.builtin").oldfiles({
          entry_maker = require("plugins.custom_pickers.find_files").entry_maker(),
        })
      end,
      desc = "Recent files (custom)",
    },
    {
      "<leader>/",
      function()
        require("telescope.builtin").live_grep({
          entry_maker = require("plugins.custom_pickers.live_grep").entry_maker(),
          layout_strategy = "vertical",
        })
      end,
      desc = "Live grep (custom)",
    },
  },
  config = function()
    local telescope = require("telescope")
    -- Configure telescope
    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-e>"] = require("telescope.actions").to_fuzzy_refine,
          },
          n = {
            ["<C-e>"] = require("telescope.actions").to_fuzzy_refine,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    -- Set up which-key group with icon for all telescope commands
    require("which-key").add({
      { "<leader>s", group = "Search" },
    })
  end,
}
