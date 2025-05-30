return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Get default config first
      local lualine = require("lualine")
      local config = lualine.get_config()
      -- lualine_c_normal = {
      --   bg = "#1E2030",
      --   fg = "#828BB8",
      --   nocombine = true,
      -- }
      vim.api.nvim_set_hl(0, "LualineFilename", { fg = "#949fd1", bold = true })

      config.options.theme = "tokyonight"

      config.sections.lualine_c = {
        {
          function()
            local filename = vim.fn.expand("%:t")
            local relative_path = vim.fn.expand("%:.")
            local dir = vim.fn.fnamemodify(relative_path, ":h")
            local separator = vim.fn.has("win32") == 1 and "\\" or "/"
            return table.concat({ dir, separator, "%#LualineFilename#", filename, "%*" })
          end,
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
