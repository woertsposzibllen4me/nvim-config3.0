return {
  "Chaitanyabsprip/fastaction.nvim",
  enabled = false,
  opts = {
    priority = {
      ruff = {
        { pattern = "organize import", key = "o", order = 98 },
        { pattern = "fix all", key = "A", order = 99 },
      },
    },
  },
  keys = {
    {
      "<leader>cx",
      function()
        require("fastaction").code_action()
      end,
      desc = "Fast Code Action",
      mode = { "n", "x" },
    },
  },
}
