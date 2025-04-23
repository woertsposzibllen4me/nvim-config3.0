return {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = true,
  opts = {
    lsp = {
      signature = {
        enabled = false,
      },
    },
  },
  keys = {
    {
      "<leader>na",
      "<cmd>NoiceAll<CR>",
      desc = "Show all notifications",
    },
  },
}
