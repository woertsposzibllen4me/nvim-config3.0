local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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
vim.g.mapleader = " " -- Set leader key to space
vim.opt.termguicolors = true -- Enable true color support

-- Plugin specifications
require("lazy").setup({
  -- Snacks plugin
  {
    "folke/snacks.nvim",
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { section = "keys" },
        {
          pane = 2,
          section = "terminal",
          cmd = "git status",
          height = 5,
          padding = 1,
        },
      },
    },
  },
})
