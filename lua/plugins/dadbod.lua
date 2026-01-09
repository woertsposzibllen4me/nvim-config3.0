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
          local dbui_tab = nil

          -- Search through all tabs for DBUI buffer
          for tab = 1, vim.fn.tabpagenr("$") do
            local buflist = vim.fn.tabpagebuflist(tab)
            for _, buf in ipairs(buflist) do
              if vim.fn.getbufvar(buf, "&filetype") == "dbui" then
                dbui_tab = tab
                break
              end
            end
            if dbui_tab then
              break
            end
          end

          if dbui_tab then
            vim.cmd("tabnext " .. dbui_tab)
          else
            vim.cmd("tabnew")
            vim.cmd("DBUI")
          end
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
