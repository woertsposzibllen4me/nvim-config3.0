return {
  {
    "tpope/vim-dadbod",
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
      { "<leader>du", ":DBUIToggle<CR>", desc = "Toggle database UI" },
      { "<leader>df", ":DBUIFindBuffer<CR>", desc = "Find database buffer" },
      { "<leader>dr", ":DBUIRenameBuffer<CR>", desc = "Rename database buffer" },
      { "<leader>dl", ":DBUILastQueryInfo<CR>", desc = "Show last query info" },
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
