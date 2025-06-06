local lazypath = vim.fn.stdpath("data") .. "-repro/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic Neovim settings
vim.g.mapleader = " "        -- Set leader key to space
vim.opt.termguicolors = true -- Enable true color support

-- Plugin specifications
require("lazy").setup({

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      -- Setup with configuration
      harpoon:setup({
        settings = {
          save_on_toggle = false,
          sync_on_ui_close = false,
          key = function()
            return vim.fn.getcwd()
          end,
        },
      })

      -- Basic Harpoon keymaps
      vim.keymap.set("n", "<leader>H", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Open Harpoon menu" })

      vim.keymap.set("n", "<leader>A", function()
        harpoon:list():add()
        -- harpoon:list():append()
      end, { desc = "Add file to Harpoon" })

      -- Navigate to files using leader + number
      vim.keymap.set("n", "<leader>1", function()
        harpoon:list():select(1)
      end, { desc = "Harpoon buffer 1" })
      vim.keymap.set("n", "<leader>2", function()
        harpoon:list():select(2)
      end, { desc = "Harpoon buffer 2" })
      vim.keymap.set("n", "<leader>3", function()
        harpoon:list():select(3)
      end, { desc = "Harpoon buffer 3" })
      vim.keymap.set("n", "<leader>4", function()
        harpoon:list():select(4)
      end, { desc = "Harpoon buffer 4" })
      vim.keymap.set("n", "<leader>5", function()
        harpoon:list():select(5)
      end, { desc = "Harpoon buffer 5" })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          globalstatus = true,
        },
        sections = {
          lualine_c = {
            {
              "harpoon2",
              icon = "󱡅",
              indicators = { "1", "2", "3", "4", "5" },
              active_indicators = { "[1]", "[2]", "[3]", "[4]", "[5]" },
              color_active = { fg = "#ff6186", gui = "bold" },
              no_harpoon = "Harpoon not loaded",
            },
            "filename",
          },
        },
      })
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
})
