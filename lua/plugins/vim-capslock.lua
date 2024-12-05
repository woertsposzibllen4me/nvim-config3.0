return {
  "tpope/vim-capslock",
  keys = {
    { "<C-g>c", mode = "i" }, -- for insert mode
    { "gC", mode = { "n" }, desc = "Toggle Capslock" }, -- optional: include normal/visual mode mappings
  },
}
