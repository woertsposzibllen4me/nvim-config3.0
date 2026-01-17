return {
  "SmiteshP/nvim-navbuddy",
  enabled = true,
  event = "LspAttach",
  dependencies = {
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>N", "<cmd>Navbuddy<cr>", desc = "Navbuddy" },
  },
}
