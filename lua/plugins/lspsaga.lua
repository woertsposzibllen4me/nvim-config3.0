return {
  "nvimdev/lspsaga.nvim",
  event = { "LspAttach" },
  enabled = false,
  opts = {
    lightbulb = {
      enable = false,
      virtual_text = false,
    },
    symbol_in_winbar = {
      enable = true,
    },
  },
  keys = {
    { "gK", "<cmd>Lspsaga hover_doc<CR>", desc = "(saga) Hover documentation" },
  },
}
