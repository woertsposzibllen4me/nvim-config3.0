return {
  "AndrewRadev/linediff.vim",
  enabled = false,
  lazy = true,
  event = { "BufReadPost", "BufNewFile" },
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
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        for _, client in pairs(clients) do
          vim.lsp.buf_detach_client(0, client.id)
        end
        vim.defer_fn(function()
          vim.cmd("Noice dismiss") -- dismiss notifications for LSP detach (noisy warnings from lsp)
        end, 100)
      end,
    })
  end,
}
