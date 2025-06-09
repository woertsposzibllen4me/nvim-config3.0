return {
  {
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Get default config first
      local lualine = require("lualine")
      local _, navic = pcall(require, "nvim-navic")
      local config = lualine.get_config()
      -- lualine_c_normal = {
      --   bg = "#1E2030",
      --   fg = "#828BB8",
      --   nocombine = true,
      -- }
      vim.api.nvim_set_hl(0, "LualineFilename", { fg = "#949fd1", bold = true })

      -- vim.api.nvim_create_autocmd({ "BufEnter" }, {
      --   callback = function()
      --     -- This ensures winbar area is always allocated
      --     if vim.wo.winbar == "" then
      --       vim.wo.winbar = " "
      --     end
      --   end,
      -- })

      config.options.theme = "tokyonight"

      config.winbar.lualine_c = {
        {
          function()
            return navic.get_location() .. " " -- White space string to make winbar always appear
          end,
          cond = function()
            return navic.is_available()
          end,
        },
      }

      config.sections.lualine_c = {
        {
          "grapple",
        },
        {
          function()
            local filename = vim.fn.expand("%:t")
            local relative_path = vim.fn.expand("%:.")
            local dir = vim.fn.fnamemodify(relative_path, ":h")
            local separator = OnWindows and "\\" or "/"
            return table.concat({ dir, separator, "%#LualineFilename#", filename, "%*" })
          end,
        },
      }

      local has_harpoon, _ = pcall(require, "harpoon")
      if has_harpoon then
        table.insert(config.sections.lualine_c, 1, {
          "harpoon2",
          icon = "󱡅", -- Harpoon icon (requires a Nerd Font)
          indicators = { "1", "2", "3", "4", "5" },
          active_indicators = { "[1]", "[2]", "[3]", "[4]", "[5]" },
          color_active = { fg = "#ff6186", gui = "bold" },
          no_harpoon = "Harpoon not loaded",
        })
      end

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
    -- "letieu/harpoon-lualine",
    dir = "C:/Users/ville/myfiles/various-github-repos/harpoon-lualine",
    name = "local-harpoon-lualine",
    enabled = false,
    dependencies = {
      -- {
      --   "ThePrimeagen/harpoon",
      --   branch = "harpoon2",
      -- },
    },
    -- event = {"BufReadPost", "BufNewFile"},
  },
}
