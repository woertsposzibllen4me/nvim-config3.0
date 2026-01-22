return {
  "shortcuts/no-neck-pain.nvim",
  enabled = true,
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    width = 120,
    autocmds = {
      -- enableOnVimEnter = "safe",
    },
    mappings = {
      enabled = true,
      -- toggle = "<leader>N",
    },
  },
}
