return {
  "AndrewRadev/linediff.vim",
  lazy = true,
  event = "VeryLazy",
  keys = {
    {
      "<leader>ld",
      ":Linediff<cr>",
      mode = { "v", "n" },
      desc = "Linediff",
      noremap = true,
      silent = true,
      nowait = true,
    },
    {
      "<leader>la",
      ":LinediffAdd<cr>",
      mode = { "v", "n" },
      desc = "LinediffAdd",
      noremap = true,
      silent = true,
      nowait = true,
    },
    { "<leader>ls", ":LinediffShow<cr>", mode = { "v", "n" }, desc = "LinediffShow", noremap = true, silent = true },
    {
      "<leader>ll",
      ":LinediffLast<cr>",
      mode = { "v", "n" },
      desc = "LinediffLast",
      noremap = true,
      silent = true,
      nowait = true,
    },
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
