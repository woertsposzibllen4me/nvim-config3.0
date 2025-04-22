return {
  {
    "jonahgoldwastaken/copilot-status.nvim",
    dependencies = { "zbirenbaum/copilot.lua" },
    event = "BufReadPost",
    enabled = true,
    config = function()
      require("copilot_status").setup({})
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Get default config first
      local lualine = require("lualine")
      local config = lualine.get_config()

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
