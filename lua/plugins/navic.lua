return {
  "SmiteshP/nvim-navic",
  enabled = false,
  event = "LspAttach",
  dependencies = { "neovim/nvim-lspconfig" }, -- Use dependencies instead of requires
  opts = {
    highlight = true,
  },
}
