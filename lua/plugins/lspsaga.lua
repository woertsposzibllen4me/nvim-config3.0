return {
  "nvimdev/lspsaga.nvim",
  event = { "LspAttach" },
  opts = {
    lightbulb = {
      enable = false,
      virtual_text = false,
    },
  },
  keys = {
    { "gK", "<cmd>Lspsaga hover_doc<CR>", desc = "(saga) Hover documentation" },
  },
}
