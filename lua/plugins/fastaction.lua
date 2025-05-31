return {
  "Chaitanyabsprip/fastaction.nvim",
  opts = {},
  keys = {
    {
      "<leader>ca",
      function()
        require("fastaction").code_action()
      end,
      desc = "Display code actions",
      mode = { "n", "x" },
    },
  },
}
