return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },

    config = function()
      vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {
        desc = "Toggle Neo-tree",
        silent = true,
        noremap = true,
      })

      local opened = false
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          local filetype = vim.bo.filetype
          if not opened and filetype ~= "dashboard" and filetype ~= "" then
            opened = true
            vim.cmd("Neotree show")
          end
        end,
      })

      require("neo-tree").setup({
        popup_border_style = "single",
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
        },
      })
    end,
  },
}
