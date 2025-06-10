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

vim.g.mapleader = " " -- Set leader key to space
vim.opt.termguicolors = true -- Enable true color support

-- Plugin specifications
require("lazy").setup({
  -- plugins here
})
