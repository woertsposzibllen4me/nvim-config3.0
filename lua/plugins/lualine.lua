return {
  {
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    enabled = true,
    config = function()
      -- Get default config first
      local lualine = require("lualine")
      local _, navic = pcall(require, "nvim-navic")
      local config = lualine.get_config()

      -- lualine_c_normal = { bg = "#1E2030", fg = "#828BB8", nocombine = true, }
      vim.api.nvim_set_hl(0, "LualineFilename", { fg = "#949fd1", bold = true })

      -- HACK: Prevents noice hover window from moving weird when entered if winbar is enabled
      -- We set a global winbar to prevent the displacement causing the visual glitch
      vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
        callback = function()
          local ft = vim.bo.filetype
          if config.winbar and config.winbar.lualine_c then
            if ft == "noice" and vim.o.winbar == "" then
              vim.o.winbar = " "
            elseif ft ~= "noice" and vim.o.winbar == " " then
              vim.o.winbar = ""
            end
          end
        end,
      })

      config.options.theme = "tokyonight"

      config.winbar.lualine_c = {
        {
          function()
            return navic.get_location() .. " " -- White space string to make winbar always appear on
            -- main window
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
        {
          function()
            local buffer_marks = vim.fn.getmarklist(vim.api.nvim_get_current_buf())
            local buffer_letters = {}

            for _, mark in ipairs(buffer_marks) do
              local letter = mark.mark:sub(2, 2)
              if letter:match("[a-z]") then
                table.insert(buffer_letters, letter)
              end
            end

            return #buffer_letters > 0 and table.concat(buffer_letters, "") or ""
          end,
        },
      }

      table.insert(config.sections.lualine_x, 1, {
        function()
          local global_marks = vim.fn.getmarklist()
          local global_letters = {}

          for _, mark in ipairs(global_marks) do
            local letter = mark.mark:sub(2, 2)
            if letter:match("[A-Z]") then
              table.insert(global_letters, letter)
            end
          end

          return #global_letters > 0 and table.concat(global_letters, "") or ""
        end,
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
}
