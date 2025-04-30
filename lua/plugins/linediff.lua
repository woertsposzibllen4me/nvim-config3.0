return {
  "AndrewRadev/linediff.vim",
  keys = {
    { "<leader>ld", "<cmd>Linediff<cr><esc>", mode = "v", desc = "Linediff" },
    { "<leader>la", "<cmd>LinediffAdd<cr><esc>", mode = "v", desc = "LinediffAdd" },
    { "<leader>ls", "<cmd>LinediffShow<cr><esc>", mode = "v", desc = "LinediffShow" },
    { "<leader>lm", "<cmd>LinediffLast<cr><esc>", mode = "v", desc = "LinediffLast" },
  },
  cmd = {
    "Linediff",
  },
  config = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "LinediffBufferReady",

      callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "q", ":LinediffReset<CR>", { noremap = true })
      end,
    })
  end,
}
