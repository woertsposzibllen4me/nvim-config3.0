return {

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
      harpoon:list():append()
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

    --Adding whichkey icons
    require("which-key").add({
      { "<leader>1", group = "Harpoon 1", icon = "󱡀" },
      { "<leader>2", group = "Harpoon 2", icon = "󱡀" },
      { "<leader>3", group = "Harpoon 3", icon = "󱡀" },
      { "<leader>4", group = "Harpoon 4", icon = "󱡀" },
      { "<leader>5", group = "Harpoon 5", icon = "󱡀" },
      { "<leader>A", group = "Harpoon Add", icon = "󱡀" },
      { "<leader>H", group = "Harpoon Menu", icon = "󱡀" },
    })
  end,
}
