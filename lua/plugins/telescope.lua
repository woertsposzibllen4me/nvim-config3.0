return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  enabled = true,
  event = "VeryLazy",
  _keys = { -- Disabled for now in favor of snack pickers
    {
      "<leader>sF",
      "<cmd>Telescope find_files<cr>",
      desc = "Find files (default)",
    },
    {
      "<leader>sL",
      "<cmd>Telescope live_grep<cr>",
      desc = "Live grep (default)",
    },
    {
      "<leader>sB",
      "<cmd>Telescope buffers<cr>",
      desc = "Buffers (default)",
    },
    {
      "<leader>sR",
      "<cmd>Telescope oldfiles<cr>",
      desc = "Recent files (default)",
    },
    {
      "<leader>sG",
      "<cmd>Telescope git_status<cr>",
      desc = "Git status (default)",
    },
    {
      "<leader><leader>",
      function()
        require("telescope.builtin").find_files({
          entry_maker = require("plugins.custom_pickers.custom_find_files").entry_maker(),
        })
      end,
      desc = "Find files (custom)",
    },
    {
      "<leader>sf",
      function()
        local lazy_path = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        require("telescope.builtin").find_files({
          cwd = lazy_path,
          -- entry_maker = require("plugins.custom_pickers.custom_find_files").entry_maker(),
        })
      end,
      desc = "Find lazy files (custom)",
    },
    {
      "<leader>sr",
      function()
        require("telescope.builtin").oldfiles({
          entry_maker = require("plugins.custom_pickers.custom_find_files").entry_maker(),
        })
      end,
      desc = "Recent files (custom)",
    },
    {
      "<leader>`",
      function()
        require("telescope.builtin").buffers({
          entry_maker = require("plugins.custom_pickers.custom_buffers").entry_maker(),
        })
      end,
      desc = "Buffers (custom)",
    },
    {
      "<leader>/",
      function()
        require("telescope.builtin").live_grep({
          entry_maker = require("plugins.custom_pickers.custom_live_grep").entry_maker(),
          layout_strategy = "vertical",
        })
      end,
      desc = "Live grep (custom)",
    },
    {
      "<leader>sg",
      function()
        require("telescope.builtin").git_status({
          entry_maker = require("plugins.custom_pickers.custom_git_status").entry_maker(),
        })
      end,
      desc = "Git status (custom)",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    -- Flash setup
    local function flash(prompt_bufnr)
      require("flash").jump({
        pattern = "^",
        label = { after = { 0, 0 } },
        search = {
          mode = "search",
          exclude = {
            function(win)
              return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
            end,
          },
        },
        action = function(match)
          local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
          picker:set_selection(match.pos[1] - 1)
        end,
      })
    end

    -- Configure telescope
    telescope.setup({
      defaults = {
        mappings = {
          n = { s = flash },
          i = { ["<m-s>"] = flash },
        },
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
        },
      },
      pickers = {
        live_grep = {
          mappings = {
            i = {
              ["<C-e>"] = actions.to_fuzzy_refine,
            },
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

    telescope.load_extension("fzf")

    -- Set up which-key group with icon for all telescope commands
    require("which-key").add({
      { "<leader>s", group = "Search" },
    })
  end,
}
