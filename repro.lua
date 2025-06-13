-- usage "nvim -u this_filename.lua"
vim.env.LAZY_STDPATH = ".repro"
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()
vim.g.mapleader = " " -- Set leader key to space

--- @ diagnostic disable: missing-fields
require("lazy.minit").repro({
  spec = {
    -- plugins here
  },
})
