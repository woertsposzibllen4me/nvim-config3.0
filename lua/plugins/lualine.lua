return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Get default config first
      local lualine = require("lualine")
      local config = lualine.get_config()

      config.options.theme = "tokyonight"

      config.sections.lualine_c = {
        {
          "filename",
          path = 1, -- 0: Just the filename
          -- 1: Relative path
          -- 2: Absolute path (full filepath)
          -- 3: Absolute path, with tilde as the home directory
          -- 4: Filename and parent dir, with tilde as the home directory
        },
      }

      -- Add our components to lualine_x section while preserving existing ones
      table.insert(config.sections.lualine_x, 2, {
        "harpoon2",
        icon = "󱡅", -- Harpoon icon (requires a Nerd Font)
        indicators = { "1", "2", "3", "4", "5" },
        active_indicators = { "[1]", "[2]", "[3]", "[4]", "[5]" },
        color_active = { fg = "#ff6186", gui = "bold" },
        component_separators = { left = "", right = "" },
        no_harpoon = "Harpoon not loaded",
      })

      table.insert(config.sections.lualine_x, 3, {
        function()
          return require("copilot_status").status_string()
        end,
        cnd = function()
          return require("copilot_status").enabled()
        end,
      })

      table.insert(config.sections.lualine_x, 4, {
        "macro",
        fmt = function()
          local reg = vim.fn.reg_recording()
          if reg ~= "" then
            return "Recording @" .. reg
          end
          return nil
        end,
        color = { fg = "#ff9e64" },
        draw_empty = false,
      })

      config.options.globalstatus = true
      lualine.setup(config)
    end,
  },
  {
    "letieu/harpoon-lualine",
    dependencies = {
      {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
      },
    },
  },
}
