return {
  "chrisgrieser/nvim-tinygit",
  dependencies = { "nvim-telescope/telescope.nvim" },
  vim.keymap.set("n", "<leader>gi", function()
    require("tinygit").interactiveStaging()
  end, { desc = "Interactive staging" }),
}
