return {
  {
    "tpope/vim-dadbod",
    enabled = true,
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    opts = {},
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    keys = {
      {
        "<leader>DD",
        function()
          require("modules.dadbodui.use-newtab").toggle_dbui_tab()
        end,
        desc = "Toggle database UI in tab",
      },
      { "<leader>Df", "<cmd>DBUIFindBuffer<CR>", desc = "Find database buffer" },
      { "<leader>Dr", "<cmd>DBUIRenameBuffer<CR>", desc = "Rename database buffer" },
      { "<leader>Dl", "<cmd>DBUILastQueryInfo<CR>", desc = "Show last query info" },
    },
    config = function(_, opts)
      vim.g.db_ui_save_location = vim.fn.stdpath("config") .. "/db_ui"
      vim.g.db_ui_use_nerd_fonts = 1

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
        end,
      })
    end,
  },
}
