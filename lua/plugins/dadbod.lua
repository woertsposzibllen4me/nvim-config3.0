return {
  {
    "tpope/vim-dadbod",
    enabled = false,
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    opts = {
      db_completion = function()
        require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
      end,
    },
    keys = {
      { "<leader>Du", ":DBUIToggle<CR>", desc = "Toggle database UI" },
      { "<leader>Df", ":DBUIFindBuffer<CR>", desc = "Find database buffer" },
      { "<leader>Dr", ":DBUIRenameBuffer<CR>", desc = "Rename database buffer" },
      { "<leader>Dl", ":DBUILastQueryInfo<CR>", desc = "Show last query info" },
    },
    config = function(_, opts)
      vim.g.db_ui_save_location = vim.fn.stdpath("config") .. "/db_ui"
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          vim.schedule(opts.db_completion)
        end,
      })
    end,
  },
}
