return {
  "SmiteshP/nvim-navic",
  enabled = true,
  event = "LspAttach",
  dependencies = { "neovim/nvim-lspconfig" }, -- Use dependencies instead of requires
  opts = {
    highlight = true,
  },
}
