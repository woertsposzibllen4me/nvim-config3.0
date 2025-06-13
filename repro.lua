-- usage "nvim -u this_fileanme.lua filename"
vim.env.LAZY_STDPATH = ".repro"
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()
vim.g.mapleader = " " -- Set leader key to space

--- @ diagnostic disable: missing-fields
require("lazy.minit").repro({
  spec = {
    {
      "folke/snacks.nvim",
      lazy = false,
    },
    {
      "mrjones2014/smart-splits.nvim",
      lazy = false,
      opts = {
        at_edge = "stop",
      },
      keys = {
        {
          "<C-h>",
          function()
            require("smart-splits").move_cursor_left()
          end,
          desc = "Move to left split",
        },
        {
          "<C-j>",
          function()
            require("smart-splits").move_cursor_down()
          end,
          desc = "Move to bottom split",
        },
        {
          "<C-k>",
          function()
            require("smart-splits").move_cursor_up()
          end,
          desc = "Move to top split",
        },
        {
          "<C-l>",
          function()
            require("smart-splits").move_cursor_right()
          end,
          desc = "Move to right split",
        },
      },
    },
  },
})
