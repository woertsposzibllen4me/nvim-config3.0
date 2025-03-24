return {
  "nvimdev/dashboard-nvim",
  -- event = "VimEnter",
  enabled = true,
  config = function()
    local custom_header = {
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "                                                                              ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "                                                                              ",
      "       ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗    ",
      "       ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║    ",
      "       ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║    ",
      "       ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║    ",
      "       ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║    ",
      "       ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝    ",
      "                                                                              ",
      "                                                                              ",
      "",
      "",
      "",
      "",
    }

    local ok, builtin = pcall(require, "telescope.builtin")
    if not ok then
      builtin = nil
    end
    local custom_find_files = require("plugins.custom_pickers.custom_find_files")
    local custom_grep = require("plugins.custom_pickers.custom_live_grep")

    -- Add an autocmd to rename the buffer when dashboard's filetype is set
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dashboard",
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_name(bufnr, "Dashboard")
      end,
    })

    require("dashboard").setup({
      theme = "doom",
      hide = {
        statusline = false,
      },
      config = {
        header = custom_header,
        center = {
          {
            action = function()
              builtin.find_files({
                entry_maker = custom_find_files.entry_maker(),
              })
            end,
            desc = " Find File",
            icon = "",
            key = "f",
          },
          {
            action = function()
              builtin.live_grep({
                entry_maker = custom_grep.entry_maker(),
                layout_strategy = "vertical",
              })
            end,
            desc = " Find Word",
            icon = "",
            key = "/",
          },
          {
            action = function()
              builtin.oldfiles({
                entry_maker = custom_find_files.entry_maker(),
              })
            end,
            desc = " Recent Files",
            icon = "",
            key = "r",
          },
          {
            action = 'lua require("persistence").load()',
            desc = " Restore Session",
            icon = "",
            key = "s",
          },
          {
            action = function()
              vim.cmd("Lazy")
            end,
            desc = " Open Lazy",
            icon = "󰒲",
            key = "l",
          },
          {
            action = function()
              vim.cmd("lua StartLazygit()")
            end,
            desc = " Open LazyGit",
            icon = "󰊢",
            key = "g",
          },
          {
            action = function()
              vim.cmd("quit")
            end,
            desc = " Quit Neovim",
            icon = "󰗼",
            key = "q",
          },
          {
            action = require("scripts.delete_temp_shadas").Delete_shada_temp_files,
            desc = " Delete Shada Temp Files",
            icon = "󱕖",
            key = "d",
          },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return {
            "",
            "",
            "",
            "",
            "",
            "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
          }
        end,
      },
    })

    -- Reset jump list when exiting dashboard (seems to crash snacks jumps picker otherwise)
    vim.api.nvim_create_autocmd("BufLeave", {
      callback = function()
        local filetype = vim.bo.filetype
        if filetype == "dashboard" then
          vim.cmd("clearjumps")
        end
      end,
    })
  end,
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
