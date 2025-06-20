return {
  "fdschmidt93/telescope-egrepify.nvim",
  enabled = false,
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>fe",
      function()
        vim.cmd("Telescope egrepify")
      end,
      desc = "Telescope Egrepify",
    },
  },
}
