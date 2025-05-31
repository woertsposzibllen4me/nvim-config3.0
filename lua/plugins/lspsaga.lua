return {
  "nvimdev/lspsaga.nvim",
  event = { "LspAttach" },
  opts = {},
  keys = {
    { "<leader>K", "<cmd>Lspsaga hover_doc<CR>", desc = "(saga) Hover documentation" },
  },
}
