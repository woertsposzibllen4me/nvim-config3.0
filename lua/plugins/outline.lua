return {
  -- I'm using this standalone version because the LazyVim version seems to not work.
  "hedyhli/outline.nvim",
  enabled = true,
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = {
    { "<leader>O", "<cmd>Outline<CR>", desc = "Toggle outline" },
  },
  opts = {
    keymaps = {
      close = { "q" },
    },
  },
}
